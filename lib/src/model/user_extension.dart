import 'package:dart_wom_connector/dart_wom_connector.dart';

extension UserExt on POSUser {
  bool get isAnonymous => name == 'Anonymous';

  User copyWith({
    List<Merchant>? merchants,
    String? name,
    String? surname,
    String? email,
  }) {
    return POSUser(
      merchants: merchants ?? this.merchants,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
    );
  }
}
