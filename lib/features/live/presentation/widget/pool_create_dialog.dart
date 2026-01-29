import 'dart:developer';

import 'package:elites_live/core/global_widget/custom_elevated_button.dart';
import 'package:elites_live/core/global_widget/custom_snackbar.dart';
import 'package:elites_live/core/global_widget/custom_text_field.dart';
import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controller/create_pool_controller.dart';
import '../../data/pool_data_model.dart';
import '../../data/pool_vote_data_model.dart';

class CreatePollDialog {
  static void show(BuildContext context, {required String streamId}) {
    final controller = Get.put(CreatePollController());
    Future.microtask(() => controller.getPool(streamId));

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Obx(
          () => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: const EdgeInsets.all(20),
            backgroundColor: Colors.white,
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Create Polls",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.clearCheckedStates();
                            Get.back();
                            Get.delete<CreatePollController>();
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.black54,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Existing Polls
                    if (controller.poolList.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Existing Polls",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...controller.poolList.asMap().entries.map((
                            pollEntry,
                          ) {
                            final pollIndex = pollEntry.key;
                            final poll = pollEntry.value;

                            // Initialize checked options for this poll
                            controller.initializeCheckedOptions(
                              pollIndex,
                              poll.options.length,
                            );

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[50],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    poll.question,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Options with checkboxes
                                  Column(
                                    children:
                                        poll.options.asMap().entries.map((
                                          entry,
                                        ) {
                                          int optionIdx = entry.key;
                                          String option = entry.value;

                                          return CheckboxListTile(
                                            contentPadding: EdgeInsets.zero,
                                            dense: true,
                                            title: Text(
                                              option,
                                              style: const TextStyle(
                                                fontSize: 13,
                                              ),
                                            ),
                                            value: controller.getCheckedValue(
                                              pollIndex,
                                              optionIdx,
                                            ),
                                            onChanged: (val) {
                                              controller.setCheckedValue(
                                                pollIndex,
                                                optionIdx,
                                                val ?? false,
                                              );
                                            },
                                            activeColor: Colors.purple,
                                          );
                                        }).toList(),
                                  ),

                                  const SizedBox(height: 8),

                                  // Action buttons
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // Vote Button
                                      GestureDetector(
                                        onTap: () {
                                          final selectedOptions = controller
                                              .getSelectedOptions(
                                                pollIndex,
                                                poll.options,
                                              );

                                          if (selectedOptions.isEmpty) {
                                            CustomSnackBar.warning(title: "Info", message: "Please select at least one option to vote");

                                            return;
                                          }

                                          controller.votePool(
                                            poll.id,
                                            streamId,
                                            selectedOptions,
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: const Text(
                                            "Vote",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),

                                      // Edit Button
                                      GestureDetector(
                                        onTap: () {
                                          _showEditPollDialog(
                                            context,
                                            controller,
                                            poll,
                                            streamId,
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: const Text(
                                            "Edit",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),

                                      // Delete Button
                                      GestureDetector(
                                        onTap: () {
                                          _showDeleteConfirmation(
                                            context,
                                            controller,
                                            poll.id,
                                            streamId,
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: const Text(
                                            "Delete",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(height: 20),
                        ],
                      ),

                    // New Poll Question
                    const Text(
                      "Question",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.questionController,
                      decoration: InputDecoration(
                        hintText: "What's your poll about?",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.purple,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // New Poll Options
                    const Text(
                      "Options",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children:
                          controller.options.asMap().entries.map((entry) {
                            int index = entry.key;
                            String option = entry.value;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      option,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => controller.removeOption(index),
                                    child: Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                    ),

                    // Add Option Button
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        _showAddOptionField(context, controller);
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.purple,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 16,
                              color: Colors.purple,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Add option",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.purple,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            controller.isLoading.value
                                ? null
                                : () => controller.createPool(streamId),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child:
                            controller.isLoading.value
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text(
                                  "Save",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // See Result Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          PollResultsDialog.show(context, streamId);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.bar_chart,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "See Results",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).then((_) {
      controller.clearCheckedStates();
      Get.delete<CreatePollController>();
    });
  }

  // Show edit dialog for existing poll
  static void _showEditPollDialog(
    BuildContext context,
    CreatePollController controller,
    PoolResult poll,
    String streamId,
  ) {
    final editQuestionController = TextEditingController(text: poll.question);

    // Store original options separately
    final List<String> originalOptions = List<String>.from(poll.options);

    // Track all options (original + new)
    final RxList<String> editOptions = RxList<String>.from(poll.options);
    final editOptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 20),

          title: Text(
            "Edit Poll",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textHeader,
            ),
          ),

          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question label
                CustomTextView(
                  text: "Question",

                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBody,
                ),
                const SizedBox(height: 8),

                // Question input
                TextField(
                  controller: editQuestionController,
                  style: const TextStyle(color: AppColors.textColorBlack),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.lightModeontainerBg,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.lightGrey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Options Title
                CustomTextView(
                  text: "Options",

                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBody,
                ),
                const SizedBox(height: 8),

                // Options List
                Obx(
                  () => Column(
                    children:
                        editOptions.asMap().entries.map((entry) {
                          final isOriginal = originalOptions.contains(
                            entry.value,
                          );

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isOriginal
                                      ? AppColors.lightModeontainerBg
                                          .withValues(alpha: 0.5)
                                      : AppColors.lightModeontainerBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    isOriginal
                                        ? AppColors.lightGrey
                                        : AppColors.secondaryColor.withValues(
                                          alpha: 0.5,
                                        ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text(
                                        entry.value,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textColorBlack,
                                          fontWeight:
                                              isOriginal
                                                  ? FontWeight.normal
                                                  : FontWeight.w600,
                                        ),
                                      ),
                                      if (!isOriginal) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.secondaryColor,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: const Text(
                                            "NEW",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                // Only allow deletion of new options, not original ones
                                if (!isOriginal)
                                  GestureDetector(
                                    onTap:
                                        () => editOptions.removeAt(entry.key),
                                    child: const Icon(
                                      Icons.close,
                                      size: 20,
                                      color: Colors.redAccent,
                                    ),
                                  )
                                else
                                  const Icon(
                                    Icons.lock_outline,
                                    size: 18,
                                    color: AppColors.textGrey,
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ),

                const SizedBox(height: 10),

                // Add option field
                TextField(
                  controller: editOptionController,
                  decoration: InputDecoration(
                    hintText: "Add new option",
                    filled: true,
                    fillColor: AppColors.primaryWhiteSmoke,
                    hintStyle: const TextStyle(color: AppColors.textGrey),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.lightGrey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: AppColors.secondaryColor,
                      ),
                      onPressed: () {
                        final newOption = editOptionController.text.trim();
                        if (newOption.isNotEmpty) {
                          if (editOptions.contains(newOption)) {
                            CustomSnackBar.warning(title: "Warning", message: "This option already exists");

                          } else {
                            editOptions.add(newOption);
                            editOptionController.clear();
                          }
                        }
                      },
                    ),
                  ),
                  onSubmitted: (value) {
                    final newOption = value.trim();
                    if (newOption.isNotEmpty) {
                      if (editOptions.contains(newOption)) {
                        CustomSnackBar.warning(title: "Warning", message: "This option already exists");

                      } else {
                        editOptions.add(newOption);
                        editOptionController.clear();
                      }
                    }
                  },
                ),
              ],
            ),
          ),

          // Action Buttons
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          actions: [
            Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    ontap: () {
                      Get.back();
                    },
                    text: "Cancel",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomElevatedButton(
                    ontap: () {
                      // Get only the NEW options (not in original list)
                      final newOptions =
                          editOptions
                              .where(
                                (option) => !originalOptions.contains(option),
                              )
                              .toList();

                      log("Original options: $originalOptions");
                      log("All options: ${editOptions.toList()}");
                      log("New options to send: $newOptions");

                      controller.updatePool(
                        poll.id,
                        streamId,
                        editQuestionController.text.trim(),
                        newOptions, // ✅ Send only NEW options
                      );
                    },
                    text: "Update",
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Show delete confirmation
  static void _showDeleteConfirmation(
    BuildContext context,
    CreatePollController controller,
    String pollId,
    String streamId,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: CustomTextView(
            text: "Delete Poll",
            color: AppColors.textHeader,
            fontWeight: FontWeight.w500,
            fontSize: 22.sp,
            textAlign: TextAlign.center,
          ),
          content: CustomTextView(
            text: "Are you sure you want to delete this poll?",
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textBody,
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    ontap: () {
                      Get.back();
                    },
                    text: "Cancel",
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.h),
            Expanded(
              child: CustomElevatedButton(
                ontap: () {
                  Get.back();
                  controller.deletePool(pollId, streamId);
                },

                text: "Delete",
              ),
            ),
          ],
        );
      },
    );
  }

  static void _showAddOptionField(
    BuildContext context,
    CreatePollController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: CustomTextView(
            text: "Add Option",

            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textHeader,
          ),
          content: CustomTextField(
            controller: controller.newOptionController,

            onSubmitted: (value) {
              controller.addOption(value);
              Get.back();
            },
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    ontap: () {
                      Get.back();
                    },
                    text: "Cancel",
                  ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: CustomElevatedButton(
                    ontap: () {
                      controller.addOption(
                        controller.newOptionController.text.trim(),
                      );
                      Get.back();
                    },
                    text: "Add",
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}



class PollResultsDialog {
  static void show(BuildContext context, String streamId) {
    final controller = Get.find<CreatePollController>();

    controller.getPoolVoteResultByStream(streamId);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Obx(
              () => AlertDialog(
            backgroundColor: AppColors.professionColor,
            contentPadding: const EdgeInsets.all(18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextView(
                          text: "Poll Results",
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textHeader,
                        ),
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Icon(
                            Icons.close,
                            color: AppColors.textColorBlack,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // No Polls
                    if (controller.poolList.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.poll_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "No polls available",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )

                    // Poll Data
                    else
                      ...controller.poolList.map((poll) {
                        final voteResult = controller.getVoteResultForPoll(poll.id);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Question
                              CustomTextView(
                                text: voteResult?.question ?? poll.question,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textColorBlack,
                              ),
                              const SizedBox(height: 4),

                              // Total Votes
                              if (voteResult != null)
                                Text(
                                  "Total Votes: ${_calculateTotalVotes(voteResult)}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textBody,
                                  ),
                                ),
                              const SizedBox(height: 14),

                              // Option list
                              if (voteResult == null)
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: CircularProgressIndicator(
                                      color: AppColors.secondaryColor,
                                    ),
                                  ),
                                )
                              else
                                ...voteResult.options.map((option) {
                                  final totalVotes = _calculateTotalVotes(voteResult);
                                  final percentage = totalVotes > 0
                                      ? (option.voters.length / totalVotes * 100)
                                      : 0.0;

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 14),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Option title + vote count
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: CustomTextView(
                                                text: option.option,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.textColorBlack,
                                              ),
                                            ),
                                            Text(
                                              "${option.count} vote${option.count != 1 ? 's' : ''}",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.secondaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),

                                        // ░░ Progress Bar ░░
                                        Stack(
                                          children: [
                                            Container(
                                              height: 28,
                                              decoration: BoxDecoration(
                                                color: AppColors.bgColor,
                                                borderRadius: BorderRadius.circular(14),
                                              ),
                                            ),
                                            FractionallySizedBox(
                                              widthFactor: percentage / 100,
                                              child: Container(
                                                height: 28,
                                                decoration: BoxDecoration(
                                                  gradient: AppColors.primaryGradient,
                                                  borderRadius: BorderRadius.circular(14),
                                                ),
                                              ),
                                            ),
                                            Positioned.fill(
                                              child: Align(
                                                alignment: Alignment.centerRight,
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                                  child: Text(
                                                    "${percentage.toStringAsFixed(1)}%",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: percentage > 50
                                                          ? Colors.white
                                                          : AppColors.textColorBlack,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),

                                        // 🟣 Voter Profile Images
                                        if (option.voters.isNotEmpty)
                                          Row(
                                            children: [
                                              ...option.voters.take(4).map((voter) {
                                                final image = (voter.profileImage == null ||
                                                    voter.profileImage!.isEmpty)
                                                    ? "https://cdn-icons-png.flaticon.com/512/149/149071.png"
                                                    : voter.profileImage!;

                                                return Container(
                                                  width: 30,
                                                  height: 30,
                                                  margin: const EdgeInsets.only(right: 6),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Colors.white, width: 2),
                                                  ),
                                                  child: ClipOval(
                                                    child: Image.network(
                                                      image,
                                                      fit: BoxFit.cover,
                                                      errorBuilder:
                                                          (context, error, stackTrace) =>
                                                          Image.network(
                                                            "https://cdn-icons-png.flaticon.com/512/149/149071.png",
                                                            fit: BoxFit.cover,
                                                          ),
                                                    ),
                                                  ),
                                                );
                                              }),

                                              // +More Badge
                                              if (option.voters.length > 4)
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.secondaryColor,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Colors.white, width: 2),
                                                  ),
                                                  child: Text(
                                                    "+${option.voters.length - 4}",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  );
                                }),
                            ],
                          ),
                        );
                      }),
                    CustomElevatedButton(ontap: (){

                    }, text: "Vote")
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // 🔢 Count all votes
  static int _calculateTotalVotes(PoolVoteResult result) {
    return result.options.fold(0, (sum, opt) => sum + opt.voters.length);
  }
}

