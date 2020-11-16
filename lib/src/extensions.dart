export 'model/user_extension.dart';

extension StringExt on String {
  bool isEmptyOrNull() => this == null || this.isEmpty;
  bool get isNotNullAndNotEmpty => this != null && this.isNotEmpty;
}
