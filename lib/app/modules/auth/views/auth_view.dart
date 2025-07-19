import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  final AuthController authController = Get.put(AuthController());
  // bool _isHiddenPasswrod = true;
  // bool _isHiddenConfirmPasswrod = true;

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
                "Aplikasi presensi online yang harus digunakan didalam lingkungan sekolah",
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
              padding: EdgeInsets.symmetric(horizontal: 90),
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
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
                  onPressed: () {
                    // Modal REGISTER
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return Wrap(
                              children: [
                                // Bagian MODAL
                                Container(
                                  color: Colors.transparent,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    // margin: EdgeInsets.symmetric(
                                    //   horizontal: 20,
                                    // ),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        202,
                                        220,
                                        255,
                                      ),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(40),
                                      ),
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 5,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Jarak
                                          SizedBox(height: 20),
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Register',
                                                    style: TextStyle(
                                                      fontSize: 28,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              Center(
                                                child: InkWell(
                                                  onTap: () {
                                                    authController.onClose();
                                                    Navigator.pop(context);
                                                  },
                                                  child: Image.asset(
                                                    'assets/images/close.png',
                                                    height: 20,
                                                    width: 20,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20),
                                          TextField(
                                            controller:
                                                authController.namaController,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              labelText: "Nama",
                                              hintText: "Nama siswa",
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          TextField(
                                            controller:
                                                authController.nisnController,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              labelText: "NISN",
                                              hintText: "03254",
                                              // suffixIcon: InkWell(
                                              //   onTap: () {
                                              //     // Menekan icon
                                              //   },
                                              //   child: Icon(
                                              //     Icons.visibility_outlined,
                                              //   ),
                                              // ),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          TextField(
                                            controller:
                                                authController.emailController,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              labelText: "Email",
                                              hintText: "siswa@gmail.com",
                                              suffixIcon: InkWell(
                                                onTap: () {
                                                  // Menekan icon
                                                },
                                                child: Icon(
                                                  Icons.email_outlined,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Obx(
                                            () => TextField(
                                              controller: authController
                                                  .passwordController,
                                              obscureText: controller
                                                  .isHiddenPassword
                                                  .value,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                labelText: "Password",
                                                hintText: "******",
                                                suffixIcon: InkWell(
                                                  onTap: controller
                                                      .togglePasswordVisibility,
                                                  child: Icon(
                                                    controller
                                                            .isHiddenPassword
                                                            .value
                                                        ? Icons
                                                              .visibility_off_outlined
                                                        : Icons
                                                              .visibility_outlined,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Obx(
                                            () => TextField(
                                              controller: authController
                                                  .confirmPasswordController,
                                              obscureText: controller
                                                  .isHiddenConfirmPassword
                                                  .value,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                labelText: "Confirm Password",
                                                hintText: "******",
                                                suffixIcon: InkWell(
                                                  onTap: controller
                                                      .toggleConfirmPasswordVisibility,
                                                  child: Icon(
                                                    controller
                                                            .isHiddenConfirmPassword
                                                            .value
                                                        ? Icons
                                                              .visibility_off_outlined
                                                        : Icons
                                                              .visibility_outlined,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Obx(
                                            () => Container(
                                              height: 50,
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width -
                                                  2 * 20,
                                              child:
                                                  AuthController()
                                                      .isLoading
                                                      .value
                                                  ? Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    )
                                                  : ElevatedButton(
                                                      onPressed: authController
                                                          .register,
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Color.fromARGB(
                                                              255,
                                                              221,
                                                              76,
                                                              197,
                                                            ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                15,
                                                              ),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        'Register',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Sudah punya akun?',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  // fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                ' Login',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  // fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 90),
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
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
                  onPressed: () {
                    // Modal LOGIN
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return Wrap(
                              children: [
                                // Bagian MODAL
                                Container(
                                  color: Colors.transparent,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    // margin: EdgeInsets.symmetric(
                                    //   horizontal: 20,
                                    // ),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        202,
                                        220,
                                        255,
                                      ),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 5,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Jarak
                                          SizedBox(height: 20),
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Login',
                                                    style: TextStyle(
                                                      fontSize: 28,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              Center(
                                                child: InkWell(
                                                  onTap: () {
                                                    authController.onClose();
                                                    Navigator.pop(context);
                                                  },
                                                  child: Image.asset(
                                                    'assets/images/close.png',
                                                    height: 20,
                                                    width: 20,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20),
                                          TextField(
                                            controller:
                                                authController.emailController,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              labelText: "NISN/Email",
                                              hintText:
                                                  "Masukan email atau NISN",
                                              suffixIcon: InkWell(
                                                // onTap: () {},
                                                child: Icon(
                                                  Icons.email_outlined,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Obx(
                                            () => TextField(
                                              controller: authController
                                                  .passwordController,
                                              obscureText: controller
                                                  .isHiddenPassword
                                                  .value,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                labelText: "Password",
                                                hintText: "******",
                                                suffixIcon: InkWell(
                                                  onTap: controller
                                                      .togglePasswordVisibility,
                                                  child: Icon(
                                                    controller
                                                            .isHiddenPassword
                                                            .value
                                                        ? Icons
                                                              .visibility_off_outlined
                                                        : Icons
                                                              .visibility_outlined,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'Lupa password?',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          SizedBox(height: 20),
                                          Container(
                                            height: 50,
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width -
                                                2 * 20,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                authController.login();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromARGB(
                                                  255,
                                                  221,
                                                  76,
                                                  197,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
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
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Sudah punya akun?',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  // fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                ' Login',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  // fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
