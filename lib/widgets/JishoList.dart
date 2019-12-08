import 'package:benkyou/models/JishoTranslation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JishoList extends StatefulWidget {
  final String researchWord;

  const JishoList({Key key, this.researchWord}) : super(key: key);

  @override
  State<StatefulWidget> createState() => JishoListState();
}

class JishoListState extends State<JishoList> {

  String subtitleFormatter(JishoTranslation translation){
    String kanji = translation.kanji ?? '';
    String reading = translation.reading ?? '';
    if (kanji.length > 0 && reading.length > 0){
      return '$kanji    $reading';
    }
    return '$kanji$reading';
  }

  Widget returnList(BuildContext context){
    if (widget.researchWord != null && widget.researchWord.length > 0){
      return FutureBuilder(
        future: JishoTranslation.getJishoTransLationListFromRequest(widget.researchWord),
        builder: (BuildContext context, AsyncSnapshot<List<JishoTranslation>> snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.done:
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index){
                    return (ListTile(
                      onTap: (){

                      },
                      title: Text(snapshot.data[index].english.join('; ')),
                      subtitle: Text(subtitleFormatter(snapshot.data[index])),
                    ));
              });
            case ConnectionState.waiting:
              return Text("Searching...");
            case ConnectionState.none:
              return Text("No connection");
            default:
              return Text("Empty");
          }
        }
      );
    }
    return Container(
      child: Text(""),
    );
  }

  @override
  Widget build(BuildContext context) {
    return returnList(context);
  }
}
