import 'package:benkyou/models/Answer.dart';
import 'package:benkyou/models/Card.dart' as card_model;
import 'package:benkyou/services/database/Database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TinderCard extends StatefulWidget{
  final bool isAnswerVisible;
  final card_model.Card card;
  final Color color;
  final AppDatabase database;

  const TinderCard({
    Key key,
    @required this.isAnswerVisible,
    @required this.card,
    @required this.database,
    this.color,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TinderCardState();
  }

}

class TinderCardState extends State<TinderCard> {
  List<String> _parsedAnswers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.database != null){
        List<Answer> unparsedAnswers = await widget.database.answerDao.findAllAnswersForCard(widget.card.id);
        for (Answer a in unparsedAnswers){
          _parsedAnswers.add(a.content);
        }
      }
    });
  }


  @override
  void dispose() {
      super.dispose();
      _parsedAnswers = [];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.color ?? Colors.white,
      elevation: 12.0,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(widget.card.question.replaceAll('|', ', '),
                    style: TextStyle(fontSize: 40),
                    textAlign: TextAlign.center),
                Text(widget.card.hint != null ? widget.card.hint : "",
                    style: TextStyle(fontSize: 24), textAlign: TextAlign.center)
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Opacity(
                  opacity: widget.isAnswerVisible ? 1.0 : 0.0,
                  child: Text(_parsedAnswers.isNotEmpty ? _parsedAnswers.join(', ') : '',
                      style: TextStyle(fontSize: 20.0),
                      textAlign: TextAlign.center),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
