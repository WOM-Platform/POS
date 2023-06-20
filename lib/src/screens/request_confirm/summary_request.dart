import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;

import 'package:pos/src/model/payment_request.dart';
import 'package:pos/src/offers/application/offers.dart';
import 'package:pos/src/screens/request_confirm/bloc.dart';
import 'package:pos/src/screens/request_confirm/request_confirm.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:clippy_flutter/arc.dart';

class SummaryRequest extends ConsumerWidget {
  final PaymentRequest paymentRequest;

  const SummaryRequest({Key? key, required this.paymentRequest})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                if (paymentRequest.deepLink != null)
                  Container(
                    height: height / 3,
                    width: height / 3,
                    child: Center(
                        child: MyBarcode(
                      link: paymentRequest.deepLink!,
                    )
                        // child: Card(
                        //   child: paymentRequest.deepLink != null
                        //       ? pdf.BarcodeWidget(
                        //           barcode: pdf.Barcode.qrCode(
                        //             errorCorrectLevel:
                        //                 pdf.BarcodeQRCorrectionLevel.high,
                        //           ),
                        //           data: paymentRequest.deepLink,
                        //           width: 200,
                        //           height: 200,
                        //         )
                        //       : Text('Errore QRCode'),
                        // ),
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
              ],
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: paymentRequest.persistent
            ? null
            : FloatingActionButton.extended(
                onPressed: () {
                  final pos = ref.read(selectedPosProvider)?.pos;
                  if (pos == null) return;
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) => ProviderScope(
                        overrides: [
                          paymentRequestProvider
                              .overrideWith((ref) => paymentRequest.copyFrom()),
                          requestConfirmNotifierProvider.overrideWith(
                            (ref) => RequestConfirmBloc(
                              ref: ref,
                              pos: ref.read(getPosProvider),
                              pointOfSale: pos,
                            ),
                          )
                        ],
                        child: const RequestConfirmScreen(),
                      ),
                    ),
                  );
                },
                label: Text(
                    'duplicate'.tr()),
              ),
      ),
    );
  }
}

class MyBarcode extends StatelessWidget {
  final String link;

  const MyBarcode({Key? key, required this.link}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: BarcodeWidget(
          barcode: pdfWidgets.Barcode.qrCode(
            errorCorrectLevel: pdfWidgets.BarcodeQRCorrectionLevel.high,
          ),
          data: link,
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
