import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {

  const SideDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.60,
      child: Drawer(
          child: ListView(
            children: <Widget>[
              Container(
                color: Colors.orange,
                height: MediaQuery.of(context).size.height * 0.12,
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
                title: Text("Item 1"),
                onTap: () {
                },
              ),
              ListTile(
                title: Text("Item 1"),
                onTap: () {
                },
              ),
            ],
          )),
    );
  }
}