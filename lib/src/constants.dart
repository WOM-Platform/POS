import 'package:pos/src/model/flavor_enum.dart';

late String domain;
late String registryKey;
Flavor? flavor;

//SHARED PREFERENCES
const LAST_LATITUDE = "lastLatitude";
const LAST_LONGITUDE = "lastLongitude";

class AimDbKeys {
  static const TABLE_NAME = 'aims';
  static const ID = 'id';
  static const CODE = 'code';
  static const ICON_URL = 'iconFile';
  static const CHILDREN = 'children';
  static const TITLES = 'titles';
}
