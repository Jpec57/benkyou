import 'package:benkyou/models/JishoTranslation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddAnswerCardWidget extends StatefulWidget{
  final String hint;

  const AddAnswerCardWidget({@required Key key, this.hint}) : super(key: key);

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
  void addAnswer({String value}) {
    textEditingControllers.add(new TextEditingController());
    if (value != null){
      textEditingControllers[textEditingControllers.length - 1].text = value;
    }
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

  Future<http.Response> getJishoTranslations(String word) async{
    JishoTranslation.getJishoTransLationListFromRequest(word);
    return null;
  }

  void setNewAnswers(List<String> answers){
    List<int> availableControllers = new List<int>();
    for (var i = 0; i < textEditingControllers.length; i++){
      if (textEditingControllers[i].text.length == 0){
        availableControllers.add(i);
      }
    }
    int availableControllerNb = availableControllers.length;
    int answerNb = answers.length;
    int i = 0;
    while (i < availableControllerNb && i < answerNb){
      textEditingControllers[availableControllers[i]].text = answers[i];
      i++;
    }
    while (i < answerNb){
     addAnswer(value: answers[i]);
     i++;
    }
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
        Padding(
          padding: EdgeInsets.only(bottom: 50),
          child: ListView.builder(
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
        ),
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