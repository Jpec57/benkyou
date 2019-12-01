import 'dart:async';

import 'package:benkyou/models/Answer.dart';
import 'package:benkyou/models/Card.dart';
import 'package:benkyou/models/Deck.dart';
import 'package:benkyou/models/User.dart';
import 'package:benkyou/services/database/AnswerDao.dart';
import 'package:benkyou/services/database/CardDao.dart';
import 'package:benkyou/services/database/DeckDao.dart';
import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'Database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [
  Deck,
  Card,
  Answer,
  User
])
abstract class AppDatabase extends FloorDatabase {
  DeckDao get deckDao;

  CardDao get cardDao;

  AnswerDao get answerDao;

}