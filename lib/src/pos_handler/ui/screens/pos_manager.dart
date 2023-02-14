import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pos/src/add_image/ui/add_image.dart';
import 'package:pos/src/blocs/authentication/authentication_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pos/src/offers/application/offers.dart';
import 'package:pos/src/services/user_repository.dart';

class POSManagerScreen extends HookConsumerWidget {
  final int size;

  const POSManagerScreen(this.size, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: size);
    final posUser = ref.watch(posUserProvider);
    final merchants = posUser?.merchants ?? [];
    final List<PointOfSale> list = merchants.expand((e) => e.posList).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Organizza i tuoi POS'),
        bottom: TabBar(
          isScrollable: true,
          controller: tabController,
          tabs: [
            for (var pos in list)
              Tab(
                text: pos.name,
                // icon: Icon(Icons.directions_car),
              ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [for (var pos in list) POSHandler(pos)],
      ),
    );
  }
}

class POSHandler extends ConsumerWidget {
  final PointOfSale pos;

  const POSHandler(this.pos, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: '',
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AddImageScreen(
                            onSave: (bytes) async {
                              final secureStorage = ref
                                  .read(userRepositoryProvider)
                                  .secureStorage;
                              final email =
                                  await secureStorage.read(key: 'email');
                              final password =
                                  await secureStorage.read(key: 'password');
                              ref.read(getPosProvider).updateCover(
                                  pos.id, bytes, email!, password!);
                            },
                          ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.edit),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Text(
                  pos.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 16),
              if (pos.isActive)
                Container(
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(16)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text(
                    'ATTIVO',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'descrizione ci va?',
            style: TextStyle(fontSize: 18),
          ),
          if (pos.latitude != null && pos.longitude != null)
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: GoogleMap(
                  zoomGesturesEnabled: false,
                  rotateGesturesEnabled: false,
                  scrollGesturesEnabled: false,
                  zoomControlsEnabled: false,
                  markers: {
                    Marker(
                        markerId: MarkerId(pos.id),
                        position: LatLng(pos.latitude!, pos.longitude!))
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(pos.latitude!, pos.longitude!),
                    zoom: 18,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
