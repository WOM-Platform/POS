// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sign_up_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SignUpState {
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
    required TResult Function(SignUpStateData value) data,
    required TResult Function(SignUpStateInitial value) initial,
    required TResult Function(SignUpStateEmailVerification value)
        emailVerification,
    required TResult Function(SignUpStateLoading value) loading,
    required TResult Function(SignUpStateError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignUpStateData value)? data,
    TResult? Function(SignUpStateInitial value)? initial,
    TResult? Function(SignUpStateEmailVerification value)? emailVerification,
    TResult? Function(SignUpStateLoading value)? loading,
    TResult? Function(SignUpStateError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignUpStateData value)? data,
    TResult Function(SignUpStateInitial value)? initial,
    TResult Function(SignUpStateEmailVerification value)? emailVerification,
    TResult Function(SignUpStateLoading value)? loading,
    TResult Function(SignUpStateError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignUpStateCopyWith<$Res> {
  factory $SignUpStateCopyWith(
          SignUpState value, $Res Function(SignUpState) then) =
      _$SignUpStateCopyWithImpl<$Res, SignUpState>;
}

/// @nodoc
class _$SignUpStateCopyWithImpl<$Res, $Val extends SignUpState>
    implements $SignUpStateCopyWith<$Res> {
  _$SignUpStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$SignUpStateDataCopyWith<$Res> {
  factory _$$SignUpStateDataCopyWith(
          _$SignUpStateData value, $Res Function(_$SignUpStateData) then) =
      __$$SignUpStateDataCopyWithImpl<$Res>;
  @useResult
  $Res call({List<String> items, int totalItemsCount, bool hasReachedMax});
}

/// @nodoc
class __$$SignUpStateDataCopyWithImpl<$Res>
    extends _$SignUpStateCopyWithImpl<$Res, _$SignUpStateData>
    implements _$$SignUpStateDataCopyWith<$Res> {
  __$$SignUpStateDataCopyWithImpl(
      _$SignUpStateData _value, $Res Function(_$SignUpStateData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? totalItemsCount = null,
    Object? hasReachedMax = null,
  }) {
    return _then(_$SignUpStateData(
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

class _$SignUpStateData implements SignUpStateData {
  const _$SignUpStateData(final List<String> items, this.totalItemsCount,
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
    return 'SignUpState.data(items: $items, totalItemsCount: $totalItemsCount, hasReachedMax: $hasReachedMax)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignUpStateData &&
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
  _$$SignUpStateDataCopyWith<_$SignUpStateData> get copyWith =>
      __$$SignUpStateDataCopyWithImpl<_$SignUpStateData>(this, _$identity);

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
    required TResult Function(SignUpStateData value) data,
    required TResult Function(SignUpStateInitial value) initial,
    required TResult Function(SignUpStateEmailVerification value)
        emailVerification,
    required TResult Function(SignUpStateLoading value) loading,
    required TResult Function(SignUpStateError value) error,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignUpStateData value)? data,
    TResult? Function(SignUpStateInitial value)? initial,
    TResult? Function(SignUpStateEmailVerification value)? emailVerification,
    TResult? Function(SignUpStateLoading value)? loading,
    TResult? Function(SignUpStateError value)? error,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignUpStateData value)? data,
    TResult Function(SignUpStateInitial value)? initial,
    TResult Function(SignUpStateEmailVerification value)? emailVerification,
    TResult Function(SignUpStateLoading value)? loading,
    TResult Function(SignUpStateError value)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class SignUpStateData implements SignUpState {
  const factory SignUpStateData(
      final List<String> items, final int totalItemsCount,
      {final bool hasReachedMax}) = _$SignUpStateData;

  List<String> get items;
  int get totalItemsCount;
  bool get hasReachedMax;
  @JsonKey(ignore: true)
  _$$SignUpStateDataCopyWith<_$SignUpStateData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SignUpStateInitialCopyWith<$Res> {
  factory _$$SignUpStateInitialCopyWith(_$SignUpStateInitial value,
          $Res Function(_$SignUpStateInitial) then) =
      __$$SignUpStateInitialCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SignUpStateInitialCopyWithImpl<$Res>
    extends _$SignUpStateCopyWithImpl<$Res, _$SignUpStateInitial>
    implements _$$SignUpStateInitialCopyWith<$Res> {
  __$$SignUpStateInitialCopyWithImpl(
      _$SignUpStateInitial _value, $Res Function(_$SignUpStateInitial) _then)
      : super(_value, _then);
}

/// @nodoc

class _$SignUpStateInitial implements SignUpStateInitial {
  const _$SignUpStateInitial();

  @override
  String toString() {
    return 'SignUpState.initial()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SignUpStateInitial);
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
    required TResult Function(SignUpStateData value) data,
    required TResult Function(SignUpStateInitial value) initial,
    required TResult Function(SignUpStateEmailVerification value)
        emailVerification,
    required TResult Function(SignUpStateLoading value) loading,
    required TResult Function(SignUpStateError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignUpStateData value)? data,
    TResult? Function(SignUpStateInitial value)? initial,
    TResult? Function(SignUpStateEmailVerification value)? emailVerification,
    TResult? Function(SignUpStateLoading value)? loading,
    TResult? Function(SignUpStateError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignUpStateData value)? data,
    TResult Function(SignUpStateInitial value)? initial,
    TResult Function(SignUpStateEmailVerification value)? emailVerification,
    TResult Function(SignUpStateLoading value)? loading,
    TResult Function(SignUpStateError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class SignUpStateInitial implements SignUpState {
  const factory SignUpStateInitial() = _$SignUpStateInitial;
}

/// @nodoc
abstract class _$$SignUpStateEmailVerificationCopyWith<$Res> {
  factory _$$SignUpStateEmailVerificationCopyWith(
          _$SignUpStateEmailVerification value,
          $Res Function(_$SignUpStateEmailVerification) then) =
      __$$SignUpStateEmailVerificationCopyWithImpl<$Res>;
  @useResult
  $Res call({String userId});
}

/// @nodoc
class __$$SignUpStateEmailVerificationCopyWithImpl<$Res>
    extends _$SignUpStateCopyWithImpl<$Res, _$SignUpStateEmailVerification>
    implements _$$SignUpStateEmailVerificationCopyWith<$Res> {
  __$$SignUpStateEmailVerificationCopyWithImpl(
      _$SignUpStateEmailVerification _value,
      $Res Function(_$SignUpStateEmailVerification) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
  }) {
    return _then(_$SignUpStateEmailVerification(
      null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SignUpStateEmailVerification implements SignUpStateEmailVerification {
  const _$SignUpStateEmailVerification(this.userId);

  @override
  final String userId;

  @override
  String toString() {
    return 'SignUpState.emailVerification(userId: $userId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignUpStateEmailVerification &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SignUpStateEmailVerificationCopyWith<_$SignUpStateEmailVerification>
      get copyWith => __$$SignUpStateEmailVerificationCopyWithImpl<
          _$SignUpStateEmailVerification>(this, _$identity);

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
    required TResult Function(SignUpStateData value) data,
    required TResult Function(SignUpStateInitial value) initial,
    required TResult Function(SignUpStateEmailVerification value)
        emailVerification,
    required TResult Function(SignUpStateLoading value) loading,
    required TResult Function(SignUpStateError value) error,
  }) {
    return emailVerification(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignUpStateData value)? data,
    TResult? Function(SignUpStateInitial value)? initial,
    TResult? Function(SignUpStateEmailVerification value)? emailVerification,
    TResult? Function(SignUpStateLoading value)? loading,
    TResult? Function(SignUpStateError value)? error,
  }) {
    return emailVerification?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignUpStateData value)? data,
    TResult Function(SignUpStateInitial value)? initial,
    TResult Function(SignUpStateEmailVerification value)? emailVerification,
    TResult Function(SignUpStateLoading value)? loading,
    TResult Function(SignUpStateError value)? error,
    required TResult orElse(),
  }) {
    if (emailVerification != null) {
      return emailVerification(this);
    }
    return orElse();
  }
}

abstract class SignUpStateEmailVerification implements SignUpState {
  const factory SignUpStateEmailVerification(final String userId) =
      _$SignUpStateEmailVerification;

  String get userId;
  @JsonKey(ignore: true)
  _$$SignUpStateEmailVerificationCopyWith<_$SignUpStateEmailVerification>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SignUpStateLoadingCopyWith<$Res> {
  factory _$$SignUpStateLoadingCopyWith(_$SignUpStateLoading value,
          $Res Function(_$SignUpStateLoading) then) =
      __$$SignUpStateLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SignUpStateLoadingCopyWithImpl<$Res>
    extends _$SignUpStateCopyWithImpl<$Res, _$SignUpStateLoading>
    implements _$$SignUpStateLoadingCopyWith<$Res> {
  __$$SignUpStateLoadingCopyWithImpl(
      _$SignUpStateLoading _value, $Res Function(_$SignUpStateLoading) _then)
      : super(_value, _then);
}

/// @nodoc

class _$SignUpStateLoading implements SignUpStateLoading {
  const _$SignUpStateLoading();

  @override
  String toString() {
    return 'SignUpState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SignUpStateLoading);
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
    required TResult Function(SignUpStateData value) data,
    required TResult Function(SignUpStateInitial value) initial,
    required TResult Function(SignUpStateEmailVerification value)
        emailVerification,
    required TResult Function(SignUpStateLoading value) loading,
    required TResult Function(SignUpStateError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignUpStateData value)? data,
    TResult? Function(SignUpStateInitial value)? initial,
    TResult? Function(SignUpStateEmailVerification value)? emailVerification,
    TResult? Function(SignUpStateLoading value)? loading,
    TResult? Function(SignUpStateError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignUpStateData value)? data,
    TResult Function(SignUpStateInitial value)? initial,
    TResult Function(SignUpStateEmailVerification value)? emailVerification,
    TResult Function(SignUpStateLoading value)? loading,
    TResult Function(SignUpStateError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class SignUpStateLoading implements SignUpState {
  const factory SignUpStateLoading() = _$SignUpStateLoading;
}

/// @nodoc
abstract class _$$SignUpStateErrorCopyWith<$Res> {
  factory _$$SignUpStateErrorCopyWith(
          _$SignUpStateError value, $Res Function(_$SignUpStateError) then) =
      __$$SignUpStateErrorCopyWithImpl<$Res>;
  @useResult
  $Res call({Object error, StackTrace st});
}

/// @nodoc
class __$$SignUpStateErrorCopyWithImpl<$Res>
    extends _$SignUpStateCopyWithImpl<$Res, _$SignUpStateError>
    implements _$$SignUpStateErrorCopyWith<$Res> {
  __$$SignUpStateErrorCopyWithImpl(
      _$SignUpStateError _value, $Res Function(_$SignUpStateError) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? st = null,
  }) {
    return _then(_$SignUpStateError(
      null == error ? _value.error : error,
      null == st
          ? _value.st
          : st // ignore: cast_nullable_to_non_nullable
              as StackTrace,
    ));
  }
}

/// @nodoc

class _$SignUpStateError implements SignUpStateError {
  const _$SignUpStateError(this.error, this.st);

  @override
  final Object error;
  @override
  final StackTrace st;

  @override
  String toString() {
    return 'SignUpState.error(error: $error, st: $st)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignUpStateError &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.st, st) || other.st == st));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(error), st);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SignUpStateErrorCopyWith<_$SignUpStateError> get copyWith =>
      __$$SignUpStateErrorCopyWithImpl<_$SignUpStateError>(this, _$identity);

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
    required TResult Function(SignUpStateData value) data,
    required TResult Function(SignUpStateInitial value) initial,
    required TResult Function(SignUpStateEmailVerification value)
        emailVerification,
    required TResult Function(SignUpStateLoading value) loading,
    required TResult Function(SignUpStateError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignUpStateData value)? data,
    TResult? Function(SignUpStateInitial value)? initial,
    TResult? Function(SignUpStateEmailVerification value)? emailVerification,
    TResult? Function(SignUpStateLoading value)? loading,
    TResult? Function(SignUpStateError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignUpStateData value)? data,
    TResult Function(SignUpStateInitial value)? initial,
    TResult Function(SignUpStateEmailVerification value)? emailVerification,
    TResult Function(SignUpStateLoading value)? loading,
    TResult Function(SignUpStateError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class SignUpStateError implements SignUpState {
  const factory SignUpStateError(final Object error, final StackTrace st) =
      _$SignUpStateError;

  Object get error;
  StackTrace get st;
  @JsonKey(ignore: true)
  _$$SignUpStateErrorCopyWith<_$SignUpStateError> get copyWith =>
      throw _privateConstructorUsedError;
}
