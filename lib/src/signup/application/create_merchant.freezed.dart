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
abstract class _$$CreateMerchantStateDataImplCopyWith<$Res> {
  factory _$$CreateMerchantStateDataImplCopyWith(
          _$CreateMerchantStateDataImpl value,
          $Res Function(_$CreateMerchantStateDataImpl) then) =
      __$$CreateMerchantStateDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<String> items, int totalItemsCount, bool hasReachedMax});
}

/// @nodoc
class __$$CreateMerchantStateDataImplCopyWithImpl<$Res>
    extends _$CreateMerchantStateCopyWithImpl<$Res,
        _$CreateMerchantStateDataImpl>
    implements _$$CreateMerchantStateDataImplCopyWith<$Res> {
  __$$CreateMerchantStateDataImplCopyWithImpl(
      _$CreateMerchantStateDataImpl _value,
      $Res Function(_$CreateMerchantStateDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? totalItemsCount = null,
    Object? hasReachedMax = null,
  }) {
    return _then(_$CreateMerchantStateDataImpl(
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

class _$CreateMerchantStateDataImpl implements CreateMerchantStateData {
  const _$CreateMerchantStateDataImpl(
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
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateMerchantStateDataImpl &&
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
  _$$CreateMerchantStateDataImplCopyWith<_$CreateMerchantStateDataImpl>
      get copyWith => __$$CreateMerchantStateDataImplCopyWithImpl<
          _$CreateMerchantStateDataImpl>(this, _$identity);

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
      {final bool hasReachedMax}) = _$CreateMerchantStateDataImpl;

  List<String> get items;
  int get totalItemsCount;
  bool get hasReachedMax;
  @JsonKey(ignore: true)
  _$$CreateMerchantStateDataImplCopyWith<_$CreateMerchantStateDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CreateMerchantStateInitialImplCopyWith<$Res> {
  factory _$$CreateMerchantStateInitialImplCopyWith(
          _$CreateMerchantStateInitialImpl value,
          $Res Function(_$CreateMerchantStateInitialImpl) then) =
      __$$CreateMerchantStateInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CreateMerchantStateInitialImplCopyWithImpl<$Res>
    extends _$CreateMerchantStateCopyWithImpl<$Res,
        _$CreateMerchantStateInitialImpl>
    implements _$$CreateMerchantStateInitialImplCopyWith<$Res> {
  __$$CreateMerchantStateInitialImplCopyWithImpl(
      _$CreateMerchantStateInitialImpl _value,
      $Res Function(_$CreateMerchantStateInitialImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$CreateMerchantStateInitialImpl implements CreateMerchantStateInitial {
  const _$CreateMerchantStateInitialImpl();

  @override
  String toString() {
    return 'CreateMerchantState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateMerchantStateInitialImpl);
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
  const factory CreateMerchantStateInitial() = _$CreateMerchantStateInitialImpl;
}

/// @nodoc
abstract class _$$CreateMerchantStateEmailVerificationImplCopyWith<$Res> {
  factory _$$CreateMerchantStateEmailVerificationImplCopyWith(
          _$CreateMerchantStateEmailVerificationImpl value,
          $Res Function(_$CreateMerchantStateEmailVerificationImpl) then) =
      __$$CreateMerchantStateEmailVerificationImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String userId});
}

/// @nodoc
class __$$CreateMerchantStateEmailVerificationImplCopyWithImpl<$Res>
    extends _$CreateMerchantStateCopyWithImpl<$Res,
        _$CreateMerchantStateEmailVerificationImpl>
    implements _$$CreateMerchantStateEmailVerificationImplCopyWith<$Res> {
  __$$CreateMerchantStateEmailVerificationImplCopyWithImpl(
      _$CreateMerchantStateEmailVerificationImpl _value,
      $Res Function(_$CreateMerchantStateEmailVerificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
  }) {
    return _then(_$CreateMerchantStateEmailVerificationImpl(
      null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CreateMerchantStateEmailVerificationImpl
    implements CreateMerchantStateEmailVerification {
  const _$CreateMerchantStateEmailVerificationImpl(this.userId);

  @override
  final String userId;

  @override
  String toString() {
    return 'CreateMerchantState.emailVerification(userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateMerchantStateEmailVerificationImpl &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateMerchantStateEmailVerificationImplCopyWith<
          _$CreateMerchantStateEmailVerificationImpl>
      get copyWith => __$$CreateMerchantStateEmailVerificationImplCopyWithImpl<
          _$CreateMerchantStateEmailVerificationImpl>(this, _$identity);

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
      _$CreateMerchantStateEmailVerificationImpl;

  String get userId;
  @JsonKey(ignore: true)
  _$$CreateMerchantStateEmailVerificationImplCopyWith<
          _$CreateMerchantStateEmailVerificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CreateMerchantStateLoadingImplCopyWith<$Res> {
  factory _$$CreateMerchantStateLoadingImplCopyWith(
          _$CreateMerchantStateLoadingImpl value,
          $Res Function(_$CreateMerchantStateLoadingImpl) then) =
      __$$CreateMerchantStateLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CreateMerchantStateLoadingImplCopyWithImpl<$Res>
    extends _$CreateMerchantStateCopyWithImpl<$Res,
        _$CreateMerchantStateLoadingImpl>
    implements _$$CreateMerchantStateLoadingImplCopyWith<$Res> {
  __$$CreateMerchantStateLoadingImplCopyWithImpl(
      _$CreateMerchantStateLoadingImpl _value,
      $Res Function(_$CreateMerchantStateLoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$CreateMerchantStateLoadingImpl implements CreateMerchantStateLoading {
  const _$CreateMerchantStateLoadingImpl();

  @override
  String toString() {
    return 'CreateMerchantState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateMerchantStateLoadingImpl);
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
  const factory CreateMerchantStateLoading() = _$CreateMerchantStateLoadingImpl;
}

/// @nodoc
abstract class _$$CreateMerchantStateErrorImplCopyWith<$Res> {
  factory _$$CreateMerchantStateErrorImplCopyWith(
          _$CreateMerchantStateErrorImpl value,
          $Res Function(_$CreateMerchantStateErrorImpl) then) =
      __$$CreateMerchantStateErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Object error, StackTrace st});
}

/// @nodoc
class __$$CreateMerchantStateErrorImplCopyWithImpl<$Res>
    extends _$CreateMerchantStateCopyWithImpl<$Res,
        _$CreateMerchantStateErrorImpl>
    implements _$$CreateMerchantStateErrorImplCopyWith<$Res> {
  __$$CreateMerchantStateErrorImplCopyWithImpl(
      _$CreateMerchantStateErrorImpl _value,
      $Res Function(_$CreateMerchantStateErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? st = null,
  }) {
    return _then(_$CreateMerchantStateErrorImpl(
      null == error ? _value.error : error,
      null == st
          ? _value.st
          : st // ignore: cast_nullable_to_non_nullable
              as StackTrace,
    ));
  }
}

/// @nodoc

class _$CreateMerchantStateErrorImpl implements CreateMerchantStateError {
  const _$CreateMerchantStateErrorImpl(this.error, this.st);

  @override
  final Object error;
  @override
  final StackTrace st;

  @override
  String toString() {
    return 'CreateMerchantState.error(error: $error, st: $st)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateMerchantStateErrorImpl &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.st, st) || other.st == st));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(error), st);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateMerchantStateErrorImplCopyWith<_$CreateMerchantStateErrorImpl>
      get copyWith => __$$CreateMerchantStateErrorImplCopyWithImpl<
          _$CreateMerchantStateErrorImpl>(this, _$identity);

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
      final Object error, final StackTrace st) = _$CreateMerchantStateErrorImpl;

  Object get error;
  StackTrace get st;
  @JsonKey(ignore: true)
  _$$CreateMerchantStateErrorImplCopyWith<_$CreateMerchantStateErrorImpl>
      get copyWith => throw _privateConstructorUsedError;
}
