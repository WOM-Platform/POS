import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pos/src/db/aim_db.dart';
import 'package:pos/src/db/app_database/app_database.dart';
import 'package:sqflite/sqflite.dart';

import '../constants.dart';
import '../my_logger.dart';

final aimRepositoryProvider = Provider<AimRepository>((ref) {
  return AimRepository();
});

final aimListFutureProvider = FutureProvider((ref) {
  final repo = ref.watch(aimRepositoryProvider);
  return repo.getAimList(database: AppDatabase.get().getDb());
});

class AimRepository {
  late AimRemoteDataSources _apiProvider;
  late AimDatabase _aimDbHelper;

  AimRepository() {
    _apiProvider = AimRemoteDataSources(domain);
    _aimDbHelper = AimDatabase.get();
  }

  // check if there is update of Aim
  //TODO delete la riga sotto quando verranno scaricati solo gli aim nuovi
  Future<List<Aim>> updateAim({required Future<Database> database}) async {
    logger.i("AimRepository: updateAim()");
    try {
      final List<Aim> newList = await _apiProvider.checkUpdate();
      if (newList != null) {
        final db = await database;
        await db.delete(AimDbKeys.TABLE_NAME);
        logger.i("${newList.length} NUOVI AIM");
        saveAimToDb(db, newList);
      }
      return newList;
    } catch (e) {
      logger.e(e);
      return [];
    }
  }

  Future<List<Aim>?> getFlatAimList({
    required Future<Database> database,
  }) async {
    logger.i("AimRepository: getFlatAimList()");
    final db = await database;
    return await _aimDbHelper.getFlatAimList(db: db);
  }

  Future<Aim?> getAim({
    required Future<Database> database,
    required String aimCode,
  }) async {
    logger.i("AimRepository: getAim()");
    final db = await database;
    return await _aimDbHelper.getAim(db: db, aimCode: aimCode);
  }

  Future<List<Aim>> getAimList({
    required Future<Database> database,
  }) async {
    logger.i("AimRepository: getAimList()");
    try {
      final db = await database;
      List<Aim> rootList =
          await _aimDbHelper.getAimWithLevel(db: db, deepLevel: 1);
      if (rootList.isEmpty) {
        final list = await _apiProvider.getAims();
        await saveAimToDb(db, list);
        rootList = await _aimDbHelper.getAimWithLevel(
          db: db,
          deepLevel: 1,
        );
      }

      final tmp = <Aim>[];

      logger.i("START READING");
      for (final aim in rootList) {
        final children = await _aimDbHelper.getAimWithLevel(
          db: db,
          deepLevel: 2,
          code: aim.code,
        );
        final newAim = aim.copyWith(children: children);

        // aim.children = await _aimDbHelper.getAimWithLevel(
        //     db: db, deepLevel: 2, code: aim.code);

        final subAims = <Aim>[];
        for (final Aim a in newAim.children ?? []) {
          final subChildren = await _aimDbHelper.getAimWithLevel(
              db: db, deepLevel: 3, code: a.code);
          final subAim = a.copyWith(children: subChildren);
          subAims.add(subAim);
          // a.children = await _aimDbHelper.getAimWithLevel(
          //     db: db, deepLevel: 3, code: a.code);
        }
        final output = newAim.copyWith(children: subAims);
        tmp.add(output);
      }

      logger.i("END READING");
      return tmp;
    } catch (ex) {
      rethrow;
    }
  }

  saveAimToDb(Database db, List<Aim> list) async {
    logger.i("AimRepository: saveAimToDb()");
    logger.i("SAVING AIM");
    list.forEach(
      (aim) async {
        await _aimDbHelper.insert(db: db, aim: aim);
      },
    );
    logger.i("AIM SAVED");
  }
}
