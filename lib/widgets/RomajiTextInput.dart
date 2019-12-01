import 'package:benkyou/services/translator/TextConversion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// TODO use input in french and display in japanese as one field
class RomajiTextInput extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _RomajiTextInputState();
}

class _RomajiTextInputState extends State<RomajiTextInput> {

  TextEditingController _titleEditingController;
  TextEditingController _hiddenTitleEditingController;
  String romaji;

  @override
  void initState() {
    super.initState();
    _titleEditingController = new TextEditingController();
    _hiddenTitleEditingController = new TextEditingController();
    _titleEditingController.addListener((){
//      print('VISIBLE listener ${_titleEditingController.text}');
//      final text = _titleEditingController.text.toLowerCase();
//      _titleEditingController.value = _titleEditingController.value.copyWith(
//          text: text,
//          selection: TextSelection(baseOffset: text.length, extentOffset: text.length),
//      composing: TextRange.empty
//      );
    });
    _hiddenTitleEditingController.addListener((){
      print('hidden listener ${_hiddenTitleEditingController.text}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: 'Hello ',
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(text: 'bold', style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: ' world!'),
            ],
          ),
        ),
        TextField(
          controller: _titleEditingController,
          onChanged: (text){
            _hiddenTitleEditingController.text = text +'a';
//            _titleEditingController.text = getJapaneseTranslation(text);
          },
          decoration: InputDecoration(
              labelText: 'Question',
              labelStyle: TextStyle(fontSize: 20),
              hintText:
              'Enter a question / a word to remember'),
          autofocus: true,
        ),
        Visibility(
          visible: false,
          child: TextField(
            onChanged: (text){
              print('onChanged $text');
            },
            controller: _hiddenTitleEditingController,
          ),
        ),
      ],
    );
  }
}