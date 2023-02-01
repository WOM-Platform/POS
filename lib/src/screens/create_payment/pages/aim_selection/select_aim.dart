import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pos/localization/app_localizations.dart';
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
              AppLocalizations.of(context)?.translate('no_connection_title') ??
                  '',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              AppLocalizations.of(context)
                      ?.translate('no_connection_aim_desc') ??
                  '',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text(
                  AppLocalizations.of(context)?.translate('try_again') ?? ''),
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
          labelText:
              AppLocalizations.of(context)?.translate('primary_aim') ?? '',
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
                labelText:
                    AppLocalizations.of(context)?.translate('secondary_aim') ??
                        '',
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
                labelText:
                    AppLocalizations.of(context)?.translate('tiertiary_aim') ??
                        '',
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
              AppLocalizations.of(context)?.translate('error') ??
              '',
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
