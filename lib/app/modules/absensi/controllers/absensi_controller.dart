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
  // Ambil Lokasi firebase
  RxBool isLoading = true.obs;
  final mapController = MapController();
  // Rx<LatLng?> lokasiSaatIni = Rx<LatLng?>(null);
  Rx<LatLng> posisiSaatIni = LatLng(0, 0).obs;
  // RxString alamatTersimpan = "".obs;

  @override
  void onInit() {
    super.onInit();
    cekJadwalSekarang();
    hitungPersentasePresensi();
    // ambilLokasi();
  }

  Future<void> cekJadwalSekarang() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('jadwal_presensi')
        .get();

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
    final snapshot = await FirebaseFirestore.instance
        .collection('presensi')
        .get();

    int total = snapshot.docs.length;
    int berhasil = snapshot.docs
        .where((doc) => doc['status'] == 'berhasil')
        .length;

    if (total > 0) {
      persentasePresensi.value = (berhasil / total) * 100;
    } else {
      persentasePresensi.value = 0.0;
    }
  }

  final namaController = TextEditingController();
  final jalanController = TextEditingController();
  final detailAlamatController = TextEditingController();

  // final mapController = MapController();

  Rx<LatLng?> lokasiTerpilih = Rx<LatLng?>(null);
  RxBool tampilPeta = false.obs;
  RxString alamatTersimpan = "".obs;

  Future<void> ambilLokasiSaatIni() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    final lokasi = LatLng(position.latitude, position.longitude);

    lokasiTerpilih.value = lokasi;
    tampilPeta.value = true;
    mapController.move(lokasi, 15.0);
  }

  Future<void> ambilAlamatDariKoordinat(LatLng posisi) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(posisi.latitude, posisi.longitude);
      if (placemarks.isNotEmpty) {
        Placemark p = placemarks.first;
        alamatTersimpan.value = "${p.street}, ${p.subLocality}, ${p.locality}";
      }
    } catch (e) {
      print("Gagal mengambil alamat: $e");
    }
  }

  Future<void> cariAlamat() async {
    try {
      String alamat =
          "${jalanController.text} ${detailAlamatController.text}";
      if (alamat.isEmpty) return;

      List<Location> locations = await locationFromAddress(alamat);
      if (locations.isNotEmpty) {
        final lokasi = LatLng(
          locations.first.latitude,
          locations.first.longitude,
        );
        lokasiTerpilih.value = lokasi;
        tampilPeta.value = true;
        mapController.move(lokasi, 15.0);
      }
    } catch (e) {
      print("Gagal mencari alamat: $e");
    }
  }

  void simpanLokasi() {
    if (lokasiTerpilih.value != null) {
      ambilAlamatDariKoordinat(lokasiTerpilih.value!);
      tampilPeta.value = false;
    }
  }
}
