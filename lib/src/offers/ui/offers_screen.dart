import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos/src/offers/application/offers.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

final refreshControllerProvider =
    Provider.autoDispose<RefreshController>((ref) {
  final c = RefreshController();
  ref.onDispose(() {
    c.dispose();
  });
  return c;
});

class OffersScreen extends ConsumerWidget {
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

    return Scaffold(
      body: SmartRefresher(
        controller: controller,
        onRefresh: () async {
          await ref.refresh(getOffersProvider(posId: selectedPosId));
          controller.refreshCompleted();
        },
        child: offersAsync.when(
          data: (list) {
            if (list.isEmpty) {
              return Center(child: Text('Non ci sono offerte attive'));
            }
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (c, index) {
                return ListTile(title: Text(list[index].title));
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
    );
  }
}
