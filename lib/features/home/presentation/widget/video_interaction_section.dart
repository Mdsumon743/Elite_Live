

import 'package:elites_live/core/global_widget/custom_comment_sheet.dart';
import 'package:elites_live/features/event/controller/schedule_controller.dart';

import 'package:elites_live/features/home/presentation/widget/donation_sheet.dart';
import 'package:elites_live/features/home/presentation/widget/share_sheet.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/global_widget/custom_text_view.dart';

import 'package:get/get.dart';



class VideoInteractionSection extends StatelessWidget {
  const VideoInteractionSection({super.key, required this.eventId, required this.reactionCount, required this.commentCount});
  final String eventId;
  final String reactionCount;
  final String commentCount;


  @override
  Widget build(BuildContext context) {
    final ScheduleController eventController = Get.find();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildItem(Icons.favorite, reactionCount, Colors.red),
          SizedBox(width: 19),
          GestureDetector(
            onTap: (){
              /*
              showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context){
                          return CommentSheet(
                              scheduleController: scheduleController,
                              eventId: eventId
                          );
                        }
                    );
               */
              showModalBottomSheet(context: context, builder: (BuildContext context){
           return    CommentSheet(scheduleController: eventController, eventId: eventId);
              });


            },
            child: _buildItem(FontAwesomeIcons.comment, commentCount),
          ),
          SizedBox(width: 19),
          GestureDetector(
            onTap: () {
              DonationSheet.show(context, eventId: eventId);
            },
            child: _buildItem(FontAwesomeIcons.donate, "Donate"),
          ),
          SizedBox(width: 19),
          GestureDetector(
            onTap: () => ShareSheet().show(context),
            child: _buildItem(Icons.share, "Share"),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(IconData icon, String text, [Color? color]) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        SizedBox(width: 4),
        CustomTextView(       text: text),

      ],
    );
  }














}
