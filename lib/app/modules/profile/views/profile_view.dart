import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  // const ProfileView({super.key});
  final controller = Get.put(ProfileController());
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
                    'Profile',
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text('Email Sekarang: ${controller.email.value}',
                style: TextStyle(fontSize: 16))),
            const SizedBox(height: 20),
            // TextField(
            //   controller: controller.emailController,
            //   decoration: InputDecoration(labelText: 'Edit Email'),
            // ),
            // ElevatedButton(
            //   onPressed: controller.updateEmail,
            //   child: Text('Perbarui Email'),
            // ),
            const SizedBox(height: 20),
            TextField(
              controller: controller.passwordController,
              decoration: InputDecoration(labelText: 'Ganti Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: controller.updatePassword,
              child: Text('Perbarui Password'),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: controller.logout,
              icon: Icon(Icons.logout),
              label: Text('Logout'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
