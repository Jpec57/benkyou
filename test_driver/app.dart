import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:benkyou/main.dart' as app;

void main() {
  // This line enables the extension.
  enableFlutterDriverExtension();

  // Call the `main()` function of the app, or call `runApp` with
  // any widget you are interested in testing.
//  app.main();

//  AppDatabase database = await DBProvider.db.database;

//  runApp(Header(
//    title: "Je suis un titre",
//  ));

  runApp(Text(
    'Blabla'
  ));

//  runApp(AppStateContainer(
//      state: null,
//      child: MaterialApp(
//          title: 'Benkyou',
//          theme: ThemeData(
//            primarySwatch: Colors.blue,
//          ),
//          home:
//              DeckPage(cardDao: database.cardDao, deckDao: database.deckDao))));
}
