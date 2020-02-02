import 'package:benkyou/services/translator/TextConversion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RomajiTextInput extends StatefulWidget{
  final bool mustConvertToKana;

  const RomajiTextInput({Key key, this.mustConvertToKana}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RomajiTextInputState();
}

class _RomajiTextInputState extends State<RomajiTextInput> {

  TextEditingController _titleEditingController;
  TextEditingController _hiddenTitleEditingController;
  String previousValue = "";

  @override
  void initState() {
    super.initState();
    _titleEditingController = new TextEditingController();
    _hiddenTitleEditingController = new TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _titleEditingController.clear();
    _hiddenTitleEditingController.clear();
  }

  //TODO improve cursor position to be able to modify in a japanese word
  // https://github.com/Jpec57/benkyou/issues/16
  int getCursorPosition(String before, String after){
//    print("${before} | ${after}");
//    print("Length ${before.length} | ${after.length}");
    int beforeLength = before.length;
    int afterLength = after.length;
    int bonus = 0;
    int size = (beforeLength < afterLength) ? beforeLength : afterLength;
    int i = 0;
    while (i < size){
//      print("cmp ${before[i]} ${after[i]}");
      if (before[i] != after[i]){
//        print("DIFF: ${i + 1}");
        if (afterLength < beforeLength){
          return i + bonus;
        }
        return i + 1 + bonus;
      }
      i++;
    }
    if (afterLength < beforeLength){
      return i + bonus;
    }
    return i + 1 + bonus;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _titleEditingController,
      onChanged: (text){
        if (widget.mustConvertToKana){
          _hiddenTitleEditingController.text = getRomConversion(text, onlyRomaji: false);
          String japanese = getJapaneseTranslation(_hiddenTitleEditingController.text);
          int cursor = getCursorPosition(previousValue, japanese);
          _titleEditingController.text = japanese;
//            _titleEditingController.selection = TextSelection.fromPosition(TextPosition(offset: cursor));
          _titleEditingController.selection = TextSelection.fromPosition(TextPosition(offset: japanese.length));
          previousValue = japanese;
        }
      },
      decoration: InputDecoration(
          labelText: 'Question',
          labelStyle: TextStyle(fontSize: 20),
          hintText:
          'Enter a question / a word to remember'),
    );
  }
}