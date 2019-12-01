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
            'CREATE TABLE IF NOT EXISTS `Deck` (`id` INTEGER, `title` TEXT, `lastUse` INTEGER, `isSynchronized` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Card` (`id` INTEGER, `deck_id` INTEGER, `question` TEXT, `hint` TEXT, `useInContext` TEXT, `lvl` INTEGER, `nbErrors` INTEGER, `nbSuccess` INTEGER, `nextAvailable` INTEGER, `isReversible` INTEGER, `isSynchronized` INTEGER, `hasSolution` INTEGER, FOREIGN KEY (`deck_id`) REFERENCES `Deck` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Answer` (`id` INTEGER, `card_id` INTEGER, `content` TEXT, `isSynchronized` INTEGER, FOREIGN KEY (`card_id`) REFERENCES `Card` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `User` (`id` INTEGER, `username` TEXT, `lvl` INTEGER, PRIMARY KEY (`id`))');

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
      : _queryAdapter = QueryAdapter(database, changeListener),
        _deckInsertionAdapter = InsertionAdapter(
            database,
            'Deck',
            (Deck item) => <String, dynamic>{
                  'id': item.id,
                  'title': item.title,
                  'lastUse': item.lastUse,
                  'isSynchronized': item.isSynchronized ? 1 : 0
                },
            changeListener),
        _deckUpdateAdapter = UpdateAdapter(
            database,
            'Deck',
            ['id'],
            (Deck item) => <String, dynamic>{
                  'id': item.id,
                  'title': item.title,
                  'lastUse': item.lastUse,
                  'isSynchronized': item.isSynchronized ? 1 : 0
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _deckMapper = (Map<String, dynamic> row) =>
      Deck(row['id'] as int, row['title'] as String, row['lastUse'] as int);

  final InsertionAdapter<Deck> _deckInsertionAdapter;

  final UpdateAdapter<Deck> _deckUpdateAdapter;

  @override
  Stream<List<Deck>> findAllDecksAsSteam() {
    return _queryAdapter.queryListStream('SELECT * FROM Deck',
        tableName: 'Deck', mapper: _deckMapper);
  }

  @override
  Future<List<Deck>> findAllDecks() async {
    return _queryAdapter.queryList('SELECT * FROM Deck', mapper: _deckMapper);
  }

  @override
  Future<Deck> findDeckById(int id) async {
    return _queryAdapter.query('SELECT * FROM Deck WHERE id = ?',
        arguments: <dynamic>[id], mapper: _deckMapper);
  }

  @override
  Future<Deck> findDeckByTitle(String title) async {
    return _queryAdapter.query('SELECT * FROM Deck WHERE title = ?',
        arguments: <dynamic>[title], mapper: _deckMapper);
  }

  @override
  Future<List<Deck>> findAllDecksNotSynchronized() async {
    return _queryAdapter.queryList(
        'SELECT * FROM Deck WHERE isSynchronized = 0',
        mapper: _deckMapper);
  }

  @override
  Future<void> insertDeck(Deck deck) async {
    await _deckInsertionAdapter.insert(deck, sqflite.ConflictAlgorithm.replace);
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
                  'isReversible': item.isReversible ? 1 : 0,
                  'isSynchronized': item.isSynchronized ? 1 : 0,
                  'hasSolution': item.hasSolution ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final InsertionAdapter<Card> _cardInsertionAdapter;

  @override
  Future<int> insertCard(Card card) {
    return _cardInsertionAdapter.insertAndReturnId(
        card, sqflite.ConflictAlgorithm.replace);
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
        answer, sqflite.ConflictAlgorithm.replace);
  }
}
