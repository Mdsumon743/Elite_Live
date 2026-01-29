import 'dart:developer';

import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/services/network_caller/repository/network_caller.dart';
import 'package:elites_live/core/utils/constants/app_urls.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../data/notification_data_model.dart';



class NotificationController extends GetxController {
  RxList<NotificationResult> notificationList = <NotificationResult>[].obs;
  RxBool isLoading = false.obs;

  final NetworkCaller networkCaller = NetworkCaller();
  final SharedPreferencesHelper helper = SharedPreferencesHelper();

  @override
  void onInit() {
    super.onInit();
    getAllNotification();
  }

  Future<void> getAllNotification() async {
    try {
      isLoading.value = true;

      final token = helper.getString("userToken");
      log("Fetching notifications with token: $token");

      final response = await networkCaller.getRequest(
        AppUrls.getAllNotification,
        token: token,
      );

      if (response.statusCode == 200 && response.isSuccess) {
        log("API Response: ${response.responseData}");

        final data = response.responseData;

        if (data is List) {
          // API returned array only
          notificationList.assignAll(
            data.map((e) => NotificationResult.fromJson(e)).toList(),
          );
        } else if (data is Map<String, dynamic>) {
          // API returned full object
          final model = NotificationDataModel.fromJson(data);
          notificationList.assignAll(model.result);
        } else {
          log("Unexpected response type: ${data.runtimeType}");
        }

        // Sort newest first
        notificationList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }
    } catch (e, st) {
      log("Error fetching notifications: $e\n$st");
    } finally {
      isLoading.value = false;
    }
  }
  
  
  /// update notificationStatus 
    Future<void> updateNotificationStatus(String notificationId)async{
    isLoading.value = true;
    final token = helper.getString("userToken");
    log("Fetching notifications status with token: $token");
    
    try{
      var response = await networkCaller.patchRequest(AppUrls.updateNotificationStatus(notificationId), body: {}, token: token);
      if(response.isSuccess) {
        log("the response is ${response.responseData}");
        await getAllNotification();
      }
    }
    catch(e){
      log("the exception is ${e.toString()}");
    }
    
    finally{
      isLoading.value = false;
    }
    }

  /// Return grouped notifications keyed by date header (Today/Yesterday/MMM d, yyyy)
  Map<String, List<NotificationResult>> get groupedNotifications {
    final Map<String, List<NotificationResult>> map = {};

    for (final n in notificationList) {
      final header = _getDateHeader(n.createdAt);
      map.putIfAbsent(header, () => []);
      map[header]!.add(n);
    }

    // maintain order: Today first, Yesterday second, then descending dates
    final orderedKeys = map.keys.toList()..sort((a, b) {
      DateTime pa = _parseHeaderToDate(a);
      DateTime pb = _parseHeaderToDate(b);
      return pb.compareTo(pa);
    });

    final orderedMap = <String, List<NotificationResult>>{};
    for (final k in orderedKeys) {
      orderedMap[k] = map[k]!;
    }

    return orderedMap;
  }

  String _getDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final d = DateTime(date.year, date.month, date.day);

    if (d == today) return 'Today';
    if (d == yesterday) return 'Yesterday';
    return DateFormat('MMMM d, yyyy').format(date); // e.g. December 25, 2025
  }

  // Helper to convert header back to a DateTime for sorting
  DateTime _parseHeaderToDate(String header) {
    if (header == 'Today') return DateTime.now();
    if (header == 'Yesterday') return DateTime.now().subtract(const Duration(days: 1));

    try {
      return DateFormat('MMMM d, yyyy').parse(header);
    } catch (_) {
      return DateTime(1970);
    }
  }

  String getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inSeconds < 60) return '${diff.inSeconds}s';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return DateFormat('MMM d').format(timestamp);
  }
}

