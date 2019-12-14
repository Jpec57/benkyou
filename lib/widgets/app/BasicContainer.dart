import 'package:benkyou/widgets/drawer/SideDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BasicContainer extends StatefulWidget{
  final Widget child;
  const BasicContainer({Key key, @required this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BasicContainerState();

}
class BasicContainerState extends State<BasicContainer>{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String text) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: widget.child,
        drawer: SideDrawer(),
      ),
    );
  }

}