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
    if (paymentRequest.password == null) {
      throw Exception('paymentRequest.password is null');
    }
    if (paymentRequest.deepLink == null) {
      throw Exception('paymentRequest.deepLink is null');
    }
    final tmpDir = await getTemporaryDirectory();
    final doc = pw.Document();

    final qrcode = pw.BarcodeWidget(
      data: paymentRequest.deepLink!,
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
                    style: const pw.TextStyle(fontSize: 30),
                    textAlign: pw.TextAlign.center),
              // pw.SizedBox(height: 120),
              pw.Spacer(),
              pw.Text(paymentRequest.name,
                  style: const pw.TextStyle(fontSize: 35),
                  textAlign: pw.TextAlign.center),
              pw.SizedBox(height: 20),
              pw.Text(
                  '${paymentRequest.aim != null ? '${paymentRequest.aim?.titles[locale]} - ' : ''}${paymentRequest.amount} WOM',
                  style: pw.TextStyle(fontSize: 30),
                  textAlign: pw.TextAlign.center),
              // pw.SizedBox(height: 60),
              pw.Spacer(),
              qrcode,
              // pw.SizedBox(height: 60),
              pw.Spacer(),
              pw.Text(
                paymentRequest.password!,
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
    final bytes = await doc.save();
    file.writeAsBytesSync(bytes);
    return file;
  }

 /* Future<File> buildPersistentPdf(
    Offer paymentRequest,
    PointOfSale pos,
    String locale,
  ) async {
    if (paymentRequest.password == null) {
      throw Exception('paymentRequest.password is null');
    }
    if (paymentRequest.deepLink == null) {
      throw Exception('paymentRequest.deepLink is null');
    }
    final tmpDir = await getTemporaryDirectory();
    final doc = pw.Document();

    final qrcode = pw.BarcodeWidget(
      data: paymentRequest.deepLink!,
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
                    style: const pw.TextStyle(fontSize: 30),
                    textAlign: pw.TextAlign.center),
              // pw.SizedBox(height: 120),
              pw.Spacer(),
              pw.Text(paymentRequest.name,
                  style: const pw.TextStyle(fontSize: 35),
                  textAlign: pw.TextAlign.center),
              pw.SizedBox(height: 20),
              pw.Text(
                  '${paymentRequest.aim != null ? '${paymentRequest.aim?.titles[locale]} - ' : ''}${paymentRequest.amount} WOM',
                  style: pw.TextStyle(fontSize: 30),
                  textAlign: pw.TextAlign.center),
              // pw.SizedBox(height: 60),
              pw.Spacer(),
              qrcode,
              // pw.SizedBox(height: 60),
              pw.Spacer(),
              pw.Text(
                paymentRequest.password!,
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
    final bytes = await doc.save();
    file.writeAsBytesSync(bytes);
    return file;
  }*/
}
