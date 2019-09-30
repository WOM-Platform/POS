import 'package:flutter/material.dart';
import 'package:pos/localization/app_localizations.dart';

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
          AppLocalizations.of(context).translate('back'),
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
      ),
    );
  }
}
