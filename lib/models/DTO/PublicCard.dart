class PublicCard {
  String question;
  String hint;
  bool isForeignWord;
  List<String> answers;

  PublicCard.fromDatabase(
      {this.question, this.hint, this.isForeignWord, this.answers});

  factory PublicCard.fromJSON(Map<String, dynamic> json) {
    return PublicCard.fromDatabase(
      question: json['question'],
      hint: json['hint'],
      isForeignWord: json['isForeignWord'] == 0,
      answers: List<String>.from(json['answers']),
    );
  }
}
