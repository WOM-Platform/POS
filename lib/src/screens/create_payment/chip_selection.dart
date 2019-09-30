//import 'package:flutter/material.dart';
//import 'package:pos/src/screens/create_payment/bloc.dart';
//
//class ChipSelection extends StatefulWidget {
//  final CreatePaymentRequestBloc bloc;
//
//  const ChipSelection({Key key, @required this.bloc}) : super(key: key);
//
//  @override
//  _ChipSelectionState createState() => _ChipSelectionState();
//}
//
//class _ChipSelectionState extends State<ChipSelection> {
//  @override
//  Widget build(BuildContext context) {
//    return Row(
//      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//      children: <Widget>[
//        ChoiceChip(
//          label: Text("Singola"),
//          selected: widget.bloc.persistentRequest,
//          onSelected: (bool value) {
//            setState(() {
////              widget.bloc.requestType = RequestType.SINGLE;
//            });
//          },
//        ),
//        ChoiceChip(
//          label: Text("Multipla"),
//          selected: widget.bloc.persistentRequest,
//          onSelected: (bool value) {
//            setState(() {
////              widget.bloc.requestType = RequestType.MULTIPLE;
//            });
//          },
//        ),
//      ],
//    );
//  }
//}
