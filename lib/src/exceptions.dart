import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:easy_localization/easy_localization.dart';

extension ServerExceptionX on ServerException {
  String? get errorDescription {
    switch (errorType) {
      case ServerExceptionType.alreadyUsedFiscalCode:
        return 'fiscal_code_already_used'.tr();
      case ServerExceptionType.invalidFiscalCode:
        return 'invalid_fiscal_code'.tr();
      case ServerExceptionType.validation:
        return 'validation_error'.tr();
      case ServerExceptionType.unkown:
        return null;
    }
  }
}
