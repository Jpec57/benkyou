import 'package:benkyou/widgets/RomajiTextInput.dart';
import 'package:benkyou/widgets/app/BasicContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:stripe_payment/stripe_payment.dart';

//https://medium.com/flutter-community/flutter-card-payments-made-easy-with-stripe-and-ruby-on-rails-50d78ac056ce
class DonationPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return DonationState();
  }

}

class DonationState extends State<DonationPage>{
  @override
  void initState() {
    super.initState();
//    StripePayment.setOptions(
//      StripeOptions(
//        publishableKey: "pk_test_3tszCL7NwDiI1s6rj7B0Jh0700AYrIrcsQ",
//        merchantId: "YOUR_MERCHANT_ID",
//        androidPayMode: 'test',
//      ),
//    );
  }

  @override
  Widget build(BuildContext context) {
    return BasicContainer(
        child: Container(
          color: Colors.grey,
          child: Padding(
              child: Column(
                children: <Widget>[
                  RomajiTextInput(mustConvertToKana: true,),
                ],
              ), padding: EdgeInsets.all(40.0),
          ),
        )
    );
  }
}