import 'package:benkyou/models/TimeCard.dart';
import 'package:benkyou/services/database/CardDao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReviewSchedule extends StatefulWidget {
  final double size;
  final List<Color> colors;
  final CardDao cardDao;
  final int deckId;

  const ReviewSchedule(
      {Key key,
      this.size = 100,
      this.colors = const [Colors.red],
        @required this.cardDao, this.deckId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ReviewScheduleState();
}

class ReviewScheduleState extends State<ReviewSchedule> {
  bool isWholeWeek = false;

  Widget _getLabel(String title, {int index = 0}) {
    return Expanded(
      child: Container(
        child: Align(
            alignment: Alignment.topCenter,
            child: Visibility(
              visible: index % 3 == 0,
              child: Text(
                "${title}",
                style: TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            )),
      ),
    );
  }

  Widget _getColumn(double current, double max, int index) {
    if (max <= 0.0){
      max = 1;
    }
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          child: ClipPath(
            clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
              topLeft: Radius.circular(3.0),
              topRight: Radius.circular(3.0),
            ))),
            child: Container(
              child: Center(
                child: Text(
                  "${current.toInt()}",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              decoration: BoxDecoration(
                  color: widget.colors[index % widget.colors.length],
                  border: Border(
                      left: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
                      right:
                          BorderSide(width: 1.0, color: Color(0xFFFF000000)))),
            ),
          ),
          height: widget.size * (current / max),
        ),
      ),
    );
  }

  String getDate(int time){
    return DateTime.fromMillisecondsSinceEpoch(time).toIso8601String();
  }

  Future<List<List<Widget>>> getTimelineSchedule() async {
    List<Widget> columns = new List();
    List<Widget> labels = new List();
    DateTime start = DateTime.now();
    DateTime tmp = start;
    Duration interval;
    DateTime end;

    if (this.isWholeWeek){
      interval = Duration(days: 1);
      start = start.subtract(Duration(hours: start.hour, minutes: start.minute, seconds: start.second));
      end = start.add(Duration(days: 14));
    } else {
      interval = Duration(hours: 1);
      end = start.add(Duration(hours: 12));
    }

    int sum;
    int maxSum = 0;
    List<TimeCard> cards = await widget.cardDao.findCardsByHour(
        start.millisecondsSinceEpoch,
        endDate: end.millisecondsSinceEpoch, deckId: widget.deckId);
    int i;
    int j = 0;

    for (TimeCard card in cards){
      if (maxSum < card.num){
        maxSum = card.num;
      }
    }
    i = 0;
    while (tmp.millisecondsSinceEpoch < end.millisecondsSinceEpoch){
      sum = 0;
      while (i < cards.length  && cards[i].nextAvailable <= tmp.millisecondsSinceEpoch){
        sum += cards[i].num;
        i++;
      }
      columns.add(_getColumn(sum.toDouble(), maxSum.toDouble(), j));
      labels.add(_getLabel(this.isWholeWeek ? "${tmp.month}/${tmp.day}" : "${tmp.hour}h", index: j));
      tmp = tmp.add(interval);
      j++;
    }
    return [columns, labels];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState(() {
          isWholeWeek = !isWholeWeek;
        });
      },
      child: Container(
        child: FutureBuilder(
            future: getTimelineSchedule(),
            builder: (BuildContext context, AsyncSnapshot<List<List<Widget>>> snapshot) {
              if (snapshot.hasData){
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(width: 1.0, color: Color(0xFFCDCDCD)),
                                left: BorderSide(width: 1.2, color: Color(0xFF696969)),
                                bottom:
                                BorderSide(width: 1.2, color: Color(0xFF696969)))),
                        height: widget.size,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            ...snapshot.data[0],
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Container(
                        child: Row(
                          children: <Widget>[...snapshot.data[1]],
                        ),
                      ),
                    )
                  ],
                );
              }
              return Container(child: Text("fdp"),);
            }
        ),
      ),
    );
  }
}
