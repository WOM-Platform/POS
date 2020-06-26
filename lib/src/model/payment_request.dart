import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:wom_package/wom_package.dart';

import '../utils.dart';

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

  String posId;
  String nonce;
  int amount;
  DateTime dateTime;
  String password;
  String registryUrl;
  String name;
  String pocketAckUrl;
  String posAckUrl;
  String deepLink;

  RequestStatus status;
  int id;
  String aimCode;

//  List<Wom> vouchers;
  LatLng location;
  Aim aim;
  String aimName;
  SimpleFilters simpleFilter;
  bool persistent;
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
    this.amount,
    this.dateTime,
    this.password,
    this.registryUrl,
    this.name,
    this.aim,
    this.status,
    this.aimCode,
    this.aimName,
    this.posId,
    this.location,
    this.simpleFilter,
    this.deepLink,
    @required this.pocketAckUrl,
    this.posAckUrl,
    this.persistent = false,
    this.onCloud = false,
  }) {
    this.nonce = generateGUID();
  }

  Map<String, dynamic> toPayloadMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['posId'] = this.posId;
    data['nonce'] = this.nonce;
    data['password'] = this.password;
    data['amount'] = this.amount;
    data['simpleFilter'] = this.simpleFilter?.toJson();
    data['posAckUrl'] = this.posAckUrl;
    data['pocketAckUrl'] = this.pocketAckUrl;
    data['persistent'] = this.persistent;
    data['onCloud'] = this.onCloud;
    return data;
  }

  String get dateString => DateFormat.yMMMd().format(dateTime);

  PaymentRequest.fromDBMap(Map<String, dynamic> map) {
    this.id = map[ID];
    this.amount = map[AMOUNT];
    this.dateTime = DateTime.fromMillisecondsSinceEpoch(map[DATE]);
    this.aimCode = map[AIM_CODE];
    this.aimName = map[AIM_NAME];
    this.location = (map[LATITUDE] != null && map[LONGITUDE] != null)
        ? LatLng(map[LATITUDE], map[LONGITUDE])
        : null;
    this.name = map[NAME];
    this.nonce = map[NONCE];
    this.password = map[PASSWORD];
    this.posId = map[POS_ID].toString();
    this.status = RequestStatus.values[map[STATUS]];
    this.registryUrl = map[URL];
    this.pocketAckUrl = map[POCKET_ACK_URL];
    this.posAckUrl = map[POS_ACK_URL];
    this.persistent = map[PERSISTENT] == 0 ? false : true;
    this.onCloud = map[ON_CLOUD] == 0 ? false : true;
    this.deepLink = map[DEEP_LINK];
    final maxAge = map[SimpleFilters.MAX_AGE];
    final aimCode = map[AIM_CODE];
    final leftTopLat = map[BoundingBox.LEFT_TOP_LAT];
    final leftTopLong = map[BoundingBox.LEFT_TOP_LONG];
    final rightBottomLat = map[BoundingBox.RIGHT_BOT_LAT];
    final rightBottomLong = map[BoundingBox.RIGHT_BOT_LONG];

    BoundingBox bounds;
    if (leftTopLat != null &&
        leftTopLong != null &&
        rightBottomLat != null &&
        rightBottomLong != null) {
      bounds = BoundingBox(
        leftTop: [leftTopLat, leftTopLong],
        rightBottom: [rightBottomLat, rightBottomLong],
      );
    }
    if (aimCode != null || maxAge != null || bounds != null) {
      this.simpleFilter = SimpleFilters(
        maxAge: maxAge,
        aimCode: aimCode,
        bounds: bounds,
      );
    }
  }

  Map<String, dynamic> toDBMap() {
    final Map<String, dynamic> map = Map();
    map[AMOUNT] = this.amount;
    map[URL] = this.registryUrl;
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
    map[SimpleFilters.MAX_AGE] = this.simpleFilter?.maxAge;
    if (simpleFilter?.bounds != null) {
      map[BoundingBox.LEFT_TOP_LAT] =
          this.simpleFilter?.bounds?.leftTop[0] ?? null;
      map[BoundingBox.LEFT_TOP_LONG] =
          this.simpleFilter?.bounds?.leftTop[1] ?? null;
      map[BoundingBox.RIGHT_BOT_LAT] =
          this.simpleFilter?.bounds?.rightBottom[0] ?? null;
      map[BoundingBox.RIGHT_BOT_LONG] =
          this.simpleFilter?.bounds?.rightBottom[1] ?? null;
    }
    map[POCKET_ACK_URL] = this.pocketAckUrl;
    map[POS_ACK_URL] = this.posAckUrl;
    return map;
  }

  PaymentRequest copyFrom() {
    return PaymentRequest(
      amount: this.amount,
      dateTime: DateTime.now(),
      registryUrl: this.registryUrl,
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
    );
  }
}
