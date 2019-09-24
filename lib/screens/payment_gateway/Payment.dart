import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stripe_api/model/stripe_source_type_model.dart';
import 'package:stripe_api/stripe_api_handler.dart';
//import 'package:stripe_flutter_channel/stripe_flutter_channel.dart';
//import 'package:stripe_payment/stripe_payment.dart';

class Payment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _paymentState();
}

class _paymentState extends State<Payment> {

//  StripeFlutterChannel stripeClient = StripeFlutterChannel("", "");

//My strupe secret : sk_test_TogZmBBPiOZmdsNnpaYGjKyE00iHbobcHB
// public key : pk_test_yMVMo43NoYrdNR4Sszp7Jnqb00BV1ZtBXL
/*String publishableKey = "pk_test_yMVMo43NoYrdNR4Sszp7Jnqb00BV1ZtBXL";

StripeApiHandler handler = new StripeApiHandler();
StripeSourceTypeModel model = new StripeSourceTypeModel();

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    handler.addCustomerSource("", "", "");
    handler.createToken(params, publishableKey);

  }*/


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Gateway"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
//                StripeSource.addSource().then((String key) {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
