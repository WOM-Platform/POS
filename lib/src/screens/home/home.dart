import 'package:clippy_flutter/arc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:pos/src/blocs/home/bloc.dart';
import 'package:pos/src/screens/create_payment/bloc.dart';
import 'package:pos/src/screens/create_payment/create_payment.dart';
import 'package:pos/src/screens/home/widgets/home_list.dart';
import 'package:wom_package/wom_package.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc bloc;
  ScrollController _scrollViewController;

  @override
  void initState() {
    _scrollViewController = ScrollController(keepScrollOffset: false);
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
        title: Text("WOM POS"),
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Alert(
                context: context,
                title: AppLocalizations.of(context).translate('logout_message'),
                buttons: [
                  DialogButton(
                    child: Text(AppLocalizations.of(context).translate('yes')),
                    onPressed: () {
                      authenticationBloc.dispatch(LoggedOut());
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
            }),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                Alert(
                  context: context,
                  title: AppLocalizations.of(context).translate('more_info'),
                  desc: 'www.wom.social',
                  buttons: [
                    DialogButton(
                      child: Text(AppLocalizations.of(context)
                          .translate('go_to_website')),
                      onPressed: () {
                        _launchURL();
                      },
                    )
                  ],
                ).show();
              }),
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
/*          NestedScrollView(
            controller: _scrollViewController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                new SliverAppBar(
                  title: new Text('WOM POS'),
                  centerTitle: true,
                  pinned: true,
                  floating: false,
                  forceElevated: innerBoxIsScrolled,
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.exit_to_app),
                      onPressed: () => authenticationBloc.dispatch(
                        LoggedOut(),
                      ),
                    ),
//                    IconButton(
//                        icon: Icon(Icons.close),
//                        onPressed: () {
//                          AppDatabase.get().closeDatabase();
//                        },),
                  ],
                ),
              ];
            },
            body: BlocBuilder(
              bloc: bloc,
              builder: (BuildContext context, HomeState state) {
                if (state is RequestLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is RequestLoaded) {
                  if (state.requests.isEmpty) {
                    return Center(
                      child: Text(
                          AppLocalizations.of(context).translate('no_request')),
                    );
                  }
                  return HomeList(
                    requests: state.requests,
                  );
                }

                return Container(
                  child: Center(
                      child: Text(AppLocalizations.of(context)
                          .translate('error_screen_state'))),
                );
              },
            ),
          ),*/
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: Key("HomeFab"),
        child: Icon(Icons.add),
        onPressed: () async {
          final provider = BlocProvider(
            child: GenerateWomScreen(),
            builder: (ctx) => CreatePaymentRequestBloc(
                draftRequest: null,
                languageCode: AppLocalizations.of(context).locale.languageCode),
          );
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => provider));
        },
      ),
    );
  }

  _launchURL() async {
    const url = 'https://wom.social';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
