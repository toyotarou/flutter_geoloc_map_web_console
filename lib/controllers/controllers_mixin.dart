import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_param/app_param.dart';
import 'geoloc/geoloc.dart';
import 'holiday/holiday.dart';
import 'tokyo_municipal/tokyo_municipal.dart';

mixin ControllersMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  //==========================================//

  AppParamState get appParamState => ref.watch(appParamProvider);

  AppParam get appParamNotifier => ref.read(appParamProvider.notifier);

  //==========================================//

  TokyoMunicipalState get tokyoMunicipalState => ref.watch(tokyoMunicipalProvider);

  TokyoMunicipal get tokyoMunicipalNotifier => ref.read(tokyoMunicipalProvider.notifier);

  //==========================================//

  GeolocState get geolocState => ref.watch(geolocProvider);

  Geoloc get geolocNotifier => ref.read(geolocProvider.notifier);

  //==========================================//

  HolidayState get holidayState => ref.watch(holidayProvider);

  Holiday get holidayNotifier => ref.read(holidayProvider.notifier);

  //==========================================//
}
