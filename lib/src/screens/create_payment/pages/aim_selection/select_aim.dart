import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:pos/src/screens/create_payment/pages/aim_selection/bloc.dart';
import 'package:pos/src/screens/create_payment/pages/aim_selection/my_dropdown.dart';

class SelectAim extends ConsumerWidget {
  // final AimSelectionBloc bloc;

  final Function() updateState;

  const SelectAim({Key? key, required this.updateState}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(aimSelectionNotifierProvider);

    if (state.aimList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'no_connection_title'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'no_connection_aim_desc'.tr(),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text('try_again'.tr()),
              onPressed: () {
                ref.read(aimSelectionNotifierProvider.notifier).updateAims();
              },
            ),
          ],
        ),
      );
    }
    return Column(
      children: <Widget>[
        MyDropdown(
          list: state.aimList,
          value: state.aimEnabled ? state.aimCode : null,
          labelText: 'primary_aim'.tr(),
          onChanged: state.aimEnabled
              ? (aim) {
                  if (aim == null) return;
                  ref
                      .read(aimSelectionNotifierProvider.notifier)
                      .changeSelectedAimRoot(aim);
                  updateState();
                }
              : null,
        ),
        state.aimCode != null && state.subAimList.isNotEmpty
            ? MyDropdown(
                list: state.subAimList,
                value: state.subAimCode,
                labelText: 'secondary_aim'.tr(),
                onChanged: (String? aimCode) {
                  if (aimCode == null) return;
                  ref
                      .read(aimSelectionNotifierProvider.notifier)
                      .changeSubAim(aimCode);
                  updateState();
                },
              )
            : Container(),
        state.subAimCode != null &&
                state.subAimList.isNotEmpty &&
                state.subSubAimList.isNotEmpty
            ? MyDropdown(
                list: state.subSubAimList,
                value: state.subSubAimCode,
                labelText: 'tiertiary_aim'.tr(),
                onChanged: (aim) {
                  if (aim == null) return;
                  ref
                      .read(aimSelectionNotifierProvider.notifier)
                      .changeSubAim(aim);
                  updateState();
                },
              )
            : Container(),
        SizedBox(
          height: 10.0,
        ),
        Divider(
          color: Colors.grey[200],
        ),
        Text(
          ref
                  .read(aimSelectionNotifierProvider.notifier)
                  .getStringOfAimSelected() ??
              'error'.tr(),
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
