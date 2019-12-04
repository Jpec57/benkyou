import 'package:benkyou/services/translator/TextConversion.dart';
import 'package:flutter_test/flutter_test.dart';
//flutter test test/unit/first.dart

void main() {
  //TODO add composition, double consonants, bad example (not parseable) and whole phrase
  group('Hiragana', () {

    test('arigatou', () {
      var test = getHiragana('arigatou');
      expect(test, "ありがとう");
    });

    test('aiueo', () {
      var test = getHiragana('aiueo');
      expect(test, "あいうえお");
    });

    test('kakikukeko', () {
      var test = getHiragana('kakikukeko');
      expect(test, "かきくけこ");
    });

    test('sashisuseso', () {
      var test = getHiragana('sashisuseso');
      expect(test, "さしすせそ");
    });

    test('tachitsuteto', () {
      var test = getHiragana('tachitsuteto');
      expect(test, "たちつてと");
    });

    test('naninuneno', () {
      var test = getHiragana('naninuneno');
      expect(test, "なにぬねの");
    });

    test('hahimumemo', () {
      var test = getHiragana('hahimumemo');
      expect(test, "はひむめも");
    });

    test('yayuyo', () {
      var test = getHiragana('yayuyo');
      expect(test, "やゆよ");
    });

    test('rarirurero', () {
      var test = getHiragana('rarirurero');
      expect(test, "らりるれろ");
    });

    test('wawo', () {
      var test = getHiragana('wawo');
      expect(test, "わを");
    });

    test('n', () {
      var test = getHiragana('n');
      expect(test, "ん");
    });

  });
}