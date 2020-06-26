import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
      appBar: AppBar(
        title: Text('Seleziona POS'),
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          for (int i = 0; i < bloc.merchants.length; i++)
            SliverStickyHeaderBuilder(
              builder: (context, state) => Container(
                color: (state.isPinned ? Colors.blue : Colors.blue[200])
                    .withOpacity(1.0 - state.scrollPercentage),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('M'),
                  ),
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
                    leading: Icon(MdiIcons.storeOutline),
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
