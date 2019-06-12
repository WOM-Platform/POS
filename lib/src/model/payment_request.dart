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
  SimpleFilter simpleFilter;

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

  PaymentRequest(
      {this.id,
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
      this.posAckUrl}) {
    this.nonce = generateGUID();
  }

  Map<String, dynamic> toPayloadMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[POS_ID] = this.posId;
    data[NONCE] = this.nonce;
    data[PASSWORD] = this.password;
    data[AMOUNT] = this.amount;
    data[SIMPLE_FILTER] = this.simpleFilter?.toMap();
    data[POS_ACK_URL] = this.posAckUrl;
    data[POCKET_ACK_URL] = this.pocketAckUrl;
    return data;
  }

  String get dateString => DateFormat.yMd().format(dateTime);

  PaymentRequest.fromMap(Map<String, dynamic> map) {
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
    this.posId = map[POS_ID];
    this.status = RequestStatus.values[map[STATUS]];
    this.registryUrl = map[URL];
    this.pocketAckUrl = map[POCKET_ACK_URL];
    this.posAckUrl = map[POS_ACK_URL];
    this.deepLink = map[DEEP_LINK];
    final maxAge = map[SimpleFilter.MAX_AGE];
    final aimCode = map[AIM_CODE];
    final leftTopLat = map[BoundingBox.LEFT_TOP_LAT];
    final leftTopLong = map[BoundingBox.LEFT_TOP_LONG];
    final rightBottomLat = map[BoundingBox.RIGHT_BOT_LAT];
    final rightBottomLong = map[BoundingBox.RIGHT_BOT_LONG];

    BoundingBox boundingBox;
    if (leftTopLat != null &&
        leftTopLong != null &&
        rightBottomLat != null &&
        rightBottomLong != null) {
      boundingBox = BoundingBox(
        leftTop: LatLng(leftTopLat, leftTopLong),
        rightBottom: LatLng(rightBottomLat, rightBottomLong),
      );
    }
    if (aimCode != null || maxAge != null || boundingBox != null) {
      this.simpleFilter = SimpleFilter(
        maxAge: maxAge,
        aimCode: aimCode,
        boundingBox: boundingBox,
      );
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = Map();
    map[AMOUNT] = this.amount;
    map[URL] = this.registryUrl;
    map[PASSWORD] = this.password;
    map[NAME] = this.name;
    map[DATE] = this.dateTime?.millisecondsSinceEpoch;
    map[AIM_CODE] = this.aimCode;
    map[AIM_NAME] = this.aimName;
    map[DEEP_LINK] = this.deepLink;
    map[NONCE] = this.nonce;
    map[POS_ID] = this.posId;
    map[STATUS] = this.status.index;
    map[SimpleFilter.MAX_AGE] = this.simpleFilter?.maxAge;
    if (simpleFilter?.boundingBox != null) {
      map[BoundingBox.LEFT_TOP_LAT] =
          this.simpleFilter?.boundingBox?.leftTop?.latitude ?? null;
      map[BoundingBox.LEFT_TOP_LONG] =
          this.simpleFilter?.boundingBox?.leftTop?.longitude ?? null;
      map[BoundingBox.RIGHT_BOT_LAT] =
          this.simpleFilter?.boundingBox?.rightBottom?.latitude ?? null;
      map[BoundingBox.RIGHT_BOT_LONG] =
          this.simpleFilter?.boundingBox?.rightBottom?.longitude ?? null;
    }
    map[POCKET_ACK_URL] = this.pocketAckUrl;
    map[POS_ACK_URL] = this.posAckUrl;
    return map;
  }

  PaymentRequest copyFrom() {
    return PaymentRequest(
      amount: this.amount,
      dateTime: DateTime.now(),
      password: this.password,
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
    );
  }
}

class SimpleFilter {
  static String AIM = "Aim";
  static String BOUNDS = "Bounds";
  static String MAX_AGE = "MaxAge";

  String aimCode;
  BoundingBox boundingBox;
  int maxAge;

  SimpleFilter({
    this.aimCode,
    this.boundingBox,
    this.maxAge,
  });

/*
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
}*/

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[AIM] = this.aimCode;
    if (boundingBox != null) {
      data[BOUNDS] = this.boundingBox.toMap();
    }
    data[MAX_AGE] = this.maxAge;
    return data;
  }
}

class BoundingBox {
  static String LEFT_TOP = "LeftTop";
  static String LEFT_TOP_LAT = "LeftTopLat";
  static String LEFT_TOP_LONG = "LeftTopLong";
  static String RIGHT_BOT = "RightBottom";
  static String RIGHT_BOT_LAT = "RightBottomLat";
  static String RIGHT_BOT_LONG = "RightBottomLong";

  LatLng leftTop;
  LatLng rightBottom;

  BoundingBox({this.leftTop, this.rightBottom});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[LEFT_TOP] = [leftTop.latitude, leftTop.longitude];
    data[RIGHT_BOT] = [this.rightBottom.latitude, this.rightBottom.longitude];
    return data;
  }
}
