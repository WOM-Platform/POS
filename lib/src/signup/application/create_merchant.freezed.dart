// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_merchant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CreateMerchantState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            List<String> items, int totalItemsCount, bool hasReachedMax)
        data,
    required TResult Function() initial,
    required TResult Function(String userId) emailVerification,
    required TResult Function() loading,
    required TResult Function(Object error, StackTrace st) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            List<String> items, int totalItemsCount, bool hasReachedMax)?
        data,
    TResult? Function()? initial,
    TResult? Function(String userId)? emailVerification,
    TResult? Function()? loading,
    TResult? Function(Object error, StackTrace st)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            List<String> items, int totalItemsCount, bool hasReachedMax)?
        data,
    TResult Function()? initial,
    TResult Function(String userId)? emailVerification,
    TResult Function()? loading,
    TResult Function(Object error, StackTrace st)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateMerchantStateData value) data,
    required TResult Function(CreateMerchantStateInitial value) initial,
    required TResult Function(CreateMerchantStateEmailVerification value)
        emailVerification,
    required TResult Function(CreateMerchantStateLoading value) loading,
    required TResult Function(CreateMerchantStateError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateMerchantStateData value)? data,
    TResult? Function(CreateMerchantStateInitial value)? initial,
    TResult? Function(CreateMerchantStateEmailVerification value)?
        emailVerification,
    TResult? Function(CreateMerchantStateLoading value)? loading,
    TResult? Function(CreateMerchantStateError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateMerchantStateData value)? data,
    TResult Function(CreateMerchantStateInitial value)? initial,
    TResult Function(CreateMerchantStateEmailVerification value)?
        emailVerification,
    TResult Function(CreateMerchantStateLoading value)? loading,
    TResult Function(CreateMerchantStateError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateMerchantStateCopyWith<$Res> {
  factory $CreateMerchantStateCopyWith(
          CreateMerchantState value, $Res Function(CreateMerchantState) then) =
      _$CreateMerchantStateCopyWithImpl<$Res, CreateMerchantState>;
}

/// @nodoc
class _$CreateMerchantStateCopyWithImpl<$Res, $Val extends CreateMerchantState>
    implements $CreateMerchantStateCopyWith<$Res> {
  _$CreateMerchantStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$CreateMerchantStateDataCopyWith<$Res> {
  factory _$$CreateMerchantStateDataCopyWith(_$CreateMerchantStateData value,
          $Res Function(_$CreateMerchantStateData) then) =
      __$$CreateMerchantStateDataCopyWithImpl<$Res>;
  @useResult
  $Res call({List<String> items, int totalItemsCount, bool hasReachedMax});
}

/// @nodoc
class __$$CreateMerchantStateDataCopyWithImpl<$Res>
    extends _$CreateMerchantStateCopyWithImpl<$Res, _$CreateMerchantStateData>
    implements _$$CreateMerchantStateDataCopyWith<$Res> {
  __$$CreateMerchantStateDataCopyWithImpl(_$CreateMerchantStateData _value,
      $Res Function(_$CreateMerchantStateData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? totalItemsCount = null,
    Object? hasReachedMax = null,
  }) {
    return _then(_$CreateMerchantStateData(
      null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<String>,
      null == totalItemsCount
          ? _value.totalItemsCount
          : totalItemsCount // ignore: cast_nullable_to_non_nullable
              as int,
      hasReachedMax: null == hasReachedMax
          ? _value.hasReachedMax
          : hasReachedMax // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$CreateMerchantStateData implements CreateMerchantStateData {
  const _$CreateMerchantStateData(
      final List<String> items, this.totalItemsCount,
      {this.hasReachedMax = true})
      : _items = items;

  final List<String> _items;
  @override
  List<String> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int totalItemsCount;
  @override
  @JsonKey()
  final bool hasReachedMax;

  @override
  String toString() {
    return 'CreateMerchantState.data(items: $items, totalItemsCount: $totalItemsCount, hasReachedMax: $hasReachedMax)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateMerchantStateData &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.totalItemsCount, totalItemsCount) ||
                other.totalItemsCount == totalItemsCount) &&
            (identical(other.hasReachedMax, hasReachedMax) ||
                other.hasReachedMax == hasReachedMax));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      totalItemsCount,
      hasReachedMax);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateMerchantStateDataCopyWith<_$CreateMerchantStateData> get copyWith =>
      __$$CreateMerchantStateDataCopyWithImpl<_$CreateMerchantStateData>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            List<String> items, int totalItemsCount, bool hasReachedMax)
        data,
    required TResult Function() initial,
    required TResult Function(String userId) emailVerification,
    required TResult Function() loading,
    required TResult Function(Object error, StackTrace st) error,
  }) {
    return data(items, totalItemsCount, hasReachedMax);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            List<String> items, int totalItemsCount, bool hasReachedMax)?
        data,
    TResult? Function()? initial,
    TResult? Function(String userId)? emailVerification,
    TResult? Function()? loading,
    TResult? Function(Object error, StackTrace st)? error,
  }) {
    return data?.call(items, totalItemsCount, hasReachedMax);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            List<String> items, int totalItemsCount, bool hasReachedMax)?
        data,
    TResult Function()? initial,
    TResult Function(String userId)? emailVerification,
    TResult Function()? loading,
    TResult Function(Object error, StackTrace st)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(items, totalItemsCount, hasReachedMax);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateMerchantStateData value) data,
    required TResult Function(CreateMerchantStateInitial value) initial,
    required TResult Function(CreateMerchantStateEmailVerification value)
        emailVerification,
    required TResult Function(CreateMerchantStateLoading value) loading,
    required TResult Function(CreateMerchantStateError value) error,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateMerchantStateData value)? data,
    TResult? Function(CreateMerchantStateInitial value)? initial,
    TResult? Function(CreateMerchantStateEmailVerification value)?
        emailVerification,
    TResult? Function(CreateMerchantStateLoading value)? loading,
    TResult? Function(CreateMerchantStateError value)? error,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateMerchantStateData value)? data,
    TResult Function(CreateMerchantStateInitial value)? initial,
    TResult Function(CreateMerchantStateEmailVerification value)?
        emailVerification,
    TResult Function(CreateMerchantStateLoading value)? loading,
    TResult Function(CreateMerchantStateError value)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class CreateMerchantStateData implements CreateMerchantState {
  const factory CreateMerchantStateData(
      final List<String> items, final int totalItemsCount,
      {final bool hasReachedMax}) = _$CreateMerchantStateData;

  List<String> get items;
  int get totalItemsCount;
  bool get hasReachedMax;
  @JsonKey(ignore: true)
  _$$CreateMerchantStateDataCopyWith<_$CreateMerchantStateData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CreateMerchantStateInitialCopyWith<$Res> {
  factory _$$CreateMerchantStateInitialCopyWith(
          _$CreateMerchantStateInitial value,
          $Res Function(_$CreateMerchantStateInitial) then) =
      __$$CreateMerchantStateInitialCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CreateMerchantStateInitialCopyWithImpl<$Res>
    extends _$CreateMerchantStateCopyWithImpl<$Res,
        _$CreateMerchantStateInitial>
    implements _$$CreateMerchantStateInitialCopyWith<$Res> {
  __$$CreateMerchantStateInitialCopyWithImpl(
      _$CreateMerchantStateInitial _value,
      $Res Function(_$CreateMerchantStateInitial) _then)
      : super(_value, _then);
}

/// @nodoc

class _$CreateMerchantStateInitial implements CreateMerchantStateInitial {
  const _$CreateMerchantStateInitial();

  @override
  String toString() {
    return 'CreateMerchantState.initial()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateMerchantStateInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            List<String> items, int totalItemsCount, bool hasReachedMax)
        data,
    required TResult Function() initial,
    required TResult Function(String userId) emailVerification,
    required TResult Function() loading,
    required TResult Function(Object error, StackTrace st) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            List<String> items, int totalItemsCount, bool hasReachedMax)?
        data,
    TResult? Function()? initial,
    TResult? Function(String userId)? emailVerification,
    TResult? Function()? loading,
    TResult? Function(Object error, StackTrace st)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            List<String> items, int totalItemsCount, bool hasReachedMax)?
        data,
    TResult Function()? initial,
    TResult Function(String userId)? emailVerification,
    TResult Function()? loading,
    TResult Function(Object error, StackTrace st)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateMerchantStateData value) data,
    required TResult Function(CreateMerchantStateInitial value) initial,
    required TResult Function(CreateMerchantStateEmailVerification value)
        emailVerification,
    required TResult Function(CreateMerchantStateLoading value) loading,
    required TResult Function(CreateMerchantStateError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateMerchantStateData value)? data,
    TResult? Function(CreateMerchantStateInitial value)? initial,
    TResult? Function(CreateMerchantStateEmailVerification value)?
        emailVerification,
    TResult? Function(CreateMerchantStateLoading value)? loading,
    TResult? Function(CreateMerchantStateError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateMerchantStateData value)? data,
    TResult Function(CreateMerchantStateInitial value)? initial,
    TResult Function(CreateMerchantStateEmailVerification value)?
        emailVerification,
    TResult Function(CreateMerchantStateLoading value)? loading,
    TResult Function(CreateMerchantStateError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class CreateMerchantStateInitial implements CreateMerchantState {
  const factory CreateMerchantStateInitial() = _$CreateMerchantStateInitial;
}

/// @nodoc
abstract class _$$CreateMerchantStateEmailVerificationCopyWith<$Res> {
  factory _$$CreateMerchantStateEmailVerificationCopyWith(
          _$CreateMerchantStateEmailVerification value,
          $Res Function(_$CreateMerchantStateEmailVerification) then) =
      __$$CreateMerchantStateEmailVerificationCopyWithImpl<$Res>;
  @useResult
  $Res call({String userId});
}

/// @nodoc
class __$$CreateMerchantStateEmailVerificationCopyWithImpl<$Res>
    extends _$CreateMerchantStateCopyWithImpl<$Res,
        _$CreateMerchantStateEmailVerification>
    implements _$$CreateMerchantStateEmailVerificationCopyWith<$Res> {
  __$$CreateMerchantStateEmailVerificationCopyWithImpl(
      _$CreateMerchantStateEmailVerification _value,
      $Res Function(_$CreateMerchantStateEmailVerification) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
  }) {
    return _then(_$CreateMerchantStateEmailVerification(
      null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CreateMerchantStateEmailVerification
    implements CreateMerchantStateEmailVerification {
  const _$CreateMerchantStateEmailVerification(this.userId);

  @override
  final String userId;

  @override
  String toString() {
    return 'CreateMerchantState.emailVerification(userId: $userId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateMerchantStateEmailVerification &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateMerchantStateEmailVerificationCopyWith<
          _$CreateMerchantStateEmailVerification>
      get copyWith => __$$CreateMerchantStateEmailVerificationCopyWithImpl<
          _$CreateMerchantStateEmailVerification>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            List<String> items, int totalItemsCount, bool hasReachedMax)
        data,
    required TResult Function() initial,
    required TResult Function(String userId) emailVerification,
    required TResult Function() loading,
    required TResult Function(Object error, StackTrace st) error,
  }) {
    return emailVerification(userId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            List<String> items, int totalItemsCount, bool hasReachedMax)?
        data,
    TResult? Function()? initial,
    TResult? Function(String userId)? emailVerification,
    TResult? Function()? loading,
    TResult? Function(Object error, StackTrace st)? error,
  }) {
    return emailVerification?.call(userId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            List<String> items, int totalItemsCount, bool hasReachedMax)?
        data,
    TResult Function()? initial,
    TResult Function(String userId)? emailVerification,
    TResult Function()? loading,
    TResult Function(Object error, StackTrace st)? error,
    required TResult orElse(),
  }) {
    if (emailVerification != null) {
      return emailVerification(userId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateMerchantStateData value) data,
    required TResult Function(CreateMerchantStateInitial value) initial,
    required TResult Function(CreateMerchantStateEmailVerification value)
        emailVerification,
    required TResult Function(CreateMerchantStateLoading value) loading,
    required TResult Function(CreateMerchantStateError value) error,
  }) {
    return emailVerification(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateMerchantStateData value)? data,
    TResult? Function(CreateMerchantStateInitial value)? initial,
    TResult? Function(CreateMerchantStateEmailVerification value)?
        emailVerification,
    TResult? Function(CreateMerchantStateLoading value)? loading,
    TResult? Function(CreateMerchantStateError value)? error,
  }) {
    return emailVerification?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateMerchantStateData value)? data,
    TResult Function(CreateMerchantStateInitial value)? initial,
    TResult Function(CreateMerchantStateEmailVerification value)?
        emailVerification,
    TResult Function(CreateMerchantStateLoading value)? loading,
    TResult Function(CreateMerchantStateError value)? error,
    required TResult orElse(),
  }) {
    if (emailVerification != null) {
      return emailVerification(this);
    }
    return orElse();
  }
}

abstract class CreateMerchantStateEmailVerification
    implements CreateMerchantState {
  const factory CreateMerchantStateEmailVerification(final String userId) =
      _$CreateMerchantStateEmailVerification;

  String get userId;
  @JsonKey(ignore: true)
  _$$CreateMerchantStateEmailVerificationCopyWith<
          _$CreateMerchantStateEmailVerification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CreateMerchantStateLoadingCopyWith<$Res> {
  factory _$$CreateMerchantStateLoadingCopyWith(
          _$CreateMerchantStateLoading value,
          $Res Function(_$CreateMerchantStateLoading) then) =
      __$$CreateMerchantStateLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CreateMerchantStateLoadingCopyWithImpl<$Res>
    extends _$CreateMerchantStateCopyWithImpl<$Res,
        _$CreateMerchantStateLoading>
    implements _$$CreateMerchantStateLoadingCopyWith<$Res> {
  __$$CreateMerchantStateLoadingCopyWithImpl(
      _$CreateMerchantStateLoading _value,
      $Res Function(_$CreateMerchantStateLoading) _then)
      : super(_value, _then);
}

/// @nodoc

class _$CreateMerchantStateLoading implements CreateMerchantStateLoading {
  const _$CreateMerchantStateLoading();

  @override
  String toString() {
    return 'CreateMerchantState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateMerchantStateLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            List<String> items, int totalItemsCount, bool hasReachedMax)
        data,
    required TResult Function() initial,
    required TResult Function(String userId) emailVerification,
    required TResult Function() loading,
    required TResult Function(Object error, StackTrace st) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            List<String> items, int totalItemsCount, bool hasReachedMax)?
        data,
    TResult? Function()? initial,
    TResult? Function(String userId)? emailVerification,
    TResult? Function()? loading,
    TResult? Function(Object error, StackTrace st)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            List<String> items, int totalItemsCount, bool hasReachedMax)?
        data,
    TResult Function()? initial,
    TResult Function(String userId)? emailVerification,
    TResult Function()? loading,
    TResult Function(Object error, StackTrace st)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateMerchantStateData value) data,
    required TResult Function(CreateMerchantStateInitial value) initial,
    required TResult Function(CreateMerchantStateEmailVerification value)
        emailVerification,
    required TResult Function(CreateMerchantStateLoading value) loading,
    required TResult Function(CreateMerchantStateError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateMerchantStateData value)? data,
    TResult? Function(CreateMerchantStateInitial value)? initial,
    TResult? Function(CreateMerchantStateEmailVerification value)?
        emailVerification,
    TResult? Function(CreateMerchantStateLoading value)? loading,
    TResult? Function(CreateMerchantStateError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateMerchantStateData value)? data,
    TResult Function(CreateMerchantStateInitial value)? initial,
    TResult Function(CreateMerchantStateEmailVerification value)?
        emailVerification,
    TResult Function(CreateMerchantStateLoading value)? loading,
    TResult Function(CreateMerchantStateError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class CreateMerchantStateLoading implements CreateMerchantState {
  const factory CreateMerchantStateLoading() = _$CreateMerchantStateLoading;
}

/// @nodoc
abstract class _$$CreateMerchantStateErrorCopyWith<$Res> {
  factory _$$CreateMerchantStateErrorCopyWith(_$CreateMerchantStateError value,
          $Res Function(_$CreateMerchantStateError) then) =
      __$$CreateMerchantStateErrorCopyWithImpl<$Res>;
  @useResult
  $Res call({Object error, StackTrace st});
}

/// @nodoc
class __$$CreateMerchantStateErrorCopyWithImpl<$Res>
    extends _$CreateMerchantStateCopyWithImpl<$Res, _$CreateMerchantStateError>
    implements _$$CreateMerchantStateErrorCopyWith<$Res> {
  __$$CreateMerchantStateErrorCopyWithImpl(_$CreateMerchantStateError _value,
      $Res Function(_$CreateMerchantStateError) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? st = null,
  }) {
    return _then(_$CreateMerchantStateError(
      null == error ? _value.error : error,
      null == st
          ? _value.st
          : st // ignore: cast_nullable_to_non_nullable
              as StackTrace,
    ));
  }
}

/// @nodoc

class _$CreateMerchantStateError implements CreateMerchantStateError {
  const _$CreateMerchantStateError(this.error, this.st);

  @override
  final Object error;
  @override
  final StackTrace st;

  @override
  String toString() {
    return 'CreateMerchantState.error(error: $error, st: $st)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateMerchantStateError &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.st, st) || other.st == st));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(error), st);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateMerchantStateErrorCopyWith<_$CreateMerchantStateError>
      get copyWith =>
          __$$CreateMerchantStateErrorCopyWithImpl<_$CreateMerchantStateError>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            List<String> items, int totalItemsCount, bool hasReachedMax)
        data,
    required TResult Function() initial,
    required TResult Function(String userId) emailVerification,
    required TResult Function() loading,
    required TResult Function(Object error, StackTrace st) error,
  }) {
    return error(this.error, st);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            List<String> items, int totalItemsCount, bool hasReachedMax)?
        data,
    TResult? Function()? initial,
    TResult? Function(String userId)? emailVerification,
    TResult? Function()? loading,
    TResult? Function(Object error, StackTrace st)? error,
  }) {
    return error?.call(this.error, st);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            List<String> items, int totalItemsCount, bool hasReachedMax)?
        data,
    TResult Function()? initial,
    TResult Function(String userId)? emailVerification,
    TResult Function()? loading,
    TResult Function(Object error, StackTrace st)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this.error, st);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateMerchantStateData value) data,
    required TResult Function(CreateMerchantStateInitial value) initial,
    required TResult Function(CreateMerchantStateEmailVerification value)
        emailVerification,
    required TResult Function(CreateMerchantStateLoading value) loading,
    required TResult Function(CreateMerchantStateError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateMerchantStateData value)? data,
    TResult? Function(CreateMerchantStateInitial value)? initial,
    TResult? Function(CreateMerchantStateEmailVerification value)?
        emailVerification,
    TResult? Function(CreateMerchantStateLoading value)? loading,
    TResult? Function(CreateMerchantStateError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateMerchantStateData value)? data,
    TResult Function(CreateMerchantStateInitial value)? initial,
    TResult Function(CreateMerchantStateEmailVerification value)?
        emailVerification,
    TResult Function(CreateMerchantStateLoading value)? loading,
    TResult Function(CreateMerchantStateError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class CreateMerchantStateError implements CreateMerchantState {
  const factory CreateMerchantStateError(
      final Object error, final StackTrace st) = _$CreateMerchantStateError;

  Object get error;
  StackTrace get st;
  @JsonKey(ignore: true)
  _$$CreateMerchantStateErrorCopyWith<_$CreateMerchantStateError>
      get copyWith => throw _privateConstructorUsedError;
}
