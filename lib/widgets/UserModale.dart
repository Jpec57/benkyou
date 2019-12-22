import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => UserPageState();
}

class UserPageState extends State<UserPage>{
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Container(
          height: 280.0,
          width: 300.0,
          child: Container(color: Colors.red),
        ),
      ),
    );
  }
}