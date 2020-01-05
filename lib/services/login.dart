import 'package:benkyou/widgets/login/LoginModal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<AuthResult> loginUser(String email, String password) async {
  try {
    var result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    return result;
  } catch (e) {
    print("hello");
    throw new Exception(e.message);
  }
}

Future<AuthResult> registerUser(String email, String password) async {
  try {
    var result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    return result;
  } catch (e) {
    print(e.message);
    throw new Exception(e.message);
  }
}

void showLoginDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return LoginModal();
      });
}

void logOut() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('uuid', null);
  await prefs.setString('username', null);
}

Future<String> isUserLoggedIn() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('uuid');
}

Future<String> getCurrentUsername() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('username');
}

Future<String> getUsualUser() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('email');
}