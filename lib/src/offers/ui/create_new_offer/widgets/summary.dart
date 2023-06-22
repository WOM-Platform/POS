import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
          Text('summary_tip').tr(),
          const SizedBox(height: 16),
          InfoText(
            text: 'offer_type'.tr(),
            value: state.type?.translate(context),
          ),
          const SizedBox(height: 16),
          InfoText(
            text: 'title'.tr(),
            value: state.title,
          ),
          const SizedBox(height: 16),
          InfoText(
            text: 'description'.tr(),
            value: state.description.isEmptyOrNull() ? null : state.description,
          ),
          const SizedBox(height: 16),
          InfoText(
            text: 'wom_number'.tr(),
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
                    'filters'.tr(),
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  InfoText(
                      text: 'filter_aim'.tr(),
                      value: ref.watch(aimNameProvider(state.aimCode))?[
                              context.locale.languageCode] ??
                          state.aimCode),
                  const SizedBox(height: 16),
                  InfoText(
                    text: 'bounding_box'.tr(),
                    value: state.mapPolygon != null ? 'bb_set'.tr() : '-',
                  ),
                  const SizedBox(height: 16),
                  InfoText(
                    text: 'wom_age'.tr(),
                    value: state.maxAge != null && state.maxAge! > 0
                        ? '${state.maxAge} ${'days'}'
                        : null,
                  ),
                ],
              ),
            )
          ] else
            InfoText(
              text: 'filters'.tr(),
              value: 'no_filters'.tr(),
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
