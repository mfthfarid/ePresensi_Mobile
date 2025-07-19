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

  void fetchRiwayat() async {
    try {
      isLoading.value = true;
      final snapshot = await FirebaseFirestore.instance
          .collection('riwayat_presensi')
          .where('userId', isEqualTo: '123456') // Ganti sesuai UID login
          .orderBy('waktu', descending: true)
          .get();

      riwayatList.value = snapshot.docs.map((doc) {
        final data = doc.data();
        final tanggalFormatted = DateFormat('dd MMM yyyy – HH:mm')
            .format((data['waktu'] as Timestamp).toDate());
        return {
          'tanggal': tanggalFormatted,
          'status': data['status'],
          'lokasi': data['lokasi'],
        };
      }).toList();
    } catch (e) {
      print('Error fetching riwayat: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
