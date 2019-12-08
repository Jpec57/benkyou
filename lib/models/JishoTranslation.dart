import 'dart:convert';

import 'package:http/http.dart' as http;

class JishoTranslation{
  String kanji;
  String reading;
  List<String> english;

  JishoTranslation(this.kanji, this.reading, this.english);

  factory JishoTranslation.fromJson(Map<String, dynamic> json){
    return JishoTranslation(
      json['kanji'],
      json['reading'],
      json['english'],
    );
  }


  @override
  String toString() {
    return 'JishoTranslation{kanji: $kanji, reading: $reading, english: $english}';
  }

  static Future<List<JishoTranslation>> getJishoTransLationListFromRequest(String word) async{
    print('jisho');
    if (word.length < 1){
      return [];
    }
    var res = await http.get('https://jisho.org/api/v1/search/words?keyword=$word');
    var matchingData = jsonDecode(res.body)['data'] as List;
    var jishoList = new List<JishoTranslation>();

    for (var matchingItem in matchingData){
      var jap = matchingItem["japanese"][0];
      var senses = matchingItem['senses'] as List;
      for (var sense in senses){
        var englishDefinitions = sense['english_definitions'] as List;
        var englishDefStringList = new List<String>();
        for (var def in englishDefinitions){
          englishDefStringList.add(def as String);
        }
        jishoList.add(JishoTranslation(jap['word'], jap['reading'], englishDefStringList));
      }
    }
    for (var jishoEntry in jishoList){
      print(jishoEntry.toString());
    }
    return jishoList;
  }

}