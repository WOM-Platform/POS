import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:pos/src/blocs/authentication/authentication_bloc.dart';
import 'package:pos/src/offers/application/create_offer_notifier.dart';
import 'package:pos/src/offers/ui/create_new_offer/widgets/styles.dart';

import '../../../domain/entities/offert_type.dart';

class SelectOfferType extends ConsumerWidget {
  const SelectOfferType({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAnonymous = ref.watch(isAnonymousUserProvider);
    final type =
        ref.watch(createOfferNotifierProvider.select((value) => value.type));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: ListTile(
              enabled: !isAnonymous,
              onTap: () {
                ref
                    .read(createOfferNotifierProvider.notifier)
                    .setOfferType(OfferType.persistent);
              },
              title: Text(
                AppLocalizations.of(context)?.translate('persistent_offer') ??
                    '-',
                style: titleStyle,
              ),
              subtitle: Text(
                AppLocalizations.of(context)
                        ?.translate('persistent_offer_desc') ??
                    '-',
                style: descStyle,
              ),
              leading: IgnorePointer(
                child: Radio<OfferType>(
                  value: OfferType.persistent,
                  groupValue: type,
                  onChanged: isAnonymous ? null : (value) {},
                ),
              ),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                ref
                    .read(createOfferNotifierProvider.notifier)
                    .setOfferType(OfferType.ephemeral);
              },
              title: Text(
                AppLocalizations.of(context)?.translate('ephemeral_offer') ??
                    '-',
                style: titleStyle,
              ),
              subtitle: Text(
                AppLocalizations.of(context)
                        ?.translate('ephemeral_offer_desc') ??
                    '-',
                style: descStyle,
              ),
              leading: IgnorePointer(
                child: Radio<OfferType>(
                  value: OfferType.ephemeral,
                  groupValue: type,
                  onChanged: (value) {},
                ),
              ),
            ),
          ),
          if (isAnonymous)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                AppLocalizations.of(context)
                        ?.translate('anonymousTypeOfferSelectorMessage') ??
                    '',
              ),
            ),
        ],
      ),
    );
  }
}
