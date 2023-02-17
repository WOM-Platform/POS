import 'package:flutter/material.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:pos/src/offers/ui/create_new_offer/widgets/styles.dart';

class CreateOfferCard extends StatelessWidget {
  final bool mandatory;
  final String title;
  final String description;
  final Widget child;
  final Widget? extra;

  const CreateOfferCard({
    Key? key,
    this.mandatory = false,
    required this.title,
    this.extra,
    required this.description,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: titleStyle,
                  ),
                ),
                const SizedBox(width: 8),
                if (mandatory)
                  Text(
                   AppLocalizations.of(context)?.translate('mandatory') ?? '-',
                    style: TextStyle(color: Colors.red),
                  ),
                if (extra != null) extra!
              ],
            ),
            const SizedBox(height: 8),
            child,
            const SizedBox(height: 16),
            Text(
              description,
              style: descStyle,
            )
          ],
        ),
      ),
    );
  }
}
