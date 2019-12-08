import 'package:benkyou/screens/DeckPage.dart';
import 'package:benkyou/services/database/DBProvider.dart';
import 'package:benkyou/services/database/Database.dart';
import 'package:benkyou/widgets/LoadingCircle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginModal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginModalState();
}

void showLoginDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return LoginModal();
      });
}

Future<String> isUserLoggedIn() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('uuid');
}

class LoginModalState extends State<LoginModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  bool _hasError = false;


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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Login', style: TextStyle(fontSize: 20)),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _hasError = false;
                          });
                        },
                        controller: _emailController,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Email",
                        )),
                    TextFormField(
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _hasError = false;
                        });
                      },
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Password",
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: _hasError,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                    child: Text(
                      "Credentials invalid. Please retry.",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () async {
                        launchLoginOrRegisterProcess(context, _emailController.text,
                            _passwordController.text, false);
                      },
                      child: Text("Register".toUpperCase()),
                    ),
                    RaisedButton(
                      onPressed: () async {
                        launchLoginOrRegisterProcess(context, _emailController.text,
                            _passwordController.text, true);
                      },
                      child: Text(
                        'Login'.toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void launchLoginOrRegisterProcess(
      BuildContext context, String email, String password, bool isLogin) async {
    _formKey.currentState.validate();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return LoadingCircle();
        });
    var res = (isLogin) ? await loginUser(email, password) : await registerUser(email, password);
    Navigator.pop(context);
    if (res != null){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('uuid', res.user.uid);
      AppDatabase database = await DBProvider.db.database;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DeckPage(deckDao: database.deckDao, cardDao: database.cardDao)
          )
      );//      Navigator.pop(context);
    } else {
      setState(() {
        _hasError = true;
      });
    }
  }

  Future<AuthResult> loginUser(String email, String password) async {
    try {
      var result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print(result);
      return result;
    } catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<AuthResult> registerUser(String email, String password) async {
    try {
      var result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print(result);
      return result;
    } catch (e) {
      print(e.message);
      return null;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
}
