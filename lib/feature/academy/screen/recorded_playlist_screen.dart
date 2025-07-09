import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/recorded_webinar_model.dart';

class RecordedPlaylistScreen extends StatelessWidget {
  final String name;
  final List<RecordedVideo> videoList;

  const RecordedPlaylistScreen({
    super.key,
    required this.name,
    required this.videoList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: name, showBackButton: true,),

      body: ListView.builder(
        itemCount: videoList.length,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemBuilder: (context, index) {
          final video = videoList[index];

          return CustomContainer(
            border: true,
            backgroundColor: CustomColor.whiteColor,
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// video play screen
                CustomContainer(
                  height: 180,
                  margin: EdgeInsets.zero,
                  child: Center(child: Icon(Icons.play_circle_fill, color: CustomColor.appColor, size: 35,)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(video.videoName,style: textStyle16(context),),
                      Text(video.videoDescription,style: textStyle14(context, color: CustomColor.descriptionColor),),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
