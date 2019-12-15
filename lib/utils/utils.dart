import 'package:flutter/cupertino.dart';

bool isKeyboardVisible(BuildContext context) {
  return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
}

String getComparableString(String string){
  return string.trim().toLowerCase();
}