#TODO
https://codelabs.developers.google.com/codelabs/flutter-firebase/index.html#4

# Benkyou

A new Flutter application using the SRS System to learn.

## Getting Started

https://medium.com/flutter-community/using-sqlite-in-flutter-187c1a82e8b
https://flutter.dev/docs/cookbook/persistence/sqlite

flutter packages pub run build_runner build  --delete-conflicting-outputs
flutter packages pub run build_runner watch

#SQL

##Update

'''
    await database.database.update('Card',
        {'lvl': this.lvl, 'nextAvailable': this.nextAvailable + ((60 * 60 * 1000) * 10), 'isSynchronized': this.isSynchronized},
        where: 'id = ?',
        whereArgs: [this.id],
        conflictAlgorithm: ConflictAlgorithm.replace
    );
'''

#TODOs

Create CreateAnswerWidget instead of duplicating code