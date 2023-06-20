import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


class EmptyOffers extends StatelessWidget {
  const EmptyOffers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'no_request'.tr(),
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
