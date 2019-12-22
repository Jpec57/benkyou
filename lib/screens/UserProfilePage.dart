import 'package:benkyou/widgets/Header.dart';
import 'package:benkyou/widgets/app/BasicContainer.dart';
import 'package:flutter/cupertino.dart';

class UserProfilePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage>{
  @override
  Widget build(BuildContext context) {
    return BasicContainer(
      child: Column(
        children: <Widget>[
          Header(title: 'Profile')
        ],
      ),
    );
  }

}