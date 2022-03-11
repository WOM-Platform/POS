import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:pos/src/blocs/home/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class PosSelectionPage extends StatefulWidget {
  static const String routeName = '/pos_selection';

  @override
  _PosSelectionPageState createState() => _PosSelectionPageState();
}

class _PosSelectionPageState extends State<PosSelectionPage> {
  late HomeBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<HomeBloc>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(AppLocalizations.of(context)?.translate('select_pos') ?? ''),
        elevation: 0,
      ),
      bottomSheet: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.fromLTRB(
            16, 16, 16, MediaQuery.of(context).padding.bottom + 8),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey,
              ),
              children: <InlineSpan>[
                TextSpan(
                  text:
                      'Per aggiungere o modificare i tuoi POS, collegati alla dashboard web: ',
                ),
                TextSpan(
                  text: 'wom.social',
                  style:TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey,
                    decoration: TextDecoration.underline
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      const url = 'https://wom.social';
                      if (await canLaunch(url)) {
                        launch(url);
                      }
                    },
                ),
              ]),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          for (int i = 0; i < bloc.merchants.length; i++)
            SliverStickyHeader.builder(
              builder: (context, state) => Container(
//                padding: EdgeInsets.all(4.0),
                color:
                    Colors.blue[200]?.withOpacity(1.0 - state.scrollPercentage),
                /*  child: ListTile(
                  leading: CircleAvatar(
                    child: Text('M'),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        bloc.merchants[i].name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        bloc.merchants[i].address,
                      ),
                      Text(
                        '${bloc.merchants[i].zipCode} - ${bloc.merchants[i].city}',
                      ),
                      Text(bloc.merchants[i].fiscalCode),
                      const SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                ),*/
                child: Row(
                  children: <Widget>[
                    const SizedBox(width: 16),
                    Text(
                      bloc.merchants[i].name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                        icon: const Icon(Icons.info),
                        color: Colors.white,
                        onPressed: () {
                          Alert(
                              context: context,
                              style: const AlertStyle(isCloseButton: false),
                              title: bloc.merchants[i].name,
                              content: Column(
                                children: <Widget>[
                                  Text(
                                    bloc.merchants[i].address,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    '${bloc.merchants[i].zipCode} - ${bloc.merchants[i].city}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    bloc.merchants[i].fiscalCode,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                ],
                              ),
                              buttons: [
                                DialogButton(
                                  color: Colors.grey[200],
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Chiudi'),
                                ),
                              ]).show();
                        }),
                  ],
                ),
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (bloc.merchants[i].posList.isEmpty) {
                      return ListTile(
                        tileColor: Colors.white,
                        title: const Text(
                          'Nessun POS',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                        onTap: () {
                          context.read<HomeBloc>().setMerchantAndPosId(
                              bloc.merchants[i].id,
                              bloc.merchants[i].posList[index].id);
                          Navigator.of(context).pop();
                        },
                      );
                    }
                    return ListTile(
                      leading: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          child: const Icon(MdiIcons.storeOutline)),
                      trailing: bloc.selectedPos?.id ==
                              bloc.merchants[i].posList[index].id
                          ? const Chip(
                              backgroundColor: Colors.green,
                              label: Text(
                                'Selezionato',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : const Icon(Icons.arrow_right),
                      title: Text(bloc.merchants[i].posList[index].name),
                      onTap: () {
                        context.read<HomeBloc>().setMerchantAndPosId(
                            bloc.merchants[i].id,
                            bloc.merchants[i].posList[index].id);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                  childCount: bloc.merchants[i].posList.isEmpty
                      ? 1
                      : bloc.merchants[i].posList.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
