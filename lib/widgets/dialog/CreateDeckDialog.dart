import 'package:benkyou/models/Deck.dart';
import 'package:benkyou/services/database/DeckDao.dart';
import 'package:flutter/material.dart';

class CreateDeckDialog extends StatefulWidget{
  final DeckDao deckDao;

  const CreateDeckDialog({Key key, this.deckDao}) : super(key: key);

  @override
  _CreateDeckDialogState createState() => new _CreateDeckDialogState();
}

class _CreateDeckDialogState extends State<CreateDeckDialog>{
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  bool _isTitleErrorVisible = false;


  @override
  Widget build(BuildContext context) {

    return (
        Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Container(
              height: 300.0,
              width: 300.0,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Create a deck',
                      style: TextStyle(fontSize: 20)
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(hintText: 'Title'),
                        autofocus: true,
                        onChanged: (value){
                          setState(() {
                            _isTitleErrorVisible = false;
                          });
                          _formKey.currentState.validate();
                        },
                        validator: (value) {
                          if (_isTitleErrorVisible){
                            if (value.isEmpty) {
                              return 'Please enter a title';
                            }
                            return 'This title is already used.\n Please choose another one.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        decoration: BoxDecoration(color: Colors.black45),
                        child: Image.asset('resources/imgs/add_photo.png'),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {_validateDeckTitle();},
                      child: Text('Create', style: TextStyle(color: Colors.white),),
                      color: Colors.blue,
                    )
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

  Future<bool> _validateDeckTitle() async {
    if (_formKey.currentState.validate()) {
      if (titleController.text.isEmpty){
        setState(() {
          _isTitleErrorVisible = true;
        });
        _formKey.currentState.validate();
        return false;
      }
      var deck = await widget.deckDao.findDeckByTitle(titleController.text);

      if (deck != null) {
        setState(() {
          _isTitleErrorVisible = true;
        });
        _formKey.currentState.validate();
        return false;
      }
      var res = await _addDeck(titleController.text);
      if (res) {
        titleController.clear();
        Navigator.of(context, rootNavigator: true).pop('dialog');
        return true;
      }
    }
    return true;
  }

  Future<bool> _addDeck(title) async {
    widget.deckDao.insertDeck(new Deck(null, titleController.text, new DateTime.now().millisecondsSinceEpoch));
    setState(() {});
    return true;
  }
}