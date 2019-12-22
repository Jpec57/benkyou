import 'dart:convert';
import 'package:benkyou/models/Card.dart' as CardModel;
import 'package:benkyou/services/database/DBProvider.dart';
import 'package:benkyou/services/database/Database.dart';
import 'package:benkyou/widgets/app/BasicContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class SynchronizePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SynchronizePageState();
}

class _SynchronizePageState extends State<SynchronizePage> {
  void importFromCSV() async {
    String kanji;
    String kana;
    String question;
    String hint;
    String translation;
    String details;
    //https://drive.google.com/open?id=1dsWv_ZoRWFlerr0sNUcofdt0jllqFx3V
    AppDatabase appDatabase = await DBProvider.db.database;
    String id = '1dsWv_ZoRWFlerr0sNUcofdt0jllqFx3V';
    String url =
        'https://drive.google.com/uc?id=$id&authuser=0&export=download';
    int startIndex = 1;
    Response res = await get(url);
    String body = utf8.decode(res.bodyBytes);
    List<String> lines = body.split('\n').sublist(2);
    if (lines.length > 0) {
      List<CardModel.Card> cards = await appDatabase.cardDao.findAllCards();
      List<String> cardQuestions = cards.map((card) => card.question).toList();

      for (var line in lines) {
        List<String> content = line.split(';');
        if (content.length < 3 + startIndex) {
          continue;
        }
        kanji = content[startIndex];
        kana = content[startIndex + 1];
        translation = content[startIndex + 2];
        details =
            (content.length > 3 + startIndex) ? content[startIndex + 3] : null;
        if (kanji.length > 1) {
          question = kanji;
          hint = kana;
        } else {
          question = kana;
          hint = null;
        }
        if (!cardQuestions.contains(question)) {
          List<String> answers = translation.split(',').toList();
          CardModel.Card.setCardWithBasicAnswers(1, question, answers,
              useInContext: details, hint: hint);
        }
      }
    }
    print('done');
  }

  @override
  Widget build(BuildContext context) {
    return BasicContainer(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(child: Text('Synchronize with firebase')),
                    GestureDetector(
                        onTap: () {
                          importFromCSV();
                        },
                        child:
                            Container(
                                color: Colors.blue,
                                child: Text('Import csv', style: TextStyle(fontSize: 30),)
                            )
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }
}
