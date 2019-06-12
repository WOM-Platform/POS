import 'package:flutter/material.dart';

class ButtonCard extends StatelessWidget {
  final String text;
  final Function onTap;

  const ButtonCard({Key key, this.text, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15.0),
          child: Text(text),
        ),
      ),
    );
  }
}