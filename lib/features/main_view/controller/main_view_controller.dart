import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../event/presentation/screen/event_screen.dart';
import '../../home/presentation/screen/home_screen.dart';
import '../../profile/presentation/screen/profile.dart';
import '../../search/presentation/screen/search.dart';


class MainViewController extends GetxController {
  var currentIndex = 0.obs;
  var isFabActive = false.obs;

  late final List<Widget> screens = [
    HomeScreen(),
    Search(),
   // SearchScreen(),
    EventScreen(),
    ProfilePage(),
  ];

  void changePage(int index) {
    currentIndex.value = index;
    isFabActive.value = false;
  }

  void toggleFab() {
    isFabActive.value = !isFabActive.value;
  }

  Widget get currentPage => screens[currentIndex.value];
}
