class TimeCard{
  final int num;
  final int nextAvailable;

  TimeCard(this.num, this.nextAvailable);

  TimeCard.fromDatabase({this.num, this.nextAvailable});

  factory TimeCard.fromJson(Map<String, dynamic> json){
    return TimeCard.fromDatabase(
      num: json['num'],
      nextAvailable: json['nextAvailable'],
    );
  }

  @override
  String toString() {
    return '${this.num} ${this.nextAvailable}';
  }

}