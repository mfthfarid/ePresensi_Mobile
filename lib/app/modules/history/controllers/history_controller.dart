import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HistoryController extends GetxController {
  RxList<Map<String, dynamic>> riwayatList = <Map<String, dynamic>>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRiwayat();
  }

  Future<void> fetchRiwayat() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar("Error", "User belum login");
        return;
      }

      isLoading.value = true;

      final snapshot = await FirebaseFirestore.instance
          .collection('presensi')
          .where('userId', isEqualTo: user.uid)
          .orderBy('waktu', descending: true)
          .get();

      // Debug
      print("Ditemukan ${snapshot.docs.length} data presensi");

      riwayatList.value = snapshot.docs.map((doc) {
        final data = doc.data();
        final waktu = data['waktu'];
        String formattedTanggal = 'Tanggal tidak valid';

        if (waktu is Timestamp) {
          formattedTanggal =
              DateFormat('dd MMM yyyy – HH:mm').format(waktu.toDate());
        }

        return {
          'tanggal': formattedTanggal,
          'keterangan': data['ket'] ?? 'Tidak diketahui',
          'jadwalId': data['jadwalId'] ?? '-',
        };
      }).toList();
    } catch (e) {
      print('Error saat mengambil riwayat: $e');
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
