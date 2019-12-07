# TODOs
https://codelabs.developers.google.com/codelabs/flutter-firebase/index.html#4
https://jisho.org/api/v1/search/words?keyword=house

# READ
https://medium.com/stuart-engineering/mocking-integration-tests-with-flutter-af3b6ba846c7
https://api.flutter.dev/flutter/dart-isolate/Isolate-class.html
https://medium.com/flutter-community/blazingly-fast-flutter-driver-tests-5e375c833aa

https://github.com/flutter/flutter/issues/27826
https://docs.fastlane.tools/
https://github.com/jonsamwell/flutter_gherkin

# Benkyou

A new Flutter application using the SRS System to learn.

## Getting Started

https://medium.com/flutter-community/using-sqlite-in-flutter-187c1a82e8b
https://flutter.dev/docs/cookbook/persistence/sqlite

flutter packages pub run build_runner build  --delete-conflicting-outputs
flutter packages pub run build_runner watch

# SQL

## Update

```
    await database.database.update('Card',
        {'lvl': this.lvl, 'nextAvailable': this.nextAvailable + ((60 * 60 * 1000) * 10), 'isSynchronized': this.isSynchronized},
        where: 'id = ?',
        whereArgs: [this.id],
        conflictAlgorithm: ConflictAlgorithm.replace
    );
```

# TODOs

Create CreateAnswerWidget instead of duplicating code

# Test

## Initialisation for integration test
flutter emulators --launch Nexus_5X_API_29

## Launch test suite
https://flutter.dev/docs/cookbook/testing/widget/introduction
flutter test test/translator/translationUnit.dart

https://flutter.dev/docs/cookbook/testing/integration/introduction
flutter drive --target=test_driver/app.dart


## Enable GitHub Hooks for project

ln -s -f ../../hooks/pre-commit .git/hooks/pre-commit
