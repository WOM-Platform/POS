import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pos/custom_icons.dart';

import '../../utils.dart';
import '../root/root.dart';

class IntroScreen extends StatefulWidget {
  final bool fromSettings;

  IntroScreen({Key key, this.fromSettings = false}) : super(key: key);

  @override
  IntroScreenState createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = List();

  @override
  void initState() {
    super.initState();
  }

  void onDonePress() async {
    if (widget.fromSettings) {
      Navigator.of(context).pop();
    } else {
      await setToNotFirstTime();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => RootScreen()));
    }
  }

  setToNotFirstTime() async {
    await setIsFirstOpen(false);
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context)
        .textTheme
        .title
        .copyWith(color: Theme.of(context).primaryColor);
    return IntroSlider(
      colorActiveDot: Theme.of(context).primaryColor,
      styleNameDoneBtn: Theme.of(context)
          .textTheme
          .headline
          .copyWith(fontSize: 16, color: Theme.of(context).primaryColor),
      styleNameSkipBtn: Theme.of(context)
          .textTheme
          .headline
          .copyWith(fontSize: 16, color: Theme.of(context).primaryColor),
      styleNamePrevBtn: Theme.of(context)
          .textTheme
          .headline
          .copyWith(fontSize: 16, color: Theme.of(context).primaryColor),
      onDonePress: this.onDonePress,
      slides: [
        Slide(
          maxLineTitle: 10,
          styleTitle: titleStyle,
          styleDescription: Theme.of(context).textTheme.body1,
          backgroundColor: Colors.white,
          heightImage: 150,
          centerWidget: Icon(
            MdiIcons.tools,
            size: 100,
          ),
          title: "Benvenuto!",
          description:
              'Con questo strumento puoi impostare sconti e agevolazioni '
              'che intendi offrire a chi ha compiuto azioni socialmente utili.',
        ),
        Slide(
          maxLineTitle: 10,
          styleTitle: titleStyle,
          styleDescription: Theme.of(context).textTheme.body1,
          backgroundColor: Colors.white,
          heightImage: 150,
          centerWidget: Icon(
            CustomIcons.merchant_logo,
            size: 100,
          ),
          title: "Merchant!",
          widgetDescription: Column(
            children: <Widget>[
              Text(
                'Per poter generare offerte devi essere registrato come merchant.\n'
                'Se non l\'hai già fatto, registrati ora!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.body1,
              ),
              SizedBox(height: 16),
              FloatingActionButton.extended(
                  onPressed: () {
                    launchUrl('https://wom.social/user/register-merchant');
                  },
                  label: Text('Registrati'))
            ],
          ),
        ),
        Slide(
          maxLineTitle: 10,
          styleTitle: titleStyle,
          styleDescription: Theme.of(context).textTheme.body1,
          backgroundColor: Colors.white,
          heightImage: 150,
          pathImage: "assets/slide4.png",
          title: "Voucher per impegno sociale",
          description:
              "Molte delle azioni individuali generano valore sociale. "
              "Tale valore è quantificato in termini di WOM, speciali voucher inclusi "
              "tra gli strumenti di innovazione sociale digitale della "
              "Commissione Europea.\n",
        ),
        Slide(
          maxLineTitle: 10,
          styleTitle: titleStyle,
          styleDescription: Theme.of(context).textTheme.body1,
          backgroundColor: Colors.white,
          heightImage: 150,
          centerWidget: Icon(
            MdiIcons.piggyBank,
            size: 100,
          ),
          title: 'Dà valore ai WOM',
          description:
              'Sapendo che ogni WOM corrisponde a un minuto di impegno, '
              'decidi liberamente quanti WOM servono per meritare le tue offerte.',
        ),
      ],
    );
  }
}
