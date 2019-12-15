import 'package:benkyou/models/Card.dart' as card_model;
import 'package:benkyou/models/Deck.dart';
import 'package:benkyou/screens/CardListPage.dart';
import 'package:benkyou/screens/CardShowPage.dart';
import 'package:benkyou/screens/DeckInfoPage.dart';
import 'package:benkyou/screens/DeckPage.dart';
import 'package:benkyou/services/database/DBProvider.dart';
import 'package:flutter/material.dart';

import 'database/Database.dart';

void goToHomePage(BuildContext context) async {
  AppDatabase appDatabase = await DBProvider.db.database;
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DeckPage(
            deckDao: appDatabase.deckDao,
            cardDao: appDatabase.cardDao,
          )
      )
  );
}

void goToDeckInfoPage(BuildContext context, int deckId) async{
  AppDatabase appDatabase = await DBProvider.db.database;
  Deck deck = await appDatabase.deckDao.findDeckById(deckId);
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DeckInfoPage(
            cardDao: appDatabase.cardDao,
            deck: deck,
          )
      )
  );
}

void goToCardPage(BuildContext context, int cardId) async{
  AppDatabase appDatabase = await DBProvider.db.database;
  card_model.Card card = await appDatabase.cardDao.findCardById(cardId);
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CardShowPage(
            card: card,
          )
      )
  );
}

void goToCardListPage(BuildContext context) async{
  AppDatabase appDatabase = await DBProvider.db.database;
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CardListPage(
            database: appDatabase,
          )
      )
  );
}