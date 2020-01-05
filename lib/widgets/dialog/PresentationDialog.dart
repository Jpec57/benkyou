import 'package:benkyou/widgets/DotsIndicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PresentationDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PresentationDialogState();
}

class PresentationDialogState extends State<PresentationDialog> {
  static const _kDuration = Duration(milliseconds: 300);

  static const NUMBER_SLIDES = 2;

  static const _kCurve = Curves.ease;

  final _formKey = GlobalKey<FormState>();
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, keepPage: false);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  Widget _renderSrsExplanationSlide() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Benkyou uses a SRS system to help you remember words "
                "through electronic cards.",
            style: TextStyle(
            ),
            textAlign: TextAlign.justify,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "What is a SRS System ?",
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            "The Spaced Repetition System helps you to long term memorize "
                "large quantities of information by exposing you frequently to "
                "them. The better you get at memorizing a card, the longer you "
                "will wait to see it showing up again.",
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _renderDeckExplanationSlide() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                "First create a deck...",
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            "It will help you categorize cards as you desire. Be careful decks "
                "are unit blocks of reviews.",
            textAlign: TextAlign.justify,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "...then create a card and you are ready to go!",
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            "Write in romaji an unknown japanese word in the kana section and"
                " let the Jisho API gives you the answer. With one more click "
                "you are all set to start reviewing your newly added word.",
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Stack(
            children: <Widget>[
              PageView(
                controller: _pageController,
                pageSnapping: false,
                physics: new AlwaysScrollableScrollPhysics(),
                children: <Widget>[
                  _renderSrsExplanationSlide(),
                  _renderDeckExplanationSlide()
                ],
              ),
              Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: new Container(
                    color: Colors.grey[800].withOpacity(0.5),
                    padding: const EdgeInsets.all(20.0),
                    child: DotsIndicator(
                      controller: _pageController,
                      itemCount: NUMBER_SLIDES,
                      onPageSelected: (int page) {
                        _pageController.animateToPage(
                          page,
                          duration: _kDuration,
                          curve: _kCurve,
                        );
                      },
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
