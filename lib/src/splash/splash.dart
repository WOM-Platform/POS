import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/src/screens/pos_selection/pos_selection_page.dart';
import 'package:pos/src/splash/bloc.dart';

import '../my_logger.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "POS",
            style: TextStyle(color: Colors.orange, fontSize: 50.0),
          ),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
