// ignore_for_file: always_specify_types

import 'dart:io';
import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pos/src/model/payment_request.dart';
import 'package:collection/collection.dart';

class PdfCreator {
  Future<File> buildPdf(
      PaymentRequest paymentRequest, PointOfSale pos, String locale) async {
    if (paymentRequest.password == null) {
      throw Exception('paymentRequest.password is null');
    }
    if (paymentRequest.deepLink == null) {
      throw Exception('paymentRequest.deepLink is null');
    }
    final tmpDir = await getTemporaryDirectory();

    final doc = _createPdf(
      pos.name,
      paymentRequest.name,
      paymentRequest.amount,
      paymentRequest.deepLink!,
      paymentRequest.password!,
        '${paymentRequest.aim != null ? '${paymentRequest.aim?.titles[locale]} - ' : ''}',
    );

    final file =
        File('${tmpDir.path}/${paymentRequest.name.replaceAll(' ', '_')}.pdf');
    final bytes = await doc.save();
    file.writeAsBytesSync(bytes);
    return file;
  }

  Future<File> buildPersistentPdf(
    Offer offer,
    PointOfSale pos,
    String locale,
    List<Aim> aimList,
  ) async {
    final tmpDir = await getTemporaryDirectory();
    final aim = aimList
        .firstWhereOrNull((element) => offer.filter?.aim == element.code);
    final aimText = aim != null ? aim.titles[locale] : null;
    final doc = _createPdf(
      pos.name,
      offer.title,
      offer.cost,
      offer.payment.link,
      offer.payment.password,
      aimText,
    );
    final file = File('${tmpDir.path}/${offer.title.replaceAll(' ', '_')}.pdf');
    final bytes = await doc.save();
    file.writeAsBytesSync(bytes);
    return file;
  }

  pw.Document _createPdf(
    String posName,
    String offerName,
    int cost,
    String link,
    String password,
    String? aim,
  ) {
    final doc = pw.Document();

    final qrcode = pw.BarcodeWidget(
      data: link,
      width: 250,
      height: 250,
      barcode: pw.Barcode.qrCode(),
    );

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              if (posName != 'Anonymous')
                pw.Text(posName,
                    style: const pw.TextStyle(fontSize: 30),
                    textAlign: pw.TextAlign.center),
              // pw.SizedBox(height: 120),
              pw.Spacer(),
              pw.Text(offerName,
                  style: const pw.TextStyle(fontSize: 35),
                  textAlign: pw.TextAlign.center),
              pw.SizedBox(height: 14),
              if (aim != null)
                pw.Text(aim,
                    style: pw.TextStyle(fontSize: 26),
                    textAlign: pw.TextAlign.center),
              pw.SizedBox(height: 20),
              pw.Text('$cost WOM',
                  style: pw.TextStyle(fontSize: 30),
                  textAlign: pw.TextAlign.center),
              pw.Spacer(),
              qrcode,
              pw.Spacer(),
              pw.Text(
                password,
                style:
                    pw.TextStyle(fontSize: 40, fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center,
              ),
              pw.Spacer(),
            ],
          ),
        ),
      ),
    );

    return doc;
  }
}
