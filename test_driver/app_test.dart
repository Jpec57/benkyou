import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('DeckPage', () {

    final firstDeckFinder = find.byValueKey("deck-0");
    final secondDeckFinder = find.byValueKey("deck-1");
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Assert two decks are well created', () async {
      await sleep(Duration(seconds: 5));
      expect(await driver.getText(firstDeckFinder), "Default");
      expect(await driver.getText(secondDeckFinder), "Test");
    });
  });
}