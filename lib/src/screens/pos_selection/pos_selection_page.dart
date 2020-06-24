import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:pos/src/blocs/home/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PosSelectionPage extends StatefulWidget {
  static const String routeName = '/pos_selection';
  @override
  _PosSelectionPageState createState() => _PosSelectionPageState();
}

class _PosSelectionPageState extends State<PosSelectionPage> {
  HomeBloc bloc;
  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<HomeBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Seleziona POS')),
      body: CustomScrollView(
        slivers: <Widget>[
          for (int i = 0; i < bloc.merchants.length; i++)
            SliverStickyHeaderBuilder(
              builder: (context, state) => Container(
                height: 60.0,
                color: (state.isPinned ? Colors.pink : Colors.lightBlue)
                    .withOpacity(1.0 - state.scrollPercentage),
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  bloc.merchants[i].name,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ListTile(
                    title: Text(bloc.merchants[i].posList[index].name),
                    onTap: () {
                      BlocProvider.of<HomeBloc>(context).selectedMerchantId =
                          bloc.merchants[i].id;
                      BlocProvider.of<HomeBloc>(context).selectedPosId =
                          bloc.merchants[i].posList[index].id;
                      Navigator.of(context).pushReplacementNamed('/home');
                    },
                  ),
                  childCount: bloc.merchants[i].posList.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
