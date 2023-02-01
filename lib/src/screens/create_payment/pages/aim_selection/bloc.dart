import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pos/src/db/app_database/app_database.dart';
import 'package:pos/src/services/aim_repository.dart';

import '../../../../my_logger.dart';
import 'package:collection/collection.dart';

part 'bloc.freezed.dart';

@freezed
class AimSelectionState with _$AimSelectionState {
  const factory AimSelectionState({
    String? aimCode,
    String? subAimCode,
    String? subSubAimCode,
    required List<Aim> aimList,
    required List<Aim> subAimList,
    required List<Aim> subSubAimList,
    @Default(false) bool aimEnabled,
  }) = _AimSelectionState;

  factory AimSelectionState.empty() => AimSelectionState(
        aimList: [],
        subAimList: [],
        subSubAimList: [],
      );
}

final aimSelectionNotifierProvider =
    StateNotifierProvider.autoDispose<AimSelectorNotifier, AimSelectionState>(
        (ref) {
  return AimSelectorNotifier(ref);
});

class AimSelectorNotifier extends StateNotifier<AimSelectionState> {
  final Ref ref;

  bool aimEnabled = false;
  String languageCode = 'it';

  AimSelectorNotifier(this.ref) : super(AimSelectionState.empty()) {
    logger.i("AimSelectionBloc()");
    getAimListFromDb();
  }

  changeSelectedAimRoot(
    String aimCode,
  ) {
    state = state.copyWith(
      aimCode: aimCode,
      subAimCode: null,
      subSubAimCode: null,
      subAimList: state.aimList
              .firstWhereOrNull((aim) => aim.code == aimCode)
              ?.children ??
          [],
      subSubAimList: [],
    );
  }

  changeSubAim(String? subAimCode) {
    state = state.copyWith(
      subAimCode: subAimCode,
      subSubAimList: [],
    );
  }

  changeSubSubAim(String? subSubAimCode) {
    state = state.copyWith(
      subSubAimCode: subSubAimCode,
      subSubAimList: state.subAimList
              .firstWhereOrNull((aim) => aim.code == subSubAimCode)
              ?.children ??
          [],
    );
  }

  toggle() {
    state = state.copyWith(aimEnabled: !state.aimEnabled);
  }

  Future<void> getAimListFromDb() async {
    try {
      final aimList =
          await ref.read(aimRepositoryProvider).getAimList(database: AppDatabase.get().getDb());
      state = AimSelectionState(
        aimList: aimList,
        subSubAimList: [],
        subAimList: [],
      );
    } catch (ex) {
      state = AimSelectionState.empty();
      logger.e(ex.toString());
    }
  }

  updateAims() async {
    final aimList =
        await ref.read(aimRepositoryProvider).updateAim(database: AppDatabase.get().getDb());
    state = AimSelectionState(
      aimList: aimList,
      subSubAimList: [],
      subAimList: [],
    );
  }

  getStringOfAimSelected() {
    final firstLevelAim = state.aimCode != null
        ? state.aimList.firstWhereOrNull((aim) => aim.code == state.aimCode)
        : null;

    if (firstLevelAim == null) {
      return "";
    }
    final firstLevel = firstLevelAim.titles[languageCode];

    final secondLevelAim =
        state.subAimList.firstWhereOrNull((aim) => aim.code == state.subAimCode);

    if (secondLevelAim == null) {
      return firstLevel;
    }

    final secondLevel = secondLevelAim.titles[languageCode];

    final thirdLevelAim =
        state.subSubAimList.firstWhereOrNull((aim) => aim.code == state.subSubAimCode);

    if (thirdLevelAim == null) {
      return firstLevel + " -> " + secondLevel;
    }

    final thirdLevel = thirdLevelAim.titles[languageCode];

    return firstLevel + " -> " + secondLevel + " -> " + thirdLevel;
  }

  //Return aim code selected
  getAimCode() {
    return state.subSubAimCode ?? state.subAimCode ?? state.aimCode;
  }

  setAimCode(String aimCode) {
    changeSelectedAimRoot(aimCode.substring(0, 1));
    if (aimCode.length == 1) return;
    changeSubAim(aimCode.substring(0, 2));
    if (aimCode.length == 2) return;
    changeSubSubAim(aimCode);
  }

  Future<Aim?> getAim() async {
    final aimCode = getAimCode();
    if (aimCode != null) {
      return await ref.read(aimRepositoryProvider).getAim(
          database: AppDatabase.get().getDb(), aimCode: aimCode);
    }

    return null;
  }
}
