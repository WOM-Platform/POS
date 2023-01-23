import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:pos/src/db/aim_db.dart';
import 'package:pos/src/db/app_database/src/app_database_base.dart';
import 'dart:async';
import 'dart:io';
import 'package:pos/src/model/payment_request.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:synchronized/synchronized.dart';

import '../../../constants.dart';
import '../../../my_logger.dart';

class AppDatabase extends AppDatabaseBase {
  static final AppDatabase _appDatabase = new AppDatabase._internal();

  static String LEFT_TOP = 'leftTop';
  static String LEFT_TOP_LAT = 'leftTopLat';
  static String LEFT_TOP_LONG = 'leftTopLong';
  static String RIGHT_BOT = 'rightBottom';
  static String RIGHT_BOT_LAT = 'rightBottomLat';
  static String RIGHT_BOT_LONG = 'rightBottomLong';
  static String MAX_AGE = 'maxAge';

  //private internal constructor to make it singletona
  AppDatabase._internal();

  Database? _database;

  static AppDatabase get() {
    return _appDatabase;
  }

  final _lock = new Lock();

  Future<Database> getDb() async {
    if (_database == null) {
      await _lock.synchronized(() async {
        // Check again once entering the synchronized block
        if (_database == null) {
          await _init();
        }
      });
    }
    return _database!;
  }

  Future _init() async {
    logger.i("AppDatabase: init database");
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "pos.db");
    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await AimDatabase.createAimTable(db);
      await _createRequestTable(db);
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      await db.execute("DROP TABLE ${AimDbKeys.TABLE_NAME}");
      await AimDatabase.createAimTable(db);
      await _createRequestTable(db);
    });
  }

  Future _createRequestTable(Database db) {
    return db.execute("CREATE TABLE ${PaymentRequest.TABLE} ("
        "${PaymentRequest.ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${PaymentRequest.AIM_CODE} TEXT,"
        "${PaymentRequest.AIM_NAME} TEXT,"
        "${PaymentRequest.DEEP_LINK} TEXT,"
        "${PaymentRequest.PASSWORD} TEXT,"
        "${PaymentRequest.POS_ID} TEXT,"
        "${PaymentRequest.NONCE} TEXT,"
        "${PaymentRequest.NAME} TEXT,"
        "${PaymentRequest.AMOUNT} INTEGER,"
        "${PaymentRequest.STATUS} INTEGER,"
        "${PaymentRequest.PERSISTENT} INTEGER,"
        "${PaymentRequest.ON_CLOUD} INTEGER,"
        "${PaymentRequest.POCKET_ACK_URL} TEXT,"
        "${PaymentRequest.POS_ACK_URL} TEXT,"
        "${PaymentRequest.LATITUDE} LONG,"
        "${PaymentRequest.LONGITUDE} LONG,"
        "$MAX_AGE INTEGER,"
        "$LEFT_TOP_LAT LONG,"
        "$LEFT_TOP_LONG LONG,"
        "$RIGHT_BOT_LAT LONG,"
        "$RIGHT_BOT_LONG LONG,"
        "${PaymentRequest.URL} TEXT,"
        "${PaymentRequest.DATE} INTEGER);");
  }

  Future<void> closeDatabase() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
      _database = null;
      logger.i("database closed");
    }
  }
}
