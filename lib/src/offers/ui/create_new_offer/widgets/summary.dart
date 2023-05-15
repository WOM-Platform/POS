import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:pos/src/extensions.dart';
import 'package:pos/src/offers/application/create_offer_notifier.dart';
import 'package:pos/src/offers/domain/entities/offert_type.dart';
import 'package:pos/src/services/aim_repository.dart';

class Summary extends ConsumerWidget {
  const Summary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createOfferNotifierProvider);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(AppLocalizations.of(context)?.translate('summary_tip') ?? '-'),
          const SizedBox(height: 16),
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
          if (state.aimCode != null ||
              state.mapPolygon != null ||
              state.maxAge != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppLocalizations.of(context)?.translate('filters') ?? '-',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  InfoText(
                      text: AppLocalizations.of(context)
                              ?.translate('filter_aim') ??
                          '-',
                      value: ref.watch(aimNameProvider(state.aimCode))?[
                              AppLocalizations.of(context)
                                      ?.locale
                                      .languageCode ??
                                  'en'] ??
                          state.aimCode),
                  const SizedBox(height: 16),
                  InfoText(
                    text: AppLocalizations.of(context)
                            ?.translate('bounding_box') ??
                        '-',
                    value: state.mapPolygon != null
                        ? AppLocalizations.of(context)?.translate('bb_set') ??
                            '-'
                        : '-',
                  ),
                  const SizedBox(height: 16),
                  InfoText(
                    text: AppLocalizations.of(context)?.translate('wom_age') ??
                        '-',
                    value: state.maxAge != null && state.maxAge! > 0
                        ? '${state.maxAge} ${AppLocalizations.of(context)?.translate('days') ?? ''}'
                        : null,
                  ),
                ],
              ),
            )
          ] else
            InfoText(
              text: AppLocalizations.of(context)?.translate('filters') ?? '-',
              value:
                  AppLocalizations.of(context)?.translate('no_filters') ?? '-',
            ),
        ],
      ),
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
