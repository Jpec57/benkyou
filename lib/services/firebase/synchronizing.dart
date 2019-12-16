import 'dart:convert';

import 'package:benkyou/models/Answer.dart' as answer_model;
import 'package:benkyou/models/Card.dart' as card_model;
import 'package:benkyou/models/Deck.dart' as deck_model;
import 'package:benkyou/services/database/AnswerDao.dart';
import 'package:benkyou/services/database/CardDao.dart';
import 'package:benkyou/services/database/DBProvider.dart';
import 'package:benkyou/services/database/Database.dart';
import 'package:benkyou/services/database/DeckDao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

void synchronizeDecksInDatabaseFromFirebase(DeckDao deckDao, Map<String, dynamic> jsonList) async{
  jsonList.forEach((key, value) async{
    deck_model.Deck deck = deck_model.Deck.fromJSON(new Map<String, dynamic>.from(value));
      deckDao.insertDeck(deck).then((_){
        print('sucess ${deck.id} ${deck.title}');
      }).catchError((err, stackTrace){
        if (!err.toString().contains("UNIQUE constraint failed")){
          print("fail deck ${deck.id} ${deck.title} ${err.toString()}");
        }
      });
  });
}

void synchronizeCardsInDatabaseFromFirebase(CardDao cardDao, Map<String, dynamic> jsonList) async{
  jsonList.forEach((key, value) async{
    card_model.Card card = card_model.Card.fromJSON(new Map<String, dynamic>.from(value));
    cardDao.insertCard(card).then((_){
      print('sucess ${card.id} ${card.question}');
    }).catchError((err, stackTrace){
      if (!err.toString().contains("UNIQUE constraint failed")) {
        print("fail card ${card.id} ${card.question} ${err.toString()}");
      }
    });
  });
}

void synchronizeAnswersInDatabaseFromFirebase(AnswerDao answerDao, Map<String, dynamic> jsonList) async{
  jsonList.forEach((key, value) async{
    answer_model.Answer answer = answer_model.Answer.fromJSON(new Map<String, dynamic>.from(value));
    answerDao.insertAnswer(answer).then((_){
      print('sucess ${answer.id} ${answer.content}');
    }).catchError((err, stackTrace){
      if (!err.toString().contains("UNIQUE constraint failed")) {
        print("fail answer ${answer.id} ${answer.content} ${err.toString()}");
      }
    });
  });
}

void synchronizeFirebaseWithLocalData() async{
  AppDatabase database = await DBProvider.db.database;
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String uuid = sharedPreferences.getString('uuid');
  print(uuid);
  CollectionReference ref = Firestore.instance.collection('benkyou/users/$uuid').reference();
  QuerySnapshot querySnapshot = await ref.getDocuments();

  Map<String, Map<String, dynamic>> orderedDocuments = new Map();
  querySnapshot.documents.map((DocumentSnapshot documentSnapshot){
  });
  for (DocumentSnapshot documentSnapshot in querySnapshot.documents){
    orderedDocuments.addAll({documentSnapshot.documentID: documentSnapshot.data});
  }
  if (orderedDocuments.containsKey(deck_model.FIREBASE_KEY)){
    await synchronizeDecksInDatabaseFromFirebase(database.deckDao, orderedDocuments[deck_model.FIREBASE_KEY]);
  }
  if (orderedDocuments.containsKey(card_model.FIREBASE_KEY)){
    await synchronizeCardsInDatabaseFromFirebase(database.cardDao, orderedDocuments[card_model.FIREBASE_KEY]);
  }
  if (orderedDocuments.containsKey(answer_model.FIREBASE_KEY)){
    await synchronizeAnswersInDatabaseFromFirebase(database.answerDao, orderedDocuments[answer_model.FIREBASE_KEY]);
  }
}