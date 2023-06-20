import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum OfferType {
  persistent, ephemeral
}

extension OfferTypeX on OfferType{
  String translate(BuildContext context){
    switch(this){
      case OfferType.persistent:
        return 'persistent'.tr();
      case OfferType.ephemeral:
        return 'ephemeral'.tr();
    }
  }
}