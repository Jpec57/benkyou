import 'package:benkyou/models/CardWithAnswers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TinderCard extends StatelessWidget {
  final bool isAnswerVisible;
  final CardWithAnswers card;
  final Color color;

  const TinderCard(
      {Key key, @required this.isAnswerVisible, @required this.card, this.color, })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: this.color ?? Colors.white,
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
                Text(card.question,
                    style: TextStyle(fontSize: 40),
                    textAlign: TextAlign.center),
                Text(card.hint != null ? card.hint : "",
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center)
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Opacity(
                  opacity: isAnswerVisible ? 1.0 : 0.0,
                  child: Text(card.answerContents.join(', '),
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
