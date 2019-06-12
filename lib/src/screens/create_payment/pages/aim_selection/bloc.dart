import 'package:pos/src/db/app_db.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wom_package/wom_package.dart';

class AimSelectionBloc {
  BehaviorSubject<String> _selectedAimCode = BehaviorSubject<String>();

  Observable<String> get selectedAimCode => _selectedAimCode.stream;

  Function get changeSelectedAimRoot => _selectedAimCode.add;

  List<Aim> get subAimList =>
      aimList
          .firstWhere((aim) => aim.code == _selectedAimCode.value,
              orElse: () => null)
          ?.children ??
      [];

  List<Aim> get subSubAimList =>
      subAimList
          .firstWhere((aim) => aim.code == subAimCode, orElse: () => null)
          ?.children ??
      [];

  bool aimEnabled = false;
  List<Aim> aimList = [];
  String subAimCode;
  String subSubAimCode;
  AimRepository _aimRepository;

  AimSelectionBloc() {
    print("AimSelectionBloc()");
    _aimRepository = AimRepository();
    getAimListFromDb().then((list) {
      aimList = list;
    });
  }

  Future<List<Aim>> getAimListFromDb() async {
    return await _aimRepository.getAimList(AppDatabase.get().getDb());
  }

//  changeSelectedAimRoot(String newSelectedAim) {
//    print("pre${_selectedAimCode.value}");
//    print("new $newSelectedAim");

//    if (newSelectedAim.substring(0, 1) != _selectedAimCode.value) {
//      subAimCode = null;
//      subSubAimCode = null;
//    }

//    _selectedAimCode.add(newSelectedAim);
//
//    if(subSubAimList.isEmpty){
//      subSubAimCode = null;
//    }
//    if(subAimList.isEmpty){
//      subAimCode = null;
//    }
//  }

  getStringOfAimSelected() {
    final String firstLevel = aimList
        .firstWhere((aim) => aim.code == _selectedAimCode.value,
            orElse: () => null)
        ?.title;

    if (firstLevel == null) {
      return "";
    }

    final String secondLevel = subAimList
        .firstWhere((aim) => aim.code == subAimCode, orElse: () => null)
        ?.title;

    if (secondLevel == null) {
      return firstLevel;
    }

    final String thirdLevel = subSubAimList
        .firstWhere((aim) => aim.code == subSubAimCode, orElse: () => null)
        ?.title;
    if (thirdLevel == null) {
      return firstLevel + " -> " + secondLevel;
    }
    return firstLevel + " -> " + secondLevel + " -> " + thirdLevel;
  }

  //Return aim code selected
  getAimCode() {
    return aimEnabled ? (subSubAimCode ?? subAimCode ?? _selectedAimCode.value) :  null;
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

  Future<Aim> getAim() async {
    final aimCode = getAimCode();
    if (aimCode != null) {
      return await _aimRepository.getAim(AppDatabase.get().getDb(), aimCode);
    }

    return null;
  }

  dispose() {
    _selectedAimCode.close();
  }
}
