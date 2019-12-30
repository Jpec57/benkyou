// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final database = _$AppDatabase();
    database.database = await database.open(
      name ?? ':memory:',
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  DeckDao _deckDaoInstance;

  CardDao _cardDaoInstance;

  AnswerDao _answerDaoInstance;

  Future<sqflite.Database> open(String name, List<Migration> migrations,
      [Callback callback]) async {
    final path = join(await sqflite.getDatabasesPath(), name);

    return sqflite.openDatabase(
      path,
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Deck` (`id` INTEGER, `title` TEXT, `isPublic` INTEGER, `publicRef` TEXT, `lastUse` INTEGER, `description` TEXT, `isSynchronized` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Card` (`id` INTEGER, `deck_id` INTEGER, `question` TEXT, `hint` TEXT, `useInContext` TEXT, `lvl` INTEGER, `nbErrors` INTEGER, `nbSuccess` INTEGER, `nextAvailable` INTEGER, `isSynchronized` INTEGER, `isForeignWord` INTEGER, `hasSolution` INTEGER, FOREIGN KEY (`deck_id`) REFERENCES `Deck` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Answer` (`id` INTEGER, `card_id` INTEGER, `content` TEXT, `isSynchronized` INTEGER, FOREIGN KEY (`card_id`) REFERENCES `Card` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `User` (`id` INTEGER, `username` TEXT, `email` TEXT, `uuid` TEXT, `lvl` INTEGER, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
  }

  @override
  DeckDao get deckDao {
    return _deckDaoInstance ??= _$DeckDao(database, changeListener);
  }

  @override
  CardDao get cardDao {
    return _cardDaoInstance ??= _$CardDao(database, changeListener);
  }

  @override
  AnswerDao get answerDao {
    return _answerDaoInstance ??= _$AnswerDao(database, changeListener);
  }
}

class _$DeckDao extends DeckDao {
  _$DeckDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _deckInsertionAdapter = InsertionAdapter(
            database,
            'Deck',
            (Deck item) => <String, dynamic>{
                  'id': item.id,
                  'title': item.title,
                  'isPublic': item.isPublic ? 1 : 0,
                  'publicRef': item.publicRef,
                  'lastUse': item.lastUse,
                  'description': item.description,
                  'isSynchronized': item.isSynchronized ? 1 : 0
                }),
        _deckUpdateAdapter = UpdateAdapter(
            database,
            'Deck',
            ['id'],
            (Deck item) => <String, dynamic>{
                  'id': item.id,
                  'title': item.title,
                  'isPublic': item.isPublic ? 1 : 0,
                  'publicRef': item.publicRef,
                  'lastUse': item.lastUse,
                  'description': item.description,
                  'isSynchronized': item.isSynchronized ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _deckMapper = (Map<String, dynamic> row) => Deck(
      row['id'] as int,
      row['title'] as String,
      row['isPublic'] as int,
      row['publicRef'] as String,
      row['lastUse'] as String);

  final InsertionAdapter<Deck> _deckInsertionAdapter;

  final UpdateAdapter<Deck> _deckUpdateAdapter;

  @override
  Future<List<Deck>> findAllDecksNotSynchronized() async {
    return _queryAdapter.queryList(
        'SELECT * FROM Deck WHERE isSynchronized = 0',
        mapper: _deckMapper);
  }

  @override
  Future<int> insertDeck(Deck deck) {
    return _deckInsertionAdapter.insertAndReturnId(
        deck, sqflite.ConflictAlgorithm.fail);
  }

  @override
  Future<void> updateDeck(Deck deck) async {
    await _deckUpdateAdapter.update(deck, sqflite.ConflictAlgorithm.replace);
  }
}

class _$CardDao extends CardDao {
  _$CardDao(this.database, this.changeListener)
      : _cardInsertionAdapter = InsertionAdapter(
            database,
            'Card',
            (Card item) => <String, dynamic>{
                  'id': item.id,
                  'deck_id': item.deckId,
                  'question': item.question,
                  'hint': item.hint,
                  'useInContext': item.useInContext,
                  'lvl': item.lvl,
                  'nbErrors': item.nbErrors,
                  'nbSuccess': item.nbSuccess,
                  'nextAvailable': item.nextAvailable,
                  'isSynchronized': item.isSynchronized ? 1 : 0,
                  'isForeignWord': item.isForeignWord ? 1 : 0,
                  'hasSolution': item.hasSolution ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final InsertionAdapter<Card> _cardInsertionAdapter;

  @override
  Future<int> insertCard(Card card) {
    return _cardInsertionAdapter.insertAndReturnId(
        card, sqflite.ConflictAlgorithm.fail);
  }
}

class _$AnswerDao extends AnswerDao {
  _$AnswerDao(this.database, this.changeListener)
      : _answerInsertionAdapter = InsertionAdapter(
            database,
            'Answer',
            (Answer item) => <String, dynamic>{
                  'id': item.id,
                  'card_id': item.cardId,
                  'content': item.content,
                  'isSynchronized': item.isSynchronized ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final InsertionAdapter<Answer> _answerInsertionAdapter;

  @override
  Future<int> insertAnswer(Answer answer) {
    return _answerInsertionAdapter.insertAndReturnId(
        answer, sqflite.ConflictAlgorithm.fail);
  }
}
