import 'package:benkyou/models/Answer.dart';
import 'package:benkyou/models/JishoTranslation.dart';
import 'package:benkyou/services/database/DBProvider.dart';
import 'package:benkyou/services/database/Database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddAnswerCardWidget extends StatefulWidget {
  final String hint;
  final bool isUpdate;
  final int cardId;

  const AddAnswerCardWidget({@required Key key, this.hint, this.isUpdate = false, this.cardId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AddAnswerCardWidgetState();
}

class AddAnswerCardWidgetState extends State<AddAnswerCardWidget> {
  DragStartDetails startHorizontalDragDetails;
  DragUpdateDetails updateHorizontalDragDetails;

  List<TextEditingController> textEditingControllers =
      <TextEditingController>[];

  @override
  void initState() {
    super.initState();
    textEditingControllers.add(new TextEditingController());
  }

  void addAnswer({String value}) {
    textEditingControllers.add(new TextEditingController());
    if (value != null) {
      textEditingControllers[textEditingControllers.length - 1].text = value;
    }
    setState(() {});
  }

  @override
  void dispose() {
    for (var controller in textEditingControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void setNewAnswers(List<String> answers) {
    List<int> availableControllers = new List<int>();
    for (var i = 0; i < textEditingControllers.length; i++) {
      if (textEditingControllers[i].text.isEmpty) {
        availableControllers.add(i);
      }
    }
    int availableControllerNb = availableControllers.length;
    int answerNb = answers.length;
    int i = 0;
    while (i < availableControllerNb && i < answerNb) {
      textEditingControllers[availableControllers[i]].text = answers[i];
      i++;
    }
    while (i < answerNb) {
      addAnswer(value: answers[i]);
      i++;
    }
  }

  void _deleteAnswerFromDatabase(String content) async{
    AppDatabase database = await DBProvider.db.database;
    Answer answer = await database.answerDao.findAnswerForCardWithTitle(widget.cardId, content);
    if (answer != null){
      await database.answerDao.deleteAnswer(answer.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
          child:  ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: textEditingControllers.length + 1,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (index == textEditingControllers.length){
                  return (Container());
                }
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: GestureDetector(
                    onHorizontalDragStart: (dragDetails) {
                      startHorizontalDragDetails = dragDetails;
                    },
                    onHorizontalDragUpdate: (dragDetails) {
                      updateHorizontalDragDetails = dragDetails;
                    },
                    onHorizontalDragEnd: (endDetails) {
                      double dx =
                          updateHorizontalDragDetails.globalPosition.dx -
                              startHorizontalDragDetails.globalPosition.dx;

                      double velocity = endDetails.primaryVelocity;

                      //Convert values to be positive
                      if (dx < 0) dx = -dx;

                      if (velocity > 0) {
                        if (widget.isUpdate){
                          _deleteAnswerFromDatabase(textEditingControllers[index].text);
                        }
                        textEditingControllers.removeAt(index);
                        setState(() {});
                      }
                    },
                    child: Card(
                      child: ListTile(
                        title: TextField(
                          controller: textEditingControllers[index],
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelStyle: TextStyle(fontSize: 20),
                            hintText: 'Possible answer ${index + 1}',
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
