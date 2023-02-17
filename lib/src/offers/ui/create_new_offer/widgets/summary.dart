import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:pos/src/extensions.dart';
import 'package:pos/src/offers/application/create_offer_notifier.dart';
import 'package:pos/src/offers/domain/entities/offert_type.dart';

class Summary extends ConsumerWidget {
  const Summary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createOfferNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InfoText(
          text: AppLocalizations.of(context)?.translate('offer_type') ?? '-',
          value: state.type?.translate(context),
        ),
        const SizedBox(height: 16),
        InfoText(
          text: AppLocalizations.of(context)?.translate('title') ?? '-',
          value: state.title,
        ),
        const SizedBox(height: 16),
        InfoText(
          text: AppLocalizations.of(context)?.translate('description') ?? '-',
          value: state.description.isEmptyOrNull() ? null : state.description,
        ),
        const SizedBox(height: 16),
        InfoText(
          text: AppLocalizations.of(context)?.translate('wom_number') ?? '-',
          value: state.wom?.toString(),
        ),
        const SizedBox(height: 16),
        InfoText(
          text: 'Aim',
          value: state.aimCode,
        ),
        const SizedBox(height: 16),
        InfoText(
          text: AppLocalizations.of(context)?.translate('bounding_box') ?? '-',
          value: state.mapPolygon != null
              ? AppLocalizations.of(context)?.translate('offer_type') ?? '-'
              : '-',
        ),
        /*   if (state.mapPolygon != null)
          AspectRatio(
            aspectRatio: 1,
            child: GoogleMap(
              polygons: {
                if (state.mapPolygon != null)
                  Polygon(
                    polygonId: PolygonId('bounding_box'),
                    points: state.mapPolygon!.polygon,
                    fillColor: Colors.green.withOpacity(0.3),
                    strokeColor: Colors.green.withOpacity(0.7),
                    strokeWidth: 2,
                  )
              },
              initialCameraPosition: CameraPosition(
                target: state.mapPolygon!.target,
                zoom: state.mapPolygon!.zoom,
              ),
            ),
          ),*/
        const SizedBox(height: 16),
        InfoText(
          text: AppLocalizations.of(context)?.translate('wom_age') ?? '-',
          value: state.maxAge?.toString(),
        ),
      ],
    );
  }
}

class InfoText extends StatelessWidget {
  final String text;
  final String? value;

  const InfoText({
    Key? key,
    required this.text,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(color: Colors.grey);
    final valueStyle = TextStyle();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          text,
          style: titleStyle,
        ),
        const SizedBox(height: 4),
        Text(
          value ?? '-',
          style: valueStyle,
        ),
      ],
    );
  }
}
