import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pos/custom_icons.dart';
import 'package:pos/localization/app_localizations.dart';

import '../../constants.dart';
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
          title: AppLocalizations.of(context).translate('welcome'),
          description: AppLocalizations.of(context).translate('welcome_desc'),
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
                AppLocalizations.of(context).translate('merchant_desc'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.body1,
              ),
              SizedBox(height: 16),
              FloatingActionButton.extended(
                  onPressed: () {
                    launchUrl('https://$domain/user/register-merchant');
                  },
                  label:
                      Text(AppLocalizations.of(context).translate('sign_up')))
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
          title: AppLocalizations.of(context).translate('wom'),
          description: AppLocalizations.of(context).translate('wom_desc'),
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
          title: AppLocalizations.of(context).translate('wom_suggestion'),
          description:
              AppLocalizations.of(context).translate('wom_suggestion_desc'),
        ),
      ],
    );
  }
}
