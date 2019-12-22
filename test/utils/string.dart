import 'package:benkyou/utils/string.dart';
import 'package:flutter_test/flutter_test.dart';

void main (){

  group("isStringDistanceValid", (){
    group('Valid differences', (){

      test("arigato", (){
        bool res = isStringDistanceValid('arigatou', 'arigato');
        expect(res, true);
      });

      test("arigat", (){
        bool res = isStringDistanceValid('arigatou', 'arigat');
        expect(res, false);
      });
    });


    group('Invalid differences', (){

//      test("senzou", (){
//        bool res = isStringDistanceValid('senzou', 'sensou');
//        expect(res, false);
//      });
    });
  });

  group('getAnswerWithoutInfo', (){

    test("Parenthesis with space", (){
      String res = getAnswerWithoutInfo('senzou (war)');
      expect(res, 'senzou');
    });

    test("Multiple parenthesis with spaces", (){
      String res = getAnswerWithoutInfo('senzou (war) (h3r3 I 4m)');
      expect(res, 'senzou');
    });

    test("Multiple parenthesis without space", (){
      String res = getAnswerWithoutInfo('senzou(war)(h3r3 I 4m)');
      expect(res, 'senzou');
    });

  });


}