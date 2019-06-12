import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/src/screens/create_payment/bloc.dart';
import 'package:pos/src/utils.dart';

class NameSelectionPage extends StatefulWidget {
  @override
  _NameSelectionPageState createState() => _NameSelectionPageState();
}

class _NameSelectionPageState extends State<NameSelectionPage> {
  CreatePaymentRequestBloc bloc;

  @override
  Widget build(BuildContext context) {
    print("NameSelectionPage build");
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
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Inserisci il nome da assegnare alla richiesta di pagamento",
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
                      print("onEditingComplete");
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      if (isValid) {
                        bloc.goToNextPage();
                      }
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(),
                      hintText: 'What is the name of request?',
                      errorText: isValid ? null : 'Value Can\'t Be Empty',
                    ),
                  )),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Ad Esempio: \n\n- Sconto 10% generico\n\n- Sconto 10% Universitario\n\n- Sconto 20% SmartRoadSense",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
            ],
          ),
        ),
        floatingActionButton: isValid
            ? FloatingActionButton(child:Icon(Icons.arrow_forward_ios),onPressed: () => bloc.goToNextPage())
            : null,
      ),
    );
  }
}
