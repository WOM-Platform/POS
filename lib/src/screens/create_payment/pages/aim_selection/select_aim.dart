import 'package:flutter/material.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:pos/src/screens/create_payment/pages/aim_selection/bloc.dart';
import 'package:pos/src/screens/create_payment/pages/aim_selection/my_dropdown.dart';

class SelectAim extends StatelessWidget {
  final AimSelectionBloc bloc;

  final Function updateState;

  const SelectAim({Key? key, required this.bloc, required this.updateState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
      stream: bloc.selectedAimCode,
      builder: (context, snapshot) {
        if (bloc.aimList == null || bloc.aimList.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)
                          ?.translate('no_connection_title') ??
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
                        AppLocalizations.of(context)?.translate('try_again') ??
                            ''),
                    onPressed: () {
                      bloc.updateAims();
                    }),
              ],
            ),
          );
        }
        return Column(
          children: <Widget>[
            MyDropdown(
              list: bloc.aimList,
              value: bloc.aimEnabled ? snapshot.data : null,
              labelText:
                  AppLocalizations.of(context)?.translate('primary_aim') ?? '',
              onChanged: bloc.aimEnabled
                  ? (aim) {
                      bloc.changeSelectedAimRoot(aim);
                      bloc.subAimCode = null;
                      updateState();
                    }
                  : null,
            ),
            snapshot.data != null && bloc.subAimList.isNotEmpty
                ? MyDropdown(
                    list: bloc.subAimList,
                    value: bloc.subAimCode,
                    labelText: AppLocalizations.of(context)
                            ?.translate('secondary_aim') ??
                        '',
                    onChanged: (String? aimCode) {
                      if (aimCode == null) return;
                      bloc.changeSelectedAimRoot(aimCode.substring(0, 1));
                      bloc.subAimCode = aimCode;
                      bloc.subSubAimCode = null;
                      updateState();
                    },
                  )
                : Container(),
            snapshot.data != null &&
                    bloc.subAimCode != null &&
                    bloc.subAimList.isNotEmpty &&
                    bloc.subSubAimList.isNotEmpty
                ? MyDropdown(
                    list: bloc.subSubAimList,
                    value: bloc.subSubAimCode,
                    labelText: AppLocalizations.of(context)
                            ?.translate('tiertiary_aim') ??
                        '',
                    onChanged: (aim) {
                      if (aim == null) return;
                      bloc.changeSelectedAimRoot(aim.substring(0, 1));
                      bloc.subSubAimCode = aim;
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
              bloc.getStringOfAimSelected() ??
                  AppLocalizations.of(context)?.translate('error') ??
                  '',
              style: TextStyle(color: Colors.white),
            ),
          ],
        );
      },
    );
  }
}
