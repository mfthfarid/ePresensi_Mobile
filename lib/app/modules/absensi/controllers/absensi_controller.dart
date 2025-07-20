import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class AbsensiController extends GetxController {
  RxString jadwalId = ''.obs;
  var adaJadwalSekarang = false.obs;
  RxString jamJadwal = ''.obs;
  var persentasePresensi = 0.0.obs;
  RxBool isLoading = true.obs;

  final mapController = MapController();

  // Lokasi jti
  final LatLng titikPusat = LatLng(-8.157573, 113.722885); // Titik pusat lokasi
  final LatLng lokasiPresensi = LatLng(-8.157573, 113.722885); // lokasi acuan

  // Lokasi random
  // final LatLng titikPusat = LatLng(-8.169330, 113.728119); // Titik pusat lokasi
  // final LatLng lokasiPresensi = LatLng(-8.169330, 113.728119); // lokasi acuan
  // Radius dalam meter
  final double radiusMeter = 1200; // 80
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

      print("Cek jadwal: mulai=$mulai, akhir=$akhir, now=$now");

      if (!now.isBefore(mulai) && !now.isAfter(akhir)) {
        ditemukan = true;
        jadwalId.value = doc.id;

        final formatJam =
            "${mulai.hour.toString().padLeft(2, '0')}:${mulai.minute.toString().padLeft(2, '0')} - "
            "${akhir.hour.toString().padLeft(2, '0')}:${akhir.minute.toString().padLeft(2, '0')}";

        jamJadwal.value = formatJam;
        adaJadwalSekarang.value = true;
        break;
      }
    }

    if (!ditemukan) {
      jadwalId.value = '';
      jamJadwal.value = 'Tidak ada jadwal aktif';
      adaJadwalSekarang.value = false; // ✅ DITAMBAHKAN DI SINI
    }
  }

  Future<void> hitungPersentasePresensi() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('presensi').get();

    int total = snapshot.docs.length;
    int berhasil = snapshot.docs.where((doc) => doc['ket'] == 'hasdir').length;

    if (total > 0) {
      persentasePresensi.value = (berhasil / total) * 100;
    } else {
      persentasePresensi.value = 0.0;
    }
  }

  Future<void> mintaIzinLokasi() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
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

  Future<void> presensi() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    // Cek radius
    if (!dalamRadius.value) {
      Get.snackbar("Gagal", "Anda berada di luar area presensi");
      return;
    }

    // Cek jadwal aktif
    if (jadwalId.value.isEmpty) {
      Get.snackbar("Gagal", "Tidak ada jadwal aktif");
      return;
    }

    // Cek nisn / id user
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (!doc.exists || !doc.data()!.containsKey('nisn')) {
      Get.snackbar("Gagal", "NISN tidak ditemukan");
      return;
    }

    final nisn = doc['nisn'];
    await FirebaseFirestore.instance.collection('presensi').add({
      'userId': uid,
      'jadwalId': jadwalId.value,
      'ket': 'Hadir',
      'waktu': Timestamp.now(),
    });

    Get.snackbar("Sukses", "Presensi berhasil disimpan");
  }

  void ajukanIzin() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    if (jadwalId.value.isEmpty) {
      Get.snackbar("Gagal", "Tidak ada jadwal aktif");
      return;
    }

    // Cek nisn / id user
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (!doc.exists || !doc.data()!.containsKey('nisn')) {
      Get.snackbar("Gagal", "NISN tidak ditemukan");
      return;
    }

    final nisn = doc['nisn'];
    await FirebaseFirestore.instance.collection('presensi').add({
      'userId': uid,
      'jadwalId': jadwalId.value,
      'ket': 'Izin',
      'waktu': Timestamp.now(),
    });

    Get.snackbar("Terkirim", "Permintaan izin berhasil dikirim.");
  }

  Future<void> pulang() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    // Cek jadwal aktif
    if (jadwalId.value.isEmpty) {
      Get.snackbar("Gagal", "Tidak ada jadwal aktif");
      return;
    }

    // Cek nisn / id user
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (!doc.exists || !doc.data()!.containsKey('nisn')) {
      Get.snackbar("Gagal", "NISN tidak ditemukan");
      return;
    }

    final nisn = doc['nisn'];
    await FirebaseFirestore.instance.collection('presensi').add({
      'userId': uid,
      'jadwalId': jadwalId.value,
      'ket': 'Pulang',
      'waktu': Timestamp.now(),
    });

    Get.snackbar("Sukses", "Presensi berhasil disimpan");
  }
}
