import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:pos/src/blocs/payment_request/payment_request_bloc.dart';

import '../../back_button_text.dart';

class MaxAgeSelectionPage extends ConsumerStatefulWidget {
  const MaxAgeSelectionPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _MaxAgeSelectionPageState();
}

class _MaxAgeSelectionPageState extends ConsumerState<MaxAgeSelectionPage> {

  @override
  Widget build(BuildContext contex) {
    final bloc = ref.watch(createPaymentNotifierProvider);
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
                    'how_recent_wom'.tr(),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'enable_disable_filter'.tr(),
                      style: TextStyle(color: Colors.white),
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
                  ],
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
//                      logger.i("onEditingComplete");
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      if (isValid) {
                        bloc.goToNextPage();
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    ],
                    keyboardType: TextInputType.number,
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
                      hintText:'how_many_days'.tr(),
                      errorText: isValid
                          ? null
                          : 'insert_value_grather'.tr(),
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
              ? FloatingActionButton(
                  child: Icon(Icons.arrow_forward_ios),
                  onPressed: () => bloc.goToNextPage())
              : null,
        ),
      ),
    );
  }
}
