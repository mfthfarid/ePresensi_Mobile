import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  final controller = Get.put(HistoryController());
  // const HistoryView({super.key});

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
                    'Riwayat Presensi',
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.riwayatList.isEmpty) {
          return Center(child: Text("Belum ada riwayat presensi"));
        }

        return ListView.builder(
          itemCount: controller.riwayatList.length,
          itemBuilder: (context, index) {
            final riwayat = controller.riwayatList[index];
            return ListTile(
              leading: Icon(Icons.access_time),
              title: Text(riwayat['tanggal']),
              subtitle: Text("Status: ${riwayat['status']}"),
            );
          },
        );
      }),
    );
  }
}
