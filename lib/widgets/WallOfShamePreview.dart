import 'dart:async';
import 'package:benkyou/services/database/CardDao.dart';
import 'package:benkyou/services/database/DBProvider.dart';
import 'package:benkyou/utils/string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WallOfShamePreview extends StatefulWidget {
  final CardDao cardDao;
  final int deckId;

  const WallOfShamePreview({Key key, this.cardDao, this.deckId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _WallOfShamePreviewState();
}

class _WallOfShamePreviewState extends State<WallOfShamePreview> {
  List<Map<String, dynamic>> _badCards;
  int _index = 0;
  int _badCardsLength = 0;
  Timer _timer;
  bool _isVisible = true;
  String _shameQuestion = 'Empty.';
  String _shameAnswer = '';
  final fadeInDuration = 3;

  @override
  void initState() {
    super.initState();
    initBadCards();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }



  void setTimer() async{
    if (_badCardsLength > 0){
      setState(() {
        _shameQuestion = getQuestionInNativeLanguage(_badCards[0]['question']);
        _shameAnswer = _badCards[0]['answer'];
        _isVisible = !_isVisible;
      });
      _timer = Timer.periodic(Duration(seconds: fadeInDuration + 1), (timer) {
        _index = (_index + 1) % _badCardsLength;
        setState(() {
          _shameQuestion = getQuestionInNativeLanguage(_badCards[_index]['question']);
          _shameAnswer = _badCards[_index]['answer'];
          _isVisible = !_isVisible;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.black),
            child: Center(
              child: Text(
                "Wall of shame",
                style: TextStyle(
                    color: Colors.white, fontSize: 30, fontFamily: 'Pacifico'),
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: Duration(seconds: fadeInDuration),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 15.0, top: 15.0),
                  child: Center(
                    child: Text(
                      _shameQuestion,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                ClipRect(
                    child: Text(
                      _shameAnswer,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }


  initBadCards() async {
    var database = await DBProvider.db.database;
    _badCards = await database.cardDao.getBadCards(widget.deckId);
    _badCardsLength = _badCards.length;
    setTimer();
  }
}
