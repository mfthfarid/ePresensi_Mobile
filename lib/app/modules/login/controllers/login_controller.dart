import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLogin = true.obs;
  var bottom = 0.0.obs;
  RxBool isLoading = false.obs;

  void login() async {
    isLoading.value = true;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Get.snackbar("Berhasil", "Login berhasil");
      // Get.offAllNamed(Routes.HOME); // Navigasi ke halaman utama jika berhasil
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Gagal Login", e.message ?? "Terjadi kesalahan");
    } finally {
      isLoading.value = false;
    }
  }
}
