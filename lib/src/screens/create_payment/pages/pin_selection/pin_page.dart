import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/src/screens/create_payment/bloc.dart';
import 'package:pos/src/screens/request_confirm/request_confirm.dart';
import 'package:pos/src/utils.dart';

class Page4 extends StatefulWidget {
  @override
  _Page4State createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  CreatePaymentRequestBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<CreatePaymentRequestBloc>(context);
    final isValid = bloc.isValidPassword;
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
                  "Digita il PIN di sicurezza ",
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
                  controller: bloc.passwordController,
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {
                    if (isValid != bloc.isValidPassword) {
                      setState(() {});
                    }
                  },
                  onEditingComplete: () {
                    print("onEditingComplete");
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    if (isValid) {
                      goToRequestScreen();
                    }
                  },
                  inputFormatters: [
                    WhitelistingTextInputFormatter(RegExp("[0-9]")),
                  ],
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelStyle: TextStyle(color: Colors.white),
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(),
                    hintText: 'PIN',
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  lorem,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Spacer(),
              Container(
                margin: const EdgeInsets.only(left: 20.0),
                height: 50.0,
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => bloc.goToPreviousPage(),
                  child: Text(
                    "Back",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: isValid
            ? FloatingActionButton(
                heroTag: Key("pinHero"),
                onPressed: () {
                  goToRequestScreen();
                },
              )
            : null,
      ),
    );
  }

  goToRequestScreen() async {
    final womRequest = await bloc.createModelForCreationRequest();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => RequestConfirmScreen(
          paymentRequest: womRequest,
        ),
      ),
    );
  }
}
