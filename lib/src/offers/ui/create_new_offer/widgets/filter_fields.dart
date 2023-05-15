import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:pos/src/my_logger.dart';
import 'package:pos/src/offers/application/create_offer_notifier.dart';
import 'package:pos/src/offers/ui/create_new_offer/bounds_selector_screen.dart';
import 'package:pos/src/offers/ui/create_new_offer/widgets/common_card.dart';
import 'package:pos/src/offers/ui/create_new_offer/widgets/common_dropdown.dart';
import 'package:pos/src/screens/create_payment/pages/aim_selection/bloc.dart';
import 'package:pos/src/services/aim_repository.dart';

class SimpleFilterBuilder extends ConsumerWidget {
  const SimpleFilterBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: const [
        SelectAim(),
        SelectBounds(),
        SelectMaxAge(),
        SizedBox(height: 100),
      ],
    );
  }
}

class SelectAim extends ConsumerWidget {
  const SelectAim({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(aimSelectionNotifierProvider);

    if (state.aimList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              AppLocalizations.of(context)?.translate('no_connection_title') ??
                  '',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              AppLocalizations.of(context)
                      ?.translate('no_connection_aim_desc') ??
                  '',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text(
                  AppLocalizations.of(context)?.translate('try_again') ?? ''),
              onPressed: () {
                ref.read(aimSelectionNotifierProvider.notifier).updateAims();
              },
            ),
          ],
        ),
      );
    }
    return CreateOfferCard(
      title: AppLocalizations.of(context)?.translate('filter_aim') ?? '-',
      description: AppLocalizations.of(context)?.translate('aimDesc') ?? '',
      extra: state.aimCode != null
          ? TextButton(
              onPressed: () {
                ref.read(aimSelectionNotifierProvider.notifier).resetAim();
                ref.read(createOfferNotifierProvider.notifier).resetAim();
              },
              child: Text('Reset'),
            )
          : null,
      child: Column(
        children: [
          AimDropdown(
            list: state.aimList,
            value: state.aimCode,
            labelText:
                AppLocalizations.of(context)?.translate('primary_aim') ?? '',
            onChanged: (aim) {
              if (aim == null) return;
              ref
                  .read(aimSelectionNotifierProvider.notifier)
                  .changeSelectedAimRoot(aim);
              ref.read(createOfferNotifierProvider.notifier).setAim(aim);
            },
          ),
          state.aimCode != null && state.subAimList.isNotEmpty
              ? AimDropdown(
                  list: state.subAimList,
                  value: state.subAimCode,
                  labelText: AppLocalizations.of(context)
                          ?.translate('secondary_aim') ??
                      '',
                  onChanged: (String? aimCode) {
                    if (aimCode == null) return;
                    ref
                        .read(aimSelectionNotifierProvider.notifier)
                        .changeSubAim(aimCode);
                    ref
                        .read(createOfferNotifierProvider.notifier)
                        .setAim(aimCode);
                  },
                )
              : Container(),
          state.subAimCode != null &&
                  state.subAimList.isNotEmpty &&
                  state.subSubAimList.isNotEmpty
              ? AimDropdown(
                  list: state.subSubAimList,
                  value: state.subSubAimCode,
                  labelText: AppLocalizations.of(context)
                          ?.translate('tiertiary_aim') ??
                      '',
                  onChanged: (aim) {
                    if (aim == null) return;
                    ref
                        .read(aimSelectionNotifierProvider.notifier)
                        .changeSubAim(aim);
                    ref.read(createOfferNotifierProvider.notifier).setAim(aim);
                  },
                )
              : Container(),
        ],
      ),
    );
  }
}

class SelectBounds extends ConsumerStatefulWidget {
  const SelectBounds({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SelectBoundsState();
}

class _SelectBoundsState extends ConsumerState<SelectBounds> {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    final mapPolygon = ref
        .watch(createOfferNotifierProvider.select((value) => value.mapPolygon));
    ref.listen<MapPolygon?>(
        createOfferNotifierProvider.select((value) => value.mapPolygon),
        (previous, next) {
      if (next != null) {
        logger.i('Select bounds update the current position');
        _controller.future.then((value) {
          value.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: next.target,
                zoom: next.zoom,
              ),
            ),
          );
        });
      }
    });
    return CreateOfferCard(
      title: AppLocalizations.of(context)?.translate('bounding_box') ?? '-',
      description:
          AppLocalizations.of(context)?.translate('bounding_box_desc') ?? '-',
      extra: mapPolygon != null
          ? TextButton(
              onPressed: () {
                ref.read(createOfferNotifierProvider.notifier).resetPolygon();
              },
              child: Text('Reset'),
            )
          : null,
      child: mapPolygon == null
          ? ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => PositionSelectionPage()));
              },
              child: Text('Imposta'),
            )
          : AspectRatio(
              aspectRatio: 1,
              child: GoogleMap(
                onMapCreated: (controller) {
                  _controller.complete(controller);
                },
                onTap: (_) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => PositionSelectionPage()));
                },
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                polygons: {
                  if (mapPolygon != null)
                    Polygon(
                      polygonId: PolygonId('bounding_box'),
                      points: mapPolygon.polygon,
                      fillColor: Colors.green.withOpacity(0.3),
                      strokeColor: Colors.green.withOpacity(0.7),
                      strokeWidth: 2,
                    )
                },
                initialCameraPosition: CameraPosition(target: LatLng(0, 0)),
              ),
            ),
    );
  }
}

class SelectMaxAge extends HookConsumerWidget {
  const SelectMaxAge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAge = useState<int>(0);
    // final maxAge =
    //     ref.watch(createOfferNotifierProvider.select((value) => value.maxAge));
    return CreateOfferCard(
        title: AppLocalizations.of(context)?.translate('wom_age') ?? '-',
        description:
            AppLocalizations.of(context)?.translate('wom_age_desc') ?? '-',
        // extra: maxAge != null
        //     ? TextButton(
        //         onPressed: () {
        //           ref.read(createOfferNotifierProvider.notifier).resetMaxAge();
        //         },
        //         child: Text('Reset'),
        //       )
        //     : null,
        child: Slider(
          divisions: maxAgeIta.length,
          max: (maxAgeIta.length - 1).toDouble(),
          value: selectedAge.value.toDouble(),
          label: getMaxAgeText(selectedAge.value,
              AppLocalizations.of(context)?.locale.languageCode ?? 'en'),
          onChanged: (double value) {
            selectedAge.value = value.toInt();
            ref
                .watch(createOfferNotifierProvider.notifier)
                .changeMaxAge(value.toInt());
          },
        )
        // child: TextFormField(
        //   textInputAction: TextInputAction.done,
        //   controller: ref.watch(maxAgeControllerProvider),
        //   keyboardType: TextInputType.number,
        //   inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
        //   decoration: InputDecoration(
        //     suffixText: AppLocalizations.of(context)?.translate('days') ?? '',
        //       hintText:
        //           AppLocalizations.of(context)?.translate('write_here') ?? '-'),
        // ),
        );
  }
}

getMaxAgeText(int value, String language) {
  if (language == 'it') {
    return maxAgeIta[value];
  }
  return maxAgeEng[value];
}

final maxAgeIta = [
  'Accetta tutti',
  'Al più una settimana',
  'Al più due settimane',
  'Al più un mese',
  'Al più tre mesi',
  'Al più sei mesi',
  'Al più un anno'
];

final maxAgeEng = [
  'Accept all',
  'At most one week old',
  'At most two weeks old',
  'At most one month old',
  'At most three months old',
  'At most six months old',
  'At most one year old',
];
