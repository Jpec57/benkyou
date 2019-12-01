import 'package:benkyou/services/navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const HEADER_WITHOUT_BACK_BUTTON = 'NO_BACK';
const HEADER_SMALL = 'SMALL';
const HEADER_DEFAULT = 'DEFAULT';
const HEADER_ICON = 'ICON';

class Header extends StatelessWidget{
  final String title;
  final double percentHeight;
  final String type;
  final Widget icon;
  final Function backFunction;

  const Header({Key key, @required this.title, this.percentHeight = 0.12, this.type = HEADER_DEFAULT, this.icon, this.backFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type){
      case HEADER_WITHOUT_BACK_BUTTON:
        return (Container(
          height: MediaQuery.of(context).size.height * percentHeight,
          decoration: BoxDecoration(color: Colors.orange),
          child: Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 30, fontFamily: 'Pacifico'),
            ),
          ),
        ));
      case HEADER_SMALL:
        return (Container(
          height: MediaQuery.of(context).size.height * 0.05,
          decoration: BoxDecoration(color: Colors.orange),
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  goToHomePage(context);
                },
                child: Image.asset('resources/imgs/home.png'),
              ),
              Flexible(
                child: Container(),
              ),
            ],
          ),
        ));
      case HEADER_ICON:
        return Container(
          padding: EdgeInsets.only(left: 20.0),
          height: MediaQuery.of(context).size.height * percentHeight,
          decoration: BoxDecoration(color: Colors.orange),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    goToHomePage(context);
                  },
                  child: Container(
                      child: Image.asset('resources/imgs/arrow_back.png')),
                ),
              ),
              Expanded(
                flex: 4,
                child: Align(
                  widthFactor: 3,
                  child: Container(
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 30, fontFamily: 'Pacifico'),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: icon,
                ),
              )
            ],
          ),
        );
      default:
        return Container(
          padding: EdgeInsets.only(left: 20.0),
          height: MediaQuery.of(context).size.height * percentHeight,
          decoration: BoxDecoration(color: Colors.orange),
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  if (backFunction != null){
                    backFunction();
                  } else {
                    goToHomePage(context);
                  }
                },
                child: Container(
                    child: Image.asset('resources/imgs/arrow_back.png')),
              ),
              Flexible(
                child: Align(
                  widthFactor: 3,
                  child: Container(
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 30, fontFamily: 'Pacifico'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }
}