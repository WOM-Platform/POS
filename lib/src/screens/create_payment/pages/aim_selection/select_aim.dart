import 'package:flutter/material.dart';
import 'package:pos/src/screens/create_payment/pages/aim_selection/bloc.dart';
import 'package:pos/src/screens/create_payment/pages/aim_selection/my_dropdown.dart';

class SelectAim extends StatelessWidget {
  final AimSelectionBloc bloc;

  final Function updateState;

  const SelectAim({Key key, this.bloc, this.updateState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: bloc.selectedAimCode,
      builder: (context, snapshot) {
        return Column(
          children: <Widget>[
            MyDropdown(
              list: bloc.aimList,
              value: bloc.aimEnabled ? snapshot.data : null,
              labelText: 'Aim di primo livello',
              onChanged: bloc.aimEnabled ? (String aim) {
                bloc.changeSelectedAimRoot(aim);
                bloc.subAimCode = null;
                updateState();
              } : null,
            ),
            snapshot.data != null && bloc.subAimList.isNotEmpty
                ? MyDropdown(
                    list: bloc.subAimList,
                    value: bloc.subAimCode,
                    labelText: 'Aim di secondo livello',
                    onChanged: (String aimCode) {
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
                    labelText: 'Aim di terzo livello',
                    onChanged: (aim) {
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
              bloc.getStringOfAimSelected() ?? "Errore",
              style: TextStyle(color: Colors.white),
            ),
          ],
        );
      },
    );
  }
}
