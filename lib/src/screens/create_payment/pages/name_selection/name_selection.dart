import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:pos/src/blocs/payment_request/payment_request_bloc.dart';

class NameSelectionPage extends ConsumerStatefulWidget {
  @override
  _NameSelectionPageState createState() => _NameSelectionPageState();
}

class _NameSelectionPageState extends ConsumerState<NameSelectionPage> {

  @override
  Widget build(BuildContext context) {
   final bloc = ref.watch(createPaymentNotifierProvider);

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
                  'request_name'.tr(),
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
                    maxLength: 65,
                    maxLines: 2,
                    minLines: 1,
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
                      counterStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow)),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      errorStyle: TextStyle(color: Colors.yellow),
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(),
                      hintText:'What is the request name?'.tr(),
                      errorText: isValid
                          ? null
                          : 'name_short'.tr(),
                    ),
                  )),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AutoSizeText('example_name_request'.tr(),
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
