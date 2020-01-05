import 'package:benkyou/models/Card.dart' as prefix0;
import 'package:benkyou/models/CardCounter.dart';
import 'package:benkyou/services/database/CardDao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SRSPreview extends StatefulWidget {
  final CardDao cardDao;
  final int deckId;

  const SRSPreview({Key key, @required this.cardDao, @required this.deckId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SRSPreviewState();
}

class _SRSPreviewState extends State<SRSPreview> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Color(0xff248CCB),
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(4.0),
                    topRight: const Radius.circular(4.0)
                ) //              shape:
            ),
            child: Center(
              child: Text(
                "SRS Resume",
                style: TextStyle(
                    color: Colors.white, fontSize: 30, fontFamily: 'Pacifico'),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15.0, top: 15.0),
            child: Center(
              child: FutureBuilder<List<CardCounter>>(
                future: widget.cardDao
                    .getNumberOfCardsPerLvlsForDeckId(widget.deckId),
                builder: (BuildContext context,
                    AsyncSnapshot<List<CardCounter>> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Text('Press button to start .');
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return Text('Awaiting result...');
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (snapshot.hasData) {
                        if (snapshot.data.isEmpty) {
                          return Text('Empty');
                        }
                        return new ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int i) {
                            return Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: 25.0,
                                  height: 25.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                      "resources/icon/app_icon.png"),
                                ),
                                Text(
                                  "${prefix0.CardSRS[snapshot.data[i].lvl >= prefix0.CardSRS.length ? prefix0.CardSRS.length - 1 : snapshot.data[i].lvl]['name']}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 25),
                                ),
                                Text(
                                  "${snapshot.data[i].number}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 25),
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider();
                          },
                        );
                      }
                  }
                  return null; // unreachable
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
