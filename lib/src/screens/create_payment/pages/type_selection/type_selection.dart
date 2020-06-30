import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:pos/src/blocs/payment_request/payment_request_bloc.dart';

import '../../back_button_text.dart';

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
                  AppLocalizations.of(context)
                      .translate('is_a_persistent_request'),
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
//              ChipSelection(bloc: bloc,),

              StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Switch(
                    value: bloc.persistentRequest,
                    onChanged: (value) {
                      setState(() {
                        bloc.persistentRequest = value;
                      });
                    });
              }),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Spacer(),
              BackButtonText(onTap: () => bloc.goToPreviousPage())
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.arrow_forward_ios),
            onPressed: () => bloc.goToNextPage()),
      ),
    );
  }
}
