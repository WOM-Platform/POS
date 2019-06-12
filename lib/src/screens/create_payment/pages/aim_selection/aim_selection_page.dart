import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/src/screens/create_payment/bloc.dart';
import 'package:pos/src/screens/create_payment/pages/aim_selection/select_aim.dart';
import 'package:pos/src/utils.dart';

import '../../back_button_text.dart';

class AimSelectionPage extends StatefulWidget {
  @override
  _AimSelectionPageState createState() => _AimSelectionPageState();
}

class _AimSelectionPageState extends State<AimSelectionPage> {
  CreatePaymentRequestBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<CreatePaymentRequestBloc>(context);
    final isValid = bloc.isValidAim;
    return SafeArea(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).primaryColor,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Per quale causa accetti i WOM?",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Switch(
                  value: bloc.aimSelectionBloc.aimEnabled,
                  onChanged: (value) {
                    setState(
                          () {
                        bloc.aimSelectionBloc.aimEnabled = value;
                      },
                    );
                  },
                ),
                SelectAim(
                  bloc: bloc.aimSelectionBloc,
                  updateState: () {
                    if (isValid != bloc.isValidAim) setState(() {});
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Selezionando un determinato AIM stabilisci che solo i WOM generati per quell'aim potranno essere usati in questo pagamento",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Spacer(),
                BackButtonText(
                  onTap: () => bloc.goToPreviousPage(),
                )
              ],
            ),
          ),
          floatingActionButton: isValid
              ? FloatingActionButton(onPressed: () => bloc.goToNextPage())
              : null,
        ),
      ),
    );
  }
}
