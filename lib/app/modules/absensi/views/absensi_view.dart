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
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
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
                    'Sistem akan mengecek lokasi anda, jika presensi diluar wilayah status presensi anda tidak valid',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => Container(
                            height: 100,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: controller.adaJadwalSekarang.value
                                  ? Colors.green[50]
                                  : Colors.yellow[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: controller.adaJadwalSekarang.value
                                    ? Colors.green
                                    : Colors.yellow,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    controller.adaJadwalSekarang.value
                                        ? '✅ Ada jadwal presensi'
                                        : '❌ Tidak ada jadwal',
                                    style: TextStyle(
                                      color: controller.adaJadwalSekarang.value
                                          ? Colors.green[800]
                                          : Colors.yellow[800],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                if (controller.adaJadwalSekarang.value &&
                                    controller.jamJadwal.value.isNotEmpty)
                                  Center(
                                    child: Text(
                                      '🕒: ${controller.jamJadwal.value}',
                                      style: TextStyle(color: Colors.grey[800]),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12), // Jarak antar kotak
                      Expanded(
                        child: Obx(() {
                          final nilai = controller.persentasePresensi.value;
                          final tampil =
                              nilai < 1 && nilai > 0 ? 1 : nilai.round();
                          return Container(
                            height: 100,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blue),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    '$tampil% berhasil',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.blue[800],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value: nilai / 100, // nilai dari 0.0 – 1.0
                                  color: Colors.blue,
                                  backgroundColor: Colors.blue[100],
                                  minHeight: 8,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // MAPS OSM
            Obx(() {
              final lokasi = controller.lokasiSekarang.value;

              return Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FlutterMap(
                    mapController: controller.mapController,
                    options: MapOptions(
                      center: lokasi ?? controller.titikPusat,
                      zoom: 15,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      ),
                      // Marker titik pusat (misalnya sekolah)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: controller.titikPusat,
                            child: Icon(Icons.school,
                                color: Colors.green, size: 40),
                          ),
                        ],
                      ),
                      // Marker posisi user
                      if (lokasi != null)
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: lokasi,
                              child: Icon(Icons.person_pin_circle,
                                  color: Colors.red, size: 40),
                            ),
                          ],
                        ),
                      // Circle area
                      if (lokasi != null)
                        CircleLayer(
                          circles: [
                            CircleMarker(
                              point: controller.titikPusat,
                              radius: controller.radiusMeter,
                              borderStrokeWidth: 2,
                              color: Colors.blue.withOpacity(0.2),
                              useRadiusInMeter: true,
                              borderColor: Colors.blue,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.indigo[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(() {
                    if (!controller.adaJadwalSekarang.value) {
                      return Column(
                        children: [
                          SizedBox(height: 20),
                          Text(
                            "Tidak ada jadwal presensi saat ini.",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        // Text(
                        //   "Jadwal Aktif: ${controller.jamJadwal.value}",
                        //   style: TextStyle(fontWeight: FontWeight.bold),
                        // ),
                        // SizedBox(height: 10),

                        /// Tombol Presensi
                        ElevatedButton(
                          onPressed: () => controller.presensi(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text("Presensi Masuk"),
                        ),
                        SizedBox(height: 10),

                        /// Tombol Izin
                        ElevatedButton(
                          onPressed: controller.ajukanIzin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text("Ajukan Izin"),
                        ),
                        ElevatedButton(
                          onPressed: () => controller.pulang(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text("Presensi Pulang"),
                        ),
                      ],
                    );
                  }),
                ],
              ),
              // child: const Center(
              //   child: Text(
              //     '08:45:12',
              //     style: TextStyle(
              //       fontSize: 32,
              //       fontWeight: FontWeight.bold,
              //       color: Colors.indigo,
              //     ),
              //   ),
              // ),
            ),
            const SizedBox(height: 30),

            // Riwayat atau status absen hari ini
            // Container(
            //   width: double.infinity,
            //   padding: const EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: const Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         'Status Hari Ini',
            //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            //       ),
            //       SizedBox(height: 10),
            //       Text('Absen Masuk: -'),
            //       Text('Absen Pulang: -'),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
