import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/src/screens/create_payment/bloc.dart';
import 'package:pos/src/screens/create_payment/pages/amount_selection/amount_selection_page.dart';
import 'package:pos/src/utils.dart';

import '../../back_button_text.dart';
import '../../chip_selection.dart';

class TypeSelectionPage extends StatelessWidget {
  CreatePaymentRequestBloc bloc;

  @override
  Widget build(BuildContext context) {
    print("TypeSelectionPage build");
    bloc = BlocProvider.of<CreatePaymentRequestBloc>(context);

    return GestureDetector(
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
                  "Seleziona la modalità di richiesta",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              ChipSelection(bloc: bloc,),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "La richiesta singola genera un'unica istanza di pagamento, "
                  "mentre la richiesta multipla permette di crare più istanze "
                  "di pagamento con un'unica procedura",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Spacer(),
              BackButtonText(onTap:()=> bloc.goToPreviousPage())
            ],
          ),
        ),
        floatingActionButton:
            FloatingActionButton(child:Icon(Icons.arrow_forward_ios),onPressed: () => bloc.goToNextPage()),
      ),
    );
  }
}
