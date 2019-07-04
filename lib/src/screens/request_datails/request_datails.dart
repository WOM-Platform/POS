import 'package:flutter/material.dart';
import 'package:pos/src/model/payment_request.dart';
import 'package:pos/src/screens/request_confirm/summary_request.dart';

class RequestDetails extends StatelessWidget {
  final PaymentRequest paymentRequest;

  const RequestDetails({Key key, this.paymentRequest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(paymentRequest.name),
        centerTitle: true,
        elevation: 0.0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text("ID ${paymentRequest.id}")),
          ),
        ],
      ),
      body: SummaryRequest(
        paymentRequest: paymentRequest,
      ),
    );
  }
}
