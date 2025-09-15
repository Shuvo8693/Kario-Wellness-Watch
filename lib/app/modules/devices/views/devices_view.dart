import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kario_wellness_watch/common/bottom_menu/bottom_menu..dart';

import '../controllers/devices_controller.dart';

class DevicesView extends StatelessWidget {
  const DevicesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(child: BottomMenu(2)),
      appBar: AppBar(
        title: const Text('DevicesView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DevicesView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
