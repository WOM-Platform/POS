import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
//      await setToNotFirstTime();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => RootScreen()));
    }
  }
//
//  setToNotFirstTime() async {
//    await Hive.box('user').put('firstTime', false);
//  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context)
        .textTheme
        .display1
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
          heightImage: 200,
          centerWidget: Icon(
            MdiIcons.tools,
            size: 100,
          ),
          title: "Benvenuto!",
          description: 'WOM POS è lo strumento della piattaforma WOM che ti '
              'consentirà di generare richieste di pagamento in cambio di '
              'beni o servizi!\n',
        ),
        Slide(
          maxLineTitle: 10,
          styleTitle: titleStyle,
          styleDescription: Theme.of(context).textTheme.body1,
          backgroundColor: Colors.white,
          heightImage: 200,
          centerWidget: Icon(
            MdiIcons.tools,
            size: 100,
          ),
          title: 'titolo',
          description: 'desccrizione',
        ),
        Slide(
          maxLineTitle: 10,
          styleTitle: titleStyle,
          styleDescription: Theme.of(context).textTheme.body1,
          backgroundColor: Colors.white,
          heightImage: 200,
          centerWidget: Icon(
            MdiIcons.tools,
            size: 100,
          ),
          title: 'titolo',
          description: 'descrizione',
        ),
        Slide(
          maxLineTitle: 10,
          styleTitle: titleStyle,
          styleDescription: Theme.of(context).textTheme.body1,
          backgroundColor: Colors.white,
          heightImage: 200,
          centerWidget: Icon(
            MdiIcons.tools,
            size: 100,
          ),
          title: 'titolo',
          description: 'descrizione',
        ),
      ],
    );
  }
}
