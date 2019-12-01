import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddAnswerCardWidget extends StatefulWidget{
  const AddAnswerCardWidget({@required Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AddAnswerCardWidgetState();


}

class AddAnswerCardWidgetState extends State<AddAnswerCardWidget>{
  List<TextEditingController> textEditingControllers =
  <TextEditingController>[];
  int numberPossibleAnswers = 1;




  @override
  void initState() {
    super.initState();
    textEditingControllers.add(new TextEditingController());
  }
  void addAnswer() {
    textEditingControllers.add(new TextEditingController());

    setState(() {
      numberPossibleAnswers++;
    });
  }

  @override
  void dispose() {
    for (var controller in textEditingControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Possible answers',
                  style: TextStyle(fontSize: 20),
                ),
                GestureDetector(
                  child: Image.asset('resources/imgs/add.png',
                      width: 30, height: 30),
                  onTap: () {
                    addAnswer();
                  },
                ),
              ],
            ),
          ),
        ),
        ListView.builder(
            itemCount: numberPossibleAnswers,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Container(
                  decoration: BoxDecoration(),
                  child: TextField(
                    controller: textEditingControllers[index],
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: 20),
                      hintText: 'Possible answer ${index + 1}',
                    ),
                  ),
                ),
              );
            }),
      ],
    );
  }

//  bool handleKey(FocusNode node, RawKeyEvent event) {
//    if (event is RawKeyDownEvent) {
//      RawKeyEventDataAndroid data = event.data as RawKeyEventDataAndroid;
//      if (data.keyCode == 61 || data.keyCode == 66) {
//        addAnswer();
//      }
//    }
//    return true;
//  }
//
//  FocusNode addAnswerFocusNode() {
//    FocusNode node = new FocusNode();
//    node.attach(context, onKey: handleKey);
//    return node;
//  }

}