import 'package:pos/src/db/app_database/src/app_database_io.dart';
import 'package:pos/src/db/payment_database/src/payment_database_base.dart';
import 'package:pos/src/model/payment_request.dart';
import 'package:sqflite/sqflite.dart';

import '../../../my_logger.dart';

class PaymentDatabase extends PaymentDatabaseBase {
  static final PaymentDatabase _requestDb =
      new PaymentDatabase._internal(AppDatabase.get());

  AppDatabase _appDatabase;

  PaymentDatabase._internal(this._appDatabase);

  static PaymentDatabase get() {
    return _requestDb;
  }

  Future<List<PaymentRequest>> getRequestsByPosId(String id) async {
    logger.i("getRequests");
    var db = await _appDatabase.getDb();
    try {
//      List<Map> maps = await db.query(
//        PaymentRequest.TABLE,
//        orderBy: "${PaymentRequest.DATE} DESC",
//      );
//    LEFT OUTER JOIN ${Aim.TABLE_NAME} ON ${PaymentRequest.AIM_CODE} = ${Aim.CODE}
      List<Map> maps = await db.rawQuery(
          'SELECT * FROM ${PaymentRequest.TABLE} WHERE ${PaymentRequest.POS_ID} = "$id" ORDER BY ${PaymentRequest.DATE} DESC');
      logger.i("requests: ${maps.length}");
      return maps.map((a) {
        return PaymentRequest.fromDBMap(a);
      }).toList();
    } catch (e) {
      logger.i(e.toString());
      return List<PaymentRequest>();
    }
  }

  Future<PaymentRequest> getRequest(int id) async {
    var db = await _appDatabase.getDb();
    try {
      List<Map> maps = await db.query(
        PaymentRequest.TABLE,
        columns: null,
        where: "${PaymentRequest.ID} = ?",
        whereArgs: [id],
      );
      return PaymentRequest.fromDBMap(maps.first);
    } catch (e) {
      logger.i(e.toString());
      throw Exception("PaymentRequest not find: ${e.toString()}");
    }
  }

  insertRequest(PaymentRequest paymentRequest) async {
    var db = await _appDatabase.getDb();
    int result;
    try {
      await db.transaction((Transaction txn) async {
        result = await txn.insert(
          PaymentRequest.TABLE,
          paymentRequest.toDBMap(),
        );
      });
      return result;
    } catch (ex) {
      logger.e(ex.toString());
      throw Exception(ex);
    }
  }

  updateRequest(PaymentRequest paymentRequest) async {
    var db = await _appDatabase.getDb();
    int result;
    try {
      await db.transaction((Transaction txn) async {
        result = await txn.update(
          PaymentRequest.TABLE,
          paymentRequest.toDBMap(),
          where: "${PaymentRequest.ID} = ?",
          whereArgs: [paymentRequest.id],
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
      return result;
    } catch (ex) {
      logger.i(ex.toString());
      throw Exception(ex);
    }
  }

  Future<int> deleteRequest(int id) async {
    var db = await _appDatabase.getDb();
    return await db.delete(PaymentRequest.TABLE,
        where: '${PaymentRequest.ID} = ?', whereArgs: [id]);
  }
}
