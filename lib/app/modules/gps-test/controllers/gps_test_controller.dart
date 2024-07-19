import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class lokasiMq {
  var latitude = -6.4729441;
  var longtitude = 106.984574;
}

class lokasiSalah {
  var latitude = -6.492880;
  var longtitude = 107.014656;
}

class GpsTestController extends GetxController {
  var currentPosition = Rx<Position?>(null);
  var error = ''.obs;
  var isAllowed = false.obs;

  final allowedLocation = {
    'latitude': lokasiMq().latitude, // ganti dengan latitude lokasi MQ
    'longitude': lokasiMq().longtitude, // ganti dengan longitude lokasi MQ
    'radius': 500,
  };

  double _getDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371e3; // Radius Bumi dalam meter
    final phi1 = _toRad(lat1);
    final phi2 = _toRad(lat2);
    final deltaPhi = _toRad(lat2 - lat1);
    final deltaLambda = _toRad(lon2 - lon1);

    final a = math.sin(deltaPhi / 2) * math.sin(deltaPhi / 2) +
        math.cos(phi1) *
            math.cos(phi2) *
            math.sin(deltaLambda / 2) *
            math.sin(deltaLambda / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return R * c;
  }

  double _toRad(double value) => value * math.pi / 180;

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
  }

  _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      error.value = 'Location services are disabled.';
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        error.value = 'Location permissions are denied.';
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      error.value = 'Location permissions are permanently denied.';
      return;
    }

    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      currentPosition.value = position;

      final distance = _getDistance(
        currentPosition.value!.latitude,
        currentPosition.value!.longitude,
        allowedLocation['latitude']!.toDouble(),
        allowedLocation['longitude']!.toDouble(),
      );

      if (distance <= allowedLocation['radius']!) {
        isAllowed.value = true;
      } else {
        isAllowed.value = false;
        error.value = 'Anda tidak ada di lokasi tersebut.';
      }
    }).catchError((e) {
      error.value = 'Gagal mendapatkan lokasi. Pastikan GPS diaktifkan.';
    });
  }

  void handleAbsensi() {
    if (!isAllowed.value) {
      Get.snackbar('Error', 'Anda tidak berada di lokasi MQ.');
    } else {
      Get.snackbar('Success', 'Absensi berhasil!');
    }
  }
}
