import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

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
  });

  final List<MunicipalModel> tokyoMunicipalList;
  final Map<String, MunicipalModel> tokyoMunicipalMap;
  final Map<String, List<GeolocModel>> geolocMap;

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

  ///
  @override
  void initState() {
    super.initState();

    for (int i = 2023; i <= DateTime.now().year; i++) {
      yearList.add(i.toString());
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() => isLoading = true);

      // ignore: inference_failure_on_instance_creation, always_specify_types
      await Future.delayed(const Duration(seconds: 2));

      buildAllPolygonsExcludeIslands();
      makeMinMaxLatLng();
      setDefaultBoundsMap();

      setState(() => isLoading = false);
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      appParamNotifier.setKeepGeolocMap(map: widget.geolocMap);
    });

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
        final double lat = point[1]; // [lng, lat]
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
    mapController.rotate(0);

    final LatLngBounds bounds = LatLngBounds.fromPoints(<LatLng>[LatLng(minLat, minLng), LatLng(maxLat, maxLng)]);

    final CameraFit cameraFit = CameraFit.bounds(
      bounds: bounds,
      padding: EdgeInsets.all(appParamState.currentPaddingIndex * 10),
    );

    mapController.fitCamera(cameraFit);

    final double newZoom = mapController.camera.zoom;
    currentZoom = newZoom;
    appParamNotifier.setCurrentZoom(zoom: newZoom);
  }

  ///
  Widget displayYearDayList() {
    final List<Widget> list = <Widget>[];

    appParamState.keepGeolocMap.forEach((String key, List<GeolocModel> value) {
      if (key.split('-')[0] == appParamState.selectedYear.toString()) {
        if (value.isNotEmpty) {
          list.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 5))),

                padding: const EdgeInsets.only(bottom: 5),

                child: CircleAvatar(
                  radius: 16,
                  child: Text(
                    '${key.split('-')[1]}-${key.split('-')[2]}',
                    style: const TextStyle(fontSize: 10),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          );
        }
      }
    });

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: list),
    );
  }
}
