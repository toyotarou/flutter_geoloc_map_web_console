import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../models/bounding_box_info_model.dart';
import '../models/geoloc_model.dart';

class Utility {
  ///
  void showError(String msg) {
    ScaffoldMessenger.of(
      NavigationService.navigatorKey.currentContext!,
    ).showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 5)));
  }

  ///
  List<Color> getTwentyFourColor() {
    return <Color>[
      const Color(0xFFE53935), // 赤 (100%)
      const Color(0xFF1E88E5), // 青 (100%)
      const Color(0xFF43A047), // 緑 (100%)
      const Color(0xFFFFA726), // オレンジ (100%)
      const Color(0xFF8E24AA), // 紫 (100%)
      const Color(0xFF00ACC1), // シアン (100%)
      const Color(0xFFFDD835), // 黄 (100%)
      const Color(0xFF6D4C41), // 茶 (100%)
      const Color(0xFFD81B60), // ピンク (100%)
      const Color(0xFF3949AB), // インディゴ (100%)
      const Color(0xFF00897B), // ティール (100%)
      const Color(0xCCFF7043), // 明るいオレンジ (80%)
      const Color(0xFF7CB342), // ライムグリーン (100%)
      const Color(0xFF5E35B1), // ディープパープル (100%)
      const Color(0xCC26C6DA), // ライトシアン (80%)
      const Color(0xCCFFEE58), // 明るい黄 (80%)
      const Color(0xFFBDBDBD), // グレー (100%)
      const Color(0xCCEF5350), // 明るい赤 (80%)
      const Color(0xCC42A5F5), // 明るい青 (80%)
      const Color(0xCC66BB6A), // 明るい緑 (80%)
      const Color(0x99FFB74D), // 明るいオレンジ (60%)
      const Color(0xCCAB47BC), // 明るい紫 (80%)
      const Color(0xCC26A69A), // 明るいティール (80%)
      const Color(0xCCFF8A65), // サーモン (80%)
    ];
  }

  ///
  Color getYoubiColor({required String date, required String youbiStr, required List<String> holiday}) {
    Color color = Colors.black.withValues(alpha: 0.2);

    switch (youbiStr) {
      case 'Sunday':
        color = Colors.redAccent.withValues(alpha: 0.2);

      case 'Saturday':
        color = Colors.blueAccent.withValues(alpha: 0.2);

      default:
        color = Colors.black.withValues(alpha: 0.2);
    }

    if (holiday.contains(date)) {
      color = Colors.greenAccent.withValues(alpha: 0.2);
    }

    return color;
  }

  ///
  String getBoundingBoxArea({required List<GeolocModel> points}) {
    if (points.isEmpty) {
      return '0.0000 km²';
    }

    final BoundingBoxInfoModel info = getBoundingBoxInfo(points);
    final NumberFormat numberFormat = NumberFormat('#,##0.0000');
    return '${numberFormat.format(info.areaKm2)} km²';
  }

  ///
  BoundingBoxInfoModel getBoundingBoxInfo(List<GeolocModel> points) {
    final List<double> lats = points.map((GeolocModel p) => double.tryParse(p.latitude) ?? 0).toList();
    final List<double> lngs = points.map((GeolocModel p) => double.tryParse(p.longitude) ?? 0).toList();

    final double maxLat = lats.reduce((double a, double b) => a > b ? a : b);
    final double minLat = lats.reduce((double a, double b) => a < b ? a : b);
    final double maxLng = lngs.reduce((double a, double b) => a > b ? a : b);
    final double minLng = lngs.reduce((double a, double b) => a < b ? a : b);

    final LatLng southWest = LatLng(minLat, minLng);
    final LatLng northWest = LatLng(maxLat, minLng);
    final LatLng southEast = LatLng(minLat, maxLng);

    const Distance distance = Distance();
    final double northSouth = distance.as(LengthUnit.Meter, southWest, northWest);
    final double eastWest = distance.as(LengthUnit.Meter, southWest, southEast);

    final double areaKm2 = (northSouth * eastWest) / 1_000_000;

    return BoundingBoxInfoModel(minLat: minLat, maxLat: maxLat, minLng: minLng, maxLng: maxLng, areaKm2: areaKm2);
  }
}

class NavigationService {
  const NavigationService._();

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
