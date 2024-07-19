import 'package:get/get.dart';

import '../controllers/gps_test_controller.dart';

class GpsTestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GpsTestController>(
      () => GpsTestController(),
    );
  }
}
