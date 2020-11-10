// ignore_for_file: always_specify_types

import 'dart:io';
import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pos/src/model/payment_request.dart';

class PdfCreator {
  Future<File> buildPdf(
      PaymentRequest paymentRequest, PointOfSale pos, String locale) async {
    final tmpDir = await getTemporaryDirectory();
    final doc = pw.Document();

    final qrcode = pw.BarcodeWidget(
      data: paymentRequest.deepLink,
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
              if (pos.name != 'Anonymous')
                pw.Text(pos.name,
                    style: pw.TextStyle(fontSize: 30),
                    textAlign: pw.TextAlign.center),
              pw.SizedBox(height: 120),
              pw.Text(paymentRequest.name,
                  style: pw.TextStyle(fontSize: 50),
                  textAlign: pw.TextAlign.center),
              pw.Text(
                  '${paymentRequest.aim != null ? '${paymentRequest.aim.titles[locale ?? 'en']} - ' : ''}${paymentRequest.amount} WOM',
                  style: pw.TextStyle(fontSize: 30),
                  textAlign: pw.TextAlign.center),
              pw.SizedBox(height: 60),
              qrcode,
              pw.SizedBox(height: 60),
              pw.Text(
                paymentRequest.password,
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

    final file =
        File('${tmpDir.path}/${paymentRequest.name.replaceAll(' ', '_')}.pdf');
    file.writeAsBytesSync(doc.save());
    return file;
  }
}
