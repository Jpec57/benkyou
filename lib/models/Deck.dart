import 'package:benkyou/models/Card.dart';

class Deck {
  final int id;
  final String title;
  List<Card> cards = [];

  Deck({this.id, this.title});
}