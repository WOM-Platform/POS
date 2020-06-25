import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:pos/src/blocs/home/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/src/screens/home/home.dart';

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
                color: (state.isPinned ? Colors.pink : Colors.lightBlue)
                    .withOpacity(1.0 - state.scrollPercentage),
                alignment: Alignment.centerLeft,
                child: ListTile(
                  leading: CircleAvatar(),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        bloc.merchants[i].name,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 30),
                      ),
                      Text(
                        bloc.merchants[i].address,
                      ),
                      Text(
                        '${bloc.merchants[i].cap} - ${bloc.merchants[i].city}',
                      ),
                      Text(bloc.merchants[i].vatNumber),
                    ],
                  ),
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
                      Navigator.of(context).pop();
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
