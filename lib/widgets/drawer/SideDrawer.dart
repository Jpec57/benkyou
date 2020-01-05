import 'package:benkyou/screens/CardListPage.dart';
import 'package:benkyou/services/database/Database.dart';
import 'package:benkyou/services/firebase/synchronizing.dart';
import 'package:benkyou/services/login.dart';
import 'package:benkyou/services/navigator.dart';
import 'package:benkyou/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SideDrawer extends StatefulWidget {
  final AppDatabase database;

  const SideDrawer({Key key, @required this.database}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SideDrawerState();
}

class SideDrawerState extends State<SideDrawer> {
  String isLoggedIn;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      isLoggedIn = await isUserLoggedIn();
    });
  }

  Widget _renderDrawerHeader(BuildContext context) {
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
                  child: FutureBuilder(
                    future: getCurrentUsername(),
                    builder: (BuildContext context, AsyncSnapshot<String> username) {
                    return Text(username.hasData && username.data != null
                        ? "Hello ${username.data}"
                        : "No user logged in",
                      softWrap: true,
                    );
                  },
                  ),
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
                      builder: (context) =>
                          CardListPage(database: widget.database)));
            },
          ),
//          ListTile(
//            title: Text("Profile"),
//            onTap: () {
//              goToUserProfilePage(context);
//            },
//          ),
          ListTile(
            title: Text("Browse online decks"),
            onTap: () async{
              String username = await getCurrentUsername();
              if (username != null){
                goToBrowsingDeckPage(context);
              } else {
                showLoginDialog(context);
              }
            },
          ),
          ListTile(
            title: Text("Quick reviews"),
            onTap: () {
              goToTinderLikePage(context);
            },
          ),
//          ListTile(
//            title: Text("Import online data"),
//            onTap: () async{
//              showLoadingDialog(context);
//              await importFirebaseDataToLocal();
//              Navigator.pop(context);
//              Navigator.pop(context);
//            },
//          ),
          ListTile(
            title: Text(this.isLoggedIn != null ? "Log out" : "Log in"),
            onTap: () async{
              if (this.isLoggedIn != null) {
                await logOut();
                Navigator.of(context).pop();
                setState(() {
                });
              } else {
                showLoginDialog(context);
              }
            },
          ),
        ],
      )),
    );
  }
}
