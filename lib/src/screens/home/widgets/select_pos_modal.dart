import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pos/src/blocs/authentication/authentication_bloc.dart';
import 'package:pos/src/offers/application/offers.dart';
import 'package:pos/src/screens/home/widgets/delete_merchant_dialog.dart';
import 'package:pos/src/services/user_repository.dart';
import 'package:pos/src/utils.dart';

class PosSelectorWidget extends ConsumerWidget {
  const PosSelectorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final merchants = ref.watch(merchantsProvider);
    final selectedPos = ref.watch(selectedPosProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'selectPosToHandle'.tr(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(),
              for (int i = 0; i < merchants.length; i++)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                merchants[i].name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // if (merchants[i].access ==
                            //     MerchantAccess.admin) ...[
                            //   const SizedBox(width: 16),
                            //   ElevatedButton(
                            //     onPressed: () async {
                            //       showDialog(
                            //         context: context,
                            //         builder: (c) => Dialog(
                            //           child: DeleteMerchantDialog(
                            //             merchantId: merchants[i].id,
                            //           ),
                            //         ),
                            //       );
                            //     },
                            //     child: Text(
                            //       'delete'.tr(),
                            //     ),
                            //   ),
                            // ],
                          ],
                        ),
                        if (merchants[i].posList.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child:
                                Text('noPosForThisMerchant' 'try_again'.tr()),
                          ),
                        for (int index = 0;
                            index < merchants[i].posList.length;
                            index++)
                          ListTile(
                            leading: Radio<String>(
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.green),
                              groupValue: selectedPos?.pos?.id,
                              onChanged: (posId) {
                                ref.read(selectedPosProvider.notifier).state =
                                    SelectedPos(merchants[i],
                                        merchants[i].posList[index]);
                                Navigator.of(context).pop();
                              },
                              value: merchants[i].posList[index].id,
                            ),
                            // trailing:
                            //     selectedPos?.pos?.id == merchants[i].posList[index].id
                            //         ? const Chip(
                            //             backgroundColor: Colors.green,
                            //             label: Text(
                            //               'Selezionato',
                            //               style: TextStyle(color: Colors.white),
                            //             ),
                            //           )
                            //         : const Icon(Icons.arrow_right),
                            title: Text(merchants[i].posList[index].name),
                            onTap: () {
                              ref.read(selectedPosProvider.notifier).state =
                                  SelectedPos(merchants[i],
                                      merchants[i].posList[index]);
                              Navigator.of(context).pop();
                            },
                          )
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
    /*return CustomScrollView(
      slivers: <Widget>[
        for (int i = 0; i < merchants.length; i++)
          SliverStickyHeader.builder(
            builder: (context, state) => Container(
              color:
              Colors.blue[200]?.withOpacity(1.0 - state.scrollPercentage),
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 16),
                  Text(
                    merchants[i].name,
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
                            title: merchants[i].name,
                            content: Column(
                              children: <Widget>[
                                Text(
                                  merchants[i].address,
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  '${merchants[i].zipCode} - ${merchants[i].city}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  merchants[i].fiscalCode,
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
                  if (merchants[i].posList.isEmpty) {
                    return ListTile(
                      tileColor: Colors.white,
                      title: const Text(
                        'Nessun POS',
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                      onTap: () {
                        ref.read(selectedMerchantProvider.notifier).state =
                            SelectedPos(
                              merchants[i],
                              merchants[i].posList[index],
                            );
                        // context.read<HomeBloc>().setMerchantAndPosId(
                        //     merchants[i].id,
                        //     merchants[i].posList[index].id);
                        Navigator.of(context).pop();
                      },
                    );
                  }
                  return ListTile(
                    leading: CircleAvatar(
                        backgroundColor:
                        Theme.of(context).scaffoldBackgroundColor,
                        child: const Icon(MdiIcons.storeOutline)),
                    trailing:
                    selectedPos?.pos?.id == merchants[i].posList[index].id
                        ? const Chip(
                      backgroundColor: Colors.green,
                      label: Text(
                        'Selezionato',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                        : const Icon(Icons.arrow_right),
                    title: Text(merchants[i].posList[index].name),
                    onTap: () {
                      ref.read(selectedMerchantProvider.notifier).state =
                          SelectedPos(
                              merchants[i], merchants[i].posList[index]);
                      Navigator.of(context).pop();
                    },
                  );
                },
                childCount: merchants[i].posList.isEmpty
                    ? 1
                    : merchants[i].posList.length,
              ),
            ),
          ),
      ],
    );*/
    /*return Scaffold(
      appBar: AppBar(
        title:
        Text('select_pos').tr()),
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
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey,
                      decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      final url = Uri.parse('https://wom.social');
                      if (await canLaunchUrl(url)) {
                        launchUrl(url);
                      }
                    },
                ),
              ]),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          for (int i = 0; i < merchants.length; i++)
            SliverStickyHeader.builder(
              builder: (context, state) => Container(
                color:
                Colors.blue[200]?.withOpacity(1.0 - state.scrollPercentage),
                child: Row(
                  children: <Widget>[
                    const SizedBox(width: 16),
                    Text(
                      merchants[i].name,
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
                              title: merchants[i].name,
                              content: Column(
                                children: <Widget>[
                                  Text(
                                    merchants[i].address,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    '${merchants[i].zipCode} - ${merchants[i].city}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    merchants[i].fiscalCode,
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
                    if (merchants[i].posList.isEmpty) {
                      return ListTile(
                        tileColor: Colors.white,
                        title: const Text(
                          'Nessun POS',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                        onTap: () {
                          ref.read(selectedMerchantProvider.notifier).state =
                              SelectedPos(
                                merchants[i],
                                merchants[i].posList[index],
                              );
                          // context.read<HomeBloc>().setMerchantAndPosId(
                          //     merchants[i].id,
                          //     merchants[i].posList[index].id);
                          Navigator.of(context).pop();
                        },
                      );
                    }
                    return ListTile(
                      leading: CircleAvatar(
                          backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                          child: const Icon(MdiIcons.storeOutline)),
                      trailing:
                      selectedPos?.pos?.id == merchants[i].posList[index].id
                          ? const Chip(
                        backgroundColor: Colors.green,
                        label: Text(
                          'Selezionato',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                          : const Icon(Icons.arrow_right),
                      title: Text(merchants[i].posList[index].name),
                      onTap: () {
                        ref.read(selectedMerchantProvider.notifier).state =
                            SelectedPos(
                                merchants[i], merchants[i].posList[index]);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                  childCount: merchants[i].posList.isEmpty
                      ? 1
                      : merchants[i].posList.length,
                ),
              ),
            ),
        ],
      ),
    );*/
  }
}
