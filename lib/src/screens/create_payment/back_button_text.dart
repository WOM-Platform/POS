import 'package:flutter/material.dart';

class BackButtonText extends StatelessWidget {
  final Function onTap;

  const BackButtonText({Key key, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20.0),
      height: 50.0,
      alignment: Alignment.topLeft,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          "Back",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
      ),
    );
  }
}