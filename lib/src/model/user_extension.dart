import 'package:dart_wom_connector/dart_wom_connector.dart';

extension UserExt on User {
  bool get isAnonymous => name == 'Anonymous';
}
