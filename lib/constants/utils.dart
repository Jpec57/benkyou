library utils_constants;

import 'dart:convert';
import 'package:benkyou/widgets/dialog/PresentationDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const isDev = false;

const String LONG_TEXT = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean "
    "ipsum justo, auctor id tristique vitae, elementum vitae massa. Vestibulum "
    "cursus lobortis lobortis. Ut quis viverra justo, lacinia rhoncus velit. Etiam "
    "eget blandit ante, eget venenatis tortor. In hac habitasse platea dictumst. Aliquam "
    "vulputate pharetra ex venenatis mollis. Integer vel iaculis tortor. Maecenas "
    "sed imperdiet odio. Interdum et malesuada fames ac ante ipsum primis in faucibus."
    " Pellentesque non justo ornare lectus dictum pharetra eu eget ante. Donec in "
    "quam at nunc efficitur malesuada. Cras egestas tortor at iaculis tincidunt."
    " Proin ornare odio eu magna finibus fringilla. Donec sem odio, efficitur ut"
    " neque at, luctus venenatis velit. \n Nam pharetra magna ut justo sodales "
    "dapibus. Vivamus lobortis nunc lacus, ut malesuada purus consectetur in. "
    "Pellentesque posuere erat elit, id ornare est fringilla in. Maecenas vitae "
    "ullamcorper nisi. Fusce quis aliquet risus, et aliquet orci. Pellentesque"
    " neque felis, ullamcorper nec tincidunt sed, tincidunt quis lacus. Aenean "
    "dictum tempor neque, vel pulvinar odio elementum vitae. Pellentesque egestas "
    "metus vel enim consectetur dignissim sit amet et risus."
    "quam at nunc efficitur malesuada. Cras egestas tortor at iaculis tincidunt."
    " Proin ornare odio eu magna finibus fringilla. Donec sem odio, efficitur ut"
    " neque at, luctus venenatis velit. \n\n Nam pharetra magna ut justo sodales "
    "dapibus. Vivamus lobortis nunc lacus, ut malesuada purus consectetur in. "
    "Pellentesque posuere erat elit, id ornare est fringilla in. Maecenas vitae "
    "ullamcorper nisi. Fusce quis aliquet risus, et aliquet orci. Pellentesque"
    " neque felis, ullamcorper nec tincidunt sed, tincidunt quis lacus. Aenean "
    "dictum tempor neque, vel pulvinar odio elementum vitae. Pellentesque egestas "
    "metus vel enim consectetur dignissim sit amet et risus."
    "quam at nunc efficitur malesuada. Cras egestas tortor at iaculis tincidunt."
    " Proin ornare odio eu magna finibus fringilla. Donec sem odio, efficitur ut"
    " neque at, luctus venenatis velit. \n Nam pharetra magna ut justo sodales "
    "dapibus. Vivamus lobortis nunc lacus, ut malesuada purus consectetur in. "
    "Pellentesque posuere erat elit, id ornare est fringilla in. Maecenas vitae "
    "ullamcorper nisi. Fusce quis aliquet risus, et aliquet orci. Pellentesque"
    " neque felis, ullamcorper nec tincidunt sed, tincidunt quis lacus. Aenean "
    "dictum tempor neque, vel pulvinar odio elementum vitae. Pellentesque egestas "
    "metus vel enim consectetur dignissim sit amet et risus."
    "quam at nunc efficitur malesuada. Cras egestas tortor at iaculis tincidunt."
    " Proin ornare odio eu magna finibus fringilla. Donec sem odio, efficitur ut"
    " neque at, luctus venenatis velit. \n Nam pharetra magna ut justo sodales "
    "dapibus. Vivamus lobortis nunc lacus, ut malesuada purus consectetur in. "
    "Pellentesque posuere erat elit, id ornare est fringilla in. Maecenas vitae "
    "ullamcorper nisi. Fusce quis aliquet risus, et aliquet orci. Pellentesque"
    " neque felis, ullamcorper nec tincidunt sed, tincidunt quis lacus. Aenean "
    "dictum tempor neque, vel pulvinar odio elementum vitae. Pellentesque egestas "
    "metus vel enim consectetur dignissim sit amet et risus.";


Future<void> insertPublicDecks() async{
  CollectionReference ref = await Firestore.instance.collection('decks');
  rootBundle.loadString('lib/fixtures/dev/firebase/public_decks.json').then((String jsonString) {
    print(jsonString);
    List<dynamic> jsonDeck = jsonDecode(jsonString);
    jsonDeck.forEach((deck){
      ref.document('${deck['author']}:${deck['title']}').setData(deck);
    });
  });
}

void showHelp(BuildContext context){
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return PresentationDialog();
      });
}