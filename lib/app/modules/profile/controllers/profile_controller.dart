import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  RxString email = ''.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    ambilDataPengguna();
  }

  void ambilDataPengguna() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      email.value = user.email ?? 'Email tidak tersedia';
    }
  }

  // Future<void> updateEmail() async {
  //   try {
  //     final user = FirebaseAuth.instance.currentUser;
  //     if (user != null) {
  //       await user.updateEmail(emailController.text);
  //       await user.reload();
  //       ambilDataPengguna();
  //       Get.snackbar("Berhasil", "Email berhasil diperbarui");
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'email-already-in-use') {
  //       Get.snackbar("Gagal", "Email sudah digunakan oleh akun lain.");
  //     } else if (e.code == 'invalid-email') {
  //       Get.snackbar("Gagal", "Format email tidak valid.");
  //     } else if (e.code == 'requires-recent-login') {
  //       Get.snackbar("Gagal", "Silakan login ulang untuk mengubah email.");
  //     } else {
  //       Get.snackbar("Gagal", "Terjadi kesalahan: ${e.message}");
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", "Gagal memperbarui email: $e");
  //   }
  // }

  Future<void> updatePassword() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePassword(passwordController.text);
        Get.snackbar("Berhasil", "Password berhasil diperbarui");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memperbarui password: $e");
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed('/login');
  }
}
