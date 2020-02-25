import 'app_database_base.dart';

class AppDatabase extends AppDatabaseBase {
  static AppDatabase _instance;

//  static Future<AppDatabse> get instance async {
//    if (_instance == null) {
//      _instance = AppDatabse();
//    }
//    return _instance;
//  }

  static AppDatabase get() {
    if (_instance == null) {
      _instance = AppDatabase();
    }
    return _instance;
  }

  Future<dynamic> getDb() async {
    return null;
  }

  Future _init() async {
    throw Exception("closeDatabase for web not implemnted");
  }

  Future _createRequestTable(dynamic db) {
    throw Exception("closeDatabase for web not implemnted");
  }

  Future<void> closeDatabase() async {
    throw Exception("closeDatabase for web not implemnted");
  }
}
