import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/src/screens/create_payment/bloc.dart';

import '../../back_button_text.dart';

class MaxAgeSelectionPage extends StatefulWidget {
  @override
  _MaxAgeSelectionPageState createState() => _MaxAgeSelectionPageState();
}

class _MaxAgeSelectionPageState extends State<MaxAgeSelectionPage> {
  CreatePaymentRequestBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<CreatePaymentRequestBloc>(context);
    final isValid = bloc.isValidMaxAge;
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Qual'è l'eta dei WOM accettai?",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Switch(
                  value: bloc.maxAgeEnabled,
                  onChanged: (value) {
                    setState(
                      () {
                        bloc.maxAgeEnabled = value;
                      },
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    enabled: bloc.maxAgeEnabled,
                    textInputAction: TextInputAction.go,
                    controller: bloc.maxAgeController,
                    onChanged: (value) {
                      if (isValid != bloc.isValidMaxAge) {
                        setState(() {});
                      }
                    },
                    onEditingComplete: () {
                      print("onEditingComplete");
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      if (isValid) {
                        bloc.goToNextPage();
                      }
                    },
                    inputFormatters: [
                      WhitelistingTextInputFormatter(RegExp("[0-9]")),
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(),
                      hintText: 'max age in days',
                      errorText: isValid ? null : 'Value Can\'t Be 0',
                    ),
                  ),
                ),
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
