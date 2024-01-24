import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:easy_localization/easy_localization.dart';

extension ServerExceptionX on ServerException {
  String? get errorDescription {
    switch (errorType) {
      case ServerExceptionType.emailAlreadyUsed:
        return 'email_already_used'.tr();
      case ServerExceptionType.alreadyUsedFiscalCode:
        return 'fiscal_code_already_used'.tr();
      case ServerExceptionType.invalidFiscalCode:
        return 'invalid_fiscal_code'.tr();
      case ServerExceptionType.tokenNotValid:
        return 'token_not_valid'.tr();
      case ServerExceptionType.merchantNotFound:
        return 'pos-not-found'.tr();
      case ServerExceptionType.posNotFound:
        return 'source-not-found'.tr();
      case ServerExceptionType.sourceNotFound:
        return 'user-not-administrator-of-merchant'.tr();
      case ServerExceptionType.userNotAdminisratorOfMerchant:
        return 'user-not-user-of-merchant'.tr();
      case ServerExceptionType.userNotUserOfMerchan:
        return 'user-not-administrator-of-source'.tr();
      case ServerExceptionType.userNotAdminisratorOfSource:
        return 'user-not-administrator'.tr();
      case ServerExceptionType.userNotAdministraor:
        return 'user-not-administrator'.tr();
      case ServerExceptionType.userNoFound:
        return 'user-not-found'.tr();
      case ServerExceptionType.userProfileNotFound:
        return 'user-profile-not-found'.tr();
      case ServerExceptionType.emailAlreadyRegistered:
        return 'email-already-registered'.tr();
      case ServerExceptionType.userNotLoggedIn:
        return 'user-not-logged-in'.tr();
      case ServerExceptionType.unkown:
      default:
        return null;
    }
  }
}
