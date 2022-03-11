import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:pos/src/blocs/payment_request/payment_request_bloc.dart';

class NameSelectionPage extends StatefulWidget {
  @override
  _NameSelectionPageState createState() => _NameSelectionPageState();
}

class _NameSelectionPageState extends State<NameSelectionPage> {
  late CreatePaymentRequestBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<CreatePaymentRequestBloc>(context);

    final isValid = bloc.isValidName;
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context)?.translate('request_name') ?? '',
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
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: bloc.nameController,
                    textInputAction: TextInputAction.go,
                    onChanged: (value) {
                      if (isValid != bloc.isValidName) {
                        setState(() {});
                      }
                    },
                    onEditingComplete: () {
//                      logger.i("onEditingComplete");
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      if (isValid) {
                        bloc.goToNextPage();
                      }
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow)),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      errorStyle: TextStyle(color: Colors.yellow),
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(),
                      hintText: AppLocalizations.of(context)
                              ?.translate('What is the request name?') ??
                          '',
                      errorText: isValid
                          ? null
                          : AppLocalizations.of(context)
                                  ?.translate('name_short') ??
                              '',
                    ),
                  )),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AutoSizeText(
                  AppLocalizations.of(context)
                          ?.translate('example_name_request') ??
                      '',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 50.0),
            ],
          ),
        ),
        floatingActionButton: isValid
            ? FloatingActionButton(
                child: const Icon(Icons.arrow_forward_ios),
                onPressed: () => bloc.goToNextPage())
            : null,
      ),
    );
  }
}
