import 'package:benkyou/main.dart';
import 'package:benkyou/models/Card.dart' as CardModel;
import 'package:benkyou/models/Deck.dart';
import 'package:benkyou/models/JishoTranslation.dart';
import 'package:benkyou/services/database/CardDao.dart';
import 'package:benkyou/services/database/DBProvider.dart';
import 'package:benkyou/services/database/Database.dart';
import 'package:benkyou/services/navigator.dart';
import 'package:benkyou/services/translator/TextConversion.dart';
import 'package:benkyou/widgets/AddAnswerCardWidget.dart';
import 'package:benkyou/widgets/Header.dart';
import 'package:benkyou/widgets/JishoList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateCardPage extends StatefulWidget {
  final CardDao cardDao;
  final Deck deck;

  CreateCardPage({@required this.cardDao, @required this.deck});

  @override
  State<StatefulWidget> createState() => _CreateCardState();
}

class _CreateCardState extends State<CreateCardPage> {
  final _formKey = GlobalKey<FormState>();
  String _bottomButtonLabel = 'NEXT';
  String japanese = '';
  String _error = '';
  String _researchWord = '';
  PageController _pageController =
      PageController(initialPage: 0, keepPage: false);

  TextEditingController _titleEditingController;
  TextEditingController _hintEditingController;
  final FocusNode _questionFocusNode = FocusNode();
  bool _isReversible = false;
  bool _needParseInJapanese = true;
  bool _isLateInit = false;
  bool _isQuestionErrorVisible = false;
  GlobalKey<AddAnswerCardWidgetState> answerWidgetKey = new GlobalKey<AddAnswerCardWidgetState>();


  //TODO Jpec
  void triggerJishoResearch() async {
    setState(() {
      _researchWord = _titleEditingController.text;
    });
  }

  @override
  void initState() {
    super.initState();
    _questionFocusNode.addListener((){
      triggerJishoResearch();
    });
    _titleEditingController = new TextEditingController();
    _hintEditingController = new TextEditingController();
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    _hintEditingController.dispose();
    _questionFocusNode.dispose();
    super.dispose();
  }

  Future<bool> _createCardOrLeave() async {
    if (_pageController.page == 0) {
      String error = await _validateCreateCard();
      if (error != null) {
        setState(() {
          _isQuestionErrorVisible = true;
          _error = error;
        });
        _formKey.currentState.validate();
        return false;
      }
      String question = _needParseInJapanese
          ? getJapaneseTranslation(_titleEditingController.text)
          : _titleEditingController.text;

      if (!_isLateInit){
        List<String> answers = [];
        for (var answerController in answerWidgetKey.currentState.textEditingControllers) {
          if (answerController.text.length > 0) {
            answers.add(answerController.text.toLowerCase());
          }
        }
        await CardModel.Card.setCardWithBasicAnswers(
            widget.deck.id, question, answers, hint: _hintEditingController.text);
      } else {
        CardModel.Card card = new CardModel.Card(null, widget.deck.id, question, null, null, false);
        AppDatabase appDatabase = await DBProvider.db.database;
        int res = await appDatabase.cardDao.insertCard(card);
      }


      setState(() {
        _bottomButtonLabel = 'DONE';
      });
      //Hide keyboard
      FocusScope.of(context).requestFocus(FocusNode());
      _pageController.animateToPage(1,
          duration: Duration(milliseconds: 500), curve: Curves.easeIn);
    } else {
      goToDeckInfoPage(context, widget.deck.id);
    }
    return true;
  }

  Future<String> _validateCreateCard() async {
    String question = _needParseInJapanese
        ? getJapaneseTranslation(_titleEditingController.text)
        : _titleEditingController.text;
    if (question == null || question.length == 0 || question == ' ') {
      return 'The question cannot be empty. ${_needParseInJapanese ? 'There is no kana in your question' : '' }';
    }
    CardModel.Card res = await widget.cardDao.findCardByQuestion(question);

    if (res != null) {
      return 'This question is already used.\n Please choose another one.';
    }
    if (!_isLateInit){
      List<String> answers = [];
      for (var answerController in answerWidgetKey.currentState.textEditingControllers) {
        if (answerController.text.length > 0) {
          answers.add(answerController.text.toLowerCase());
        }
      }
      if (answers.length < 1) {
        return 'You must have at least one answer not blank.';
      }
    }
    return null;
  }


  Widget _renderForm(){
    return Padding(
      padding: EdgeInsets.only(left: 50.0, right: 50.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding:
                        EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Column(children: <Widget>[
                          Visibility(
                            visible: _needParseInJapanese,
                            child: Text(japanese),
                          ),
                          TextFormField(
                            focusNode: _questionFocusNode,
                            controller: _titleEditingController,
                            onChanged: (text) {
                              setState(() {
                                _isQuestionErrorVisible = false;
                                japanese =
                                "${getJapaneseTranslation(text) ?? ''}";
                              });
                              _formKey.currentState.validate();
                            },
                            validator: (value) {
                              if (_isQuestionErrorVisible) {
                                if (value.isEmpty) {
                                  return 'Please enter a question';
                                }
                                return _error;
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                labelText: 'Question *',
                                labelStyle: TextStyle(fontSize: 20),
                                hintText:
                                'Enter a question / a word to remember'),
                            autofocus: true,
                          ),
                        ]),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding:
                        EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: TextFormField(
                          controller: _hintEditingController,
                          onChanged: (text) {
                            _formKey.currentState.validate();
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              labelText: 'Hint',
                              labelStyle: TextStyle(fontSize: 20),
                              hintText:
                              'Enter a hint'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Need to be parsed in Kana ?',
                            style: TextStyle(fontSize: 16),
                          ),
                          Checkbox(
                            value: _needParseInJapanese,
                            onChanged: (bool value) {
                              setState(() {
                                _needParseInJapanese = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Late init ?',
                          style: TextStyle(fontSize: 16),
                        ),
                        Checkbox(
                          value: _isLateInit,
                          onChanged: (bool value) {
                            setState(() {
                              _isLateInit = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Is reversible ?',
                              style: TextStyle(fontSize: 16),
                            ),
                            Checkbox(
                              value: _isReversible,
                              onChanged: (bool value) {
                                setState(() {
                                  _isReversible = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !_isLateInit,
                      child: AddAnswerCardWidget(key: answerWidgetKey),
                    ),
                  ],
                ),
              ),
            ),
          ),],
      ),
    );
  }

  Widget _renderAgainOrLeave(){
    return (Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Container(
            child: Center(
              child: Text(
                'Your card have been successfully created !',
                style: TextStyle(
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () async {
              _titleEditingController.clear();
              setState(() {
                _bottomButtonLabel = 'NEXT';
              });
              _pageController.animateToPage(0,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeIn);
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.12,
              decoration: BoxDecoration(color: Colors.red),
              child: Center(
                child: Text(
                  'CREATE ANOTHER CARD',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
          ),
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BasicContainer(
      child: Column(children: <Widget>[
        Header(title: 'Create a card', type: HEADER_DEFAULT, backFunction: (){
          goToDeckInfoPage(context, widget.deck.id);
        },),
        Expanded(
          flex: 4,
          child: PageView(
            controller: _pageController,
            pageSnapping: false,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              _renderForm(),
              _renderAgainOrLeave()
            ],
          ),
        ),
        GestureDetector(
          onTap: () async {
            _createCardOrLeave();
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.12,
            decoration: BoxDecoration(color: Colors.lightBlueAccent),
            child: Center(
              child: Text(
                _bottomButtonLabel,
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
