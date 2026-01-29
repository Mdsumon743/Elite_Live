
import 'dart:developer';

import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/services/network_caller/repository/network_caller.dart';
import 'package:elites_live/core/utils/constants/app_urls.dart';
import 'package:elites_live/features/profile/data/my_recording_data_model.dart';

import 'package:get/get.dart';

import '../data/my_event_data_model.dart';


class MyScheduleEventController extends GetxController {
  var isLoading = false.obs;
  final NetworkCaller networkCaller = NetworkCaller();
  final SharedPreferencesHelper helper = SharedPreferencesHelper();
  RxInt page = 1.obs;
  RxInt limit = 20.obs;

  RxList<MyEventResult> myEventScheduleList = <MyEventResult>[].obs;
  RxList<MyRecordingResult> myRecordingList = <MyRecordingResult>[].obs;

  @override
  void onInit() {
    super.onInit();
    getMyRecording();
    getMyScheduleEvent(page.value, limit.value);
  }

  /// get my schedule event
  Future<void> getMyScheduleEvent(int page, int limit) async {
    isLoading.value = true;
    String? token = helper.getString("userToken");
    log("token during fetch my event is $token");

    try {
      var response = await networkCaller.getRequest(AppUrls.myEvent(page, limit), token: token);

      if (response.isSuccess) {
        log("=== RAW API RESPONSE ===");
        log("${response.responseData}");
        log("Response type: ${response.responseData.runtimeType}");


        Map<String, dynamic> data = response.responseData;

        MyEventResult scheduleResult;


        if (data.containsKey('result')) {
          log("Response has 'result' wrapper");
          final schedule = MyEventDataModel.fromJson(data);
          scheduleResult = schedule.result;
        } else if (data.containsKey('events')) {

          log("Response is direct result object");
          scheduleResult = MyEventResult.fromJson(data);
        } else {
          log("ERROR: Unknown response structure");
          log("Keys in response: ${data.keys.toList()}");
          return;
        }




        for (var i = 0; i < scheduleResult.events.length && i < 3; i++) {
          final event = scheduleResult.events[i];
          log("Event $i:");
          log("  - ID: ${event.id}");
          log("  - Type: ${event.eventType}");
          log("  - Text: ${event.text}");
          log("  - User: ${event.user.firstName} ${event.user.lastName}");
        }

        // Assign the result
        myEventScheduleList.assignAll([scheduleResult]);

        log("=== ASSIGNMENT COMPLETE ===");
        log("myEventScheduleList length: ${myEventScheduleList.length}");
        if (myEventScheduleList.isNotEmpty) {
          log("First item events count: ${myEventScheduleList.first.events.length}");
        }
      } else {
        log("API request failed: ${response.errorMessage}");
      }
    } catch (e, stackTrace) {
      log("=== EXCEPTION ===");
      log("Exception: ${e.toString()}");
      log("Stack trace: $stackTrace");
    } finally {
      isLoading.value = false;
      log("Loading complete. Final list length: ${myEventScheduleList.length}");
    }
  }


  /// my recording

  /// my recording
  Future<void> getMyRecording() async {
    isLoading.value = true;
    String? token = helper.getString("userToken");
    log("token during fetch my recording is $token");

    try {
      var response = await networkCaller.getRequest(AppUrls.getMyRecording, token: token);

      if (response.isSuccess) {
        log("=== RAW API RESPONSE ===");
        log("${response.responseData}");
        log("Response type: ${response.responseData.runtimeType}");

        // Check if response is a List directly
        if (response.responseData is List) {
          log("Response is a direct List");
          List<dynamic> dataList = response.responseData;

          // Parse each item in the list
          List<MyRecordingResult> recordings = dataList
              .map((item) => MyRecordingResult.fromJson(item as Map<String, dynamic>))
              .toList();

          // Assign the list of recordings
          myRecordingList.assignAll(recordings);

        } else if (response.responseData is Map<String, dynamic>) {
          log("Response is a Map with wrapper");
          Map<String, dynamic> data = response.responseData;

          // Parse the response using the model
          final recording = MyRecordingDataModel.fromJson(data);

          // Assign the list of recordings directly
          myRecordingList.assignAll(recording.result);
        } else {
          log("ERROR: Unknown response type");
          return;
        }

        log("=== ASSIGNMENT COMPLETE ===");
        log("myRecordingList length: ${myRecordingList.length}");

        // Log first few recordings
        for (var i = 0; i < myRecordingList.length && i < 3; i++) {
          final rec = myRecordingList[i];
          log("Recording $i:");
          log("  - ID: ${rec.id}");
          log("  - Recording Link: ${rec.recordingLink}");
          log("  - Watch Count: ${rec.watchCount}");
        }

      } else {
        log("API request failed: ${response.errorMessage}");
      }
    } catch (e, stackTrace) {
      log("=== EXCEPTION ===");
      log("Exception: ${e.toString()}");
      log("Stack trace: $stackTrace");
    } finally {
      isLoading.value = false;
      log("Loading complete. Final list length: ${myRecordingList.length}");
    }
  }

  /// get others user information

}