import 'package:easy_localization/easy_localization.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as md;

import 'package:pos/src/offers/application/offers.dart';
import 'package:pos/src/offers/ui/create_new_offer/new_offer.dart';
import 'package:pos/src/offers/ui/offers_screen.dart';
import 'package:pos/src/screens/home/widgets/select_pos_modal.dart';
import 'package:pos/src/screens/settings/settings.dart';
import '../../../main_common.dart';

class HomeScreen extends StatefulHookConsumerWidget {
  static const String routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      if (isFirstOpen) {
        _showTutorial(context);
      }
      // else {
      //   showSelector(context);
      // }
    });
    super.initState();
  }

  showSelector(BuildContext context) {
    md.showMaterialModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder: (context) => PosSelectorWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedPos = ref.watch(selectedPosProvider);

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).primaryColor,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Theme.of(context).primaryColor,
        ),
        title: DescribedFeatureOverlay(
          featureId: 'show_pos_selection_info',
          tapTarget: Text('POS'),
          title: Text('selection_pos_suggestion' 'try_again'.tr()),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          targetColor: Colors.white,
          textColor: Theme.of(context).primaryColor,
          child: GestureDetector(
            onTap: () async {
              md.showMaterialModalBottomSheet(
                context: context,
                useRootNavigator: true,
                builder: (context) => PosSelectorWidget(),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(selectedPos?.pos?.name ?? 'Seleziona POS'),
                  // if (ref.read(homeNotifierProvider.notifier).posSelectionEnabled)
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () async {
              context.push('/${SettingsScreen.path}');
            },
          ),
        ],
      ),
      body: OffersScreen(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: selectedPos != null
          ? FloatingActionButton.extended(
              backgroundColor: Colors.blue,
              heroTag: Key("HomeFab"),
              onPressed: () {
                context.go('/${NewOfferScreen.path}');
              },
              label: Row(
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  Text(
                    'createOffer'.tr(),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            )
          : null,
    );
  }

/*  Future _goToCreatePaymentScreen(
      BuildContext context, PointOfSale? pos) async {
    final posId = pos?.id;
    if (posId == null) return;

    final provider = ProviderScope(
      child: GenerateWomScreen(),
      overrides: [
        createPaymentNotifierProvider.overrideWith((ref) =>
            CreatePaymentRequestBloc(
                ref: ref,
                posId: posId,
                draftRequest: null,
                languageCode:
                   context.locale.languageCode))
      ],
    );
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => provider));
  }

   void _goToSettingsScreen() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => SettingsScreen()));
  }

  void _showLogoutDialog(Function logout) {
    Alert(
      context: context,
      title: 'logout_message'),
      buttons: [
        DialogButton(
          child: Text('No'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        DialogButton(
          child: Text('yes').tr()),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            logout();
          },
        ),
      ],
    ).show();
  }

  Future _clearTutorial(context) async {
    await FeatureDiscovery.clearPreferences(
      context,
      const <String>{
        'show_fab_info',
        'show_pos_selection_info',
        'show_logout_info',
      },
    );
  }*/

  void _showTutorial(BuildContext context) {
    FeatureDiscovery.discoverFeatures(
      context,
      const <String>{
        'show_fab_info',
        'show_pos_selection_info',
        'show_logout_info',
      },
    );
  }
}

class WarningWidget extends StatelessWidget {
  final String text;

  const WarningWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.warning,
                color: Colors.yellow,
                size: 40,
              ),
              Text(
                text,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
