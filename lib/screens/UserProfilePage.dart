import 'package:benkyou/services/database/CardDao.dart';
import 'package:benkyou/widgets/Header.dart';
import 'package:benkyou/widgets/app/BasicContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  final CardDao cardDao;

  const UserProfilePage({Key key, this.cardDao}) : super(key: key);
  @override
  State<StatefulWidget> createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {

  @override
  Widget build(BuildContext context) {
    return BasicContainer(
      child: Column(
        children: <Widget>[
          Header(title: 'Profile'),

        ],
      ),
    );
  }
}
