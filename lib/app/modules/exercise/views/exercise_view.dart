import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kario_wellness_watch/common/bottom_menu/bottom_menu..dart';

import '../controllers/exercise_controller.dart';

class ExerciseView extends StatelessWidget {
  const ExerciseView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(1),
      appBar: AppBar(
        title: const Text('ExerciseView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ExerciseView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
