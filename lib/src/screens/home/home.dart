import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/src/screens/create_payment/bloc.dart';
import 'package:pos/src/screens/create_payment/create_payment.dart';
import 'package:pos/src/screens/home/bloc.dart';
import 'package:pos/src/screens/home/home_event.dart';
import 'package:pos/src/screens/home/widgets/home_list.dart';
import 'package:pos/src/screens/home/home_state.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc bloc;
  CreatePaymentRequestBloc _generateWomBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Home build()");
    bloc = BlocProvider.of<HomeBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("HOME"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.update),
              onPressed: () => bloc.dispatch(LoadRequest()))
        ],
      ),
      body: BlocBuilder(
        bloc: bloc,
        builder: (BuildContext context, HomeState state) {
          if (state is RequestLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is RequestLoaded) {
            if(state.requests.isEmpty){
              return Center(
                child: Text("There aren't requests"),
              );
            }
            return HomeList(
              requests: state.requests,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: Key("HomeFab"),
        child: Icon(Icons.add),
        onPressed: () async {
          final provider = BlocProvider(
            child: GenerateWomScreen(),
            bloc: CreatePaymentRequestBloc(draftRequest: null),
          );
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => provider));
          debugPrint("return to the home");
        },
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
