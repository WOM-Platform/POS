import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:pos/src/blocs/authentication/authentication_bloc.dart';
import 'package:pos/src/offers/application/create_offer_notifier.dart';
import 'package:pos/src/offers/application/offers.dart';
import 'package:pos/src/offers/ui/create_new_offer/widgets/styles.dart';

import '../../../domain/entities/offert_type.dart';

class SelectOfferType extends ConsumerWidget {
  const SelectOfferType({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAnonymous = ref.watch(isAnonymousUserProvider);
    final type =
        ref.watch(createOfferNotifierProvider.select((value) => value.type));
    final merchant = ref.watch(selectedPosProvider);
    final canCreateOffer = merchant?.merchant.access == MerchantAccess.admin;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (canCreateOffer)
            Card(
              child: ListTile(
                enabled: !isAnonymous && canCreateOffer,
                onTap: () {
                  ref
                      .read(createOfferNotifierProvider.notifier)
                      .setOfferType(OfferType.persistent);
                },
                title: Text(
                  'persistent_offer'.tr(),
                  style: titleStyle,
                ),
                subtitle: Text(
                  'persistent_offer_desc'.tr(),
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
                'ephemeral_offer'.tr(),
                style: titleStyle,
              ),
              subtitle: Text(
                'ephemeral_offer_desc'.tr(),
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
                'anonymousTypeOfferSelectorMessage'.tr(),
                style: TextStyle(color: Colors.grey),
              ),
            )
          else if (!canCreateOffer)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'no_permission_to_create'.tr(),
                style: TextStyle(color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}
