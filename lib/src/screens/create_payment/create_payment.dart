import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';


import 'package:pos/src/blocs/payment_request/payment_request_bloc.dart';
import 'package:pos/src/offers/application/offers.dart';
import 'package:pos/src/screens/create_payment/pages/aim_selection/aim_selection_page.dart';
import 'package:pos/src/screens/create_payment/pages/aim_selection/bloc.dart';
import 'package:pos/src/screens/create_payment/pages/name_selection/name_selection.dart';
import 'package:pos/src/screens/create_payment/pages/position_selection/position_selection_page.dart';
import 'package:pos/src/screens/create_payment/pages/amount_selection/amount_selection_page.dart';

import 'pages/age_selection/age_selection_page.dart';
import 'pages/type_selection/type_selection.dart';

class GenerateWomScreen extends ConsumerStatefulWidget {
  @override
  _GenerateWomScreenState createState() => _GenerateWomScreenState();
}

class _GenerateWomScreenState extends ConsumerState<GenerateWomScreen> {
  int page = 0;

  Future<bool> onWillPop() {
    if (ref.read(createPaymentNotifierProvider).pageController.page?.round() ==
        ref.read(createPaymentNotifierProvider).pageController.initialPage) {
      return Future.value(true);
    }
    ref.read(createPaymentNotifierProvider).goToPreviousPage();
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(aimSelectionNotifierProvider, (previous, next) {});
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              PageView(
                controller:
                    ref.watch(createPaymentNotifierProvider).pageController,
                physics: new NeverScrollableScrollPhysics(),
                children: <Widget>[
                  NameSelectionPage(),
                  TypeSelectionPage(),
                  AmountSelectionPage(),
                  AimSelectionPage(),
                  MaxAgeSelectionPage(),
                  PositionSelectionPage(),
                ],
              ),
              Positioned(
                top: 0.0,
                right: 0.0,
                child: IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (ref
                            .read(createPaymentNotifierProvider)
                            .pageController
                            .page
                            ?.round() !=
                        0) {
                      showAlert(context);
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  showAlert(
    BuildContext context,
  ) async {
    bool result = await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('save_draft_request_title_popup'.tr()),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            ElevatedButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
            ),
            ElevatedButton(
              child: Text('yes').tr(),
              onPressed: () {
                Navigator.of(ctx).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (result) {
      await ref.read(createPaymentNotifierProvider).saveDraftRequest();
      ref.invalidate(requestNotifierProvider);
    }
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    // ref.read(createPaymentNotifierProvider).close();
    super.dispose();
  }
}
