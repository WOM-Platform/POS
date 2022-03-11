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
        baseStyle: TextStyle(color: Colors.yellow),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(7),
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          hintStyle: TextStyle(
            color: Colors.white,
          ),
          border: OutlineInputBorder(
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
              style: TextStyle(color: Colors.white),
            ),
            onChanged: onChanged,
            items: list.map((Aim aim) {
              return DropdownMenuItem<String>(
                value: aim.code,
                child: Text(
                  (aim.titles ?? const {})[languageCode ?? "en"] ?? '-',
                  style: TextStyle(),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
