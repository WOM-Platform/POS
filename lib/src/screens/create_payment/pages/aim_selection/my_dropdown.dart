import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:flutter/material.dart';
import 'package:pos/localization/app_localizations.dart';

class MyDropdown extends StatelessWidget {
  final List<Aim> list;
  final String? value;
  final String labelText;

  final ValueChanged<String?>? onChanged;

  const MyDropdown({
    Key? key,
    required this.list,
    this.value,
    this.onChanged,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageCode = AppLocalizations.of(context)?.locale.languageCode;
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: InputDecorator(
        baseStyle: const TextStyle(color: Colors.yellow),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(7),
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Colors.white,
          ),
          hintStyle: const TextStyle(
            color: Colors.white,
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          filled: true,
          // fillColor: Colors.white,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            value: value,
            hint: Text(
              AppLocalizations.of(context)?.translate('choose') ?? '',
              style: const TextStyle(color: Colors.white),
            ),
            onChanged: onChanged,
            items: list.map((Aim aim) {
              return DropdownMenuItem<String>(
                value: aim.code,
                child: Text(
                  aim.title(languageCode: languageCode) ?? '-',
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
