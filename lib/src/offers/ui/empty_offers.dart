import 'package:flutter/material.dart';
import 'package:pos/localization/app_localizations.dart';

class EmptyOffers extends StatelessWidget {
  const EmptyOffers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppLocalizations.of(context)?.translate('no_request') ?? '',
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
