import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/absensi_controller.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AbsensiView extends GetView<AbsensiController> {
  final controller = Get.put(AbsensiController());
  // final area = controller.areaGedungTI

  // const AbsensiView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 213, 242, 255),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 213, 242, 255),
        toolbarHeight: 60,
        flexibleSpace: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(150),
            bottomRight: Radius.circular(150),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: 60,
                right: 40,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Presensi Siswa',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    color: Colors.amber,
                    icon: Icon(Icons.person_2_sharp),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama dan jabatan
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Perhatian!!!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Anda diharuskan melakukan presensi digedung jurusan Teknologi Informasi Politeknik Negeri Jember.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Sistem akan mengecek lokasi anda, jika presensi diluar wilayah status presensi anda hari itu merah',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // MAPS OSM
            Obx(() {
              final posisi = controller.posisiSaatIni.value;
              final dalamArea = controller.dalamArea.value;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Posisi Anda: ${posisi.latitude}, ${posisi.longitude}'),
                  const SizedBox(height: 20),
                  Text(
                    dalamArea
                        ? '✅ Anda berada di dalam area'
                        : '❌ Anda di luar area',
                    style: TextStyle(
                      fontSize: 18,
                      color: dalamArea ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              );
            }),
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  controller.dalamArea.value
                      ? "📍 Kamu berada di dalam area"
                      : "🚫 Kamu berada di luar area",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: controller.dalamArea.value
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Tombol Cek Lokasi
            Obx(
              () => Column(
                children: [
                  ElevatedButton(
                    onPressed: () => controller.cekLokasi(),
                    child: const Text("Cek Lokasi"),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    controller.dalamArea.value
                        ? "✅ Anda di dalam area"
                        : "❌ Anda di luar area",
                    style: TextStyle(
                      color: controller.dalamArea.value
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Jam sekarang (dummy)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.indigo[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  '08:45:12',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Tombol absen masuk
            ElevatedButton.icon(
              onPressed: () {}, // TODO: isi fungsi absen masuk
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.login),
              label: const Text('Absen Masuk'),
            ),
            const SizedBox(height: 16),

            // Tombol absen pulang
            ElevatedButton.icon(
              onPressed: () {}, // TODO: isi fungsi absen pulang
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.logout),
              label: const Text('Absen Pulang'),
            ),

            const SizedBox(height: 30),

            // Riwayat atau status absen hari ini
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status Hari Ini',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Absen Masuk: -'),
                  Text('Absen Pulang: -'),
                ],
              ),
            ),
          ],
        ),
      ),
      // body: SafeArea(
      //   child: Container(color: const Color.fromARGB(255, 213, 242, 255)),
      // ),
    );
  }
}
