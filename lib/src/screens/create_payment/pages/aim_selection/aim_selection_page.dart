import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:pos/src/blocs/payment_request/payment_request_bloc.dart';
import 'package:pos/src/screens/create_payment/pages/aim_selection/bloc.dart';

import 'package:pos/src/screens/create_payment/pages/aim_selection/select_aim.dart';

import '../../back_button_text.dart';

class AimSelectionPage extends ConsumerStatefulWidget {
  @override
  _AimSelectionPageState createState() => _AimSelectionPageState();
}

class _AimSelectionPageState extends ConsumerState<AimSelectionPage> {
  late CreatePaymentRequestBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = ref.watch(createPaymentNotifierProvider);
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'what_aim'.tr(),
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
                      value: ref.watch(aimSelectionNotifierProvider).aimEnabled,
                      onChanged: (value) {
                        setState(
                          () {
                            ref.read(aimSelectionNotifierProvider.notifier).toggle();
                          },
                        );
                      },
                    ),
                  ],
                ),
                SelectAim(
                  // bloc: bloc.aimSelectionBloc,
                  updateState: () {
                    if (isValid != bloc.isValidAim) setState(() {});
                  },
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'aim_suggestion'.tr(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'aim_warning'.tr(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const Spacer(),
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
