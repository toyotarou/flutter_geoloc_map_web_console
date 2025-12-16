import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../const/const.dart';
import '../controllers/controllers_mixin.dart';
import '../extensions/extensions.dart';
import '../models/geoloc_model.dart';
import '../models/municipal_model.dart';
import '../utility/map_functions.dart';
import '../utility/tile_provider.dart';
import '../utility/utility.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({
    super.key,
    required this.tokyoMunicipalList,
    required this.tokyoMunicipalMap,
    required this.geolocMap,
    required this.holidayList,
  });

  final List<MunicipalModel> tokyoMunicipalList;
  final Map<String, MunicipalModel> tokyoMunicipalMap;
  final Map<String, List<GeolocModel>> geolocMap;
  final List<String> holidayList;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with ControllersMixin<HomeScreen> {
  List<List<List<List<double>>>> allPolygons = <List<List<List<double>>>>[];

  bool isLoading = false;

  final List<double> latList = <double>[];
  final List<double> lngList = <double>[];

  double minLat = 0.0;
  double maxLat = 0.0;
  double minLng = 0.0;
  double maxLng = 0.0;

  final MapController mapController = MapController();

  double? currentZoom;
  double currentZoomEightTeen = 18;

  final Utility utility = Utility();

  List<String> yearList = <String>[];

  final AutoScrollController autoScrollController = AutoScrollController();

  List<Marker> lifetimeMarkerList = <Marker>[];

  ///
  @override
  void initState() {
    super.initState();

    for (int i = 2023; i <= DateTime.now().year; i++) {
      yearList.add(i.toString());
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      // ignore: always_specify_types
      Future(() {
        if (!mounted) {
          return;
        }
        appParamNotifier.setKeepGeolocMap(map: widget.geolocMap);
        appParamNotifier.setKeepHolidayList(list: widget.holidayList);
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }

      setState(() => isLoading = true);

      // ignore: inference_failure_on_instance_creation, always_specify_types
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) {
        return;
      }

      buildAllPolygonsExcludeIslands();
      makeMinMaxLatLng();
      setDefaultBoundsMap();

      if (!mounted) {
        return;
      }
      setState(() => isLoading = false);
    });
  }

  ///
  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    // ignore: always_specify_types
    Future(() {
      if (!mounted) {
        return;
      }

      if (oldWidget.geolocMap != widget.geolocMap) {
        appParamNotifier.setKeepGeolocMap(map: widget.geolocMap);
      }

      if (oldWidget.holidayList != widget.holidayList) {
        appParamNotifier.setKeepHolidayList(list: widget.holidayList);
      }
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    makeLifetimeMarkerList();

    return Scaffold(
      body: Stack(
        children: <Widget>[
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: const LatLng(zenpukujiLat, zenpukujiLng),
              initialZoom: currentZoomEightTeen,
              onPositionChanged: (MapCamera position, bool isMoving) {
                if (isMoving) {
                  appParamNotifier.setCurrentZoom(zoom: position.zoom);
                }
              },
            ),
            children: <Widget>[
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                tileProvider: CachedTileProvider(),
                userAgentPackageName: 'com.example.app',
              ),
              // ignore: always_specify_types
              PolygonLayer(polygons: makeAreaPolygons()),

              if (appParamState.selectedDaysList.isNotEmpty) ...<Widget>[MarkerLayer(markers: lifetimeMarkerList)],
            ],
          ),
          Positioned(
            top: 5,
            right: 5,
            left: 5,
            child: Row(
              children: <Widget>[
                Row(
                  children: yearList.map((String e) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: GestureDetector(
                        onTap: () {
                          autoScrollController.scrollToIndex(0);

                          appParamNotifier.clearSelectedDaysList();

                          appParamNotifier.setSelectedYear(year: e.toInt());
                        },
                        child: CircleAvatar(
                          backgroundColor: (e.toInt() == appParamState.selectedYear)
                              ? Colors.yellowAccent
                              : Colors.black,
                          child: Text(e, style: const TextStyle(fontSize: 12)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 30),
                Expanded(child: displayYearDayList()),
              ],
            ),
          ),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  ///
  void buildAllPolygonsExcludeIslands() {
    allPolygons.clear();

    for (final MunicipalModel element in widget.tokyoMunicipalList) {
      for (final List<List<List<double>>> poly in element.polygons) {
        if (isMainlandPolygon(poly)) {
          allPolygons.add(poly);
        }
      }
    }
  }

  ///
  bool isMainlandPolygon(List<List<List<double>>> polygon) {
    double maxLat = -90.0;

    for (final List<List<double>> ring in polygon) {
      for (final List<double> point in ring) {
        final double lat = point[1];
        if (lat > maxLat) {
          maxLat = lat;
        }
      }
    }

    return maxLat >= 35.0;
  }

  ///
  // ignore: always_specify_types
  List<Polygon> makeAreaPolygons() {
    // ignore: always_specify_types
    final List<Polygon> polygonList = <Polygon>[];

    if (allPolygons.isEmpty) {
      return polygonList;
    }

    final List<Color> colors = utility.getTwentyFourColor();
    int idx = 0;

    for (final List<List<List<double>>> poly in allPolygons) {
      // ignore: always_specify_types
      final Polygon? polygon = getColorPaintPolygon(
        polygon: poly,
        color: colors[idx % colors.length].withValues(alpha: 0.3),
      );

      if (polygon != null) {
        polygonList.add(polygon);
        idx++;
      }
    }

    return polygonList;
  }

  ///
  void makeMinMaxLatLng() {
    latList.clear();
    lngList.clear();

    for (final List<List<List<double>>> poly in allPolygons) {
      for (final List<List<double>> ring in poly) {
        for (final List<double> point in ring) {
          lngList.add(point[0]);
          latList.add(point[1]);
        }
      }
    }

    if (latList.isNotEmpty && lngList.isNotEmpty) {
      minLat = latList.reduce(min);
      maxLat = latList.reduce(max);
      minLng = lngList.reduce(min);
      maxLng = lngList.reduce(max);
    }
  }

  ///
  void setDefaultBoundsMap() {
    if (latList.isEmpty || lngList.isEmpty) {
      return;
    }
    if (minLat == maxLat && minLng == maxLng) {
      return;
    }

    mapController.rotate(0);

    final LatLngBounds bounds = LatLngBounds.fromPoints(<LatLng>[LatLng(minLat, minLng), LatLng(maxLat, maxLng)]);

    final CameraFit cameraFit = CameraFit.bounds(
      bounds: bounds,
      padding: EdgeInsets.all(appParamState.currentPaddingIndex * 10),
    );

    mapController.fitCamera(cameraFit);

    final double newZoom = mapController.camera.zoom;

    if (!newZoom.isFinite) {
      return;
    }

    currentZoom = newZoom;
    appParamNotifier.setCurrentZoom(zoom: newZoom);
  }

  ///
  Widget displayYearDayList() {
    final List<Widget> list = <Widget>[];

    int i = 0;
    appParamState.keepGeolocMap.forEach((String key, List<GeolocModel> value) {
      if (key.split('-')[0] == appParamState.selectedYear.toString()) {
        if (value.isNotEmpty) {
          final String youbiStr = DateTime.parse(key).youbiStr;

          list.add(
            AutoScrollTag(
              // ignore: always_specify_types
              key: ValueKey(i),
              index: i,
              controller: autoScrollController,

              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: (appParamState.selectedDaysList.contains(key))
                            ? getDaysListUnderBarColor(day: key)
                            : Colors.black,
                        width: 5,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.only(bottom: 5),
                  child: GestureDetector(
                    onTap: () {
                      appParamNotifier.setSelectedDaysList(day: key);
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: utility
                          .getYoubiColor(date: key, youbiStr: youbiStr, holiday: widget.holidayList)
                          .withValues(alpha: 0.8),
                      child: DefaultTextStyle(
                        style: const TextStyle(fontSize: 10, color: Colors.white),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 5),
                            Text('${key.split('-')[1]}-${key.split('-')[2]}'),
                            Text(utility.getBoundingBoxArea(points: value).split('.')[0]),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        i++;
      }
    });

    return SingleChildScrollView(
      controller: autoScrollController,
      scrollDirection: Axis.horizontal,
      child: Row(children: list),
    );
  }

  ///
  Color getDaysListUnderBarColor({required String day}) {
    final List<Color> twentyFourColor = utility.getTwentyFourColor();

    final int pos = appParamState.selectedDaysList.indexWhere((String e) => e == day);

    if (pos < 0) {
      return Colors.black;
    }

    return twentyFourColor[pos % twentyFourColor.length];
  }

  ///
  void makeLifetimeMarkerList() {
    lifetimeMarkerList.clear();

    for (final String dayKey in appParamState.selectedDaysList) {
      final Color color = getDaysListUnderBarColor(day: dayKey);

      final List<GeolocModel>? points = appParamState.keepGeolocMap[dayKey];
      if (points == null || points.isEmpty) {
        continue;
      }

      for (final GeolocModel p in points) {
        lifetimeMarkerList.add(
          Marker(
            point: LatLng(p.latitude.toDouble(), p.longitude.toDouble()),
            width: 40,
            height: 40,
            child: Icon(Icons.ac_unit, color: color),
          ),
        );
      }
    }
  }
}
