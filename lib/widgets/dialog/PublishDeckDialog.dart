import 'package:benkyou/models/DTO/PublicDeck.dart';
import 'package:benkyou/models/Deck.dart';
import 'package:benkyou/services/database/DBProvider.dart';
import 'package:benkyou/services/database/Database.dart';
import 'package:benkyou/services/navigator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PublishDeckDialog extends StatefulWidget{
  final Deck deck;

  const PublishDeckDialog({Key key, @required this.deck}) : super(key: key);
  @override
  State<StatefulWidget> createState() => PublishDeckDialogState();

}

class PublishDeckDialogState extends State<PublishDeckDialog>{
  TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _descriptionController = new TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {

    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  Future<void> _publishDeck() async {
    Deck deck = widget.deck;
    AppDatabase appDatabase = await DBProvider.db.database;
    //TODO user instead of Jpec
    deck.isPublic = true;
    deck.description = _descriptionController.text;
    await appDatabase.deckDao.updateDeck(deck);
    Map<String, dynamic> data = await convertDeckToPublic(deck);
    await Firestore.instance.collection('decks').document('Jpec:${deck.title}').setData(data);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Container(
          height: 200.0,
          width: 300.0,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Publish deck', style: TextStyle(fontSize: 20)),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                        hintText: 'Description',
                    ),
                    autofocus: true,
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    _publishDeck();
                    goToBrowsingDeckPage(context);
                  },
                  child: Text(
                    'Publish',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}