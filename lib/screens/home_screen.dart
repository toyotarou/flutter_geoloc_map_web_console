import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../const/const.dart';
import '../controllers/controllers_mixin.dart';
import '../models/municipal_model.dart';
import '../utility/map_functions.dart';
import '../utility/tile_provider.dart';
import '../utility/utility.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, required this.tokyoMunicipalList, required this.tokyoMunicipalMap});

  final List<MunicipalModel> tokyoMunicipalList;
  final Map<String, MunicipalModel> tokyoMunicipalMap;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with ControllersMixin<HomeScreen> {
  List<List<List<List<double>>>>? allPolygons = <List<List<List<double>>>>[];

  //  List<GeolocModel> monthlyGeolocList = <GeolocModel>[];

  bool isLoading = false;

  List<double> latList = <double>[];
  List<double> lngList = <double>[];

  double minLat = 0.0;
  double maxLat = 0.0;
  double minLng = 0.0;
  double maxLng = 0.0;

  final MapController mapController = MapController();

  double? currentZoom;

  double currentZoomEightTeen = 18;

  List<Marker> markerList = <Marker>[];

  Utility utility = Utility();

  List<LatLng> latLngList = <LatLng>[];

  //  List<GeolocModel> selectedGeolocList = <GeolocModel>[];

  List<LatLng> polygonPoints = <LatLng>[];

  double centerLat = 0.0;
  double centerLng = 0.0;

  ///
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // getDataNotifier.setKeepTempleList(list: widget.templeList);
      // getDataNotifier.setKeepTempleLatLngList(list: widget.templeLatLngList);
      // getDataNotifier.setKeepTempleLatLngMap(map: widget.templeLatLngMap);
      // getDataNotifier.setKeepStationMap(map: widget.stationMap);
      // getDataNotifier.setKeepTokyoMunicipalList(list: widget.tokyoMunicipalList);
      // getDataNotifier.setKeepTokyoMunicipalMap(map: widget.tokyoMunicipalMap);
      // getDataNotifier.setKeepTempleListMap(map: widget.templeListMap);
      // getDataNotifier.setKeepTempleListList(list: widget.templeListList);
      // getDataNotifier.setKeepTempleListNavitimeMap(map: widget.templeListNavitimeMap);
      // getDataNotifier.setKeepTokyoTrainList(list: widget.tokyoTrainList);
      // getDataNotifier.setKeepTokyoTrainMap(map: widget.tokyoTrainMap);
      // getDataNotifier.setKeepTokyoStationTokyoTrainModelListMap(map: widget.tokyoStationTokyoTrainModelListMap);
      //
      // /////////////////////////////////
      //
      // final Set<String> existingTempleNames = widget.templeLatLngList.map((TempleLatLngModel e) => e.temple).toSet();
      //
      // final List<TempleListModel> filteredNotVisitTempleList = widget.templeListList
      //     .where((TempleListModel temple) => !existingTempleNames.contains(temple.name))
      //     .toList();
      //
      // getDataNotifier.setKeepFilteredNotVisitTempleList(list: filteredNotVisitTempleList);
      //
      // /////////////////////////////////

      for (final MunicipalModel element in widget.tokyoMunicipalList) {
        allPolygons?.addAll(element.polygons);
      }
    });

    return Scaffold(
      body: FlutterMap(
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
          if (allPolygons != null) PolygonLayer(polygons: makeAreaPolygons()),

          // if (appParamState.keepAllPolygonsList.isNotEmpty) ...<Widget>[
          //   // ignore: always_specify_types
          //   PolygonLayer(
          //     polygons: makeAreaPolygons(
          //       allPolygonsList: appParamState.keepAllPolygonsList,
          //       twentyFourColor: utility.getTwentyFourColor(),
          //     ),
          //   ),
          // ],
          //
          // MarkerLayer(markers: markerList),
          //
          // if (polygonPoints.isNotEmpty) ...<Widget>[
          //   // ignore: always_specify_types
          //   PolygonLayer(
          //     polygons: <Polygon<Object>>[
          //       // ignore: always_specify_types
          //       Polygon(
          //         points: polygonPoints,
          //         color: Colors.purpleAccent.withValues(alpha: 0.2),
          //         borderColor: Colors.purpleAccent.withValues(alpha: 0.4),
          //         borderStrokeWidth: 2,
          //       ),
          //     ],
          //   ),
          // ],
        ],
      ),
    );
  }

  ///
  // ignore: always_specify_types
  List<Polygon> makeAreaPolygons() {
    // ignore: always_specify_types
    final List<Polygon> polygonList = <Polygon>[];

    final List<List<List<List<double>>>>? all = allPolygons;

    if (all == null || all.isEmpty) {
      return polygonList;
    }

    final List<Color> twentyFourColor = utility.getTwentyFourColor();

    final Map<String, List<List<List<double>>>> uniquePolygons = <String, List<List<List<double>>>>{};

    for (final List<List<List<double>>> poly in all) {
      final String key = poly.toString();
      uniquePolygons[key] = poly;
    }

    int idx = 0;
    for (final List<List<List<double>>> poly in uniquePolygons.values) {
      // ignore: always_specify_types
      final Polygon? polygon = getColorPaintPolygon(
        polygon: poly,
        color: twentyFourColor[idx % 24].withValues(alpha: 0.3),
      );

      if (polygon != null) {
        polygonList.add(polygon);
        idx++;
      }
    }

    return polygonList;
  }
}
