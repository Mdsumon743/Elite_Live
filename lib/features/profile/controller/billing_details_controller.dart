import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routing.dart';


class BillingDetailsController extends GetxController {
  // Dropdowns
  var selectedCountry = 'America'.obs;
  var selectedCurrency = 'US Dollar'.obs;
  var selectedTimeZone = 'Los Angeles, America (GMT-0.........)'.obs;

  final countries = ['America', 'Canada', 'United Kingdom', 'Australia'];
  final currencies = ['US Dollar', 'Canadian Dollar', 'British Pound', 'Euro'];
  final timeZones = [
    'Los Angeles, America (GMT-0.........)',
    'New York, America (GMT-5.........)',
    'London, UK (GMT+0.........)',
    'Tokyo, Japan (GMT+9.........)'
  ];

  // Text fields
  TextEditingController streetAddress1Controller = TextEditingController();
  TextEditingController streetAddress2Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController binController = TextEditingController();

  // Radio button
  var isBuyingForBusiness = true.obs;

  @override
  void onClose() {
    streetAddress1Controller.dispose();
    streetAddress2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    binController.dispose();
    super.onClose();
  }

  void onNext() {
    // Add your logic here
    Get.toNamed(AppRoute.paymentInfo);
  }
}