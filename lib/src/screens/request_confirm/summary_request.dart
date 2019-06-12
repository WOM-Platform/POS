import 'package:flutter/material.dart';
import 'package:pos/src/model/payment_request.dart';
import 'package:pos/src/screens/request_confirm/request_confirm.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SummaryRequest extends StatelessWidget {
  final PaymentRequest paymentRequest;

  const SummaryRequest({Key key, this.paymentRequest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("#${paymentRequest.id}"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(paymentRequest.aimName ?? ""),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(paymentRequest.dateTime
                        .toIso8601String()
                        .substring(0, 10)),
                  ),
                ],
              ),
              Spacer(),
              RichText(
                text: TextSpan(
                  text: "${paymentRequest.amount} ",
                  style: TextStyle(
                      fontSize: 40.0,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                        text: "WOM",
                        style: TextStyle(fontWeight: FontWeight.normal)),
                  ],
                ),
              ),
              Container(
                height: 300.0,
                width: 300.0,
                child: Card(
                  child: QrImage(
                    padding: const EdgeInsets.all(30.0),
                    data: paymentRequest.deepLink,
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Pin ',
                  style: TextStyle(fontSize: 30.0, color: Colors.red),
                  children: <TextSpan>[
                    TextSpan(
                        text: paymentRequest.password,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  OutlineButton(
                      child: Text('Duplica'),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (ctx) => RequestConfirmScreen(
                                  paymentRequest: paymentRequest.copyFrom(),
                                ),
                          ),
                        );
                      }),
                  OutlineButton.icon(
                    color: Colors.white,
                    splashColor: Colors.blue,
                    highlightedBorderColor: Colors.green,
                    disabledBorderColor: Colors.red,
                    highlightColor: Colors.yellow,
                    textColor: Colors.purple,
                    highlightElevation: 4,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.check),
                    label: Text('Torna alla home'),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
