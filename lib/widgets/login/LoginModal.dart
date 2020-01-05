import 'package:benkyou/screens/DeckPage.dart';
import 'package:benkyou/services/database/DBProvider.dart';
import 'package:benkyou/services/database/Database.dart';
import 'package:benkyou/services/login.dart';
import 'package:benkyou/utils/utils.dart';
import 'package:benkyou/widgets/LoadingCircle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginModal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginModalState();
}

class LoginModalState extends State<LoginModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = new TextEditingController();
  TextEditingController _usernameController;
  final TextEditingController _passwordController = new TextEditingController();
  final snackBar = SnackBar(content: Text("Successfully logged in."));
  String _error = '';

  @override
  void initState() {
    super.initState();
    _usernameController = new TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String usualUser = await getUsualUser();
      if (usualUser != null){
        _emailController.text = usualUser;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Login', style: TextStyle(fontSize: 20)),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                        onChanged: (value) {
                          setState(() {
                            _error = '';
                          });
                        },
                        controller: _usernameController,
                        decoration: InputDecoration(
                          contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Username*",
                        )),
                    TextFormField(
                        onChanged: (value) {
                          setState(() {
                            _error = '';
                          });
                        },
                        controller: _emailController,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Email",
                        )),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          _error = '';
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
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                  child: Text(
                    _error,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                  child: Text(
                    "*Username is required only for registering",
                    style: TextStyle(
                      fontStyle: FontStyle.italic
                    ),
                    textAlign: TextAlign.center,
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

  void _returnError(String error){
    Navigator.pop(context);
    setState(() {
      _error = error;
    });
  }

  void launchLoginOrRegisterProcess(
      BuildContext context, String email, String password, bool isLogin) async {
    CollectionReference usersRef = Firestore.instance.collection('users');
    String username = _usernameController.text.trim();
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty){
      setState(() {
        _error = "The email and password cannot be empty";
      });
      return;
    }
    showLoadingDialog(context);
    if (!isLogin){
      if (username.isEmpty){
        _returnError("The username cannot be empty");
        return;
      }

      var v = await usersRef.document(username).get();
      if (v != null && v.exists){
        _returnError("The username '${username}' is already in use");
        return;
      }

    }
    try
    {
      AuthResult res;
      if (isLogin){
        res = await loginUser(email.trim(), password.trim());
        DocumentSnapshot user = await Firestore.instance.collection('users').document(res.user.uid).get();
        username = user.data['username'];
        print(user);
      } else{
        res = await registerUser(email.trim(), password.trim());
        Map<String, dynamic> user = new Map();
        user['username'] = username;
        usersRef.document(res.user.uid).setData(user);
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('uuid', res.user.uid);
      await prefs.setString('username', username);
      AppDatabase database = await DBProvider.db.database;
      Navigator.pop(context);
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DeckPage(deckDao: database.deckDao, cardDao: database.cardDao)
          )
      );
    }
    on Exception catch(exception){
      _returnError(exception.toString().replaceFirst("Exception: ", ''));
    }

  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }
}
