//import 'package:pos/src/db/app_db.dart';
//import 'package:wom_package/wom_package.dart';
//
//class AimDb {
//  static final AimDb _aimDb = new AimDb._internal(AppDatabase.get());
//
//  AppDatabase _appDatabase;
//
//  AimDb._internal(this._appDatabase);
//
//  static AimDb get() {
//    return _aimDb;
//  }
//
//  AimDbHelper _aimDbHelper = AimDbHelper();
//
//  Future<List<Aim>> getAimWithLevel({int deepLevel, String code}) async {
//    var db = await _appDatabase.getDb();
//    return _aimDbHelper.getAimWithLevel(db: db,deepLevel: deepLevel,code: code);
//  }
//
//  Future<Aim> getAim(String aimCode) async {
//    var db = await _appDatabase.getDb();
//    return _aimDbHelper.getAim(db: db,aimCode: aimCode);
//  }
//
//  /// Inserts or replaces the task.
//  Future<int> insert(Aim aim) async {
//    var db = await _appDatabase.getDb();
//    return _aimDbHelper.insert(db: db,aim: aim);
//  }
//}
