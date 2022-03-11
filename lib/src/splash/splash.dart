import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
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
