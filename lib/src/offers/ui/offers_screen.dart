import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pos/custom_icons.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:pos/src/blocs/authentication/authentication_bloc.dart';
import 'package:pos/src/offers/application/offers.dart';
import 'package:pos/src/offers/domain/entities/offert_type.dart';
import 'package:pos/src/offers/ui/empty_offers.dart';
import 'package:pos/src/screens/home/widgets/card_request.dart';
import 'package:pos/src/screens/home/widgets/home_list.dart';
import 'package:pos/src/screens/request_datails/request_datails.dart';
import 'package:pos/src/services/aim_repository.dart';
import 'package:pos/src/services/pdf_creator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share/share.dart';
import 'package:collection/collection.dart';
import '../../db/app_database/app_database.dart';

final offersTabProvider = StateProvider<OfferType>((ref) {
  final isAnonymous = ref.watch(isAnonymousUserProvider);
  return isAnonymous ? OfferType.ephemeral : OfferType.persistent;
});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('offerscreen build');
    final selectedPosId = ref.watch(selectedPosProvider)?.pos?.id;
    final offersAsync = ref.watch(cloudOffersNotifierProvider(selectedPosId));
    final controller = ref.watch(refreshControllerProvider);
    final isAnonymous = ref.watch(isAnonymousUserProvider);
    final tabController = useTabController(initialLength: isAnonymous ? 1 : 2);
    tabController.addListener(() {
      if (ref.read(offersTabProvider.notifier).state.index !=
          tabController.index) {
        ref.read(offersTabProvider.notifier).state =
            OfferType.values[tabController.index];
      }
    });
    ref.listen<OfferType>(offersTabProvider, (previous, next) {
      if (!isAnonymous && next != tabController.index) {
        tabController.animateTo(next.index);
      }
    });
    return Scaffold(
      body: Column(
        children: [
          if (!isAnonymous)
            Container(
              color: Theme.of(context).primaryColor,
              child: TabBar(
                indicatorColor: Colors.white,
                controller: tabController,
                tabs: [
                  Tab(
                    text: AppLocalizations.of(context)
                            ?.translate('persistentTabBar') ??
                        '-',
                    // icon: Icon(Icons.directions_car),
                  ),
                  Tab(
                    text: AppLocalizations.of(context)
                            ?.translate('ephemeralTabBar') ??
                        '-',
                    // icon: Icon(Icons.directions_transit),
                  ),
                ],
              ),
            ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                if (!isAnonymous)
                  SmartRefresher(
                    controller: controller,
                    onRefresh: () async {
                      await ref.refresh(
                          cloudOffersNotifierProvider(selectedPosId).future);
                      controller.refreshCompleted();
                    },
                    child: offersAsync.when(
                      data: (list) {
                        if (list.isEmpty) {
                          return EmptyOffers();
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: list.length,
                          itemBuilder: (c, index) {
                            final offer = list[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => RequestDetails(
                                      id: '',
                                      cost: offer.cost,
                                      password: offer.payment.password,
                                      link: offer.payment.link,
                                      name: offer.title,
                                      onCreatePdf: () async {
                                        final pos =
                                            ref.read(selectedPosProvider)?.pos;
                                        if (pos == null) return;
                                        final aims = await ref.read(
                                            aimFlatListFutureProvider.future);
                                        final pdfCreator = PdfCreator();
                                        final file =
                                            await pdfCreator.buildPersistentPdf(
                                          offer,
                                          pos,
                                          AppLocalizations.of(context)
                                                  ?.locale
                                                  .languageCode ??
                                              'en',
                                          aims,
                                        );
                                        Share.shareFiles([file.path]);
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: OfferTile(
                                offer: offer,
                                onDelete: () async {
                                  if (selectedPosId == null) return;
                                  await ref
                                      .read(cloudOffersNotifierProvider(
                                              selectedPosId)
                                          .notifier)
                                      .deleteOffer(list[index].id);
                                },
                              ),
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
      ),
    );
  }
}

class OfferTile extends ConsumerStatefulWidget {
  final Offer offer;
  final Function() onDelete;

  const OfferTile({
    Key? key,
    required this.offer,
    required this.onDelete,
  }) : super(key: key);

  @override
  ConsumerState<OfferTile> createState() => _OfferTileState();
}

class _OfferTileState extends ConsumerState<OfferTile> {
  static final dateFormat = DateFormat('dd MMM yyyy');
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: FlipCard(
        key: cardKey,
        flipOnTouch: false,
        front: Slidable(
          startActionPane: ActionPane(
            extentRatio: 0.5,
            motion: const BehindMotion(),
            children: [
              MySlidableAction(
                icon: Icons.share,
                onTap: () {
                  Share.share(widget.offer.payment.link);
                },
                color: Colors.green,
              ),
              MySlidableAction(
                icon: Icons.picture_as_pdf,
                onTap: () async {
                  final pos = ref.read(selectedPosProvider)?.pos;
                  if (pos == null) return;
                  final aims = await ref.read(aimFlatListFutureProvider.future);
                  final pdfCreator = PdfCreator();
                  final file = await pdfCreator.buildPersistentPdf(
                    widget.offer,
                    pos,
                    AppLocalizations.of(context)?.locale.languageCode ?? 'en',
                    aims,
                  );
                  Share.shareFiles([file.path]);
                },
                color: Colors.pink,
              ),
            ],
          ),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.25,
            children: [
              MySlidableAction(
                icon: Icons.delete,
                onTap: widget.onDelete,
                color: Colors.red,
              ),
            ],
          ),
          child: Card(
            // margin: const EdgeInsets.only(top: 8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                textBaseline: TextBaseline.alphabetic,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.offer.title,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 18),
                      // Text(
                      //   dateFormat.format(offer.createdOn),
                      //   style: TextStyle(fontSize: 16),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(
                    height: 2,
                  ),
                  if (widget.offer.description != null &&
                      widget.offer.description!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        widget.offer.description!,
                        style: TextStyle(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            ItemRow2(
                              tooltip: AppLocalizations.of(context)
                                      ?.translate('creation_date') ??
                                  '-',
                              icon: MdiIcons.calendar,
                              text: dateFormat.format(widget.offer.createdOn),
                            ),
                            Consumer(
                              builder: (context, ref, child) {
                                if (widget.offer.filter?.aim == null) {
                                  return ItemRow2(
                                    tooltip: AppLocalizations.of(context)
                                            ?.translate('filter_aim') ??
                                        '-',
                                    icon: MdiIcons.shapeOutline,
                                    text: '-',
                                  );
                                }
                                final languageCode =
                                    AppLocalizations.of(context)
                                        ?.locale
                                        .languageCode;
                                final aimList = ref
                                    .watch(aimListFutureProvider)
                                    .valueOrNull;

                                var aimText = '';
                                if (aimList != null && aimList.isNotEmpty) {
                                  final aim = aimList.firstWhereOrNull(
                                      (element) =>
                                          element.code ==
                                          widget.offer.filter?.aim);
                                  if (aim != null) {
                                    aimText =
                                        aim.titles[languageCode ?? 'en'] ?? '-';
                                  }
                                }
                                return ItemRow2(
                                  tooltip: AppLocalizations.of(context)
                                          ?.translate('filter_aim') ??
                                      '-',
                                  icon: MdiIcons.shapeOutline,
                                  text: aimText,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            ItemRow2(
                              tooltip: AppLocalizations.of(context)
                                      ?.translate('wom_age') ??
                                  '-',
                              icon: widget.offer.filter?.maxAge != null
                                  ? MdiIcons.timerSand
                                  : MdiIcons.timerSandEmpty,
                              text: widget.offer.filter?.maxAge != null
                                  ? '${widget.offer.filter?.maxAge} ${AppLocalizations.of(context)?.translate('days') ?? ''}'
                                  : '-',
                            ),
                            ItemRow2(
                              tooltip: AppLocalizations.of(context)
                                      ?.translate('bounding_box') ??
                                  '-',
                              onPressed: widget.offer.filter?.bounds != null
                                  ? () {
                                      cardKey.currentState?.toggleCard();
                                    }
                                  : null,
                              icon: widget.offer.filter?.bounds != null
                                  ? MdiIcons.mapCheckOutline
                                  : MdiIcons.mapOutline,
                              text: widget.offer.filter?.bounds != null
                                  ? AppLocalizations.of(context)
                                          ?.translate('geo_filter') ??
                                      ''
                                  : '-',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Spacer(),
                      Text(
                        widget.offer.cost.toString(),
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
          ),
        ),
        back: (widget.offer.filter?.bounds != null)
            ? Container(
                height: 250,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: GoogleMap(
                    onTap: (lat) => cardKey.currentState?.toggleCard(),
                    onMapCreated: (controller) {
                      controller.moveCamera(
                        CameraUpdate.newLatLngBounds(
                          LatLngBounds(
                            southwest: LatLng(
                              widget.offer.filter!.bounds!.rightBottom[0],
                              widget.offer.filter!.bounds!.leftTop[1],
                            ),
                            northeast: LatLng(
                              widget.offer.filter!.bounds!.leftTop[0],
                              widget.offer.filter!.bounds!.rightBottom[1],
                            ),
                          ),
                          72.0,
                        ),
                      );
                    },
                    cameraTargetBounds: CameraTargetBounds(
                      LatLngBounds(
                        southwest: LatLng(
                          widget.offer.filter!.bounds!.rightBottom[0],
                          widget.offer.filter!.bounds!.leftTop[1],
                        ),
                        northeast: LatLng(
                          widget.offer.filter!.bounds!.leftTop[0],
                          widget.offer.filter!.bounds!.rightBottom[1],
                        ),
                      ),
                    ),
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        widget.offer.filter!.bounds!.center.latitude,
                        widget.offer.filter!.bounds!.center.longitude,
                      ),
                      zoom: 14,
                    ),
                    rotateGesturesEnabled: false,
                    scrollGesturesEnabled: false,
                    zoomGesturesEnabled: false,
                    tiltGesturesEnabled: false,
                    compassEnabled: false,
                    myLocationButtonEnabled: false,
                    myLocationEnabled: false,
                    mapToolbarEnabled: false,
//                    circles: {
//                      Circle(
//                        circleId: CircleId('bb'),
//                        radius: getRadiusFromBoundingBox(
//                            request.simpleFilter.bounds.leftTop,
//                            request.simpleFilter.bounds.rightBottom),
//                        strokeColor: Colors.green,
//                        strokeWidth: 1,
//                        center: request.location,
//                        fillColor: Colors.green.withOpacity(0.3),
//                      )
//                    },
                    markers: {
                      Marker(
                        markerId: MarkerId(widget.offer.id.toString()),
                        position: LatLng(
                          widget.offer.filter!.bounds!.center.latitude,
                          widget.offer.filter!.bounds!.center.longitude,
                        ),
                      ),
                    },
                    polygons: {
                      Polygon(
                        polygonId: PolygonId('bounding_box'),
                        points: bbPoints,
                        fillColor: Colors.green.withOpacity(0.3),
                        strokeColor: Colors.green.withOpacity(0.7),
                        strokeWidth: 2,
                      )
                    },
                  ),
                ),
              )
            : Container(),
      ),
    );
  }

  List<LatLng> get bbPoints => widget.offer.filter?.bounds != null
      ? [
          LatLng(widget.offer.filter!.bounds!.leftTop[0],
              widget.offer.filter!.bounds!.leftTop[1]),
          LatLng(widget.offer.filter!.bounds!.rightBottom[0],
              widget.offer.filter!.bounds!.leftTop[1]),
          LatLng(widget.offer.filter!.bounds!.rightBottom[0],
              widget.offer.filter!.bounds!.rightBottom[1]),
          LatLng(widget.offer.filter!.bounds!.leftTop[0],
              widget.offer.filter!.bounds!.rightBottom[1]),
          LatLng(widget.offer.filter!.bounds!.leftTop[0],
              widget.offer.filter!.bounds!.leftTop[1]),
        ]
      : [];
}

class MySlidableAction extends StatelessWidget {
  final Color? color;
  final Function()? onTap;
  final IconData icon;

  const MySlidableAction({Key? key, this.color, this.onTap, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Container(
            // margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
            decoration: BoxDecoration(
              color: color,
              // borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
