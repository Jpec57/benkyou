import 'package:flutter/cupertino.dart';

class MyText extends StatelessWidget {
  final String text;
  final TextAlign align;
  final TextStyle style;

  MyText(
      this.text, {
        this.align,
        TextStyle style = const TextStyle(),
      }) : style = style.copyWith(
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: style,
    );
  }
}