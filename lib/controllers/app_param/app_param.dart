import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/geoloc_model.dart';

part 'app_param.freezed.dart';

part 'app_param.g.dart';

@freezed
class AppParamState with _$AppParamState {
  const factory AppParamState({
    ///
    @Default(0) double currentZoom,
    @Default(5) int currentPaddingIndex,

    ///
    @Default(0) int selectedYear,
    @Default(<dynamic>[]) List<String> selectedDaysList,

    ///
    @Default(<String, List<GeolocModel>>{}) Map<String, List<GeolocModel>> keepGeolocMap,
    @Default(<String>[]) List<String> keepHolidayList,
  }) = _AppParamState;
}

@Riverpod(keepAlive: true)
class AppParam extends _$AppParam {
  ///
  @override
  AppParamState build() => AppParamState(selectedYear: DateTime.now().year);

  ///
  void setCurrentZoom({required double zoom}) => state = state.copyWith(currentZoom: zoom);

  ///
  void setSelectedYear({required int year}) => state = state.copyWith(selectedYear: year);

  ///
  void clearSelectedDaysList() => state = state.copyWith(selectedDaysList: <String>[]);

  ///
  void setSelectedDaysList({required String day}) {
    final List<String> list = <String>[...state.selectedDaysList];

    if (list.contains(day)) {
      list.remove(day);
    } else {
      list.add(day);
    }

    state = state.copyWith(selectedDaysList: list);
  }

  ///
  void setKeepGeolocMap({required Map<String, List<GeolocModel>> map}) => state = state.copyWith(keepGeolocMap: map);

  ///
  void setKeepHolidayList({required List<String> list}) => state = state.copyWith(keepHolidayList: list);
}
