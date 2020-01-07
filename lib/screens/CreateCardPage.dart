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
import 'package:benkyou/widgets/app/BasicContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const ERR_KANA = 'There is no kana in your question';
const ERR_KANA_KANJI = 'You must at least provide a kana or a kanji.';
const ERR_ALREADY_EXISTING = 'A card has already the same kanji/kana.\n Please enter something else.';

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

  TextEditingController _kanjiEditingController;
  TextEditingController _kanaEditingController;
  final FocusNode _kanjiFocusNode = FocusNode();
  final FocusNode _kanaFocusNode = FocusNode();
  bool _isLateInit = false;
  bool _isQuestionErrorVisible = false;
  bool _isReversible = true;
  GlobalKey<AddAnswerCardWidgetState> answerWidgetKey =
      new GlobalKey<AddAnswerCardWidgetState>();

  void triggerJishoResearch(String text) async {
    setState(() {
      _researchWord = text;
    });
  }

  @override
  void initState() {
    super.initState();
    _kanjiEditingController = new TextEditingController();
    _kanaEditingController = new TextEditingController();

    _kanjiFocusNode.addListener(() {
      triggerJishoResearch(_kanjiEditingController.text);
    });

    _kanaFocusNode.addListener(() {
      triggerJishoResearch(_kanaEditingController.text);
    });
  }

  @override
  void dispose() {
    _kanjiEditingController.dispose();
    _kanaEditingController.dispose();
    _kanjiFocusNode.dispose();
    _kanaFocusNode.dispose();
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
      String hint;
      String question;
      if (_kanaEditingController.text.trim().isNotEmpty){
        hint = stringNeedToBeParsed(_kanaEditingController.text)
            ? getJapaneseTranslation(_kanaEditingController.text)
            : _kanaEditingController.text;
      }
      if (_kanjiEditingController.text.trim().isEmpty){
        question = hint;
        hint = '';
      } else {
        question = _kanjiEditingController.text;
      }

      if (!_isLateInit) {
        List<String> answers = [];
        for (var answerController
            in answerWidgetKey.currentState.textEditingControllers) {
          if (answerController.text.isNotEmpty) {
            answers.add(answerController.text.toLowerCase());
          }
        }
        await CardModel.Card.setCardWithBasicAnswers(
            widget.deck.id, question, answers,
            hint: hint, isReversible: _isReversible);
      } else {
        CardModel.Card card = new CardModel.Card(
            null, widget.deck.id, question, hint, null, false);
        AppDatabase appDatabase = await DBProvider.db.database;
        await appDatabase.cardDao.insertCard(card);
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
    String hint = _kanaEditingController.text.trim();
    String question = stringNeedToBeParsed(_kanaEditingController.text)
        ? getJapaneseTranslation(_kanjiEditingController.text)
        : _kanjiEditingController.text;
    if (question == null || question.trim().isEmpty) {
      //If no kanji is given, kana can be considered as question
      if (hint == null || hint.isEmpty){
        return ERR_KANA_KANJI;
      }
      if (stringNeedToBeParsed(hint)){
        hint = japanese;
      } else {
      }
      if (hint.isEmpty){
        return ERR_KANA;
      }
      question = hint;
    }
    CardModel.Card res = await widget.cardDao.findCardByQuestion(question);

    if (res != null) {
      return ERR_ALREADY_EXISTING;
    }
    List<String> answers = [];
    for (var answerController
        in answerWidgetKey.currentState.textEditingControllers) {
      if (answerController.text.isNotEmpty) {
        answers.add(answerController.text.toLowerCase());
      }
    }
    if (answers.isEmpty) {
      _isLateInit = true;
    }
    return null;
  }

  bool stringNeedToBeParsed(text){
    int startLower = "a".codeUnitAt(0);
    int endLower = "z".codeUnitAt(0);
    int startUpper = "A".codeUnitAt(0);
    int endUpper = "Z".codeUnitAt(0);
    for (var i = 0; i < text.length; i++){
      int char = text.codeUnitAt(i);
      if ((startLower <= char && char <= endLower) ||
          (startUpper <= char && char <= endUpper)){
        return true;
      }
    }
    return false;
  }

  Widget _renderForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 50.0, right: 50.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: TextFormField(
                          controller: _kanaEditingController,
                          focusNode: _kanaFocusNode,
                          validator: (value) {
                            if (_isQuestionErrorVisible) {
                              return _error;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _isQuestionErrorVisible = false;
                            bool needtoBeParsed = stringNeedToBeParsed(_kanaEditingController.text);
                            setState(() {
                              japanese = needtoBeParsed ?
                              "${getJapaneseTranslation(_kanaEditingController.text) ?? ''}": '';
                            });
                            _formKey.currentState.validate();
                          },
                          textInputAction: TextInputAction.next,
                          autofocus: true,
                          decoration: InputDecoration(
                              labelText: 'Kana',
                              labelStyle: TextStyle(fontSize: 20),
                              hintText: 'Enter kana here'),
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Column(children: <Widget>[
                          Text(japanese),
                          TextFormField(
                            focusNode: _kanjiFocusNode,
                            controller: _kanjiEditingController,
                            onChanged: (text) {
                              _isQuestionErrorVisible = false;
                              _formKey.currentState.validate();
                            },
                            validator: (value) {
                              if (_isQuestionErrorVisible) {
                                if (_error != ERR_KANA){
                                  return _error;
                                }
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                labelText: 'Kanji',
                                labelStyle: TextStyle(fontSize: 20),
                                hintText:
                                    'Enter kanji here'),
                          ),
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Is card reversible ?', style: TextStyle(fontSize: 18),),
                          Switch(
                            value: _isReversible,
                            onChanged: (bool value) {
                              setState(() {
                                _isReversible = !_isReversible;
                              });
                          },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: AddAnswerCardWidget(key: answerWidgetKey),
                    ),
                    Container(child: Text(
                      'Propositions of answer',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.start,
                    ),),

                    JishoList(researchWord: _researchWord, callback: getBackTranslation),

                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void getBackTranslation(JishoTranslation translation){
    _kanjiEditingController.text = translation.kanji;
    _kanaEditingController.text = translation.reading;
    setState(() {
    });
    answerWidgetKey.currentState.setNewAnswers(translation.english);
  }

  Widget _renderAgainOrLeave() {
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
        GestureDetector(
          onTap: () async {
            _kanjiEditingController.clear();
            _kanaEditingController.clear();
            setState(() {
              japanese = '';
              _researchWord = '';
              _bottomButtonLabel = 'NEXT';
            });
            _pageController.animateToPage(0,
                duration: Duration(milliseconds: 500), curve: Curves.easeIn);
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.08,
            decoration: BoxDecoration(color: Color(0xff646461)),
            child: Center(
              child: Text(
                'CREATE ANOTHER CARD',
                style: TextStyle(fontSize: 30, color: Colors.white),
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
        Header(
          title: 'Create a card',
          type: HEADER_DEFAULT,
          backFunction: () {
            goToDeckInfoPage(context, widget.deck.id);
          },
        ),
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
            height: MediaQuery.of(context).size.height * 0.08,
            decoration: BoxDecoration(color: Color(0xff248CCB)),
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
