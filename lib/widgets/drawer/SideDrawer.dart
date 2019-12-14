import 'package:benkyou/screens/CardListPage.dart';
import 'package:benkyou/services/database/Database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SideDrawer extends StatelessWidget {
  final bool isLoggedIn;
  final AppDatabase database;

  const SideDrawer({Key key, this.isLoggedIn = false, @required this.database}) : super(key: key);


  Widget _renderDrawerHeader(BuildContext context){
    return Container(
      color: Colors.orange,
      height: MediaQuery.of(context).size.height * 0.12,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(
              children: <Widget>[
                Image.asset('resources/imgs/luffy_icon.png',
                    width: 40, height: 40),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(this.isLoggedIn ? "Coucou toi": "No user logged in"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.60,
      child: Drawer(
          child: ListView(
            children: <Widget>[
              _renderDrawerHeader(context),
              ListTile(
                title: Text("List cards"),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CardListPage(database: database,)
                      )
                  );
                },
              ),
              ListTile(
                title: Text("Item 1"),
                onTap: () {
                },
              ),
              ListTile(
                title: Text("Item 1"),
                onTap: () {
                },
              ),
              ListTile(
                title: Text("Log out"),
                onTap: () {
                  print("Log out");
                },
              ),
            ],
          )),
    );
  }
}