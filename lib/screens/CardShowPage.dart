import 'package:benkyou/models/Card.dart';
import 'package:benkyou/services/navigator.dart';
import 'package:benkyou/widgets/Header.dart';
import 'package:benkyou/widgets/app/BasicContainer.dart';
import 'package:flutter/cupertino.dart';

class CardShowPage extends StatefulWidget{
  final Card card;

  const CardShowPage({Key key, this.card}) : super(key: key);
  @override
  State<StatefulWidget> createState() => CardShowPageState();
}

class CardShowPageState extends State<CardShowPage>{
  @override
  Widget build(BuildContext context) {
    return BasicContainer(
      child: Column(
        children: <Widget>[
          Header(
            title: "Card Show",
            backFunction: (){
              goToCardListPage(context);
            },
          ),
          Text("Card ${widget.card.question}")
        ],
      ),

    );
  }
}