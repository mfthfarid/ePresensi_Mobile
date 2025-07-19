import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';

class AbsensiController extends GetxController {
  // Ambil Lokasi firebase
  Rx<LatLng> posisiSaatIni = LatLng(0, 0).obs;
  RxBool dalamArea = false.obs;

  double latMin = 0;
  double latMax = 0;
  double longMin = 0;
  double longMax = 0;

  //   final now = DateTime.now();
  // final today = DateFormat('EEEE').format(now);

  /// Fungsi utama: ambil posisi dan cek
  Future<void> ambilPosisiDanCekArea() async {
    try {
      // Ambil posisi pengguna
      Position posisi = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      posisiSaatIni.value = LatLng(posisi.latitude, posisi.longitude);

      // Ambil bounding box dari Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('jadwal_presensi')
          .doc('jadwalId')
          // .where('hari', isEqualTo: today)
          .get();

      if (!snapshot.exists) {
        print("Dokumen tidak ditemukan");
        return;
      }

      final lokasi = snapshot.data()!['lokasi'];
      latMin = (lokasi['latMin'] as num).toDouble();
      latMax = (lokasi['latMax'] as num).toDouble();
      longMin = (lokasi['longMin'] as num).toDouble();
      longMax = (lokasi['longMax'] as num).toDouble();

      // Panggil fungsi untuk cek lokasi
      cekLokasi();
    } catch (e) {
      print("Gagal mengambil data lokasi: $e");
    }
  }

  /// Cek apakah posisi saat ini berada dalam area
  void cekLokasi() {
    final lat = posisiSaatIni.value.latitude;
    final lng = posisiSaatIni.value.longitude;

    bool isDalam =
        lat >= latMin && lat <= latMax && lng >= longMin && lng <= longMax;
    dalamArea.value = isDalam;

    print(
      "Cek lokasi: ($lat, $lng) -> ${isDalam ? "✅ Dalam area" : "❌ Di luar area"}",
    );
  }
}

  // void fetchBoundingBox() async {
  //   try {
  //     print("🔥 Mengambil data dari Firestore...");

  //     final snapshot = await FirebaseFirestore.instance
  //         .collection('jadwal_presensi')
  //         .doc('jadwalId') // Ganti sesuai ID dokumen di Firestore
  //         .get();

  //     if (!snapshot.exists) {
  //       print("❌ Dokumen tidak ditemukan");
  //       return;
  //     }

  //     final data = snapshot.data();
  //     print("✅ Data Firestore: $data");

  //     final lokasi = data?['lokasi'];
  //     if (lokasi != null &&
  //         lokasi['latMin'] != null &&
  //         lokasi['latMax'] != null &&
  //         lokasi['longMin'] != null &&
  //         lokasi['longMax'] != null) {
  //       latMin = double.tryParse(lokasi['latMin'].toString()) ?? 0;
  //       latMax = double.tryParse(lokasi['latMax'].toString()) ?? 0;
  //       lngMin = double.tryParse(lokasi['longMin'].toString()) ?? 0;
  //       lngMax = double.tryParse(lokasi['longMax'].toString()) ?? 0;

  //       // Validasi tambahan
  //       if (latMin == 0 && latMax == 0 && lngMin == 0 && lngMax == 0) {
  //         print("⚠️ Semua nilai koordinat adalah 0. Tidak valid.");
  //         return;
  //       }

  //       polygonPoints.assignAll([
  //         LatLng(latMin, lngMin),
  //         LatLng(latMin, lngMax),
  //         LatLng(latMax, lngMax),
  //         LatLng(latMax, lngMin),
  //         LatLng(latMin, lngMin),
  //       ]);

  //       centerPoint.value = LatLng(
  //         (latMin + latMax) / 2,
  //         (lngMin + lngMax) / 2,
  //       );

  //       print("✅ Bounding box berhasil diatur.");
  //       cekLokasi();
  //     } else {
  //       print("⚠️ Data lokasi tidak lengkap atau null.");
  //     }
  //   } catch (e) {
  //     print("❗ Error ambil data Firestore: $e");
  //   }
  // }

  // Futur
  // Rx<LatLng> posisiSaatIni = LatLng(0, 0).obs;
  // RxBool dalamArea = false.obs;

  // // Koordinat polygon area gedung TI
  // final List<LatLng> areaGedungTI = [
  //   LatLng(-8.157883, 113.723227),
  //   LatLng(-8.157501, 113.723398),
  //   LatLng(-8.157248, 113.722617),
  //   LatLng(-8.157618, 113.722458),
  // ];

  // @override
  // void onInit() {
  //   super.onInit();
  //   _ambilPosisi();
  // }

  // Future<void> _ambilPosisi() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   // Cek apakah service GPS aktif
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     Get.snackbar("Error", "Layanan lokasi tidak aktif");
  //     return;
  //   }

  //   // Minta izin lokasi
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       Get.snackbar("Error", "Izin lokasi ditolak");
  //       return;
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     Get.snackbar("Error", "Izin lokasi ditolak permanen");
  //     return;
  //   }

  //   // Ambil posisi awal dan update posisi saat bergerak
  //   Position position = await Geolocator.getCurrentPosition();
  //   posisiSaatIni.value = LatLng(position.latitude, position.longitude);

  //   Geolocator.getPositionStream(
  //     locationSettings: const LocationSettings(
  //       accuracy: LocationAccuracy.high,
  //       distanceFilter: 5, // update jika pindah 5 meter
  //     ),
  //   ).listen((Position pos) {
  //     posisiSaatIni.value = LatLng(pos.latitude, pos.longitude);
  //   });
  // }

  // void cekLokasiPresensi(String idJadwal) {
  //   final userPoint = posisiSaatIni.value;
  //   dalamArea.value = _isPointInPolygon(userPoint, areaGedungTI);

  //   if (dalamArea.value) {
  //     Get.snackbar("Berhasil", "Anda berada di dalam area presensi");
  //     // TODO: lakukan presensi, kirim ke backend pakai idJadwal, dll
  //   } else {
  //     Get.snackbar(
  //       "Gagal",
  //       "Anda berada di luar area yang ditentukan. Segeralah kembali ke Gedung TI untuk melakukan presensi",
  //     );
  //   }
  // }

  // /// Algoritma Ray Casting: apakah titik di dalam polygon
  // bool _isPointInPolygon(LatLng point, List<LatLng> polygon) {
  //   int intersectCount = 0;
  //   for (int j = 0; j < polygon.length - 1; j++) {
  //     LatLng p1 = polygon[j];
  //     LatLng p2 = polygon[j + 1];

  //     if (((p1.longitude > point.longitude) !=
  //             (p2.longitude > point.longitude)) &&
  //         (point.latitude <
  //             (p2.latitude - p1.latitude) *
  //                     (point.longitude - p1.longitude) /
  //                     (p2.longitude - p1.longitude) +
  //                 p1.latitude)) {
  //       intersectCount++;
  //     }
  //   }
  //   return (intersectCount % 2 == 1); // true jika ganjil
  // }

  // RxBool dalamArea = false.obs;

  // Future<void> cekLokasiPresensi(String idJadwal) async {
  //   final snapshot = await FirebaseFirestore.instance
  //       .collection('jadwal_presensi')
  //       .doc(idJadwal)
  //       .get();

  //   final data = snapshot.data();
  //   final lokasi = data?['lokasi'];

  //   double latMin = lokasi['latMin'];
  //   double latMax = lokasi['latMax'];
  //   double lngMin = lokasi['lngMin'];
  //   double lngMax = lokasi['lngMax'];

  //   Position posisi = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   );

  //   double userLat = posisi.latitude;
  //   double userLng = posisi.longitude;

  //   dalamArea.value =
  //       (userLat >= latMin && userLat <= latMax) &&
  //       (userLng >= lngMin && userLng <= lngMax);
  // }

  // var currentTime = ''.obs;
  // var isAbsenMasuk = false.obs;
  // var isAbsenPulang = false.obs;
  // var waktuMasuk = ''.obs;
  // var waktuPulang = ''.obs;

  // late Timer _timer;

  // @override
  // void onInit() {
  //   super.onInit();
  //   _updateTime();
  //   _timer = Timer.periodic(Duration(seconds: 1), (_) => _updateTime());
  // }

  // void _updateTime() {
  //   currentTime.value = DateFormat(
  //     'dd MMM yyyy – HH:mm:ss',
  //   ).format(DateTime.now());
  // }

  // void absenMasuk() {
  //   isAbsenMasuk.value = true;
  //   waktuMasuk.value = currentTime.value;
  // }

  // void absenPulang() {
  //   isAbsenPulang.value = true;
  //   waktuPulang.value = currentTime.value;
  // }

  // @override
  // void onClose() {
  //   _timer.cancel();
  //   super.onClose();
  // }

