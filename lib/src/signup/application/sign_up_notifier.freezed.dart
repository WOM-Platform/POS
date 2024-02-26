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
abstract class _$$SignUpStateDataImplCopyWith<$Res> {
  factory _$$SignUpStateDataImplCopyWith(_$SignUpStateDataImpl value,
          $Res Function(_$SignUpStateDataImpl) then) =
      __$$SignUpStateDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<String> items, int totalItemsCount, bool hasReachedMax});
}

/// @nodoc
class __$$SignUpStateDataImplCopyWithImpl<$Res>
    extends _$SignUpStateCopyWithImpl<$Res, _$SignUpStateDataImpl>
    implements _$$SignUpStateDataImplCopyWith<$Res> {
  __$$SignUpStateDataImplCopyWithImpl(
      _$SignUpStateDataImpl _value, $Res Function(_$SignUpStateDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? totalItemsCount = null,
    Object? hasReachedMax = null,
  }) {
    return _then(_$SignUpStateDataImpl(
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

class _$SignUpStateDataImpl implements SignUpStateData {
  const _$SignUpStateDataImpl(final List<String> items, this.totalItemsCount,
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
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignUpStateDataImpl &&
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
  _$$SignUpStateDataImplCopyWith<_$SignUpStateDataImpl> get copyWith =>
      __$$SignUpStateDataImplCopyWithImpl<_$SignUpStateDataImpl>(
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
      {final bool hasReachedMax}) = _$SignUpStateDataImpl;

  List<String> get items;
  int get totalItemsCount;
  bool get hasReachedMax;
  @JsonKey(ignore: true)
  _$$SignUpStateDataImplCopyWith<_$SignUpStateDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SignUpStateInitialImplCopyWith<$Res> {
  factory _$$SignUpStateInitialImplCopyWith(_$SignUpStateInitialImpl value,
          $Res Function(_$SignUpStateInitialImpl) then) =
      __$$SignUpStateInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SignUpStateInitialImplCopyWithImpl<$Res>
    extends _$SignUpStateCopyWithImpl<$Res, _$SignUpStateInitialImpl>
    implements _$$SignUpStateInitialImplCopyWith<$Res> {
  __$$SignUpStateInitialImplCopyWithImpl(_$SignUpStateInitialImpl _value,
      $Res Function(_$SignUpStateInitialImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$SignUpStateInitialImpl implements SignUpStateInitial {
  const _$SignUpStateInitialImpl();

  @override
  String toString() {
    return 'SignUpState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SignUpStateInitialImpl);
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
  const factory SignUpStateInitial() = _$SignUpStateInitialImpl;
}

/// @nodoc
abstract class _$$SignUpStateEmailVerificationImplCopyWith<$Res> {
  factory _$$SignUpStateEmailVerificationImplCopyWith(
          _$SignUpStateEmailVerificationImpl value,
          $Res Function(_$SignUpStateEmailVerificationImpl) then) =
      __$$SignUpStateEmailVerificationImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String userId});
}

/// @nodoc
class __$$SignUpStateEmailVerificationImplCopyWithImpl<$Res>
    extends _$SignUpStateCopyWithImpl<$Res, _$SignUpStateEmailVerificationImpl>
    implements _$$SignUpStateEmailVerificationImplCopyWith<$Res> {
  __$$SignUpStateEmailVerificationImplCopyWithImpl(
      _$SignUpStateEmailVerificationImpl _value,
      $Res Function(_$SignUpStateEmailVerificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
  }) {
    return _then(_$SignUpStateEmailVerificationImpl(
      null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SignUpStateEmailVerificationImpl
    implements SignUpStateEmailVerification {
  const _$SignUpStateEmailVerificationImpl(this.userId);

  @override
  final String userId;

  @override
  String toString() {
    return 'SignUpState.emailVerification(userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignUpStateEmailVerificationImpl &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SignUpStateEmailVerificationImplCopyWith<
          _$SignUpStateEmailVerificationImpl>
      get copyWith => __$$SignUpStateEmailVerificationImplCopyWithImpl<
          _$SignUpStateEmailVerificationImpl>(this, _$identity);

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
      _$SignUpStateEmailVerificationImpl;

  String get userId;
  @JsonKey(ignore: true)
  _$$SignUpStateEmailVerificationImplCopyWith<
          _$SignUpStateEmailVerificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SignUpStateLoadingImplCopyWith<$Res> {
  factory _$$SignUpStateLoadingImplCopyWith(_$SignUpStateLoadingImpl value,
          $Res Function(_$SignUpStateLoadingImpl) then) =
      __$$SignUpStateLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SignUpStateLoadingImplCopyWithImpl<$Res>
    extends _$SignUpStateCopyWithImpl<$Res, _$SignUpStateLoadingImpl>
    implements _$$SignUpStateLoadingImplCopyWith<$Res> {
  __$$SignUpStateLoadingImplCopyWithImpl(_$SignUpStateLoadingImpl _value,
      $Res Function(_$SignUpStateLoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$SignUpStateLoadingImpl implements SignUpStateLoading {
  const _$SignUpStateLoadingImpl();

  @override
  String toString() {
    return 'SignUpState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SignUpStateLoadingImpl);
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
  const factory SignUpStateLoading() = _$SignUpStateLoadingImpl;
}

/// @nodoc
abstract class _$$SignUpStateErrorImplCopyWith<$Res> {
  factory _$$SignUpStateErrorImplCopyWith(_$SignUpStateErrorImpl value,
          $Res Function(_$SignUpStateErrorImpl) then) =
      __$$SignUpStateErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Object error, StackTrace st});
}

/// @nodoc
class __$$SignUpStateErrorImplCopyWithImpl<$Res>
    extends _$SignUpStateCopyWithImpl<$Res, _$SignUpStateErrorImpl>
    implements _$$SignUpStateErrorImplCopyWith<$Res> {
  __$$SignUpStateErrorImplCopyWithImpl(_$SignUpStateErrorImpl _value,
      $Res Function(_$SignUpStateErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? st = null,
  }) {
    return _then(_$SignUpStateErrorImpl(
      null == error ? _value.error : error,
      null == st
          ? _value.st
          : st // ignore: cast_nullable_to_non_nullable
              as StackTrace,
    ));
  }
}

/// @nodoc

class _$SignUpStateErrorImpl implements SignUpStateError {
  const _$SignUpStateErrorImpl(this.error, this.st);

  @override
  final Object error;
  @override
  final StackTrace st;

  @override
  String toString() {
    return 'SignUpState.error(error: $error, st: $st)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignUpStateErrorImpl &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.st, st) || other.st == st));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(error), st);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SignUpStateErrorImplCopyWith<_$SignUpStateErrorImpl> get copyWith =>
      __$$SignUpStateErrorImplCopyWithImpl<_$SignUpStateErrorImpl>(
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
      _$SignUpStateErrorImpl;

  Object get error;
  StackTrace get st;
  @JsonKey(ignore: true)
  _$$SignUpStateErrorImplCopyWith<_$SignUpStateErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
