import 'package:benkyou/widgets/Header.dart';
import 'package:benkyou/widgets/app/BasicContainer.dart';
import 'package:flutter/cupertino.dart';

class BrowseOnlineDeckPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => BrowseOnlineDeckPageState();
}

class BrowseOnlineDeckPageState extends State<BrowseOnlineDeckPage>{
  @override
  Widget build(BuildContext context) {
    return BasicContainer(
      child: Column(
        children: <Widget>[
          Header(title: 'Online decks')
        ],
      ),
    );
  }

}