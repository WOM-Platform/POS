/*
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentRegistrationApiProvider {



  Future<bool> verifyWomCreation(
      String url, Map<String, dynamic> map) async {
    final resp = await http.post(
      url,
      body: json.encode(map),
      headers: {HttpHeaders.contentTypeHeader: "application/json"},
    );
    if (resp.statusCode == 200) {
      return true;
    }
    final Map<String, dynamic> jsonError = json.decode(resp.body);
    throw Exception(jsonError['title']);
  }

}
*/
