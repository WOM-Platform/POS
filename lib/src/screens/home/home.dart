import 'package:clippy_flutter/arc.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:pos/src/blocs/home/bloc.dart';
import 'package:pos/src/blocs/payment_request/payment_request_bloc.dart';
import 'package:pos/src/screens/create_payment/create_payment.dart';
import 'package:pos/src/screens/home/widgets/home_list.dart';
import 'package:pos/src/screens/pos_selection/pos_selection_page.dart';
import 'package:pos/src/screens/settings/settings.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../../main_common.dart';
import '../../utils.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      if (isFirstOpen) {
        _showTutorial(context);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).primaryColor,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Theme.of(context).primaryColor,
      ),
    );

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: DescribedFeatureOverlay(
          featureId: 'show_pos_selection_info',
          tapTarget: Text('POS'),
          title: Text(AppLocalizations.of(context)
                  ?.translate('selection_pos_suggestion') ??
              ''),
          backgroundColor: Theme.of(context).accentColor,
          targetColor: Colors.white,
          textColor: Theme.of(context).primaryColor,
          child: GestureDetector(
            onTap: () async {
              if (context.read<HomeBloc>().posSelectionEnabled) {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PosSelectionPage(),
                  ),
                );
                setState(() {});
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(context.read<HomeBloc>().selectedPos?.name ?? 'Seleziona POS'),
                if (context.read<HomeBloc>().posSelectionEnabled)
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  ),
              ],
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () async {
              await _clearTutorial(context);
              _showTutorial(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              _goToSettingsScreen();
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Arc(
              child: Container(
                color: Theme.of(context).primaryColor,
                height: MediaQuery.of(context).size.height / 2 - 50,
              ),
              height: 50,
            ),
          ),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (BuildContext context, HomeState state) {
              if (state is NoPosState) {
                return Center(
                  child: WarningWidget(
                    text:
                        AppLocalizations.of(context)?.translate('no_pos') ?? '',
                  ),
                );
              } else if (state is NoMerchantState) {
                return Center(
                  child: WarningWidget(
                    text: AppLocalizations.of(context)
                            ?.translate('no_merchants') ??
                        '',
                  ),
                );
              } else if (state is RequestLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is RequestLoaded) {
                if (state.requests.isEmpty) {
                  return Center(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppLocalizations.of(context)
                                  ?.translate('no_request') ??
                              '',
                          style: const TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }
                return HomeList(
                  requests: state.requests,
                );
              } else if (state is RequestsLoadingErrorState) {
                return Center(
                  child: Text(
                    AppLocalizations.of(context)?.translate(state.error) ?? '',
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (state is NoDataConnectionState) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context)
                                ?.translate('no_connection_title') ??
                            '',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)
                                ?.translate('no_connection_aim_desc') ??
                            '',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FloatingActionButton.extended(
                          label: Text(AppLocalizations.of(context)
                                  ?.translate('try_again') ??
                              ''),
                          onPressed: () {
                            context.read<HomeBloc>().loadRequest();
                          }),
                    ],
                  ),
                );
              }

              return Center(
                  child: Text(AppLocalizations.of(context)
                          ?.translate('error_screen_state') ??
                      ''));
            },
          ),
        ],
      ),
      floatingActionButton: DescribedFeatureOverlay(
        featureId: 'show_fab_info',
        tapTarget: const Icon(Icons.add),
        title:
            Text(AppLocalizations.of(context)?.translate('create_offer') ?? ''),
        description: Text(''),
        backgroundColor: Theme.of(context).accentColor,
        targetColor: Colors.white,
        textColor: Theme.of(context).primaryColor,
        child: FloatingActionButton(
          heroTag: Key("HomeFab"),
          child: Icon(Icons.add),
          onPressed: () async {
            await _goToCreatePaymentScreen(context);
          },
        ),
      ),
    );
  }

  Future _goToCreatePaymentScreen(BuildContext context) async {
    final posId = context.read<HomeBloc>().selectedPos?.id;
    if (posId == null) return;

    final provider = BlocProvider(
      child: GenerateWomScreen(),
      create: (ctx) => CreatePaymentRequestBloc(
          posId: posId,
          draftRequest: null,
          languageCode: AppLocalizations.of(context)?.locale.languageCode),
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
      title: AppLocalizations.of(context)?.translate('logout_message'),
      buttons: [
        DialogButton(
          child: Text('No'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        DialogButton(
          child: Text(AppLocalizations.of(context)?.translate('yes') ?? ''),
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
  }

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
