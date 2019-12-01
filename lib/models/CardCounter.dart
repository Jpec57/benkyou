class CardCounter {
  final int lvl;
  final int number;

  CardCounter({this.lvl, this.number});

  factory CardCounter.fromJSON(Map<String, dynamic> json) {
    return CardCounter(
      lvl: json['lvl'],
      number: json['number'],
    );
  }
}