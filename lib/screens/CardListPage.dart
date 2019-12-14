import 'package:benkyou/models/Card.dart' as ModelCard;
import 'package:benkyou/models/CardWithAnswers.dart';
import 'package:benkyou/services/database/Database.dart';
import 'package:benkyou/widgets/app/BasicContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardListPage extends StatefulWidget {
  final AppDatabase database;

  const CardListPage({Key key, @required this.database}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CardListPageState();
}

class CardListPageState extends State<CardListPage> {
  TextEditingController _researchTermController;
  DragStartDetails startHorizontalDragDetails;
  DragUpdateDetails updateHorizontalDragDetails;

  @override
  void initState() {
    super.initState();
    _researchTermController = new TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _researchTermController.dispose();
  }

  String _getTitleFormat(ModelCard.Card card) {
    if (card.hint != null) {
      return '${card.question} - ${card.hint}';
    }
    return '${card.question}';
  }

  @override
  Widget build(BuildContext context) {
    return BasicContainer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: TextField(
                    controller: _researchTermController,
//                    decoration: InputDecoration(
//                        border: InputBorder.none
//                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                  future: widget.database.cardDao.findAllCardsWithAnswers(),
                  builder: (_, AsyncSnapshot<List<CardWithAnswers>> snapshot) {
                    if (snapshot.hasData && snapshot.data.length > 0) {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ExpansionTile(
                              title:
                                  Text(_getTitleFormat(snapshot.data[index])),
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    print("Show card");
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      itemCount: snapshot
                                          .data[index].answerContents.length,
                                      itemBuilder:
                                          (BuildContext context, int subIndex) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(snapshot.data[index]
                                                .answerContents[subIndex]),
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) => Divider(
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            );
                          });
                    }
                    return Container(
                      child: Text('No entry yet. Please create a card.'),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }
}
