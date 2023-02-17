import 'package:flutter/material.dart';
import 'package:pos/localization/app_localizations.dart';

enum OfferType {
  persistent, ephemeral
}

extension OfferTypeX on OfferType{
  String translate(BuildContext context){
    switch(this){
      case OfferType.persistent:
        return AppLocalizations.of(context)?.translate('persistent') ?? '';
      case OfferType.ephemeral:
        return AppLocalizations.of(context)?.translate('ephemeral') ?? '';
    }
  }
}