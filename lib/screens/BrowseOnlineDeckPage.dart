import 'package:benkyou/models/DTO/PublicCard.dart';
import 'package:benkyou/models/DTO/PublicDeck.dart';
import 'package:benkyou/services/navigator.dart';
import 'package:benkyou/utils/string.dart';
import 'package:benkyou/widgets/app/BasicContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrowseOnlineDeckPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BrowseOnlineDeckPageState();
}

class BrowseOnlineDeckPageState extends State<BrowseOnlineDeckPage> {
  TextEditingController _filter;
  bool _isSearching = false;
  String _searchTerm = '';
  List<PublicDeck> _decks = new List();
  List<PublicDeck> _filteredDecks = new List();
  List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange
  ];

  @override
  void initState() {
    super.initState();
    _filter = new TextEditingController();
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchTerm = "";
          _filteredDecks = _decks;
        });
      } else {
        setState(() {
          _searchTerm = _filter.text;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _renderResearchField() {
    if (_isSearching) {
      return Container(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: TextField(
              controller: _filter,
            ),
          ),
        ),
      );
    }
    return Container(
      child: Text(
        "Online Decks",
        style: TextStyle(fontSize: 30, fontFamily: 'Pacifico'),
      ),
    );
  }

  Widget _renderResearchBar() {
    return Container(
      padding: EdgeInsets.only(left: 20.0),
      height: MediaQuery.of(context).size.height * 0.12,
      decoration: BoxDecoration(color: Colors.orange),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                goToHomePage(context);
              },
              child: Container(
                  child: Image.asset('resources/imgs/arrow_back.png')),
            ),
          ),
          Expanded(
            flex: 4,
            child: Align(widthFactor: 3, child: _renderResearchField()),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              },
              child: Container(
                child: Image.asset('resources/imgs/search.png'),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _getTrendingDecks(List<PublicDeck> decks) {
    List<Widget> deckList = new List();

    for (int i = 0; i < decks.length; i++) {
      deckList.add(Container(
        height: 30,
        width: 160.0,
        color: colors[i],
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '${decks[i].title}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'from ${decks[i].author}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            ],
          ),
        ),
      ));
    }
    return deckList;
  }


  bool _doesDeckContainString(PublicDeck deck, String researchString){
    List<String> cardStrings = [
      deck.description,
      deck.title,
      deck.author,
    ];
    for (String string in cardStrings) {
      if (string != null) {
        String comparableString = getComparableString(string);
        if (comparableString.isNotEmpty &&
            comparableString.contains(researchString)) {
          return true;
        }
      }
    }
    return false;
  }

  Future<List<PublicDeck>> _fetchTrendingDeckList() async{
    QuerySnapshot decks = await Firestore.instance.collection('decks').limit(5).orderBy('lastUse', descending: true).getDocuments();
//    QuerySnapshot decks = await Firestore.instance.collection('decks').limit(5).orderBy('lastUse', descending: true).where('uid', isEqualTo: "UfNhvvQiGQOTaixk0Cc4vW9GHAM2").getDocuments();
    List<PublicDeck> publicDecks = new List();
    decks.documents.forEach((DocumentSnapshot snapshot){
      Map<String, dynamic> data = snapshot.data;
      List<dynamic> cards = data['cards'];
      List<PublicCard> publicCardList = new List();
      cards.forEach((card){
        PublicCard parsedCard = PublicCard.fromJSON(Map<String, dynamic>.from(card));
        publicCardList.add(parsedCard);
      });
      publicDecks.add(PublicDeck.fromJSON(Map<String, dynamic>.from(data), publicCardList));
    });
    return publicDecks;
  }

  Widget _renderTrendingDecks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Trending", style: TextStyle(fontFamily: 'Pacifico', fontSize: 20)),
        ),
        SizedBox(
          height: 100,
          child: FutureBuilder(
            future: _fetchTrendingDeckList(),
            builder: (BuildContext context, AsyncSnapshot<List<PublicDeck>> snapshot) {
              if (snapshot.hasData && snapshot.data.isNotEmpty){
                return ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[..._getTrendingDecks(snapshot.data)],
                );
              }
              return ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: <Widget>[..._getTrendingDecks([])],
              );
          },
          ),
        )
      ],
    );
  }

  Future<List<PublicDeck>> _fetchRegularDeckList() async{
    QuerySnapshot decks = await Firestore.instance.collection('decks').getDocuments();
//    QuerySnapshot decks = await Firestore.instance.collection('decks').where('uid', isEqualTo: "UfNhvvQiGQOTaixk0Cc4vW9GHAM2").getDocuments();
    List<PublicDeck> publicDecks = new List();
    decks.documents.forEach((DocumentSnapshot snapshot){
      Map<String, dynamic> data = snapshot.data;
      List<dynamic> cards = data['cards'];
      List<PublicCard> publicCardList = new List();
      cards.forEach((card){
        PublicCard parsedCard = PublicCard.fromJSON(Map<String, dynamic>.from(card));
        publicCardList.add(parsedCard);
      });
      publicDecks.add(PublicDeck.fromJSON(Map<String, dynamic>.from(data), publicCardList));
    });
    return publicDecks;
  }
  
  Widget _renderRegularDeckList() {
    _fetchRegularDeckList();
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: FutureBuilder(
          future: _fetchRegularDeckList(),
          builder: (BuildContext context, AsyncSnapshot<List<PublicDeck>> snapshot) {
            if (snapshot.hasData){
              if (_searchTerm.isNotEmpty) {
                _filteredDecks = new List<PublicDeck>();
                String researchTermFormatted = getComparableString(_searchTerm);
                for (PublicDeck deck in snapshot.data) {
                  if (_doesDeckContainString(deck, researchTermFormatted)) {
                    _filteredDecks.add(deck);
                  }
                }
              } else {
                _filteredDecks = snapshot.data;
              }
              return GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                children: List.generate(_filteredDecks.length, (index) {
                  return GestureDetector(
                    onTap: (){
                      goToPreviewOnlineDeckPage(context, _filteredDecks[index]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: colors[index % 5],
                            borderRadius: BorderRadius.all(Radius.circular(5.0))),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                '${_filteredDecks[index].title}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                'from ${_filteredDecks[index].author}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            }
            return Container(child: Center(child: Text("No deck available."),),);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasicContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _renderResearchBar(),
          (_isSearching) ? Container() : _renderTrendingDecks(),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 10.0),
            child: Text("Decks",
                style: TextStyle(fontFamily: 'Pacifico', fontSize: 20)),
          ),
          _renderRegularDeckList()
        ],
      ),
    );
  }
}
