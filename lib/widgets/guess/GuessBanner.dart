import 'package:benkyou/screens/GuessPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:benkyou/models/Card.dart' as prefix0;

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
//    List<dynamic> languages = await flutterTts.getLanguages;
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