import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';

class AbsensiController extends GetxController {
  var adaJadwalSekarang = false.obs;
  RxString jamJadwal = ''.obs;
  var persentasePresensi = 0.0.obs;
  RxBool isLoading = true.obs;

  final mapController = MapController();
  // Titik pusat lokasi (misal: kantor/sekolah)
  final LatLng titikPusat = LatLng(-8.157573, 113.722885);
  // Radius dalam meter
  final double radiusMeter = 100;
  // Lokasi user saat ini
  var lokasiSekarang = Rx<LatLng?>(null);
  // Apakah berada dalam radius
  var dalamRadius = false.obs;

  @override
  void onInit() {
    super.onInit();
    cekJadwalSekarang();
    hitungPersentasePresensi();
    ambilLokasiSaatIni();
  }

  Future<void> cekJadwalSekarang() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('jadwal_presensi').get();

    final now = DateTime.now();
    bool ditemukan = false;

    for (final doc in snapshot.docs) {
      final mulai = (doc['waktu_mulai'] as Timestamp).toDate();
      final akhir = (doc['waktu_akhir'] as Timestamp).toDate();

      if (now.isAfter(mulai) && now.isBefore(akhir)) {
        ditemukan = true;

        // Format jam: 08:00 - 10:00
        final formatJam =
            "${mulai.hour.toString().padLeft(2, '0')}:${mulai.minute.toString().padLeft(2, '0')} - "
            "${akhir.hour.toString().padLeft(2, '0')}:${akhir.minute.toString().padLeft(2, '0')}";

        jamJadwal.value = formatJam;
        break;
      }
    }

    adaJadwalSekarang.value = ditemukan;

    if (!ditemukan) {
      jamJadwal.value = ''; // kosongkan jika tidak ada jadwal
    }
  }

  Future<void> hitungPersentasePresensi() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('presensi').get();

    int total = snapshot.docs.length;
    int berhasil =
        snapshot.docs.where((doc) => doc['status'] == 'berhasil').length;

    if (total > 0) {
      persentasePresensi.value = (berhasil / total) * 100;
    } else {
      persentasePresensi.value = 0.0;
    }
  }

  Future<void> ambilLokasiSaatIni() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
          "Lokasi Tidak Aktif", "Aktifkan layanan lokasi di perangkat.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
          "Izin Lokasi Ditolak", "Buka pengaturan dan izinkan lokasi.");
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        Get.snackbar("Izin Lokasi Ditolak", "Tidak bisa mengakses lokasi.");
        return;
      }
    }

    // Ambil posisi sekarang
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    lokasiSekarang.value = LatLng(position.latitude, position.longitude);

    // Cek apakah dalam radius
    final distance = Distance().as(
      LengthUnit.Meter,
      titikPusat,
      lokasiSekarang.value!,
    );

    dalamRadius.value = distance <= radiusMeter;
  }

  // Future<void> ambilAlamatDariKoordinat(LatLng posisi) async {
  //   try {
  //     List<Placemark> placemarks =
  //         await placemarkFromCoordinates(posisi.latitude, posisi.longitude);
  //     if (placemarks.isNotEmpty) {
  //       Placemark p = placemarks.first;
  //       alamatTersimpan.value = "${p.street}, ${p.subLocality}, ${p.locality}";
  //     }
  //   } catch (e) {
  //     print("Gagal mengambil alamat: $e");
  //   }
  // }
}
