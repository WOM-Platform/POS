import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:pos/src/db/app_database/app_database.dart';
import 'package:pos/src/services/aim_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../my_logger.dart';
import 'package:collection/collection.dart';

class AimSelectionBloc {
  BehaviorSubject<String?> _selectedAimCode = BehaviorSubject<String?>();

  Stream<String?> get selectedAimCode => _selectedAimCode.stream;

  Function get changeSelectedAimRoot => _selectedAimCode.add;

  List<Aim> get subAimList =>
      aimList
          .firstWhereOrNull((aim) => aim.code == _selectedAimCode.value)
          ?.children ??
      [];

  List<Aim> get subSubAimList =>
      subAimList.firstWhereOrNull((aim) => aim.code == subAimCode)?.children ??
      [];

  bool aimEnabled = false;
  List<Aim> aimList = [];
  String? subAimCode;
  String? subSubAimCode;
  late AimRepository _aimRepository;
  final String languageCode;

  AimSelectionBloc(this.languageCode) {
    logger.i("AimSelectionBloc()");
    _aimRepository = AimRepository();
    getAimListFromDb();
  }

  Future<void> getAimListFromDb() async {
    try {
      aimList =
          await _aimRepository.getAimList(database: AppDatabase.get().getDb());
    } catch (ex) {
      aimList = [];
      logger.e(ex.toString());
    }
  }

  updateAims() async {
    aimList =
        await _aimRepository.updateAim(database: AppDatabase.get().getDb());
    _selectedAimCode.add(null);
  }

  getStringOfAimSelected() {
    final firstLevelAim = _selectedAimCode.hasValue
        ? aimList.firstWhereOrNull((aim) => aim.code == _selectedAimCode.value)
        : null;

    if (firstLevelAim == null) {
      return "";
    }
    final firstLevel = firstLevelAim.titles[languageCode];

    final secondLevelAim =
        subAimList.firstWhereOrNull((aim) => aim.code == subAimCode);

    if (secondLevelAim == null) {
      return firstLevel;
    }

    final secondLevel = secondLevelAim.titles[languageCode];

    final thirdLevelAim =
        subSubAimList.firstWhereOrNull((aim) => aim.code == subSubAimCode);

    if (thirdLevelAim == null) {
      return firstLevel + " -> " + secondLevel;
    }

    final thirdLevel = thirdLevelAim.titles[languageCode];

    return firstLevel + " -> " + secondLevel + " -> " + thirdLevel;
  }

  //Return aim code selected
  getAimCode() {
    return aimEnabled && _selectedAimCode.hasValue
        ? (subSubAimCode ?? subAimCode ?? _selectedAimCode.value)
        : null;
  }

  setAimCode(String aimCode) {
    _selectedAimCode.add(aimCode.substring(0, 1));
    if (aimCode.length == 1) {
      return;
    }
    subAimCode = aimCode.substring(0, 2);
    if (aimCode.length == 2) {
      return;
    }
    subSubAimCode = aimCode;
  }

  Future<Aim?> getAim() async {
    final aimCode = getAimCode();
    if (aimCode != null) {
      return await _aimRepository.getAim(
          database: AppDatabase.get().getDb(), aimCode: aimCode);
    }

    return null;
  }

  dispose() {
    _selectedAimCode.close();
  }
}
