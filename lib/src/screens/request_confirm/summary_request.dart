import 'package:flutter/material.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:pos/src/model/payment_request.dart';
import 'package:pos/src/screens/request_confirm/request_confirm.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:clippy_flutter/arc.dart';

class SummaryRequest extends StatelessWidget {
  final PaymentRequest paymentRequest;

  const SummaryRequest({Key key, this.paymentRequest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Arc(
                child: Container(
                  color: Theme.of(context).primaryColor,
                  height: MediaQuery.of(context).size.height / 2 - 50,
                ),
                height: 50,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: Text(paymentRequest.dateTime
//                            .toIso8601String()
//                            .substring(0, 10),style: TextStyle(color: Colors.white),),
//                      ),
////                      Padding(
////                        padding: const EdgeInsets.all(8.0),
////                        child: Text("id ${paymentRequest.id}"),
////                      ),
//                      Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: Text(paymentRequest.aimName ?? ""),
//                      ),
//
//                    ],
//                  ),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: RichText(
                    text: TextSpan(
                      text: "${paymentRequest.amount} ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: "WOM",
                            style: TextStyle(fontWeight: FontWeight.normal)),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: height / 2.5,
                  width: height / 2.5,
                  child: Card(
                    child: QrImage(
                      padding: const EdgeInsets.all(20.0),
                      data: paymentRequest.deepLink,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'PIN ',
                      style: TextStyle(
                          fontSize: 30.0,
                          color: Theme.of(context).primaryColor),
                      children: <TextSpan>[
                        TextSpan(
                            text: paymentRequest.password,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 80.0,
                ),
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      OutlineButton(
//                          child: Text('Duplicate'),
//                          onPressed: () {
//                            Navigator.of(context).pushReplacement(
//                              MaterialPageRoute(
//                                builder: (ctx) => RequestConfirmScreen(
//                                  paymentRequest: paymentRequest.copyFrom(),
//                                ),
//                              ),
//                            );
//                          }),
//                      OutlineButton.icon(
//                        color: Colors.white,
//                        splashColor: Colors.blue,
//                        highlightedBorderColor: Colors.green,
//                        disabledBorderColor: Colors.red,
//                        highlightColor: Colors.yellow,
//                        textColor: Colors.purple,
//                        highlightElevation: 4,
//                        onPressed: () {
//                          Navigator.of(context).pop();
//                        },
//                        icon: Icon(Icons.check),
//                        label: Text('Home'),
//                      ),
//                    ],
//                  ),
//                  Spacer(),
              ],
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => RequestConfirmScreen(
                    paymentRequest: paymentRequest.copyFrom(),
                  ),
                ),
              );
            },
            label: Text(AppLocalizations.of(context).translate('duplicate'))),
      ),
    );
  }
}
