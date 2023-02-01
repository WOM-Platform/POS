// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_offer_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MapPolygon {
  LatLng get target => throw _privateConstructorUsedError;
  List<LatLng> get polygon => throw _privateConstructorUsedError;
  double get zoom => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MapPolygonCopyWith<MapPolygon> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapPolygonCopyWith<$Res> {
  factory $MapPolygonCopyWith(
          MapPolygon value, $Res Function(MapPolygon) then) =
      _$MapPolygonCopyWithImpl<$Res, MapPolygon>;
  @useResult
  $Res call({LatLng target, List<LatLng> polygon, double zoom});
}

/// @nodoc
class _$MapPolygonCopyWithImpl<$Res, $Val extends MapPolygon>
    implements $MapPolygonCopyWith<$Res> {
  _$MapPolygonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? target = null,
    Object? polygon = null,
    Object? zoom = null,
  }) {
    return _then(_value.copyWith(
      target: null == target
          ? _value.target
          : target // ignore: cast_nullable_to_non_nullable
              as LatLng,
      polygon: null == polygon
          ? _value.polygon
          : polygon // ignore: cast_nullable_to_non_nullable
              as List<LatLng>,
      zoom: null == zoom
          ? _value.zoom
          : zoom // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MapPolygonCopyWith<$Res>
    implements $MapPolygonCopyWith<$Res> {
  factory _$$_MapPolygonCopyWith(
          _$_MapPolygon value, $Res Function(_$_MapPolygon) then) =
      __$$_MapPolygonCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LatLng target, List<LatLng> polygon, double zoom});
}

/// @nodoc
class __$$_MapPolygonCopyWithImpl<$Res>
    extends _$MapPolygonCopyWithImpl<$Res, _$_MapPolygon>
    implements _$$_MapPolygonCopyWith<$Res> {
  __$$_MapPolygonCopyWithImpl(
      _$_MapPolygon _value, $Res Function(_$_MapPolygon) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? target = null,
    Object? polygon = null,
    Object? zoom = null,
  }) {
    return _then(_$_MapPolygon(
      target: null == target
          ? _value.target
          : target // ignore: cast_nullable_to_non_nullable
              as LatLng,
      polygon: null == polygon
          ? _value._polygon
          : polygon // ignore: cast_nullable_to_non_nullable
              as List<LatLng>,
      zoom: null == zoom
          ? _value.zoom
          : zoom // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$_MapPolygon implements _MapPolygon {
  const _$_MapPolygon(
      {required this.target,
      required final List<LatLng> polygon,
      required this.zoom})
      : _polygon = polygon;

  @override
  final LatLng target;
  final List<LatLng> _polygon;
  @override
  List<LatLng> get polygon {
    if (_polygon is EqualUnmodifiableListView) return _polygon;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_polygon);
  }

  @override
  final double zoom;

  @override
  String toString() {
    return 'MapPolygon(target: $target, polygon: $polygon, zoom: $zoom)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MapPolygon &&
            (identical(other.target, target) || other.target == target) &&
            const DeepCollectionEquality().equals(other._polygon, _polygon) &&
            (identical(other.zoom, zoom) || other.zoom == zoom));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, target, const DeepCollectionEquality().hash(_polygon), zoom);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MapPolygonCopyWith<_$_MapPolygon> get copyWith =>
      __$$_MapPolygonCopyWithImpl<_$_MapPolygon>(this, _$identity);
}

abstract class _MapPolygon implements MapPolygon {
  const factory _MapPolygon(
      {required final LatLng target,
      required final List<LatLng> polygon,
      required final double zoom}) = _$_MapPolygon;

  @override
  LatLng get target;
  @override
  List<LatLng> get polygon;
  @override
  double get zoom;
  @override
  @JsonKey(ignore: true)
  _$$_MapPolygonCopyWith<_$_MapPolygon> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CreateOfferState {
  int get activeStep => throw _privateConstructorUsedError;
  OfferType? get type => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  int? get wom => throw _privateConstructorUsedError;
  int? get maxAge => throw _privateConstructorUsedError;
  String? get aimCode => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  MapPolygon? get mapPolygon => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CreateOfferStateCopyWith<CreateOfferState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateOfferStateCopyWith<$Res> {
  factory $CreateOfferStateCopyWith(
          CreateOfferState value, $Res Function(CreateOfferState) then) =
      _$CreateOfferStateCopyWithImpl<$Res, CreateOfferState>;
  @useResult
  $Res call(
      {int activeStep,
      OfferType? type,
      String? title,
      int? wom,
      int? maxAge,
      String? aimCode,
      String? description,
      MapPolygon? mapPolygon});

  $MapPolygonCopyWith<$Res>? get mapPolygon;
}

/// @nodoc
class _$CreateOfferStateCopyWithImpl<$Res, $Val extends CreateOfferState>
    implements $CreateOfferStateCopyWith<$Res> {
  _$CreateOfferStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeStep = null,
    Object? type = freezed,
    Object? title = freezed,
    Object? wom = freezed,
    Object? maxAge = freezed,
    Object? aimCode = freezed,
    Object? description = freezed,
    Object? mapPolygon = freezed,
  }) {
    return _then(_value.copyWith(
      activeStep: null == activeStep
          ? _value.activeStep
          : activeStep // ignore: cast_nullable_to_non_nullable
              as int,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as OfferType?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      wom: freezed == wom
          ? _value.wom
          : wom // ignore: cast_nullable_to_non_nullable
              as int?,
      maxAge: freezed == maxAge
          ? _value.maxAge
          : maxAge // ignore: cast_nullable_to_non_nullable
              as int?,
      aimCode: freezed == aimCode
          ? _value.aimCode
          : aimCode // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      mapPolygon: freezed == mapPolygon
          ? _value.mapPolygon
          : mapPolygon // ignore: cast_nullable_to_non_nullable
              as MapPolygon?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MapPolygonCopyWith<$Res>? get mapPolygon {
    if (_value.mapPolygon == null) {
      return null;
    }

    return $MapPolygonCopyWith<$Res>(_value.mapPolygon!, (value) {
      return _then(_value.copyWith(mapPolygon: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_CreateOfferStateCopyWith<$Res>
    implements $CreateOfferStateCopyWith<$Res> {
  factory _$$_CreateOfferStateCopyWith(
          _$_CreateOfferState value, $Res Function(_$_CreateOfferState) then) =
      __$$_CreateOfferStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int activeStep,
      OfferType? type,
      String? title,
      int? wom,
      int? maxAge,
      String? aimCode,
      String? description,
      MapPolygon? mapPolygon});

  @override
  $MapPolygonCopyWith<$Res>? get mapPolygon;
}

/// @nodoc
class __$$_CreateOfferStateCopyWithImpl<$Res>
    extends _$CreateOfferStateCopyWithImpl<$Res, _$_CreateOfferState>
    implements _$$_CreateOfferStateCopyWith<$Res> {
  __$$_CreateOfferStateCopyWithImpl(
      _$_CreateOfferState _value, $Res Function(_$_CreateOfferState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeStep = null,
    Object? type = freezed,
    Object? title = freezed,
    Object? wom = freezed,
    Object? maxAge = freezed,
    Object? aimCode = freezed,
    Object? description = freezed,
    Object? mapPolygon = freezed,
  }) {
    return _then(_$_CreateOfferState(
      activeStep: null == activeStep
          ? _value.activeStep
          : activeStep // ignore: cast_nullable_to_non_nullable
              as int,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as OfferType?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      wom: freezed == wom
          ? _value.wom
          : wom // ignore: cast_nullable_to_non_nullable
              as int?,
      maxAge: freezed == maxAge
          ? _value.maxAge
          : maxAge // ignore: cast_nullable_to_non_nullable
              as int?,
      aimCode: freezed == aimCode
          ? _value.aimCode
          : aimCode // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      mapPolygon: freezed == mapPolygon
          ? _value.mapPolygon
          : mapPolygon // ignore: cast_nullable_to_non_nullable
              as MapPolygon?,
    ));
  }
}

/// @nodoc

class _$_CreateOfferState implements _CreateOfferState {
  const _$_CreateOfferState(
      {required this.activeStep,
      this.type,
      this.title,
      this.wom,
      this.maxAge,
      this.aimCode,
      this.description,
      this.mapPolygon});

  @override
  final int activeStep;
  @override
  final OfferType? type;
  @override
  final String? title;
  @override
  final int? wom;
  @override
  final int? maxAge;
  @override
  final String? aimCode;
  @override
  final String? description;
  @override
  final MapPolygon? mapPolygon;

  @override
  String toString() {
    return 'CreateOfferState(activeStep: $activeStep, type: $type, title: $title, wom: $wom, maxAge: $maxAge, aimCode: $aimCode, description: $description, mapPolygon: $mapPolygon)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CreateOfferState &&
            (identical(other.activeStep, activeStep) ||
                other.activeStep == activeStep) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.wom, wom) || other.wom == wom) &&
            (identical(other.maxAge, maxAge) || other.maxAge == maxAge) &&
            (identical(other.aimCode, aimCode) || other.aimCode == aimCode) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.mapPolygon, mapPolygon) ||
                other.mapPolygon == mapPolygon));
  }

  @override
  int get hashCode => Object.hash(runtimeType, activeStep, type, title, wom,
      maxAge, aimCode, description, mapPolygon);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CreateOfferStateCopyWith<_$_CreateOfferState> get copyWith =>
      __$$_CreateOfferStateCopyWithImpl<_$_CreateOfferState>(this, _$identity);
}

abstract class _CreateOfferState implements CreateOfferState {
  const factory _CreateOfferState(
      {required final int activeStep,
      final OfferType? type,
      final String? title,
      final int? wom,
      final int? maxAge,
      final String? aimCode,
      final String? description,
      final MapPolygon? mapPolygon}) = _$_CreateOfferState;

  @override
  int get activeStep;
  @override
  OfferType? get type;
  @override
  String? get title;
  @override
  int? get wom;
  @override
  int? get maxAge;
  @override
  String? get aimCode;
  @override
  String? get description;
  @override
  MapPolygon? get mapPolygon;
  @override
  @JsonKey(ignore: true)
  _$$_CreateOfferStateCopyWith<_$_CreateOfferState> get copyWith =>
      throw _privateConstructorUsedError;
}
