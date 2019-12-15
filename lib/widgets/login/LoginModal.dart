import 'package:benkyou/screens/DeckPage.dart';
import 'package:benkyou/services/database/DBProvider.dart';
import 'package:benkyou/services/database/Database.dart';
import 'package:benkyou/services/login.dart';
import 'package:benkyou/widgets/LoadingCircle.dart';
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
  final TextEditingController _passwordController = new TextEditingController();
  final snackBar = SnackBar(content: Text("Successfully logged in."));
  String _error = '';


  @override
  void initState() {
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
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
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
    // ignore: unawaited_futures
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return LoadingCircle();
        });
    try
    {
      var res = (isLogin) ? await loginUser(email.trim(), password.trim()) :
      await registerUser(email.trim(), password.trim());

      print(res);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('uuid', res.user.uid);
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
      Navigator.pop(context);
      setState(() {
        _error = exception.toString().replaceFirst("Exception: ", '');
      });
    }

  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
}
