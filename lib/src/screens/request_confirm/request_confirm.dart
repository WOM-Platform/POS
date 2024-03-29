import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:pos/src/blocs/payment_request/payment_request_bloc.dart';
import 'package:pos/src/model/payment_request.dart';
import 'package:pos/src/offers/application/offers.dart';
import 'package:pos/src/screens/request_confirm/bloc.dart';
import 'package:pos/src/screens/request_confirm/summary_request.dart';
import 'package:pos/src/screens/request_confirm/wom_creation_event.dart';
import 'package:pos/src/screens/request_confirm/wom_creation_state.dart';

class RequestConfirmScreen extends ConsumerStatefulWidget {
  // final PaymentRequest paymentRequest;

  const RequestConfirmScreen({
    Key? key,
    // required this.paymentRequest,
  }) : super(key: key);

  @override
  _RequestConfirmScreenState createState() => _RequestConfirmScreenState();
}

class _RequestConfirmScreenState extends ConsumerState<RequestConfirmScreen> {
  // late RequestConfirmBloc bloc;
  // late HomeBloc homeBloc;

  bool isComplete = false;
  bool isWrong = false;
  bool noDataConnection = false;

  // @override
  // void initState() {
  //   bloc = RequestConfirmBloc(
  //     pos: context.read<PosClient>(),
  //     pointOfSale: context.read<HomeBloc>().selectedPos,
  //     paymentRequest: widget.paymentRequest,
  //   );
  //   super.initState();
  // }

  Future<bool> onWillPop() {
    if (isComplete || isWrong || noDataConnection) {
      ref.invalidate(requestNotifierProvider);
      return Future.value(true);
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    // final bloc = context.read<RequestConfirmBloc>();
    // final homeBloc = ref.watch(homeNotifierProvider);

    final paymentRequest = ref.watch(paymentRequestProvider);
    final state = ref.watch(requestConfirmNotifierProvider);
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(paymentRequest.name),
          centerTitle: true,
          elevation: 0.0,
//          actions: <Widget>[
//            Text("${bloc.paymentRequest.id}"),
//          ],
        ),
        body: Builder(
          builder: (c) {
            if (state is WomCreationRequestEmpty) {
              return Center(
                child: Text('starting_creation_request' 'try_again'.tr()),
              );
            } else if (state is WomCreationRequestLoading) {
              isWrong = false;
              isComplete = false;
              noDataConnection = false;
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WomCreationRequestError) {
              isWrong = true;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      state.error ?? 'somethings_wrong'.tr(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Center(
                    child: FloatingActionButton.extended(
                      onPressed: () => ref
                          .read(requestConfirmNotifierProvider.notifier)
                          .createWomRequest(CreateWomRequest()),
                      label: Text(
                        'try_again'.tr(),
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is WomCreationRequestNoDataConnectionState) {
              noDataConnection = true;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'no_connection_title'.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      'no_connection_transaction_desc'.tr(),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FloatingActionButton.extended(
                        label: Text('try_again'.tr()),
                        onPressed: () {
                          ref
                              .read(requestConfirmNotifierProvider.notifier)
                              .createWomRequest(CreateWomRequest());
                        }),
                  ],
                ),
              );
            } else if (state is WomVerifyCreationRequestComplete) {
              isComplete = true;
              return SummaryRequest(
                paymentRequest: ref.read(paymentRequestProvider),
              );
            }

            return Center(child: Text('error_screen_state'.tr()));
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    ref.invalidate(requestNotifierProvider);
    // bloc.close();
    super.dispose();
  }
}
