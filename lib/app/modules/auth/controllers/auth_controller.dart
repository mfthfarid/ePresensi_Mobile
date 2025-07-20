import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_presensi/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final namaController = TextEditingController();
  final nisnController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  // var bottom = 0.0.obs;
  RxBool isLoading = false.obs;
  var isHiddenPassword = true.obs;
  var isHiddenConfirmPassword = true.obs;

  void togglePasswordVisibility() {
    isHiddenPassword.value = !isHiddenPassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    isHiddenConfirmPassword.value = !isHiddenConfirmPassword.value;
  }

  // FUngsi Register
  void register() async {
    final nama = namaController.text.trim();
    final nisn = nisnController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    if (nama.isEmpty) {
      Get.snackbar("Gagal Register", "Nama tidak boleh kosong");
      return;
    }
    if (nisnController.text.isEmpty) {
      Get.snackbar("Gagal Register", "NISN tidak boleh kosong");
      return;
    }
    if (emailController.text.isEmpty) {
      Get.snackbar("Gagal Register", "Email tidak boleh kosong");
      return;
    }
    if (password.length < 6) {
      Get.snackbar("Gagal Register", "Password minimal 6 karakter");
      if (password != confirmPassword) {
        Get.snackbar("Gagal Register", "Password tidak sama");
        return;
      }
    }

    isLoading.value = true;
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final uid = userCredential.user!.uid;
      final nisn = nisnController.text.trim();

      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        'uid': uid,
        'nisn': nisn,
        'nama': namaController.text,
        'email': emailController.text.trim(),
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      });

      Get.snackbar("Berhasil", "Register berhasil");
      Get.offAllNamed(Routes.LOGIN);
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Gagal Register", e.message ?? "Terjadi kesalahan");
    } finally {
      isLoading.value = false;
    }
  }

  void login() async {
    isLoading.value = true;
    String emailLogin = emailController.text.trim();

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Gagal Login", "Email/NISN dan Password wajib diisi");
      return;
    }

    try {
      // Input NISN
      if (!emailController.text.contains("@")) {
        // Cari user berdasarkan NISN
        final snapshot = await firestore
            .collection('users')
            .where('nisn', isEqualTo: emailController.text.trim())
            .limit(1)
            .get();

        if (snapshot.docs.isEmpty) {
          Get.snackbar("Gagal Login", "NISN tidak ditemukan");
          isLoading.value = false;
          return;
        }
        emailLogin = snapshot.docs.first['email'];
      }
      // Login menggunakan email
      await auth.signInWithEmailAndPassword(
        email: emailLogin,
        password: passwordController.text.trim(),
      );

      Get.snackbar("Berhasil", "Login berhasil");
      Get.offAllNamed(Routes.HOME); // navigasi ke halaman utama
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          Get.snackbar("Gagal Login", "Email tidak ditemukan");
          break;
        case 'wrong-password':
          Get.snackbar("Gagal Login", "Password salah");
          break;
        case 'invalid-email':
          Get.snackbar("Gagal Login", "Format email salah");
          break;
        case 'user-disabled':
          Get.snackbar("Gagal Login", "Akun dinonaktifkan");
          break;
        case 'too-many-requests':
          Get.snackbar(
            "Gagal Login",
            "Terlalu banyak percobaan login. Coba beberapa saat lagi",
          );
          break;
        case 'invalid-credential':
          Get.snackbar("Gagal Login", "Password salah");
          break;
        default:
          Get.snackbar(
            "Gagal Login",
            e.message ?? "Terjadi kesalahan yang tidak diketahui",
          );
      }
    }
  }

  @override
  void onClose() {
    namaController.clear();
    nisnController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }
}
