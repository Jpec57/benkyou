import 'package:benkyou/models/Card.dart' as card_model;
import 'package:benkyou/models/CardWithAnswers.dart';
import 'package:benkyou/models/DTO/PublicDeck.dart';
import 'package:benkyou/models/Deck.dart';
import 'package:benkyou/screens/BrowseOnlineDeckPage.dart';
import 'package:benkyou/screens/CardListPage.dart';
import 'package:benkyou/screens/CardShowPage.dart';
import 'package:benkyou/screens/DeckInfoPage.dart';
import 'package:benkyou/screens/DeckPage.dart';
import 'package:benkyou/screens/PreviewOnlineDeckPage.dart';
import 'package:benkyou/screens/TinderLikePage.dart';
import 'package:benkyou/screens/UserProfilePage.dart';
import 'package:benkyou/services/database/DBProvider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

void goToCardPage(BuildContext context, CardWithAnswers card) async{
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


void goToTinderLikePage(BuildContext context, {int deckId}) async{
  AppDatabase appDatabase = await DBProvider.db.database;
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TinderLikePage(
            cardDao: appDatabase.cardDao,
            deckId: deckId,
          )
      )
  );
}

void goToUserProfilePage(BuildContext context) async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UserProfilePage(username: preferences.getString('username'), userUid: preferences.getString('uuid'), cardDao: null,)
      )
  );
}

void goToBrowsingDeckPage(BuildContext context) async{
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BrowseOnlineDeckPage(
          )
      )
  );
}

void goToPreviewOnlineDeckPage(BuildContext context, PublicDeck deck) async{
  AppDatabase appDatabase = await DBProvider.db.database;

  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PreviewOnlineDeckPage(
            deck: deck,
            deckDao: appDatabase.deckDao,
          )
      )
  );
}