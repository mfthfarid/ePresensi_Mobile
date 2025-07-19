import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Saya'), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            // if (controller.photoURL.isNotEmpty)
            //   CircleAvatar(
            //     radius: 50,
            //     // backgroundImage: NetworkImage(controller.photoURL),
            //   )
            // else
            //   (const CircleAvatar(radius: 50, child: Icon(Icons.person))),
            const SizedBox(height: 20),
            Text('Email: ', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                controller.logout();
              },
              icon: Icon(Icons.logout),
              label: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
