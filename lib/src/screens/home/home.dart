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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => authenticationBloc.dispatch(
              LoggedOut(),
            ),
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

  @override
  void dispose() {
    super.dispose();
  }
}
