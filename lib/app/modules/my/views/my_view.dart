import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kario_wellness_watch/common/bottom_menu/bottom_menu..dart';

import '../controllers/my_controller.dart';

class MyView extends StatelessWidget {
  const MyView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(3),
      appBar: AppBar(
        title: const Text('MyView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MyView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
