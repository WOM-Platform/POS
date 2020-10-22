import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:intl/intl.dart';
import 'package:pos/src/model/request_status_enum.dart';

import '../utils.dart';

class PaymentRequest extends RequestPaymentPayload {
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

  DateTime dateTime;
  // String registryUrl;
  String name;
  String deepLink;

  RequestStatus status;
  int id;
  String aimCode;

//  List<Wom> vouchers;
  LatLng location;
  Aim aim;
  String aimName;
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
    this.id,
    String posId,
    int amount,
    password,
    SimpleFilter simpleFilter,
    String pocketAckUrl,
    String posAckUrl,
    String nonce,
    this.dateTime,
    // this.registryUrl,
    this.name,
    this.aim,
    this.status,
    this.aimCode,
    this.aimName,
    this.location,
    this.deepLink,
    bool persistent = false,
    this.onCloud = false,
  }) : super(
            posId: posId,
            amount: amount,
            password: password,
            simpleFilter: simpleFilter,
            pocketAckUrl: pocketAckUrl,
            posAckUrl: posAckUrl,
            persistent: persistent) {
    this.nonce = generateGUID();
  }

  Map<String, dynamic> toPayloadMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['posId'] = this.posId;
    data['nonce'] = this.nonce;
    data['password'] = this.password;
    data['amount'] = this.amount;
    data['simpleFilter'] = this.simpleFilter?.toMap();
    data['posAckUrl'] = this.posAckUrl;
    data['pocketAckUrl'] = this.pocketAckUrl;
    data['persistent'] = this.persistent;
    data['onCloud'] = this.onCloud;
    return data;
  }

  String get dateString => DateFormat.yMMMd().format(dateTime);

  List<LatLng> get bbPoints => simpleFilter?.bounds != null
      ? [
          LatLng(
              simpleFilter.bounds.leftTop[0], simpleFilter.bounds.leftTop[1]),
          LatLng(simpleFilter.bounds.rightBottom[0],
              simpleFilter.bounds.leftTop[1]),
          LatLng(simpleFilter.bounds.rightBottom[0],
              simpleFilter.bounds.rightBottom[1]),
          LatLng(simpleFilter.bounds.leftTop[0],
              simpleFilter.bounds.rightBottom[1]),
          LatLng(
              simpleFilter.bounds.leftTop[0], simpleFilter.bounds.leftTop[1]),
        ]
      : [];

  factory PaymentRequest.fromDBMap(Map<String, dynamic> map) {
    final maxAge = map[SimpleFilter.MAX_AGE];
    final aimCode = map[AIM_CODE];
    final leftTopLat = map[Bounds.LEFT_TOP_LAT];
    final leftTopLong = map[Bounds.LEFT_TOP_LONG];
    final rightBottomLat = map[Bounds.RIGHT_BOT_LAT];
    final rightBottomLong = map[Bounds.RIGHT_BOT_LONG];

    SimpleFilter simpleFilter;
    Bounds bounds;
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
        aimCode: aimCode,
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
      posId: map[POS_ID]?.toString(),
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
    final Map<String, dynamic> map = Map();
    map[AMOUNT] = this.amount;
    // map[URL] = this.registryUrl;
    map[PASSWORD] = this.password;
    map[NAME] = this.name;
    map[DATE] = this.dateTime?.millisecondsSinceEpoch;
    map[LATITUDE] = this.location?.latitude;
    map[LONGITUDE] = this.location?.longitude;
    map[AIM_CODE] = this.aimCode;
    map[AIM_NAME] = this.aimName;
    map[DEEP_LINK] = this.deepLink;
    map[NONCE] = this.nonce;
    map[POS_ID] = this.posId;
    map[STATUS] = this.status.index;
    map[PERSISTENT] = this.persistent ? 1 : 0;
    map[ON_CLOUD] = this.onCloud ? 1 : 0;
    map[SimpleFilter.MAX_AGE] = this.simpleFilter?.maxAge;
    if (simpleFilter?.bounds != null) {
      map[Bounds.LEFT_TOP_LAT] = this.simpleFilter?.bounds?.leftTop[0] ?? null;
      map[Bounds.LEFT_TOP_LONG] = this.simpleFilter?.bounds?.leftTop[1] ?? null;
      map[Bounds.RIGHT_BOT_LAT] =
          this.simpleFilter?.bounds?.rightBottom[0] ?? null;
      map[Bounds.RIGHT_BOT_LONG] =
          this.simpleFilter?.bounds?.rightBottom[1] ?? null;
    }
    map[POCKET_ACK_URL] = this.pocketAckUrl;
    map[POS_ACK_URL] = this.posAckUrl;
    return map;
  }

  PaymentRequest copyFrom({String password}) {
    return PaymentRequest(
      id: this.id,
      amount: this.amount,
      dateTime: DateTime.now(),
      password: password ?? this.password,
      // registryUrl: this.registryUrl,
      nonce: this.nonce,
      name: this.name,
      aim: this.aim,
      aimCode: this.aimCode,
      aimName: this.aimName,
      status: this.status,
      posId: this.posId,
      location: this.location,
      simpleFilter: this.simpleFilter,
      pocketAckUrl: this.pocketAckUrl,
      posAckUrl: this.posAckUrl,
      persistent: this.persistent,
      onCloud: this.onCloud,
      deepLink: this.deepLink,
    );
  }
}
