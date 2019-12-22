import 'package:benkyou/models/Answer.dart';
import 'package:benkyou/models/Card.dart' as model_card;
import 'package:benkyou/models/CardWithAnswers.dart';
import 'package:benkyou/services/database/DBProvider.dart';
import 'package:benkyou/services/database/Database.dart';
import 'package:benkyou/services/navigator.dart';
import 'package:benkyou/utils/utils.dart';
import 'package:benkyou/widgets/AddAnswerCardWidget.dart';
import 'package:benkyou/widgets/Header.dart';
import 'package:benkyou/widgets/JishoList.dart';
import 'package:benkyou/widgets/app/BasicContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardShowPage extends StatefulWidget {
  final CardWithAnswers card;

  const CardShowPage({Key key, this.card}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CardShowPageState();
}

class CardShowPageState extends State<CardShowPage> {
  GlobalKey<AddAnswerCardWidgetState> answerWidgetKey =
      new GlobalKey<AddAnswerCardWidgetState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      answerWidgetKey.currentState.setNewAnswers(widget.card.answerContents);
    });
  }

  void _updateCardWithAnswers() async {
    AppDatabase appDatabase = await DBProvider.db.database;
    List<String> answers = [];
    for (var answerController
    in answerWidgetKey.currentState.textEditingControllers) {
      if (answerController.text.isNotEmpty) {
        answers.add(answerController.text.toLowerCase());
      }
    }
    appDatabase.answerDao.updateAnswersFromCard(widget.card.id, answers);
  }

  Widget _renderHeader() {
    return Container(
      padding: EdgeInsets.only(left: 20.0),
      height: MediaQuery.of(context).size.height * 0.12,
      decoration: BoxDecoration(color: Colors.orange),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                goToCardListPage(context);
              },
              child: Container(
                  child: Image.asset('resources/imgs/arrow_back.png')),
            ),
          ),
          Flexible(
            flex: 5,
            child: Align(
              widthFactor: 4,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "${widget.card.question}",
                      style: TextStyle(fontSize: 30, fontFamily: 'Pacifico'),
                    ),
                    _renderSubtitle(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderSubtitle() {
    if (widget.card.hint != null) {
      return Text(
        "${widget.card.hint}",
        style: TextStyle(
            fontSize: 12, fontFamily: 'Pacifico', color: Color(0xff424242)),
      );
    }
    return Container();
  }

  Widget _renderDeleteButton(BuildContext context) {
    if (isKeyboardVisible(context)) {
      return Container();
    }
    return GestureDetector(
      onTap: () async {
        AppDatabase database = await DBProvider.db.database;
        database.cardDao.deleteCard(widget.card.id);
        goToCardListPage(context);
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.10,
        decoration: BoxDecoration(color: Colors.red),
        child: Center(
          child: Text(
            'DELETE CARD',
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasicContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _renderHeader(),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 50.0, right: 50.0),
                child: AddAnswerCardWidget(key: answerWidgetKey, isUpdate: true, cardId: widget.card.id),
              ),
            ),
          ),
          _renderDeleteButton(context),
          GestureDetector(
            onTap: (){
              _updateCardWithAnswers();
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.10,
              decoration: BoxDecoration(color: Colors.blue),
              child: Center(
                child: Text(
                  'UPDATE CARD',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
