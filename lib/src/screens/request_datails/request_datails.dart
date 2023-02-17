import 'package:clippy_flutter/arc.dart';
import 'package:flutter/material.dart';
import 'package:pos/src/model/payment_request.dart';
import 'package:pos/src/screens/request_confirm/summary_request.dart';

class RequestDetails extends StatelessWidget {
  // final PaymentRequest paymentRequest;
  final int cost;
  final String id;
  final String password;
  final String name;
  final String link;

  const RequestDetails(
      {Key? key,
      required this.id,
      required this.cost,
      required this.password,
      required this.link,
      required this.name})
      : super(key: key);

  factory RequestDetails.fromPaymentRequest(PaymentRequest request) {
    return RequestDetails(
      id: request.id.toString(),
      cost: request.amount,
      password: request.password ?? '-',
      name: request.name,
      link: request.deepLink ?? '-',
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        centerTitle: true,
        elevation: 0.0,
        actions: <Widget>[
          if(id.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text("ID ${id}")),
          ),
        ],
      ),
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
          ListView(
            // mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "${cost} ",
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
                height: height / 3,
                width: height / 3,
                child: Center(
                  child: MyBarcode(
                    link: link,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'PIN ',
                    style: TextStyle(
                        fontSize: 30.0, color: Theme.of(context).primaryColor),
                    children: <TextSpan>[
                      TextSpan(
                          text: password,
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
            ],
          ),
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: paymentRequest.persistent
      //     ? null
      //     : FloatingActionButton.extended(
      //   onPressed: () {
      //     final pos = ref.read(selectedPosProvider)?.pos;
      //     if (pos == null) return;
      //     Navigator.of(context).pushReplacement(
      //       MaterialPageRoute(
      //         builder: (ctx) => ProviderScope(
      //           overrides: [
      //             paymentRequestProvider
      //                 .overrideWith((ref) => paymentRequest.copyFrom()),
      //             requestConfirmNotifierProvider.overrideWith(
      //                   (ref) => RequestConfirmBloc(
      //                 ref: ref,
      //                 pos: ref.read(getPosProvider),
      //                 pointOfSale: pos,
      //               ),
      //             )
      //           ],
      //           child: const RequestConfirmScreen(),
      //         ),
      //       ),
      //     );
      //   },
      //   label: Text(
      //       AppLocalizations.of(context)?.translate('duplicate') ?? ''),
      // ),
    );
  }
}
