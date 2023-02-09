import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pos/src/offers/application/create_offer_notifier.dart';

class Summary extends ConsumerWidget {
  const Summary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createOfferNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InfoText(
          text: 'Tipo di offerta',
          value: state.type.toString(),
        ),
        const SizedBox(height: 16),
        InfoText(
          text: 'Titolo',
          value: state.title,
        ),
        const SizedBox(height: 16),
        InfoText(
          text: 'Descrizione',
          value: state.description,
        ),
        const SizedBox(height: 16),
        InfoText(
          text: 'WOM',
          value: state.wom?.toString(),
        ),
        const SizedBox(height: 16),
        InfoText(
          text: 'Aim',
          value: state.aimCode,
        ),
        const SizedBox(height: 16),
        InfoText(
          text: 'Bounding box',
          value: state.mapPolygon != null ? 'Configurato' : '-',
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
          text: 'Filtro età',
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