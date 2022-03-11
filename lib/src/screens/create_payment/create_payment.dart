import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:pos/src/blocs/home/bloc.dart';
import 'package:pos/src/blocs/payment_request/payment_request_bloc.dart';
import 'package:pos/src/screens/create_payment/pages/aim_selection/aim_selection_page.dart';
import 'package:pos/src/screens/create_payment/pages/name_selection/name_selection.dart';
import 'package:pos/src/screens/create_payment/pages/position_selection/position_selection_page.dart';
import 'package:pos/src/screens/create_payment/pages/amount_selection/amount_selection_page.dart';

import 'pages/age_selection/age_selection_page.dart';
import 'pages/type_selection/type_selection.dart';

class GenerateWomScreen extends StatefulWidget {
  @override
  _GenerateWomScreenState createState() => _GenerateWomScreenState();
}

class _GenerateWomScreenState extends State<GenerateWomScreen> {
  int page = 0;
  late CreatePaymentRequestBloc bloc;
  late HomeBloc homeBloc;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> onWillPop() {
    if (bloc.pageController.page?.round() == bloc.pageController.initialPage) {
      return Future.value(true);
    }
    bloc.goToPreviousPage();
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<CreatePaymentRequestBloc>(context);
    homeBloc = BlocProvider.of<HomeBloc>(context);
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              PageView(
                controller: bloc.pageController,
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
                    if (bloc.pageController.page?.round() != 0) {
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

  showAlert(BuildContext context) async {
    bool result = await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: new Text(AppLocalizations.of(context)
              ?.translate('save_draft_request_title_popup') ?? ''),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
            ),
            new FlatButton(
              child: new Text(AppLocalizations.of(context)?.translate('yes') ?? ''),
              onPressed: () {
                Navigator.of(ctx).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (result) {
      await bloc.saveDraftRequest();
      homeBloc.loadRequest();
    }
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }
}
