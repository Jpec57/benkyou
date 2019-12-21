import 'package:benkyou/utils/string.dart';
import 'package:flutter_test/flutter_test.dart';

void main (){
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

    test("senzou", (){
      bool res = isStringDistanceValid('senzou', 'sensou');
      expect(res, false);
    });
  });


}