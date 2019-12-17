import 'package:benkyou/widgets/LoadingCircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool isKeyboardVisible(BuildContext context) {
  return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
}

/// Show a loading dialog dismissable with Navigator.pop(context);
void showLoadingDialog(BuildContext context){
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return LoadingCircle();
      });
}



