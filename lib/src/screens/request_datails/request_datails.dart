import 'package:clippy_flutter/arc.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:pos/src/db/app_database/app_database.dart';
import 'package:pos/src/model/payment_request.dart';
import 'package:pos/src/screens/request_confirm/summary_request.dart';
import 'package:pos/src/services/aim_repository.dart';
import 'package:pos/src/services/pdf_creator.dart';
import 'package:share/share.dart';

import '../../offers/application/offers.dart';

class RequestDetails extends ConsumerWidget {
  // final PaymentRequest paymentRequest;
  final int cost;
  final String id;
  final String password;
  final String name;
  final String link;
  final Function()? onCreatePdf;

  const RequestDetails(
      {Key? key,
      required this.id,
      required this.cost,
      this.onCreatePdf,
      required this.password,
      required this.link,
      required this.name})
      : super(key: key);

  factory RequestDetails.fromPaymentRequest(
    PaymentRequest request,
    Function()? onCreatePdf,
  ) {
    return RequestDetails(
      id: request.id.toString(),
      cost: request.amount,
      password: request.password ?? '-',
      name: request.name,
      link: request.deepLink ?? '-',
      onCreatePdf: onCreatePdf,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        centerTitle: true,
        elevation: 0.0,
        actions: <Widget>[
          if (id.isNotEmpty)
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
              if (onCreatePdf != null) ...[
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                    ),
                    onPressed: onCreatePdf,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.picture_as_pdf),
                        const SizedBox(width: 16),
                        Text('Scarica PDF'),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () => Share.share(link),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.share),
                        const SizedBox(width: 16),
                        Text('Condividi link'),
                      ],
                    ),
                  ),
                ),
                /* Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                      ),
                      onPressed: onCreatePdf,
                      child: Row(
                        children: [
                          Icon(Icons.picture_as_pdf),
                          const SizedBox(width: 16),
                          Text('Scarica PDF'),
                        ],
                      ),
                    ),
                    // IconButton(
                    //   icon: Icon(Icons.picture_as_pdf),
                    //   color: Colors.pink,
                    //   iconSize: 50,
                    //   onPressed: onCreatePdf,
                    // ),
                    const SizedBox(width: 24),
                    IconButton(
                      icon: Icon(Icons.share),
                      color: Colors.green,
                      iconSize: 50,
                      onPressed: () {
                        Share.share(link);
                      },
                    ),
                  ],
                ),*/
              ]
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
