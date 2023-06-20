import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:pos/src/blocs/payment_request/payment_request_bloc.dart';

import '../../back_button_text.dart';

class TypeSelectionPage extends ConsumerStatefulWidget {
  const TypeSelectionPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _TypeSelectionPageState();
}

class _TypeSelectionPageState extends ConsumerState<TypeSelectionPage> {

  @override
  Widget build(BuildContext context) {

    final bloc = ref.watch(createPaymentNotifierProvider);
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
                child: Text('is_a_persistent_request'.tr(),
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
