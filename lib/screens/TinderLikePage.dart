import 'dart:math';
import 'package:benkyou/animations/TinderCard/TinderCardAnimations.dart';
import 'package:benkyou/models/CardWithAnswers.dart';
import 'package:benkyou/services/database/CardDao.dart';
import 'package:benkyou/services/database/DBProvider.dart';
import 'package:benkyou/services/database/Database.dart';
import 'package:benkyou/widgets/Header.dart';
import 'package:benkyou/widgets/TinderCard.dart';
import 'package:benkyou/widgets/app/BasicContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:benkyou/models/Card.dart' as model_card;

class TinderLikePage extends StatefulWidget {
  final CardDao cardDao;
  final int deckId;

  const TinderLikePage({Key key, @required this.cardDao, this.deckId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TinderLikePageState();
}

List<Alignment> cardsAlign = [new Alignment(0.0, 0.0), new Alignment(0.0, 0.2)];
List<Size> cardsSize = new List(2);

class TinderLikePageState extends State<TinderLikePage>
    with SingleTickerProviderStateMixin {
  List<CardWithAnswers> _cards = new List();
  AnimationController _controller;
  final Alignment defaultFrontCardAlign = new Alignment(0.0, 0.0);
  Alignment frontCardAlign;
  double frontCardRot = 0.0;
  bool _isAnswerVisible = false;
  int _success = 0;
  int _errors = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.deckId != null){
        _cards = await widget.cardDao.findCardsFromDeckWithAnswers(widget.deckId, isAvailableOnly: true);
      } else {
        _cards = await widget.cardDao.findAllCardsWithAnswers(isAvailableOnly: true);
      }
      setState(() {});
    });

    frontCardAlign = cardsAlign[1];

    // Init the animation controller
    _controller = new AnimationController(
        duration: new Duration(milliseconds: 700), vsync: this);
    _controller.addListener(() => setState(() {}));
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) removeOneCardFromTop();
    });
  }

  Widget backCard(BuildContext context, model_card.Card card) {
    if (card == null) {
      return Container();
    }
    return Align(
      alignment: _controller.status == AnimationStatus.forward
          ? TinderCardAnimations.backCardAlignmentAnim(_controller, cardsAlign)
              .value
          : cardsAlign[1],
      child: SizedBox.fromSize(
        size: _controller.status == AnimationStatus.forward
            ? TinderCardAnimations.backCardSizeAnim(_controller, cardsSize)
                .value
            : cardsSize[1],
        child: TinderCard(isAnswerVisible: false, card: card),
      ),
    );
  }

  Color _getCardColor(){
    if (frontCardRot > 3.0){
      return Colors.green;
    } else if (frontCardRot < -3.0){
      return Colors.red;
    } else {
      return Colors.white;
    }
  }

  Widget frontCard(BuildContext context, model_card.Card card) {
    if (card == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Congratulations !"),
            Text("You're done reviewing cards."),
          ],
        ),
      );
    }
    return Align(
        alignment: _controller.status == AnimationStatus.forward
            ? TinderCardAnimations.frontCardDisappearAlignmentAnim(
                    _controller, frontCardAlign)
                .value
            : frontCardAlign,
        child: Transform.rotate(
          angle: (pi / 180.0) * frontCardRot,
          child: SizedBox.fromSize(
            size: cardsSize[0],
            child: TinderCard(isAnswerVisible: _isAnswerVisible, card: card, color: _getCardColor(),),
          ),
        ));
  }

  void removeOneCardFromTop() {
    _cards.removeAt(0);
    setState(() {
      frontCardAlign = defaultFrontCardAlign;
      frontCardRot = 0.0;
    });
  }

  void animateCards() {
    _controller.stop();
    _controller.value = 0.0;
    _controller.forward();
  }

  Widget _cardSwipingWidget() {
    // Prevent swiping if the cards are animating
    return _controller.status != AnimationStatus.forward
        ? SizedBox.expand(
            child: GestureDetector(
            onTap: () {
              setState(() {
                _isAnswerVisible = !_isAnswerVisible;
              });
            },
            // While dragging the first card
            onPanUpdate: (DragUpdateDetails details) {
              // Add what the user swiped in the last frame to the alignment of the card
              setState(() {
                // 20 is the "speed" at which moves the card
                frontCardAlign = Alignment(
                    frontCardAlign.x +
                        20 *
                            details.delta.dx /
                            MediaQuery.of(context).size.width,
                    frontCardAlign.y +
                        40 *
                            details.delta.dy /
                            MediaQuery.of(context).size.width);

                frontCardRot = frontCardAlign.x; // * rotation speed;
              });
            },
            // When releasing the first card
            onPanEnd: (_) async {
              // If the front card was swiped far enough to count as swiped
              if (frontCardAlign.x > 3.0 || frontCardAlign.x < -3.0) {
                AppDatabase database = await DBProvider.db.database;
                bool isSuccess = frontCardAlign.x > 3.0;
                await _cards[0]
                    .updateCard(database, isSuccess);
                if (isSuccess){
                  _success++;
                } else {
                  _errors++;
                }
                setState(() {
                  _isAnswerVisible = false;
                });
                animateCards();
              } else {
                // Return to the initial rotation and alignment
                setState(() {
                  frontCardAlign = defaultFrontCardAlign;
                  frontCardRot = 0.0;
                });
              }
            },
          ))
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return BasicContainer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Header(title: 'Card swiper'),
          Expanded(
            flex: 3,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0, bottom: 20.0),
              child: Stack(
                children: <Widget>[
                  backCard(context, (0 + 1 < _cards.length) ? _cards[0 + 1] : null),
                  frontCard(context, (_cards.isNotEmpty) ? _cards[0] : null),
                  _cardSwipingWidget()
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Success: ${_success}",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Errors: ${_errors}",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Remaining: ${_cards.length}",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
