import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pos/custom_icons.dart';
import '../../constants.dart';
import '../../utils.dart';
import '../root/root.dart';

class IntroScreen extends StatefulWidget {
  final bool fromSettings;

  IntroScreen({Key? key, this.fromSettings = false}) : super(key: key);

  @override
  IntroScreenState createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = <Slide>[];

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
        .subtitle1
        ?.copyWith(color: Theme.of(context).primaryColor);
    return IntroSlider(
      colorActiveDot: Theme.of(context).primaryColor,
      doneButtonStyle: TextButton.styleFrom(
        textStyle: Theme.of(context)
            .textTheme
            .headline6
            ?.copyWith(fontSize: 16, color: Theme.of(context).primaryColor),
      ),
      skipButtonStyle: TextButton.styleFrom(
        textStyle: Theme.of(context)
            .textTheme
            .headline6
            ?.copyWith(fontSize: 16, color: Theme.of(context).primaryColor),
      ),
      prevButtonStyle: TextButton.styleFrom(
        textStyle: Theme.of(context)
            .textTheme
            .headline6
            ?.copyWith(fontSize: 16, color: Theme.of(context).primaryColor),
      ),
      onDonePress: this.onDonePress,

      slides: [
        Slide(
          maxLineTitle: 10,
          styleTitle: titleStyle,
          styleDescription: Theme.of(context).textTheme.bodyText1,
          backgroundColor: Colors.white,
          heightImage: 150,
          centerWidget: Icon(
            MdiIcons.tools,
            size: 100,
          ),
          title: 'welcome'.tr(),
          description: 'welcome_desc'.tr(),
        ),
        Slide(
          maxLineTitle: 10,
          styleTitle: titleStyle,
          styleDescription: Theme.of(context).textTheme.bodyText1,
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
                'merchant_desc'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(height: 16),
              FloatingActionButton.extended(
                onPressed: () {
                  launchUrl('https://$domain/user/register-merchant');
                },
                label: Text(
                  'sign_up'.tr(),
                ),
              )
            ],
          ),
        ),
        Slide(
          maxLineTitle: 10,
          styleTitle: titleStyle,
          styleDescription: Theme.of(context).textTheme.bodyText1,
          backgroundColor: Colors.white,
          heightImage: 150,
          pathImage: "assets/slide4.png",
          title: 'wom'.tr(),
          description: 'wom_desc'.tr(),
        ),
        Slide(
          maxLineTitle: 10,
          styleTitle: titleStyle,
          styleDescription: Theme.of(context).textTheme.bodyText1,
          backgroundColor: Colors.white,
          heightImage: 150,
          centerWidget: Icon(
            MdiIcons.piggyBank,
            size: 100,
          ),
          title: 'wom_suggestion'.tr(),
          description: 'wom_suggestion_desc'.tr(),
        ),
      ],
    );
  }
}
