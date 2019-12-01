import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const int KEYBOARD_TAB_CODE = 61;
const int KEYBOARD_ENTER_CODE = 66;

class KeyboardAwareInput extends StatefulWidget {
  final Widget child;
  final FocusNode focusNode;
  final Map<int, Function> callbacks;
  final Map<int, Function> specialCallbacks;

  KeyboardAwareInput({@required this.child, @required this.focusNode, this.callbacks, this.specialCallbacks});

  @override
  _KeyboardAwareInputState createState() => new _KeyboardAwareInputState();
}

class _KeyboardAwareInputState extends State<KeyboardAwareInput> {

  handleKey(RawKeyEvent key) {
    RawKeyEventDataAndroid data = key.data as RawKeyEventDataAndroid;
    //Two possible events triggered: KeyUp and KeyDown
    if (key.runtimeType.toString() == 'RawKeyDownEvent'){
      if (widget.specialCallbacks != null){
        widget.specialCallbacks.forEach((int code, Function callback){
          if (code == data.keyCode){
            callback();
          }
        });
      }
    } else {
      if (widget.callbacks != null){
        widget.callbacks.forEach((int code, Function callback){
          if (code == data.keyCode){
            callback();
          }
        });
      }
    }
    return false;
  }


  _buildTextComposer() {
    return new RawKeyboardListener(
        focusNode: widget.focusNode,
        onKey: handleKey,
        child: widget.child
    );
  }


  @override
  Widget build(BuildContext context) {
    return _buildTextComposer();
  }
}