import 'package:e_presensi/app/modules/absensi/views/absensi_view.dart';
import 'package:e_presensi/app/modules/history/controllers/history_controller.dart';
import 'package:e_presensi/app/modules/history/views/history_view.dart';
import 'package:e_presensi/app/modules/home/views/home_view.dart';
import 'package:e_presensi/app/modules/profile/controllers/profile_controller.dart';
import 'package:e_presensi/app/modules/profile/views/profile_view.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Get.lazyPut(() => HomeController());
    Get.lazyPut(() => AbsensiView());
    Get.lazyPut(() => HistoryController());
    Get.lazyPut(() => ProfileController());
  }

  final List<Widget> pages = [
    const Center(
      child: Text(
        '',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
    // HomeView(),
    AbsensiView(),
    HistoryView(),
    ProfileView(),
  ];

  void changePage(int index) {
    currentIndex.value = index;
  }
}
