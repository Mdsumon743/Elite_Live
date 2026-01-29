import 'package:get/get.dart';

class ProfileTabsController extends GetxController {
  final String gridActive = 'assets/icons/grid_active.png';
  final String gridInactive = 'assets/icons/grid_inactive.png';
  final String scheduleActive = 'assets/icons/calendar_active.png';
  final String scheduleInactive = 'assets/icons/calender_inactive.png';
  final String crowdActive = 'assets/icons/calendar_active.png';
  final String crowdInactive = 'assets/icons/calender_inactive.png';
  RxInt selectedIndex = 0.obs;
}