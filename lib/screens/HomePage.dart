//import 'package:benkyou/models/Deck.dart';
//import 'package:benkyou/screens/DeckInfoPage.dart';
//import 'package:benkyou/screens/DeckPage.dart';
//import 'package:benkyou/services/database/CardDao.dart';
//import 'package:benkyou/services/database/CategoriesDAO.dart';
//import 'package:benkyou/services/database/DBProvider.dart';
//import 'package:benkyou/services/database/Database.dart';
//import 'package:benkyou/services/database/DeckDao.dart';
//import 'package:benkyou/services/http/rest.dart';
//import 'package:benkyou/services/notifications/notification.dart';
//import 'package:benkyou/widgets/MyText.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import '../models/Category.dart';
//
//class RecentCategoriesListView extends StatelessWidget {
//  final CategoryDao categoryDao;
//  final CardDao cardDao;
//  final DeckDao deckDao;
//
//  const RecentCategoriesListView(
//      {Key key,
//      @required this.categoryDao,
//      @required this.deckDao,
//      @required this.cardDao})
//      : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    final List<int> colorCodes = <int>[600, 400, 200];
//
//    return Expanded(
//        flex: 1,
//        child: SizedBox.expand(
//            child: Container(
//                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
//                child: Column(children: <Widget>[
//                  Container(
//                    margin: EdgeInsets.only(top: 10),
//                    alignment: Alignment.topLeft,
//                    child: Text(
//                      'Recents decks',
//                      style:
//                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                    ),
//                  ),
//                  Expanded(
//                      child: StreamBuilder(
//                          stream: this.deckDao.findAllDecks(),
//                          builder: (BuildContext context,
//                              AsyncSnapshot<List<Deck>> snapshot) {
//                            if (snapshot.hasData &&
//                                snapshot.data != null &&
//                                snapshot.data.length > 0) {
//                              return (ListView.builder(
//                                itemBuilder: (context, index) {
//                                  return GestureDetector(
//                                    onTap: () {
//                                      Navigator.push(
//                                          context,
//                                          MaterialPageRoute(
//                                              builder: (context) => DeckInfoPage(
//                                                cardDao: this.cardDao,
//                                                deck: snapshot.data[index],
//                                              )
//                                          )
//                                      );
//                                    },
//                                    child: Container(
//                                        margin: EdgeInsets.only(bottom: 2.0),
//                                        decoration: BoxDecoration(
//                                          color: Colors.amber[colorCodes[
//                                              index % colorCodes.length]],
//                                        ),
//                                        child: Padding(
//                                          padding: const EdgeInsets.all(8.0),
//                                          child: MyText(
//                                              snapshot.data[index].title),
//                                        )),
//                                  );
//                                },
//                                itemCount: snapshot.data.length > 3
//                                    ? 3
//                                    : snapshot.data.length,
//                                shrinkWrap: true,
//                              ));
//                            }
//                            return Text('Empty');
//                          })),
//                ]))));
//  }
//}
//
//class AllCategoriesListView extends StatelessWidget {
//  final CategoryDao categoryDao;
//  final DeckDao deckDao;
//  final CardDao cardDao;
//
//  const AllCategoriesListView(
//      {Key key,
//      @required this.categoryDao,
//      @required this.deckDao,
//      @required this.cardDao})
//      : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    final List<int> colorCodes = <int>[600, 500, 100];
//
//    return Expanded(
//      flex: 2,
//      child: SizedBox.expand(
//          child: Container(
//              margin: const EdgeInsets.only(
//                  left: 20.0, right: 20.0, bottom: 100, top: 20),
//              child: Column(
//                children: <Widget>[
//                  Container(
//                    margin: EdgeInsets.only(top: 10),
//                    alignment: Alignment.topLeft,
//                    child: Text(
//                      'All categories',
//                      style:
//                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                    ),
//                  ),
//                  Expanded(
//                    child: StreamBuilder<List<Category>>(
//                      stream: this.categoryDao.findAllCategories(),
//                      builder: (BuildContext context,
//                          AsyncSnapshot<List<Category>> snapshot) {
//                        if (snapshot.hasData &&
//                            snapshot.data != null &&
//                            snapshot.data.length > 0) {
//                          return (ListView.builder(
//                            itemBuilder: (context, index) {
//                              return GestureDetector(
//                                onTap: () {
//                                  Navigator.push(
//                                      context,
//                                      MaterialPageRoute(
//                                          builder: (context) => DeckPage(
//                                              cardDao: this.cardDao,
//                                              deckDao: this.deckDao,
//                                              categoryId:
//                                                  snapshot.data[index].id)));
//                                },
//                                child: Container(
//                                    margin: EdgeInsets.only(bottom: 2.0),
//                                    decoration: BoxDecoration(
//                                      color: Colors.amber[colorCodes[
//                                          index % colorCodes.length]],
//                                    ),
//                                    child: Padding(
//                                      padding: const EdgeInsets.all(8.0),
//                                      child: MyText(snapshot.data[index].title),
//                                    )),
//                              );
//                            },
//                            itemCount: snapshot.data.length,
//                            shrinkWrap: true,
//                          ));
//                        } else {
//                          return Center(child: Text("Nothing"));
//                        }
//                      },
//                    ),
//                  ),
//                ],
//              ))),
//    );
//  }
//}
//
//class HomePage extends StatefulWidget {
//  final AppDatabase database;
//
//  HomePage({Key key, @required this.database}) : super(key: key);
//
//  @override
//  _HomePageState createState() => _HomePageState();
//}
//
//class _HomePageState extends State<HomePage> {
//  final _formKey = GlobalKey<FormState>();
//  final titleController = TextEditingController();
//  bool _isTitleErrorVisible = false;
//  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//
//
//  @override
//  void dispose() {
//    titleController.dispose();
//    super.dispose();
//  }
//
//  Future onSelectNotification(String payload) async {
//    showDialog(
//      context: context,
//      builder: (_) {
//        return new AlertDialog(
//          title: Text("PayLoad"),
//          content: Text("Payload : $payload"),
//        );
//      },
//    );
//  }
//
//  @override
//  void initState(){
//    super.initState();
//
//    var callback = onSelectNotification;
//    WidgetsBinding.instance.addPostFrameCallback((_) async {
////      showAddCategoryDialog();
//        scheduleNotification(context, flutterLocalNotificationsPlugin, callback);
//    });
//  }
//
//  void showAddCategoryDialog() {
//    showDialog(
////        barrierDismissible: false,
//        context: context,
//        builder: (BuildContext context) {
//          return AlertDialog(
//            title: Text('Create a category'),
//            titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
//            content: Form(
//              key: _formKey,
//              child: Column(
//                mainAxisSize: MainAxisSize.min,
//                children: <Widget>[
//                  Padding(
//                    padding: EdgeInsets.all(5.0),
//                    child: TextFormField(
//                      controller: titleController,
//                      decoration: InputDecoration(hintText: 'Title'),
//                      autofocus: true,
//                      onChanged: (value){
//                        setState(() {
//                          _isTitleErrorVisible = false;
//                        });
//                        _formKey.currentState.validate();
//                      },
//                      validator: (value) {
//                        if (_isTitleErrorVisible){
//                          if (value.isEmpty) {
//                            return 'Please enter a title';
//                          }
//                          return 'This title is already used.\n Please choose another one.';
//                        }
//                        return null;
//                      },
//                    ),
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: RaisedButton(
//                      onPressed: (){
//                        validateCategoryTitle();
//                      },
//                      textColor: Colors.white,
//                      color: Colors.lightBlue,
//                      padding: const EdgeInsets.all(0.0),
//                      child: Text("Create"),
//                    ),
//                  )
//                ],
//              ),
//            ),
//          );
//        });
//  }
//
//  Future<bool> validateCategoryTitle() async {
//    if (_formKey.currentState.validate()) {
//      if (titleController.text.isEmpty){
//        setState(() {
//          _isTitleErrorVisible = true;
//        });
//        _formKey.currentState.validate();
//        return false;
//      }
//      var database = (await DBProvider.db.database);
//      var category = await database.categoryDao.findCategoryByTitle(titleController.text);
//
//      if (category != null) {
//        setState(() {
//          _isTitleErrorVisible = true;
//        });
//        _formKey.currentState.validate();
//        return false;
//      }
//      var res = await _addCategory(titleController.text);
//      if (res) {
//        titleController.clear();
//        Navigator.of(context, rootNavigator: true).pop('dialog');
//        return true;
//      }
//    }
//    return true;
//  }
//
//  Future<bool> _addCategory(title) async {
//    var database = (await DBProvider.db.database);
//    database.categoryDao.insertCategory(new Category(null, title, null));
//    setState(() {});
//    return true;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return SafeArea(
//      child: Scaffold(
//        body: Column(
//          children: <Widget>[
//            Container(
//              height: MediaQuery.of(context).size.height * 0.12,
//              decoration: BoxDecoration(color: Colors.orange),
//              child: Center(
//                child: Text(
//                  'Benkyou',
//                  style: TextStyle(fontSize: 30, fontFamily: 'Pacifico'),
//                ),
//              ),
//            ),
//            RecentCategoriesListView(
//                cardDao: widget.database.cardDao,
//                categoryDao: widget.database.categoryDao,
//                deckDao: widget.database.deckDao),
//            AllCategoriesListView(
//                cardDao: widget.database.cardDao,
//                categoryDao: widget.database.categoryDao,
//                deckDao: widget.database.deckDao)
//          ],
//        ),
//        floatingActionButton: FloatingActionButton(
//          onPressed: showAddCategoryDialog,
//          tooltip: 'Add a category',
//          child: Icon(Icons.add),
//        ), // This trailing comma makes auto-formatting nicer for build methods.
//      ),
//    );
//  }
//}
