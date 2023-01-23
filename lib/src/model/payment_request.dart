// import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:intl/intl.dart';
import 'package:pos/src/model/request_status_enum.dart';
import '../utils.dart';
import 'package:pos/src/db/keys.dart';

class PaymentRequest {
  static String TABLE = "paymentRequest";
  static String ID = "id";
  static String DEEP_LINK = "deepLink";
  static String AIM_CODE = "aim_code";
  static String AIM_NAME = "aim_name";
  static String AMOUNT = "amount";
  static String STATUS = "status";
  static String NAME = "name";
  static String PASSWORD = "Password";
  static String DATE = "date";
  static String URL = "url";
  static String POS_ID = "PosId";
  static String LATITUDE = "longitude";
  static String LONGITUDE = "latitude";
  static String NONCE = "Nonce";
  static String VOUCHERS = "Vouchers";
  static String PAYLOAD = "Payload";
  static String SIMPLE_FILTER = "SimpleFilter";
  static String POCKET_ACK_URL = "PocketAckUrl";
  static String POS_ACK_URL = "PosAckUrl";

  static String PERSISTENT = "Persistent";
  static String ON_CLOUD = "onCloud";

  final String posId;
  final int amount;

  final DateTime? dateTime;

  final String? password;
  final String nonce;

  // String registryUrl;
  String name;
  String? deepLink;

  RequestStatus status;
  int? id;

  SimpleFilter? simpleFilter;
  String? aimCode;
  final bool persistent;

//  List<Wom> vouchers;
  LatLng? location;
  Aim? aim;
  String aimName;
  String? pocketAckUrl;
  String? posAckUrl;
  bool onCloud;

  /*      {
        "PosId": 1,
    "Nonce": "91553f9f3d404a5399a7a7d651bb0ddd",
    "Password": "1234",
    "Amount": 10,
    "SimpleFilter": {
    "Aim": "11",
    "Bounds": {
    "LeftTop": [ 45.0, -170.0 ],
    "RightBottom": [ 50.0, -160.0 ]
    },
    "MaxAge": 14
    },
    "PocketAckUrl": "pocket://confirmation-url",
    "PosAckUrl": "https://merchant.com/confirmation"
    }

    */

  PaymentRequest({
    this.password,
    this.id,
    this.dateTime,
    required this.name,
    this.aim,
    required this.status,
    this.aimCode,
    required this.aimName,
    this.location,
    this.deepLink,
    this.onCloud = false,
    required this.posId,
    required this.amount,
    this.simpleFilter,
    this.pocketAckUrl,
    this.posAckUrl,
    this.persistent = false,
    required this.nonce,
  });

  Map<String, dynamic> toPayloadMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['posId'] = posId;
    data['nonce'] = nonce;
    data['amount'] = amount;
    data['simpleFilter'] = simpleFilter?.toJson();
    data['posAckUrl'] = posAckUrl;
    data['pocketAckUrl'] = pocketAckUrl;
    data['persistent'] = persistent;
    data['onCloud'] = onCloud;
    return data;
  }

  String? get dateString =>
      dateTime != null ? DateFormat.yMMMd().format(dateTime!) : null;

  List<LatLng> get bbPoints => simpleFilter?.bounds != null
      ? [
          LatLng(simpleFilter!.bounds!.leftTop[0],
              simpleFilter!.bounds!.leftTop[1]),
          LatLng(simpleFilter!.bounds!.rightBottom[0],
              simpleFilter!.bounds!.leftTop[1]),
          LatLng(simpleFilter!.bounds!.rightBottom[0],
              simpleFilter!.bounds!.rightBottom[1]),
          LatLng(simpleFilter!.bounds!.leftTop[0],
              simpleFilter!.bounds!.rightBottom[1]),
          LatLng(simpleFilter!.bounds!.leftTop[0],
              simpleFilter!.bounds!.leftTop[1]),
        ]
      : [];

  factory PaymentRequest.fromDBMap(Map<String, dynamic> map) {
    final maxAge = map[SimpleFiltersKeys.MAX_AGE];
    final aimCode = map[AIM_CODE];
    final leftTopLat = map[BoundsKeys.LEFT_TOP_LAT];
    final leftTopLong = map[BoundsKeys.LEFT_TOP_LONG];
    final rightBottomLat = map[BoundsKeys.RIGHT_BOT_LAT];
    final rightBottomLong = map[BoundsKeys.RIGHT_BOT_LONG];

    SimpleFilter? simpleFilter;
    Bounds? bounds;
    if (leftTopLat != null &&
        leftTopLong != null &&
        rightBottomLat != null &&
        rightBottomLong != null) {
      bounds = Bounds(
        leftTop: [leftTopLat, leftTopLong],
        rightBottom: [rightBottomLat, rightBottomLong],
      );
    }
    if (aimCode != null || maxAge != null || bounds != null) {
      simpleFilter = SimpleFilter(
        maxAge: maxAge,
        aim: aimCode,
        bounds: bounds,
      );
    }

    return PaymentRequest(
      id: map[ID],
      amount: map[AMOUNT],
      dateTime: map[DATE] != null
          ? DateTime.fromMillisecondsSinceEpoch(map[DATE])
          : null,
      aimCode: map[AIM_CODE],
      aimName: map[AIM_NAME],
      location: (map[LATITUDE] != null && map[LONGITUDE] != null)
          ? LatLng(map[LATITUDE].toDouble(), map[LONGITUDE].toDouble())
          : null,
      name: map[NAME],
      nonce: map[NONCE],
      password: map[PASSWORD],
      posId: map[POS_ID],
      status: RequestStatus.values[map[STATUS]],
      // registryUrl: map[URL],
      pocketAckUrl: map[POCKET_ACK_URL],
      posAckUrl: map[POS_ACK_URL],
      persistent: map[PERSISTENT] == 0 ? false : true,
      onCloud: map[ON_CLOUD] == 0 ? false : true,
      deepLink: map[DEEP_LINK],
      simpleFilter: simpleFilter,
    );
  }

  Map<String, dynamic> toDBMap() {
    final Map<String, dynamic> map = {};
    map[AMOUNT] = amount;
    // map[URL] = this.registryUrl;
    map[PASSWORD] = password;
    map[NAME] = name;
    map[DATE] = dateTime?.millisecondsSinceEpoch;
    map[LATITUDE] = location?.latitude;
    map[LONGITUDE] = location?.longitude;
    map[AIM_CODE] = aimCode;
    map[AIM_NAME] = aimName;
    map[DEEP_LINK] = deepLink;
    map[NONCE] = nonce;
    map[POS_ID] = posId;
    map[STATUS] = status.index;
    map[PERSISTENT] = persistent ? 1 : 0;
    map[ON_CLOUD] = onCloud ? 1 : 0;
    map[SimpleFiltersKeys.MAX_AGE] = simpleFilter?.maxAge;
    if (simpleFilter?.bounds != null) {
      map[BoundsKeys.LEFT_TOP_LAT] = simpleFilter?.bounds?.leftTop[0];
      map[BoundsKeys.LEFT_TOP_LONG] = simpleFilter?.bounds?.leftTop[1];
      map[BoundsKeys.RIGHT_BOT_LAT] = simpleFilter?.bounds?.rightBottom[0];
      map[BoundsKeys.RIGHT_BOT_LONG] = simpleFilter?.bounds?.rightBottom[1];
    }
    map[POCKET_ACK_URL] = pocketAckUrl;
    map[POS_ACK_URL] = posAckUrl;
    return map;
  }

  toPayload() {
    return RequestPaymentPayload(
      amount: amount,
      nonce: nonce,
      posId: posId,
      persistent: persistent,
      pocketAckUrl: pocketAckUrl,
      simpleFilter: simpleFilter,
      posAckUrl: posAckUrl,
    );
  }

  PaymentRequest copyFrom({String? password}) {
    return PaymentRequest(
      id: id,
      amount: amount,
      dateTime: DateTime.now(),
      password: password ?? this.password,
      // registryUrl: this.registryUrl,
      nonce: nonce,
      name: name,
      aim: aim,
      aimCode: aimCode,
      aimName: aimName,
      status: status,
      posId: posId,
      location: location,
      simpleFilter: simpleFilter,
      pocketAckUrl: pocketAckUrl,
      posAckUrl: posAckUrl,
      persistent: persistent,
      onCloud: onCloud,
      deepLink: deepLink,
    );
  }
}
