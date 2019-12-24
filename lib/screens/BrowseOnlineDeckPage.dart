import 'package:benkyou/models/Deck.dart';
import 'package:benkyou/services/navigator.dart';
import 'package:benkyou/widgets/Header.dart';
import 'package:benkyou/widgets/app/BasicContainer.dart';
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
  List<Deck> _decks = new List();
  List<Deck> _filteredDecks = new List();
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

  List<Widget> _getTrendingDecks() {
    List<Widget> deckList = new List();

    for (int i = 0; i < 5; i++) {
      deckList.add(Container(
        height: 30,
        width: 160.0,
        color: colors[i],
      ));
    }
    return deckList;
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
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: <Widget>[..._getTrendingDecks()],
          ),
        )
      ],
    );
  }

  Widget _renderRegularDeckList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          children: List.generate(100, (index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: colors[index % 5],
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child: Center(
                  child: Text(
                    'Item $index',
                    style: Theme.of(context).textTheme.headline,
                  ),
                ),
              ),
            );
          }),
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
          _renderTrendingDecks(),
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
