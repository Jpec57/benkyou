import 'package:benkyou/services/translator/TextConversion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RomajiTextInput extends StatefulWidget{
  final bool mustConvertToKana;
  final InputDecoration decoration;
  final Function onChanged;
  final TextAlign textAlign;
  final TextEditingController titleEditingController;
  final FocusNode focusNode;
  final bool autoFocus;
  final Function onEditingComplete;
  final TextStyle textStyle;

//  static _RomajiTextInputState of(BuildContext context) => context.findRootAncestorStateOfType();

  const RomajiTextInput({Key key, @required this.mustConvertToKana, this.decoration, this.onChanged, this.textAlign, this.focusNode, this.autoFocus, this.onEditingComplete, this.textStyle,  @required this.titleEditingController}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RomajiTextInputState();
}

class _RomajiTextInputState extends State<RomajiTextInput> {

//  TextEditingController titleEditingController;
  TextEditingController hiddenTitleEditingController;
  String previousValue = "";

  @override
  void initState() {
    super.initState();
//    titleEditingController = new TextEditingController();
    hiddenTitleEditingController = new TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
//    titleEditingController.clear();
    hiddenTitleEditingController.clear();
  }




  void onConversionChanged(String text){
    if (widget.mustConvertToKana){
      hiddenTitleEditingController.text = getRomConversion(text, onlyRomaji: false);
      String japanese = getJapaneseTranslation(hiddenTitleEditingController.text, hasSpace: true);
      int cursor = getCursorPosition(previousValue, japanese);
      setState(() {
        widget.titleEditingController.text = japanese;
//            titleEditingController.selection = TextSelection.fromPosition(TextPosition(offset: cursor));
        widget.titleEditingController.selection = TextSelection.fromPosition(TextPosition(offset: japanese.length));
        previousValue = japanese;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.titleEditingController,
      onChanged: (text){
        print("help ${text}");
        onConversionChanged(text);
        widget.onChanged(text);
      },
      decoration: widget.decoration,
      textAlign: widget.textAlign,
      style: widget.textStyle,
      focusNode: widget.focusNode,
      autofocus: widget.autoFocus,
      onEditingComplete: (){
        widget.onEditingComplete();
      },
    );
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


//  @override
//  Widget build(BuildContext context) {
//    return Column(
//      children: <Widget>[
//        TextField(
//          controller: titleEditingController,
//          onChanged: (text){
//            onConversionChanged(text);
//          },
//          decoration: InputDecoration(
//              labelText: 'Question',
//              labelStyle: TextStyle(fontSize: 20),
//              hintText:
//              'Enter a question / a word to remember'),
//        ),
//        Text(hiddenTitleEditingController.text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),)
//      ],
//    );
//  }
}