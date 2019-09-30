import 'package:flutter/material.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:wom_package/wom_package.dart';

class MyDropdown extends StatelessWidget {
  final List<Aim> list;
  final String value;
  final String labelText;

  final ValueChanged<String> onChanged;

  const MyDropdown(
      {Key key, this.list, this.value, this.onChanged, this.labelText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Theme.of(context).primaryColor,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            value: value,
            hint: Text(AppLocalizations.of(context).translate('choose')),
            onChanged: onChanged,
            items: list.map((Aim aim) {
              return DropdownMenuItem<String>(
                value: aim.code,
                child: Text(aim.title),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
