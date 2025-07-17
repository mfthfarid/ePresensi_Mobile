import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Login')),
      backgroundColor: const Color.fromARGB(255, 8, 57, 114),
      body: SafeArea(
        bottom: false,
        child: ListView(
          children: [
            SizedBox(height: 50),
            Image.asset('assets/images/login.png', height: 300),
            SizedBox(height: 50),
            Text(
              "Selamat Datang",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Ini adalah aplikasi presensi online yang harus digunakan didalam lingkungan sekolah",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 120),
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 12, 189, 121),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'Buat Akun',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 120),
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 5, 113, 211),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        // child: SingleChildScrollView(
        //   padding: EdgeInsets.all(24),
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Image.asset('assets/images/login.png', width: 200),
        //       SizedBox(height: 30),

        //       // ✅ Judul login
        //       Text(
        //         'Selamat Datang',
        //         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        //       ),
        //       SizedBox(height: 10),

        //       // ✅ Input Email
        //       TextField(
        //         controller: controller.emailController,
        //         decoration: InputDecoration(
        //           labelText: 'Email',
        //           filled: true,
        //           fillColor: Colors.white,
        //           border: OutlineInputBorder(),
        //         ),
        //       ),
        //       SizedBox(height: 16),

        //       // ✅ Input Password
        //       TextField(
        //         controller: controller.passwordController,
        //         decoration: InputDecoration(
        //           labelText: 'Password',
        //           filled: true,
        //           fillColor: Colors.white,
        //           border: OutlineInputBorder(),
        //         ),
        //         obscureText: true,
        //       ),
        //       SizedBox(height: 20),

        //       // ✅ Tombol login
        //       Obx(
        //         () => controller.isLoading.value
        //             ? CircularProgressIndicator()
        //             : ElevatedButton(
        //                 style: ElevatedButton.styleFrom(
        //                   backgroundColor: Colors.blue, // warna tombol
        //                   minimumSize: Size(double.infinity, 50), // lebar penuh
        //                 ),
        //                 onPressed: controller.login,
        //                 child: Text('Login'),
        //               ),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
