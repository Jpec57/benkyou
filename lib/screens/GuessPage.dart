import 'dart:math';

import 'package:benkyou/services/navigator.dart';
import 'package:benkyou/widgets/Header.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:benkyou/models/Answer.dart';
import 'package:benkyou/models/Card.dart' as prefix0;
import 'package:benkyou/services/database/Database.dart';
import 'package:benkyou/widgets/EnterInput.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

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

class GuessBanner extends StatefulWidget {
  final prefix0.Card card;

  GuessBanner({Key key, this.card}) : super(key: key);

  @override
  _GuessBannerState createState() => _GuessBannerState();
}

class _GuessBannerState extends State<GuessBanner> {
  FlutterTts flutterTts = new FlutterTts();
  TtsState ttsState = TtsState.stopped;
  bool _isHintNeeded = true;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();

    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });
    initTts();
  }

  Future initTts() async {
    List<dynamic> languages = await flutterTts.getLanguages;
    await flutterTts.setLanguage("ja-JP");
    await flutterTts.setSpeechRate(1.0);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.isLanguageAvailable("ja-JP");
    _speak();
  }

  Future _speak() async {
    var result = await flutterTts.speak(widget.card.question);
    if (result == 1) setState(() => ttsState = TtsState.playing);
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  @override
  Widget build(BuildContext context) {
    return (ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.2,
        maxHeight: MediaQuery.of(context).size.height * 0.2,
      ),
      child: GestureDetector(
        onLongPress: () {},
        child: Stack(children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    widget.card.question,
                    style: TextStyle(fontSize: 30),
                  ),
                  Visibility(
                    visible: _isHintNeeded,
                    child: Text(
                      widget.card.hint ?? '',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10.0,
            right: 15.0,
            child: GestureDetector(
              onTap: () {
                if (ttsState == TtsState.playing) {
                  _stop();
                } else {
                  _speak();
                }
              },
              child: Container(
                padding: EdgeInsets.all(2.0),
                child: Image.asset('resources/imgs/sound.png'),
                decoration: BoxDecoration(
                    color: Colors.black12, shape: BoxShape.circle),
              ),
            ),
          )
        ]),
      ),
    ));
  }
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
  final _newAnswerController = TextEditingController();
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
    _newAnswerController.dispose();
    _answerScrollController.dispose();
    super.dispose();
  }

  void getNextQuestion() async {
    if (!answerController.text.isNotEmpty) {
      animationController.forward().whenComplete((){
        animationController.reset();
      });
      return;
    }
    if (_isSearching) {
      bool res = await widget.cards[currentQuestionIndex]
          .checkIfCorrectAnswer(answerController.text);

      await widget.cards[currentQuestionIndex].updateCard(widget.appDatabase, res);
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
                                  hintStyle: TextStyle(color: Colors.white30)),
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
                            constraints:
                                BoxConstraints(minWidth: 40.0, minHeight: 40.0),
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
                                future: widget.appDatabase.answerDao.findAllAnswersForCard(
                                    widget.cards[currentQuestionIndex].id),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<Answer>> snapshot) {
                                  _answers = snapshot.data;
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                      return Text('Press button to start .');
                                    case ConnectionState.active:
                                    case ConnectionState.waiting:
                                      return Text('Awaiting result...');
                                    case ConnectionState.done:
                                      if (snapshot.hasError)
                                        return Text('Error: ${snapshot.error}');
                                      if (snapshot.hasData) {
                                        Widget answerPart;
                                        if (snapshot.data.length > 1) {
                                          var answerContainers = [];
                                          for (var i = 1;
                                              i < _answers.length;
                                              i++) {
                                            answerContainers.addAll([
                                              new Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: new Divider()),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 15.0),
                                                child: Container(
                                                  child: Text(
                                                    _answers[i].content,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              )
                                            ]);
                                          }
                                          answerPart = Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              Text(
                                                _answers[0].content,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 25),
                                              ),
                                              ...answerContainers
                                            ],
                                          );
                                        } else {
                                          answerPart = Text(
                                            _answers[0].content,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 30),
                                          );
                                        }

                                        return Column(
                                          children: <Widget>[
                                            answerPart,
                                            Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: Container(
                                                child: GestureDetector(
                                                  onTap: () async{
                                                    Answer answer = new Answer(null, widget.cards[currentQuestionIndex].id, _newAnswerController.text);
                                                    await widget.appDatabase.answerDao.insertAnswer(answer);
                                                    this.setState((){
                                                      _newAnswerController.clear();
                                                      _answerScrollController.jumpTo(_answerScrollController.position.maxScrollExtent);
                                                    });
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.only(right: 15.0),
                                                        child: Image.asset('resources/imgs/add.png',
                                                            width: 15, height: 15),
                                                      ),
                                                      SizedBox(
                                                        width: 150,
                                                        child: Padding(
                                                          padding: EdgeInsets.only(top: 15),
                                                          child: TextField(
                                                              maxLines: 2,
                                                              onEditingComplete: () {
                                                                print('done editing');
                                                              },
                                                              controller: _newAnswerController,
                                                              decoration: InputDecoration.collapsed(
                                                                  border: InputBorder.none,
                                                                  hintText: 'Enter a synonym'
                                                              )
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        );
                                      }
                                  }
                                  return null; // unreachable
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
      ),
    );
  }
}
