import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangeLanguageScreen extends ConsumerWidget {
  const ChangeLanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.locale.languageCode;
    return Scaffold(
      appBar: AppBar(
        title: Text('change_language_title').tr(),
      ),
      body: ListView(
        children: [
          // for(final l in AppLocalizations.of(context)?.supportedLocales ?? [])
          ListTile(
            title: Text('Italiano'),
            trailing: l == 'it' ? Icon(Icons.check) : null,
            onTap: () {
              context.setLocale(Locale('it'));
            },
          ),
          ListTile(
            title: Text('English'),
            trailing: l == 'en' ? Icon(Icons.check) : null,
            onTap: () {
              context.setLocale(Locale('en'));
            },
          )
        ],
      ),
    );
  }
}
