// import 'dart:convert';
// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;
// import 'package:pos/src/constants.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
//
// part 'api.g.dart';
//
// @riverpod
// SignUpRemoteApi signUpRemoteApi(SignUpRemoteApiRef ref) {
//   return SignUpRemoteApi(ref.watch(dioProvider));
// }
//
// @Riverpod(keepAlive: true)
// Dio dio(DioRef ref) {
//   return Dio(
//     BaseOptions(
//       baseUrl: 'https://$domain',
//       headers: {
//         HttpHeaders.contentTypeHeader: 'application/json',
//       },
//     ),
//   );
// }
//
// class SignUpRemoteApi {
//   final Dio dio;
//
//   SignUpRemoteApi(this.dio);
//
//   Future singUp(
//     String email,
//     String name,
//     String surname,
//     String password,
//   ) async {
//     final response = await dio.post(
//       '/api/v1/user/register',
//       data: <String, dynamic>{
//         'email': email,
//         'name': name,
//         'surname': surname,
//         'password': password,
//       },
//     );
//     // final response = await http.post(
//     //   Uri.parse('https://$domain/api/v1/user/register'),
//     //   headers: {HttpHeaders.contentTypeHeader: 'application/json'},
//     //   body: jsonEncode(
//     //     {
//     //       'email': email,
//     //       'name': name,
//     //       'surname': surname,
//     //       'password': password,
//     //     },
//     //   ),
//     // );
//
//     if (response.statusCode == 201) {
//       final map = Map.from(response.data);
//       return map['id'];
//     }
//     throw Exception('/v1/user/register => ${response.statusCode}');
//   }
//
//   Future<bool> sendVerificationEmail(String userId, String token) async {
//     final response = await dio.post('/api/v1/user/$userId/request-verification',
//         options: Options(
//           headers: {
//             'authorization': 'Bearer $token',
//           },
//         ));
//     if (response.statusCode == 200) {
//       return true;
//     }
//     throw Exception('/v1/user/register => ${response.statusCode}');
//   }
//
//   /*/v1/merchant/ (autenticata)
// - Name (min length 8)
// - FiscalCode (min 11, max 16)
// - PrimaryActivity (vedi messaggio sotto)
// - Address
// - ZIP code
// - City
// - Country
// - Description (opzionale)
// - Url (opzionale)*/
//   Future createMerchant({
//     required String name,
//     required String fiscalCode,
//     required String address,
//     required String primaryActivity,
//     required String zipCode,
//     required String city,
//     required String country,
//     String? description,
//     String? url,
//     required String token,
//   }) async {
//     final response = await dio.post(
//       '/api/v1/merchant',
//       data: <String, dynamic>{
//         'name': name,
//         'fiscalCode': fiscalCode,
//         'address': address,
//         'primaryActivity': primaryActivity,
//         'zipCode': zipCode,
//         'city': city,
//         'country': country,
//         'description': description,
//         'url': url,
//       },
//       options: Options(
//         headers: {
//           'authorization': 'Bearer $token',
//         },
//       ),
//     );
//     // final response = await http.post(
//     //   Uri.parse('https://$domain/api/v1/user/register'),
//     //   headers: {HttpHeaders.contentTypeHeader: 'application/json'},
//     //   body: jsonEncode(
//     //     {
//     //       'email': email,
//     //       'name': name,
//     //       'surname': surname,
//     //       'password': password,
//     //     },
//     //   ),
//     // );
//
//     if (response.statusCode == 201) {
//       final map = Map.from(response.data);
//       return map['id'];
//     }
//     throw Exception('/v1/user/register => ${response.statusCode}');
//   }
//
// /*POST /v1/pos/ (autenticata)
// - OwnerMerchantId (ID da richiesta precedente)
// - Name (min 4, max 128)
// - Description (opzionale, max 4096)
// - Latitude (opzionale)
// - Longitude (opzionale)
// - Url (opzionale)*/
//
//   Future createPOS({
//     required String id,
//     required String name,
//     String? description,
//     String? latitude,
//     String? longitude,
//     String? url,
//     required String token,
//   }) async {
//     final response = await dio.post(
//       '/api/v1/pos',
//       data: <String, dynamic>{
//         'id': id,
//         'name': name,
//         'latitude': latitude,
//         'longitude': longitude,
//         'description': description,
//         'url': url,
//       },
//       options: Options(
//         headers: {
//           'authorization': 'Bearer $token',
//         },
//       ),
//     );
//     // final response = await http.post(
//     //   Uri.parse('https://$domain/api/v1/user/register'),
//     //   headers: {HttpHeaders.contentTypeHeader: 'application/json'},
//     //   body: jsonEncode(
//     //     {
//     //       'email': email,
//     //       'name': name,
//     //       'surname': surname,
//     //       'password': password,
//     //     },
//     //   ),
//     // );
//
//     if (response.statusCode == 201) {
//       final map = Map.from(response.data);
//       return map['id'];
//     }
//     throw Exception('/v1/user/register => ${response.statusCode}');
//   }
//
//   Future deleteMerchant({
//     required String merchantId,
//     required String token,
//     bool dryRun = false,
//   }) async {
//     final response = await dio.delete(
//       '/api/v1/merchant/$merchantId',
//       queryParameters: {
//         'dryRun': dryRun,
//       },
//       options: Options(
//         headers: {
//           'authorization': 'Bearer $token',
//         },
//       ),
//     );
//     if (response.statusCode == 201) {
//       final map = Map.from(response.data);
//       return map['id'];
//     }
//     throw Exception('/v1/user/register => ${response.statusCode}');
//   }
// }
