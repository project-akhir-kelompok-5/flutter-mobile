import 'package:get/get.dart';

import '../modules/gps-test/bindings/gps_test_binding.dart';
import '../modules/gps-test/views/gps_test_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.GPS_TEST;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.GPS_TEST,
      page: () =>  GpsTestView(),
      binding: GpsTestBinding(),
    ),
  ];
}
