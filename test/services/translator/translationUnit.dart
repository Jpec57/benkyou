import 'package:benkyou/services/translator/TextConversion.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Hiragana', () {

    group('Particular case: ha', (){
      test('wa dynamic', () {
        String test = getHiragana('wa', isStaticAnalysis : false);
        expect(test, "わ");
      });

      test('wa static', () {
        String test = getHiragana('wa', isStaticAnalysis : true);
        expect(test, "は");
      });
    });


    test('arigatou', () {
      String test = getHiragana('arigatou');
      expect(test, "ありがとう");
    });

    group("Double consonants", (){
      test("asatte", (){
        String test = getHiragana('asatte');
        expect(test, "あさって");
      });

      test("zasshi", (){
        String test = getHiragana('zasshi');
        expect(test, "ざっし");
      });

      test("zacchi", (){
        String test = getHiragana('zacchi');
        expect(test, "ざっち");
      });

      test("zattsu", (){
        String test = getHiragana('zattsu');
        expect(test, "ざっつ");
      });

      test("seppuku", (){
        String test = getHiragana('seppuku');
        expect(test, "せっぷく");
      });

      test("haragaetta", (){
        String test = getHiragana('haragaetta');
        expect(test, "はらがえった");
      });
    });

    group("Bad examples", (){
      test("nar", (){
        String test = getHiragana('nar');
        expect(test, "なr");
      });
      test("nvm", (){
        String test = getHiragana('nvm');
        expect(test, "んvm");
      });
    });

    group("Full sentences", (){
      test("kore wa kamisama ga sazukete kudasatte ni chigainai", (){
        String test = getHiragana('kore wa kamisama ga sazukete kudasatte ni chigainai');
        expect(test, "これ は かみさま が さずけて くださって に ちがいない");
      });
      test("kore wa kamisama ga sazukete kudasatte ni chigainai", (){
        String test = getHiragana('kore wa kamisama ga sazukete kudasatte ni chigainai', hasSpace: false);
        expect(test, "これはかみさまがさずけてくださってにちがいない");
      });
    });

    group('syllables', (){
      test('aiueo', () {
        String test = getHiragana('aiueo');
        expect(test, "あいうえお");
      });

      test('kakikukeko', () {
        String test = getHiragana('kakikukeko');
        expect(test, "かきくけこ");
      });

      test('sashisuseso', () {
        String test = getHiragana('sashisuseso');
        expect(test, "さしすせそ");
      });

      test('tachitsuteto', () {
        String test = getHiragana('tachitsuteto');
        expect(test, "たちつてと");
      });

      test('naninuneno', () {
        String test = getHiragana('naninuneno');
        expect(test, "なにぬねの");
      });

      test('hahimumemo', () {
        String test = getHiragana('hahimumemo');
        expect(test, "はひむめも");
      });

      test('yayuyo', () {
        String test = getHiragana('yayuyo');
        expect(test, "やゆよ");
      });

      test('rarirurero', () {
        String test = getHiragana('rarirurero');
        expect(test, "らりるれろ");
      });

      test('wawo', () {
        String test = getHiragana('wawo');
        expect(test, "わを");
      });

      test('papipupepo', () {
        String test = getHiragana('papipupepo');
        expect(test, "ぱぴぷぺぽ");
      });

      test('n', () {
        String test = getHiragana('n');
        expect(test, "ん");
      });
    });

    group('compound syllables', (){
      List<String> originalStrings = ["kya", "kyu", "kyo", "sha", "shu", "sho",
        "shi","tsu", "cha", "chu", "chi", "nya", "nyu", "nyo", "hya","hyu", "hyo",
        "mya", "myu", "myo", "rya", "ryu", "ryo", "gya", "gyu", "gyo", "bya", "byu",
        "byo", "pya", "pyu", "pyo"
      ];
      List<String> expectedTranslations = [
        "きゃ", "きゅ", "きょ", "しゃ", "しゅ", "しょ",
        "し","つ", "ちゃ", "ちゅ", "ち", "にゃ", "にゅ", "にょ", "ひゃ","ひゅ", "ひょ",
        "みゃ", "みゅ", "みょ", "りゃ", "りゅ", "りょ", "ぎゃ", "ぎゅ", "ぎょ", "びゃ", "びゅ",
        "びょ", "ぴゃ", "ぴゅ", "ぴょ"
      ];
      int length = originalStrings.length;
      for (int i = 0; i < length; i++){
        test('${originalStrings[i]}', () {
          String givenString = getHiragana(originalStrings[i]);
          expect(givenString, expectedTranslations[i]);
        });
      }
    });

  });

  /// Katakana section
  ///
  ///
  group('Katakana', (){
    test('arigatou', () {
      String test = getKatakana('arigatou');
      expect(test, "アリガトウ");
    });

    group('Particular case: ha', (){
      test('wa dynamic', () {
        String test = getKatakana('wa', isStaticAnalysis : false);
        expect(test, "ワ");
      });

      test('wa static', () {
        String test = getKatakana('wa', isStaticAnalysis : true);
        expect(test, "ハ");
      });
    });

    group("syllables", (){
      test('aiueo', () {
        String test = getKatakana('aiueo');
        expect(test, "アイウエオ");
      });

      test('kakikukeko', () {
        String test = getKatakana('kakikukeko');
        expect(test, "カキクケコ");
      });

      test('sashisuseso', () {
        String test = getKatakana('sashisuseso');
        expect(test, "サシスセソ");
      });

      test('tachitsuteto', () {
        String test = getKatakana('tachitsuteto');
        expect(test, "タチツテト");
      });

      test('naninuneno', () {
        String test = getKatakana('naninuneno');
        expect(test, "ナニヌネノ");
      });

      test('hahimumemo', () {
        String test = getKatakana('hahimumemo');
        expect(test, "ハヒムメモ");
      });

      test('yayuyo', () {
        String test = getKatakana('yayuyo');
        expect(test, "ヤユヨ");
      });

      test('rarirurero', () {
        String test = getKatakana('rarirurero');
        expect(test, "ラリルレロ");
      });

      test('wawo', () {
        String test = getKatakana('wawo');
        expect(test, "ワヲ");
      });

      test('papipupepo', () {
        String test = getKatakana('papipupepo');
        expect(test, "パピプペポ");
      });

      test('n', () {
        String test = getKatakana('n');
        expect(test, "ン");
      });
    });

    group("Double consonants", (){
      test("asatte", (){
        String test = getKatakana('asatte');
        expect(test, "アサッテ");
      });

      test("seppuku", (){
        String test = getKatakana('seppuku');
        expect(test, "セップク");
      });

      test("haragaetta", (){
        String test = getKatakana('haragaetta');
        expect(test, "ハラガエッタ");
      });

      test("zasshi", (){
        String test = getKatakana('zasshi');
        expect(test, "ザッシ");
      });

      test("zacchi", (){
        String test = getKatakana('zacchi');
        expect(test, "ザッチ");
      });

      test("zattsu", (){
        String test = getKatakana('zattsu');
        expect(test, "ザッツ");
      });
    });

    group("Bad examples", (){
      test("nar", (){
        String test = getKatakana('nar');
        expect(test, "ナr");
      });
      test("nvm", (){
        String test = getKatakana('nvm');
        expect(test, "ンvm");
      });
    });

    group("Full sentences", (){
      test("kore wa kamisama ga sazukete kudasatte ni chigainai", (){
        String test = getKatakana('kore wa kamisama ga sazukete kudasatte ni chigainai');
        expect(test, "コレ ハ カミサマ ガ サズケテ クダサッテ ニ チガイナイ");
      });
      test("kore wa kamisama ga sazukete kudasatte ni chigainai", (){
        String test = getKatakana('kore wa kamisama ga sazukete kudasatte ni chigainai', hasSpace: false);
        expect(test, "コレハカミサマガサズケテクダサッテニチガイナイ");
      });
    });


    group('compound syllables', (){
      List<String> originalStrings = ["kya", "kyu", "kyo", "sha", "shu", "sho",
        "shi","tsu", "cha", "chu", "chi", "nya", "nyu", "nyo", "hya","hyu", "hyo",
        "mya", "myu", "myo", "rya", "ryu", "ryo", "gya", "gyu", "gyo", "bya", "byu",
        "byo", "pya", "pyu", "pyo"
      ];
      List<String> expectedTranslations = [
        "キャ", "キュ", "キョ", "シャ", "シュ", "ショ",
        "シ","ツ", "チャ", "チュ", "チ", "ニャ", "ニュ", "ニョ", "ヒャ","ヒュ", "ヒョ",
        "ミャ", "ミュ", "ミョ", "リャ", "リュ", "リョ", "ギャ", "ギュ", "ギョ", "ビャ", "ビュ",
        "ビョ", "ピャ", "ピュ", "ピョ"
      ];
      int length = originalStrings.length;
      for (int i = 0; i < length; i++){
        test('${originalStrings[i]}', () {
          String givenString = getKatakana(originalStrings[i]);
          expect(givenString, expectedTranslations[i]);
        });
      }
    });
  });


  /// Romaji section
  ///
  ///
  group('Romaji', (){
    test('arigatou', () {
      String test = getRomConversion('アリガトウ');
      expect(test, "arigatou");
    });

    group("syllables", (){
      test('aiueo', () {
        String test = getRomConversion('アイウエオ');
        expect(test, "aiueo");
      });

      test('kakikukeko', () {
        String test = getRomConversion('カキクケコ');
        expect(test, "kakikukeko");
      });

      test('sashisuseso', () {
        String test = getRomConversion('サシスセソ');
        expect(test, "sashisuseso");
      });

      test('tachitsuteto', () {
        String test = getRomConversion('タチツテト');
        expect(test, "tachitsuteto");
      });

      test('naninuneno', () {
        String test = getRomConversion('ナニヌネノ');
        expect(test, "naninuneno");
      });

      test('hahimumemo', () {
        String test = getRomConversion('ハヒムメモ');
        expect(test, "hahimumemo");
      });

      test('yayuyo', () {
        String test = getRomConversion('ヤユヨ');
        expect(test, "yayuyo");
      });

      test('rarirurero', () {
        String test = getRomConversion('ラリルレロ');
        expect(test, "rarirurero");
      });

      test('wawo', () {
        String test = getRomConversion('ワヲ');
        //wo -> o
        expect(test, "wao");
      });

      test('papipupepo', () {
        String test = getRomConversion('パピプペポ');
        expect(test, "papipupepo");
      });

      test('n', () {
        String test = getRomConversion('ン');
        expect(test, "n");
      });
    });

    group("Double consonants", (){
      test("asatte", (){
        String test = getRomConversion('アサッテ');
        expect(test, "asatte");
      });

      test("seppuku", (){
        String test = getRomConversion('セップク');
        expect(test, "seppuku");
      });

      test("haragaetta", (){
        String test = getRomConversion('ハラガエッタ');
        expect(test, "haragaetta");
      });

      test("zasshi", (){
        String test = getRomConversion('ザッシ');
        expect(test, "zasshi");
      });

      test("zacchi", (){
        String test = getRomConversion('ザッチ');
        expect(test, "zacchi");
      });

      test("zattsu", (){
        String test = getRomConversion('ザッツ');
        expect(test, "zattsu");
      });
    });

    group("Bad examples", (){
      test("nar", (){
        String test = getRomConversion('ナr');
        expect(test, "nar");
      });
      test("nvm", (){
        //Loss of information accurate because n=m in japanese
        String test = getRomConversion('ンvン');
        expect(test, "nvn");
      });
    });

    group("Full sentence", (){
      test("kore wa kamisama ga sazukete kudasatte ni chigainai", (){
        String test = getRomConversion('コレ ハ カミサマ ガ サズケテ クダサッテ ニ チガイナイ');
        expect(test, "kore wa kamisama ga sazukete kudasatte ni chigainai");
      });
    });


    group('compound syllables', (){

      List<String> originalStrings = [
        "キャ", "キュ", "キョ", "シャ", "シュ", "ショ",
        "シ","ツ", "チャ", "チュ", "チ", "ニャ", "ニュ", "ニョ", "ヒャ","ヒュ", "ヒョ",
        "ミャ", "ミュ", "ミョ", "リャ", "リュ", "リョ", "ギャ", "ギュ", "ギョ", "ビャ", "ビュ",
        "ビョ", "ピャ", "ピュ", "ピョ"
      ];

      List<String> expectedTranslations = ["kya", "kyu", "kyo", "sha", "shu", "sho",
        "shi","tsu", "cha", "chu", "chi", "nya", "nyu", "nyo", "hya","hyu", "hyo",
        "mya", "myu", "myo", "rya", "ryu", "ryo", "gya", "gyu", "gyo", "bya", "byu",
        "byo", "pya", "pyu", "pyo"
      ];

      int length = originalStrings.length;
      for (int i = 0; i < length; i++){
        test('${originalStrings[i]}', () {
          String givenString = getRomConversion(originalStrings[i]);
          expect(givenString, expectedTranslations[i]);
        });
      }
    });
  });
}