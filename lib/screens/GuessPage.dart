import 'dart:math';

import 'package:benkyou/services/navigator.dart';
import 'package:benkyou/widgets/Header.dart';
import 'package:benkyou/widgets/guess/GuessBanner.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:benkyou/models/Answer.dart';
import 'package:benkyou/models/Card.dart' as prefix0;
import 'package:benkyou/services/database/Database.dart';
import 'package:benkyou/widgets/EnterInput.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TtsState { playing, stopped }

class GuessPage extends StatefulWidget {
  final int deckId;
  final AppDatabase appDatabase;
  final List<prefix0.Card> cards;

  GuessPage(
      {Key key,
      @required this.appDatabase,
      @required this.cards,
      @required this.deckId})
      : super(key: key);

  @override
  _GuessPageState createState() => _GuessPageState();
}

class _GuessPageState extends State<GuessPage>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  FocusNode pageFocusNode;
  FocusNode inputFocusNode;
  final answerController = TextEditingController();
  List<Answer> _answers;
  bool _isSearching = true;
  final newAnswerController = TextEditingController();
  final _answerScrollController = ScrollController();

  String boxColor = 'standard';
  int currentQuestionIndex = 0;
  Map<String, MaterialColor> boxColors = {
    "standard": Colors.blueGrey,
    "error": Colors.red,
    "success": Colors.green
  };

  @override
  void initState() {
    super.initState();
    pageFocusNode = new FocusNode();
    inputFocusNode = new FocusNode();
    setAnimation();
  }

  void setAnimation() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1, milliseconds: 500),
    )..addListener(() => setState(() {}));

    animation = Tween<double>(
      begin: 10.0,
      end: 80.0,
    ).animate(animationController);
  }

  vector.Vector3 _shake() {
    double progress = animationController.value;
    double offset = sin(progress * pi * 10.0);
    return vector.Vector3(offset * 5, 0.0, 0.0);
  }

  @override
  void dispose() {
    answerController.dispose();
    newAnswerController.dispose();
    _answerScrollController.dispose();
    super.dispose();
  }

  void getNextQuestion() async {
    if (!answerController.text.isNotEmpty) {
      animationController.forward().whenComplete(() {
        animationController.reset();
      });
      return;
    }
    if (_isSearching) {
      bool res = await widget.cards[currentQuestionIndex]
          .checkIfCorrectAnswer(answerController.text);

      await widget.cards[currentQuestionIndex]
          .updateCard(widget.appDatabase, res);
      var newBoxColor = res ? "success" : "error";
      FocusScope.of(context).requestFocus(pageFocusNode);
      setState(() {
        boxColor = newBoxColor;
        _isSearching = false;
      });
    } else {
      boxColor = 'standard';

      FocusScope.of(context).requestFocus(inputFocusNode);
      if (widget.cards.length > 1) {
        widget.cards.remove(widget.cards[currentQuestionIndex]);
        Random random = new Random();
        currentQuestionIndex = (widget.cards.length - 1 > 2)
            ? random.nextInt(widget.cards.length - 1)
            : 0;
        answerController.clear();
        setState(() {
          _isSearching = true;
        });
      } else {
        goToDeckInfoPage(context, widget.deckId);
      }
    }
  }

  void _addSynonym() async {
    var answerText = newAnswerController.text;
    if (answerText.isNotEmpty) {
      Answer answer = new Answer(null, widget.cards[currentQuestionIndex].id,
          newAnswerController.text);
      for (var existingAnswer in _answers) {
        if (existingAnswer.content == answerText) {
          return null;
        }
      }

      await widget.appDatabase.answerDao.insertAnswer(answer);
      this.setState(() {
        newAnswerController.clear();
        _answerScrollController
            .jumpTo(_answerScrollController.position.maxScrollExtent);
      });
    }
  }

  //TODO enabling adding synonym on the fly
  Widget _getSynonymWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
//          mainAxisAlignment: MainAxisAlignment.center,
//          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () async {
                _addSynonym();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Image.asset('resources/imgs/add.png',
                    width: 15, height: 15),
              ),
            ),
            Flexible(
              child: TextField(
//    controller: newAnswerController,
                  ),
            )
//            SizedBox(
//              width: 150,
//              height: 50,
//              child: Padding(
//                padding: EdgeInsets.only(top: 10),
//                child: TextField(
//                    maxLines: 2,
//                    controller: newAnswerController,
//                    decoration: InputDecoration.collapsed(hintText: 'Enter a synonym')),
//              ),
//            )
          ],
        ),
      ),
    );
  }

  Widget _getCardAnswers(AsyncSnapshot<List<Answer>> snapshot) {
    if (snapshot.data.length > 1) {
      var answerContainers = [];
      for (var i = 1; i < _answers.length; i++) {
        answerContainers.addAll([
          new Padding(padding: EdgeInsets.all(8.0), child: new Divider()),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Container(
              child: Text(
                _answers[i].content,
                textAlign: TextAlign.center,
              ),
            ),
          )
        ]);
      }
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            _answers[0].content,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25),
          ),
          ...answerContainers
        ],
      );
    }
    return Text(
      _answers[0].content,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 30),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return KeyboardAwareInput(
        focusNode: pageFocusNode,
        specialCallbacks: {
          KEYBOARD_ENTER_CODE: () {
            getNextQuestion();
          }
        },
        child: SafeArea(
          child: Scaffold(
              body: Column(children: <Widget>[
            Header(title: '', type: HEADER_SMALL),
            StreamBuilder<List<Card>>(
                stream: null,
                builder: (context, snapshot) {
                  return GuessBanner(
                      card: widget.cards.isNotEmpty
                          ? widget.cards[currentQuestionIndex]
                          : null);
                }),
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(color: boxColors[boxColor]),
                    child: ConstrainedBox(
                      child: Row(
                        children: <Widget>[
                          Flexible(
                              child: Container(
                            child: Center(
                                child: Transform(
                              child: TextField(
                                textAlign: TextAlign.center,
                                focusNode: inputFocusNode,
                                autofocus: true,
                                onEditingComplete: () {
                                  getNextQuestion();
                                },
                                controller: answerController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration.collapsed(
                                    border: InputBorder.none,
                                    hintText: 'Enter a search term',
                                    hintStyle:
                                        TextStyle(color: Colors.white30)),
                              ),
                              transform: Matrix4.translation(_shake()),
                            )),
                          )),
                          GestureDetector(
                            onTap: () => getNextQuestion(),
                            child: ConstrainedBox(
                              child: Container(
                                child: Center(
                                    child: Image.asset(
                                        'resources/imgs/arrow_forward.png')),
                              ),
                              constraints: BoxConstraints(
                                  minWidth: 40.0, minHeight: 40.0),
                            ),
                          )
                        ],
                      ),
                      constraints: BoxConstraints(minHeight: 40),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: Color(0xffE3E3E3)),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(color: Color(0xC0C0C0)),
                        child: Visibility(
                          visible: !_isSearching,
                          child: Card(
                            elevation: 5.0,
                            margin: EdgeInsets.only(
                                top: 15.0, bottom: 20.0, left: 5, right: 5),
                            child: Padding(
                              padding: EdgeInsets.all(7.0),
                              child: SingleChildScrollView(
                                controller: _answerScrollController,
                                child: FutureBuilder<List<Answer>>(
                                  future: widget.appDatabase.answerDao
                                      .findAllAnswersForCard(widget
                                          .cards[currentQuestionIndex].id),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<Answer>> snapshot) {
                                    _answers = snapshot.data;
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.none:
                                        return Text('No result.');
                                      case ConnectionState.active:
                                      case ConnectionState.waiting:
                                        return Text('Awaiting result...');
                                      case ConnectionState.done:
                                        if (snapshot.hasError) {
                                          return Text('Error: ${snapshot.error}');
                                        }
                                        if (snapshot.hasData && snapshot.data.isNotEmpty) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              _getCardAnswers(snapshot),
//TODO FixMe: rebuilding widget when keyboard pops up
//                                              _getSynonymWidget()
                                            ],
                                          );
                                        }
                                        return Container();
                                    }
                                    return Container();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ])),
        ));
  }
}
