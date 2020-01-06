import 'package:benkyou/services/database/CardDao.dart';
import 'package:benkyou/services/navigator.dart';
import 'package:benkyou/widgets/Header.dart';
import 'package:benkyou/widgets/app/BasicContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  final CardDao cardDao;
  final String userUid;
  final String username;

  const UserProfilePage({Key key, @required this.cardDao, @required this.userUid, @required this.username}) : super(key: key);
  @override
  State<StatefulWidget> createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {

  static const avatarSize = 40.0;

  @override
  Widget build(BuildContext context) {
    return BasicContainer(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget> [
              Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.12,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFFF9800), Color(0xFFFFE0B2)]
                      )
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: avatarSize
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: avatarSize),
                    child: Container(
                        width: MediaQuery.of(context).size.width,

//                        decoration: BoxDecoration(
//                            border: Border(
//                              bottom: BorderSide(
//                                width: 1.0,
//                                color: Colors.grey
//                              )
//                            )
//                        ),
                      child: Center(
                          child: Column(
                            children: <Widget>[
                              Text(widget.username,
                                style: TextStyle(fontFamily: 'Pacifico', fontSize: 20)
                                ),
                              Text("-lvl -",
                                  style: TextStyle(
                                      fontFamily: 'Pacifico',
                                      fontSize: 14,
                                    color: Color(0xFFA9A9A9)
                                  )
                              ),
                            ],
                          )
                      ),
                    ),
                  ),
                ),
              ],
            ),
              Positioned(
                top: (MediaQuery.of(context).size.height * 0.12) / 2 + avatarSize / 4,
                left: (MediaQuery.of(context).size.width) / 2 - avatarSize,
                  child: CircleAvatar(
                    radius: avatarSize,
                    backgroundImage: AssetImage('resources/imgs/luffy_icon.png'),
                  )
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 10),
                child: GestureDetector(
                  onTap: () {
                    goToHomePage(context);
                  },
                  child: Container(
                      child: Image.asset('resources/imgs/arrow_back.png'))
                ),
              )
          ]),

          Card(
            elevation: 12.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width - 50,
                child: Text(
                  "This feature is currently not available. Come back later :)"
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
