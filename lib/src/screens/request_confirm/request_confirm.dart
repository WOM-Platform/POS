import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/src/blocs/home/bloc.dart';
import 'package:pos/src/model/payment_request.dart';
import 'package:pos/src/screens/request_confirm/bloc.dart';
import 'package:pos/src/screens/request_confirm/summary_request.dart';
import 'package:pos/src/screens/request_confirm/wom_creation_event.dart';
import 'package:pos/src/screens/request_confirm/wom_creation_state.dart';

class RequestConfirmScreen extends StatefulWidget {
  final PaymentRequest paymentRequest;

  const RequestConfirmScreen({Key key, this.paymentRequest}) : super(key: key);

  @override
  _RequestConfirmScreenState createState() => _RequestConfirmScreenState();
}

class _RequestConfirmScreenState extends State<RequestConfirmScreen> {
  RequestConfirmBloc bloc;
  HomeBloc homeBloc;

  bool isComplete = false;

  @override
  void initState() {
    bloc = RequestConfirmBloc(paymentRequest: widget.paymentRequest);
    super.initState();
  }

  Future<bool> onWillPop() {
    if (isComplete) {
      return Future.value(true);
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    homeBloc = BlocProvider.of<HomeBloc>(context);

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(title: Text(bloc.paymentRequest.name),),
        body: BlocBuilder(
          bloc: bloc,
          builder: (_, WomCreationState state) {
            if (state is WomCreationRequestEmpty) {
              return Center(
                child: Text("Starting Creation Request"),
              );
            }

            if (state is WomCreationRequestLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is WomCreationRequestError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(state.error),
                  OutlineButton(
                      child: Text('RIPROVA!'),
                      onPressed: (){
                    bloc.dispatch(CreateWomRequest());
                  })
                ],
              );
            }

            if (state is WomVerifyCreationRequestComplete) {
              isComplete = true;
              return SummaryRequest(
                paymentRequest: bloc.paymentRequest,
              );
            }

            return Center(child: Text("ERROR SCREEN STATE"));
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    homeBloc.dispatch(LoadRequest());
    bloc.dispose();
    super.dispose();
  }
}
