// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppParamState {
  ///
  double get currentZoom => throw _privateConstructorUsedError;
  int get currentPaddingIndex => throw _privateConstructorUsedError;

  ///
  int get selectedYear => throw _privateConstructorUsedError;

  ///
  Map<String, List<GeolocModel>> get keepGeolocMap =>
      throw _privateConstructorUsedError;

  /// Create a copy of AppParamState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppParamStateCopyWith<AppParamState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppParamStateCopyWith<$Res> {
  factory $AppParamStateCopyWith(
          AppParamState value, $Res Function(AppParamState) then) =
      _$AppParamStateCopyWithImpl<$Res, AppParamState>;
  @useResult
  $Res call(
      {double currentZoom,
      int currentPaddingIndex,
      int selectedYear,
      Map<String, List<GeolocModel>> keepGeolocMap});
}

/// @nodoc
class _$AppParamStateCopyWithImpl<$Res, $Val extends AppParamState>
    implements $AppParamStateCopyWith<$Res> {
  _$AppParamStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppParamState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentZoom = null,
    Object? currentPaddingIndex = null,
    Object? selectedYear = null,
    Object? keepGeolocMap = null,
  }) {
    return _then(_value.copyWith(
      currentZoom: null == currentZoom
          ? _value.currentZoom
          : currentZoom // ignore: cast_nullable_to_non_nullable
              as double,
      currentPaddingIndex: null == currentPaddingIndex
          ? _value.currentPaddingIndex
          : currentPaddingIndex // ignore: cast_nullable_to_non_nullable
              as int,
      selectedYear: null == selectedYear
          ? _value.selectedYear
          : selectedYear // ignore: cast_nullable_to_non_nullable
              as int,
      keepGeolocMap: null == keepGeolocMap
          ? _value.keepGeolocMap
          : keepGeolocMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<GeolocModel>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppParamStateImplCopyWith<$Res>
    implements $AppParamStateCopyWith<$Res> {
  factory _$$AppParamStateImplCopyWith(
          _$AppParamStateImpl value, $Res Function(_$AppParamStateImpl) then) =
      __$$AppParamStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double currentZoom,
      int currentPaddingIndex,
      int selectedYear,
      Map<String, List<GeolocModel>> keepGeolocMap});
}

/// @nodoc
class __$$AppParamStateImplCopyWithImpl<$Res>
    extends _$AppParamStateCopyWithImpl<$Res, _$AppParamStateImpl>
    implements _$$AppParamStateImplCopyWith<$Res> {
  __$$AppParamStateImplCopyWithImpl(
      _$AppParamStateImpl _value, $Res Function(_$AppParamStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppParamState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentZoom = null,
    Object? currentPaddingIndex = null,
    Object? selectedYear = null,
    Object? keepGeolocMap = null,
  }) {
    return _then(_$AppParamStateImpl(
      currentZoom: null == currentZoom
          ? _value.currentZoom
          : currentZoom // ignore: cast_nullable_to_non_nullable
              as double,
      currentPaddingIndex: null == currentPaddingIndex
          ? _value.currentPaddingIndex
          : currentPaddingIndex // ignore: cast_nullable_to_non_nullable
              as int,
      selectedYear: null == selectedYear
          ? _value.selectedYear
          : selectedYear // ignore: cast_nullable_to_non_nullable
              as int,
      keepGeolocMap: null == keepGeolocMap
          ? _value._keepGeolocMap
          : keepGeolocMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<GeolocModel>>,
    ));
  }
}

/// @nodoc

class _$AppParamStateImpl implements _AppParamState {
  const _$AppParamStateImpl(
      {this.currentZoom = 0,
      this.currentPaddingIndex = 5,
      this.selectedYear = 0,
      final Map<String, List<GeolocModel>> keepGeolocMap =
          const <String, List<GeolocModel>>{}})
      : _keepGeolocMap = keepGeolocMap;

  ///
  @override
  @JsonKey()
  final double currentZoom;
  @override
  @JsonKey()
  final int currentPaddingIndex;

  ///
  @override
  @JsonKey()
  final int selectedYear;

  ///
  final Map<String, List<GeolocModel>> _keepGeolocMap;

  ///
  @override
  @JsonKey()
  Map<String, List<GeolocModel>> get keepGeolocMap {
    if (_keepGeolocMap is EqualUnmodifiableMapView) return _keepGeolocMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_keepGeolocMap);
  }

  @override
  String toString() {
    return 'AppParamState(currentZoom: $currentZoom, currentPaddingIndex: $currentPaddingIndex, selectedYear: $selectedYear, keepGeolocMap: $keepGeolocMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppParamStateImpl &&
            (identical(other.currentZoom, currentZoom) ||
                other.currentZoom == currentZoom) &&
            (identical(other.currentPaddingIndex, currentPaddingIndex) ||
                other.currentPaddingIndex == currentPaddingIndex) &&
            (identical(other.selectedYear, selectedYear) ||
                other.selectedYear == selectedYear) &&
            const DeepCollectionEquality()
                .equals(other._keepGeolocMap, _keepGeolocMap));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentZoom, currentPaddingIndex,
      selectedYear, const DeepCollectionEquality().hash(_keepGeolocMap));

  /// Create a copy of AppParamState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppParamStateImplCopyWith<_$AppParamStateImpl> get copyWith =>
      __$$AppParamStateImplCopyWithImpl<_$AppParamStateImpl>(this, _$identity);
}

abstract class _AppParamState implements AppParamState {
  const factory _AppParamState(
          {final double currentZoom,
          final int currentPaddingIndex,
          final int selectedYear,
          final Map<String, List<GeolocModel>> keepGeolocMap}) =
      _$AppParamStateImpl;

  ///
  @override
  double get currentZoom;
  @override
  int get currentPaddingIndex;

  ///
  @override
  int get selectedYear;

  ///
  @override
  Map<String, List<GeolocModel>> get keepGeolocMap;

  /// Create a copy of AppParamState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppParamStateImplCopyWith<_$AppParamStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
