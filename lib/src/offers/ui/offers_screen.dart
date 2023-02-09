import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pos/custom_icons.dart';
import 'package:pos/src/offers/application/offers.dart';
import 'package:pos/src/screens/home/widgets/home_list.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

final refreshControllerProvider =
    Provider.autoDispose<RefreshController>((ref) {
  final c = RefreshController();
  ref.onDispose(() {
    c.dispose();
  });
  return c;
});

class OffersScreen extends HookConsumerWidget {
  const OffersScreen({Key? key}) : super(key: key);

  // void _onRefresh() async {
  //   // monitor network fetch
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   // if failed,use refreshFailed()
  //   _refreshController.refreshCompleted();
  // }
  //
  // void _onLoading() async {
  //   // monitor network fetch
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   // if failed,use loadFailed(),if no data return,use LoadNodata()
  //   _refreshController.loadComplete();
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPosId = ref.watch(selectedPosProvider)?.pos?.id;
    final offersAsync = ref.watch(getOffersProvider(posId: selectedPosId));
    final controller = ref.watch(refreshControllerProvider);

    final tabController = useTabController(initialLength: 2);
    return Scaffold(
        body: Column(
      children: [
        Container(
          color: Theme.of(context).primaryColor,
          child: TabBar(
              indicatorColor: Colors.white,
              controller: tabController,
              tabs: [
                Tab(
                  text: 'Persistenti',
                  // icon: Icon(Icons.directions_car),
                ),
                Tab(
                  text: 'Effimere',
                  // icon: Icon(Icons.directions_transit),
                ),
              ]),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              SmartRefresher(
                controller: controller,
                onRefresh: () async {
                  await ref.refresh(getOffersProvider(posId: selectedPosId).future);
                  controller.refreshCompleted();
                },
                child: offersAsync.when(
                  data: (list) {
                    if (list.isEmpty) {
                      return Center(child: Text('Non ci sono offerte attive'));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: list.length,
                      itemBuilder: (c, index) {
                        return OfferTile(
                          offer: list[index],
                        );
                      },
                    );
                  },
                  error: (ex, st) {
                    return Center(child: Text(ex.toString()));
                  },
                  loading: () {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              HomeList(),
            ],
          ),
        ),
      ],
    ));
  }
}

class OfferTile extends StatelessWidget {
  final Offer offer;

  const OfferTile({Key? key, required this.offer}) : super(key: key);

  static final dateFormat = DateFormat('dd MMM yyyy');

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    offer.title,
                    maxLines: 2,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  dateFormat.format(offer.createdOn),
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            if (offer.description != null)
              Text(
                offer.description!,
                style: TextStyle(),
              ),
            Row(
              children: [
                Spacer(),
                Text(
                  offer.cost.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Icon(
                  CustomIcons.wom_logo,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
