import 'dart:convert';
import 'dart:developer';

import 'package:elites_live/core/global_widget/custom_snackbar.dart';
import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/services/network_caller/repository/network_caller.dart';
import 'package:elites_live/core/utils/constants/app_urls.dart';
import 'package:elites_live/features/live/data/pool_data_model.dart';
import 'package:elites_live/features/live/data/pool_vote_data_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';



class CreatePollController extends GetxController {
  final questionController = TextEditingController();
  final newOptionController = TextEditingController();
  final RxList<String> options = <String>[].obs;
  var isLoading = false.obs;
  final NetworkCaller networkCaller = NetworkCaller();
  final SharedPreferencesHelper helper = SharedPreferencesHelper();
  RxList<PoolResult> poolList = <PoolResult>[].obs;


  RxMap<String, PoolVoteResult> poolVoteMap = <String, PoolVoteResult>{}.obs;


  final RxMap<int, RxList<bool>> checkedOptionsMap = <int, RxList<bool>>{}.obs;



  void initializeCheckedOptions(int pollIndex, int optionsCount) {
    if (!checkedOptionsMap.containsKey(pollIndex)) {
      checkedOptionsMap[pollIndex] = List<bool>.generate(optionsCount, (_) => false).obs;
    }
  }


  bool getCheckedValue(int pollIndex, int optionIndex) {
    if (checkedOptionsMap.containsKey(pollIndex)) {
      final list = checkedOptionsMap[pollIndex]!;
      if (optionIndex < list.length) {
        return list[optionIndex];
      }
    }
    return false;
  }

  void setCheckedValue(int pollIndex, int optionIndex, bool value) {
    if (checkedOptionsMap.containsKey(pollIndex)) {
      final list = checkedOptionsMap[pollIndex]!;
      if (optionIndex < list.length) {
        list[optionIndex] = value;
      }
    }
  }


  void clearCheckedStates() {
    checkedOptionsMap.clear();
  }


  List<String> getSelectedOptions(int pollIndex, List<String> pollOptions) {
    if (!checkedOptionsMap.containsKey(pollIndex)) {
      return [];
    }

    final checkedList = checkedOptionsMap[pollIndex]!;
    final selectedOptions = <String>[];

    for (int i = 0; i < checkedList.length && i < pollOptions.length; i++) {
      if (checkedList[i]) {
        selectedOptions.add(pollOptions[i]);
      }
    }

    return selectedOptions;
  }

  void addOption(String option) {
    if (option.trim().isNotEmpty) {
      options.add(option.trim());
      newOptionController.clear();
    }
  }

  /// create pool
  Future<void> createPool(String streamId) async {
    isLoading.value = true;
    String? token = helper.getString("userToken");
    log("token during create pool: $token");

    try {
      final Map<String, dynamic> body = {
        "question": questionController.text.trim(),
        "options": options.toList(),
      };

      log("Sending Poll Body: $body");

      var response = await networkCaller.postRequest(
        AppUrls.createPool(streamId),
        body: body,
        token: token,
      );

      if (response.statusCode == 201 && response.isSuccess) {
        log("Poll Created: ${response.responseData}");

        // Clear fields and refresh
        questionController.clear();
        options.clear();
        await getPool(streamId);

        Get.back();
        CustomSnackBar.success(title: "Success", message: "Poll created successfully");

      } else {
        log("Poll Create Failed: ${response.responseData}");
        CustomSnackBar.error(title: "Error", message: "Failed to create Pool");

      }
    } catch (e) {
      log("Exception in createPool: ${e.toString()}");
      CustomSnackBar.error(title: "Error", message: "Failed to create Pool");
    } finally {
      isLoading.value = false;
    }
  }

  /// get pool
  Future<void> getPool(String streamId) async {
    isLoading.value = true;
    String? token = helper.getString("userToken");
    log("Fetching polls for streamId: $streamId");

    try {
      var response = await networkCaller.getRequest(
        AppUrls.getSinglePool(streamId),
        token: token,
      );

      log("Response Status: ${response.statusCode}");
      log("Response Data: ${response.responseData}");

      if (response.isSuccess && response.responseData != null) {
        List<PoolResult> polls = [];

        // Check if response.responseData is the wrapper or direct result
        if (response.responseData is Map) {
          final data = Map<String, dynamic>.from(response.responseData);

          // Check if it has the wrapper structure (success, message, result)
          if (data.containsKey('success') && data.containsKey('result')) {
            log("✅ Response has wrapper structure");
            final result = data['result'];

            if (result is List) {
              polls = result
                  .map((item) => PoolResult.fromJson(Map<String, dynamic>.from(item)))
                  .toList();
            } else if (result is Map) {
              polls = [PoolResult.fromJson(Map<String, dynamic>.from(result))];
            }
          } else {
            // Direct result object (no wrapper)
            log("✅ Response is direct result object");
            polls = [PoolResult.fromJson(data)];
          }
        } else if (response.responseData is List) {
          log("✅ Response is a List");
          polls = (response.responseData as List)
              .map((item) => PoolResult.fromJson(Map<String, dynamic>.from(item)))
              .toList();
        }

        log("✅ Parsed ${polls.length} polls");

        if (polls.isNotEmpty) {
          poolList.value = polls;
          log("✅ Successfully loaded ${poolList.length} polls");

          for (var poll in poolList) {
            log("  📊 Poll: ${poll.question} (${poll.options.length} options)");
          }
        } else {
          log("⚠️ No polls found");
          poolList.clear();
        }
      } else {
        log("❌ API call failed with status: ${response.statusCode}");
        CustomSnackBar.error(title: "Error", message: "Error loading polls:");
      }
    } catch (e, stackTrace) {
      log("❌ Exception in getPool: $e");
      log("Stack trace: $stackTrace");
      CustomSnackBar.error(title: "Error", message: "Error loading polls: ${e.toString()}");
    } finally {
      isLoading.value = false;
      log("🔹 getPool completed. poolList.length = ${poolList.length}");
    }
  }

  /// update pool
  /// Update pool with question and options
  Future<void> updatePool(String poolId, String streamId, String question, List<String> options) async {
    if (question.trim().isEmpty) {
      CustomSnackBar.error(title: "Error", message: "Question cannot be empty");
      return;
    }

    if (options.isEmpty) {

      CustomSnackBar.error(title: "Error", message: "Add at least one option");
      return;
    }

    isLoading.value = true;
    String? token = helper.getString("userToken");
    log("Token during update pool: $token");

    try {
      final Map<String, dynamic> body = {
        "question": question.trim(),
        "options": options, // Include options in update
      };

      log("Updating Poll Body: $body");

      var response = await networkCaller.patchRequest(
        AppUrls.updatePool(poolId),
        body: body,
        token: token,
      );

      if (response.statusCode == 200 && response.isSuccess) {
        log("Poll updated: ${response.responseData}");

        // Clear the form
        questionController.clear();
        this.options.clear();

        // Refresh poll list
        await getPool(streamId);

        Get.back();
        CustomSnackBar.success(
         title:  "Success",
        message:   "Poll updated successfully",

        );
      } else {
        log("Poll update failed: ${response.responseData}");
        CustomSnackBar.error(
         title:  "Error",
        message:   response.responseData?['message'] ?? "Failed to update poll",

        );
      }
    } catch (e) {
      log("Exception in updatePool: ${e.toString()}");
      CustomSnackBar.error(
       title:  "Error",
       message:  "Something went wrong",

      );
    } finally {
      isLoading.value = false;
    }
  }

  /// delete pool
  Future<void> deletePool(String poolId, String streamId) async {
    isLoading.value = true;
    String? token = helper.getString("userToken");
    log("the token during delete pool is $token");
    try {
      var response =
      await networkCaller.deleteRequest(AppUrls.deletePool(poolId), token);
      if (response.isSuccess) {
        log("the api response is ${response.responseData}");
        await getPool(streamId);
        CustomSnackBar.success(title: "Success", message: "Poll deleted successfully");
      }
    } catch (e) {
      log("the exception is ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  /// Vote on a pool with selected options
  /// Vote on a pool with selected option
  Future<void> votePool(String poolId, String streamId, List<String> selectedOptions) async {
    if (selectedOptions.isEmpty) {
      CustomSnackBar.error(title: "Error", message: "Please select at least one option");
      return;
    }

    isLoading.value = true;
    String? token = helper.getString("userToken");
    log("Token during vote pool: $token");
    log("Voting on poll: $poolId with option: ${selectedOptions.first}");

    try {
      // Send single option as string (API expects "option" not "options")
      final Map<String, dynamic> body = {
        "option": selectedOptions.first, // ✅ Send first selected option as string
      };

      log("Vote Body: $body");

      var response = await networkCaller.postRequest(
        AppUrls.votePool(poolId),
        body: body,
        token: token,
      );

      if (response.isSuccess && response.statusCode == 200) {
        log("Vote successful: ${response.responseData}");


        clearCheckedStates();


        await getPool(streamId);
        await getPoolVoteResultByStream(streamId);
        CustomSnackBar.success(title: "Success", message: "Vote submitted successfully");


      } else {
        log("Vote failed: ${response.responseData}");
        CustomSnackBar.error(title: "Error", message: "Failed to create Pool");

      }
    } catch (e) {
      log("Exception in votePool: ${e.toString()}");
      CustomSnackBar.error(title: "Error", message: "Failed to create Pool ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  /// get pool vote result - FIXED VERSION
  Future<void> getPoolVoteResultByStream(String streamId) async {
    String? token = helper.getString("userToken");
    log("🔍 Fetching vote results for streamId: $streamId");

    try {
      // Use streamId instead of pollId in the endpoint
      var response = await networkCaller.getRequest(
        AppUrls.poolResult(streamId), // ✅ Pass streamId, not pollId
        token: token,
      );

      log("📊 Response Status: ${response.statusCode}");
      log("📊 Raw Response: ${response.responseData}");

      if (response.isSuccess && response.responseData != null) {
        try {
          // The response can be a single poll result or array of results
          List<dynamic> resultsArray = [];

          if (response.responseData is String) {
            final decoded = json.decode(response.responseData);
            if (decoded is Map && decoded.containsKey('result')) {
              final result = decoded['result'];
              resultsArray = result is List ? result : [result];
            } else if (decoded is List) {
              resultsArray = decoded;
            } else {
              resultsArray = [decoded];
            }
          } else if (response.responseData is Map) {
            final responseMap = Map<String, dynamic>.from(response.responseData);

            if (responseMap.containsKey('result')) {
              final result = responseMap['result'];
              resultsArray = result is List ? result : [result];
            } else {
              resultsArray = [responseMap];
            }
          } else if (response.responseData is List) {
            resultsArray = response.responseData;
          }

          log("📊 Processing ${resultsArray.length} poll result(s)");

          // Process each poll result
          for (var resultData in resultsArray) {
            final resultMap = Map<String, dynamic>.from(resultData);
            final pollResult = PoolVoteResult.fromJson(resultMap);

            // Store using poll ID as key
            poolVoteMap[pollResult.id] = pollResult;

            log("✅ Stored vote results for poll: ${pollResult.id}");
            log("   Question: ${pollResult.question}");
            log("   Total options: ${pollResult.options.length}");
          }

          // Trigger UI update
          poolVoteMap.refresh();
          log("✅ Completed fetching poll results for stream: $streamId");

        } catch (parseError, parseStack) {
          log("❌ Parse Error: $parseError");
          log("Parse Stack: $parseStack");
        }
      } else {
        log("⚠️ API call failed or returned no data");
      }
    } catch (e, stackTrace) {
      log("❌ Network Error: $e");
      log("Stack: $stackTrace");
    }
  }

  /// Get vote result for specific poll by ID
  PoolVoteResult? getVoteResultForPoll(String pollId) {
    final result = poolVoteMap[pollId];
    log("🔍 Looking up vote result for poll: $pollId, Found: ${result != null}");
    return result;
  }

  void removeOption(int index) {
    options.removeAt(index);
  }

  @override
  void onClose() {
    questionController.clear();
    newOptionController.clear();
    options.clear();
    clearCheckedStates();
    super.onClose();
  }
}