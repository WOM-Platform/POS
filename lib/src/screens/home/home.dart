import 'package:clippy_flutter/arc.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:pos/src/blocs/home/bloc.dart';
import 'package:pos/src/screens/create_payment/bloc.dart';
import 'package:pos/src/screens/create_payment/create_payment.dart';
import 'package:pos/src/screens/home/widgets/home_list.dart';
import 'package:pos/src/screens/settings/settings.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:wom_package/wom_package.dart';
import '../../../main_common.dart';
import '../../utils.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc bloc;

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
    print("Home build()");
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).primaryColor,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Theme.of(context).primaryColor,
      ),
    );
    bloc = BlocProvider.of<HomeBloc>(context);

    final AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: bloc.myPos.isNotEmpty
            ? StatefulBuilder(
                builder: (BuildContext context,
                    void Function(void Function()) setWidgetState) {
                  return DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: bloc.posSelected,
                      items: <DropdownMenuItem<int>>[
                        for (int i = 0; i < bloc.myPos.length; i++)
                          DropdownMenuItem(
                            child: Text(
                              bloc.myPos[i].name,
                              style: TextStyle(color: Colors.white),
                            ),
                            value: i,
                          ),
                      ],
                      onChanged: (int value) {
                        setWidgetState(() => bloc.posSelected = value);
                      },
                    ),
                  );
                },
              )
            : Text('No POS'),
        centerTitle: true,
        elevation: 0.0,
        leading: DescribedFeatureOverlay(
          featureId: 'show_logout_info',
          // Unique id that identifies this overlay.
          tapTarget: const Icon(Icons.exit_to_app),
          // The widget that will be displayed as the tap target.
          title: Text('Da qui potrai effettuare il logout'),
          backgroundColor: Theme.of(context).accentColor,
          targetColor: Colors.white,
          textColor: Theme.of(context).primaryColor,
          child: IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              _showLogoutDialog(() {
                authenticationBloc.dispatch(LoggedOut());
              });
            },
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              _clearTutorial(context);
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
          BlocBuilder(
            bloc: bloc,
            builder: (BuildContext context, HomeState state) {
              if (state is RequestLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is RequestLoaded) {
                if (state.requests.isEmpty) {
                  return Center(
                    child: Text(
                        AppLocalizations.of(context).translate('no_request')),
                  );
                }
                return HomeList(
                  requests: state.requests,
                );
              } else if (state is RequestsLoadingErrorState) {
                return Center(
                  child: Text(
                    AppLocalizations.of(context).translate(state.error),
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (state is NoPosState) {
                return Column(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context).translate('no_pos_alert'),
                      textAlign: TextAlign.center,
                    ),
                    RaisedButton(
                        child: Text(AppLocalizations.of(context)
                            .translate('go_to_website')),
                        onPressed: () {
                          launchUrl('https://wom.social');
                        }),
                  ],
                );
              } else if (state is NoDataConnectionState) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context)
                            .translate('no_connection_title'),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)
                            .translate('no_connection_aim_desc'),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                          child: Text(AppLocalizations.of(context)
                              .translate('try_again')),
                          onPressed: () {
                            bloc.dispatch(LoadRequest());
                          }),
                    ],
                  ),
                );
              }

              return Container(
                child: Center(
                    child: Text(AppLocalizations.of(context)
                        .translate('error_screen_state'))),
              );
            },
          ),
        ],
      ),
      floatingActionButton: DescribedFeatureOverlay(
        featureId: 'show_fab_info',
        // Unique id that identifies this overlay.
        tapTarget: const Icon(Icons.add),
        // The widget that will be displayed as the tap target.
        title: Text('Genera una richiesta di pagamento'),
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

  @override
  void dispose() {
    super.dispose();
  }

  Future _goToCreatePaymentScreen(context) async {
    final provider = BlocProvider(
      child: GenerateWomScreen(),
      builder: (ctx) => CreatePaymentRequestBloc(
          posId: bloc.selectedPosId,
          draftRequest: null,
          languageCode: AppLocalizations.of(context).locale.languageCode),
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
      title: AppLocalizations.of(context).translate('logout_message'),
      buttons: [
        DialogButton(
          child: Text(AppLocalizations.of(context).translate('yes')),
          onPressed: () {
            Navigator.of(context).pop();
            logout();
          },
        ),
        DialogButton(
          child: Text('No'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    ).show();
  }

  Future _clearTutorial(context) async {
    await FeatureDiscovery.clearPreferences(
      context,
      const <String>{
        'show_fab_info',
        'show_logout_info',
      },
    );
  }

  void _showTutorial(BuildContext context) {
    FeatureDiscovery.discoverFeatures(
      context,
      const <String>{
        'show_fab_info',
        'show_logout_info',
      },
    );
  }
}
