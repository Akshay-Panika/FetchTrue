import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_headline.dart';
import '../model/training_tutorial_model.dart';

class PlayVideoScreen extends StatefulWidget {
  final String name;
  final List<TutorialVideo> videoList;
  const PlayVideoScreen({
    super.key,
    required this.name,
    required this.videoList,
  });

  @override
  State<PlayVideoScreen> createState() => _PlayVideoScreenState();
}

class _PlayVideoScreenState extends State<PlayVideoScreen> {
  int selectedIndex = 0;

  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    try {
      final currentVideo = widget.videoList[selectedIndex];
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(currentVideo.videoUrl));
      await _videoPlayerController!.initialize();

      _videoPlayerController!.addListener(() {
        if (_videoPlayerController!.value.position >=
            _videoPlayerController!.value.duration &&
            selectedIndex < widget.videoList.length - 1) {
          changeVideo(selectedIndex + 1);
        }
      });

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowPlaybackSpeedChanging: false,
        fullScreenByDefault: false,
        materialProgressColors: ChewieProgressColors(
          playedColor: CustomColor.appColor,
          handleColor: CustomColor.appColor,
          backgroundColor: Colors.grey.shade300,
          bufferedColor: Colors.grey,
        ),
      );

      setState(() {});
    } catch (e) {
      debugPrint('Video initialization error: $e');
    }
  }

  Future<void> changeVideo(int newIndex) async {
    try {
      setState(() {
        selectedIndex = newIndex;
      });

      await _chewieController?.pause();
      await _videoPlayerController?.dispose();

      final newVideo = widget.videoList[selectedIndex];
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(newVideo.videoUrl));
      await _videoPlayerController!.initialize();

      _videoPlayerController!.addListener(() {
        if (_videoPlayerController!.value.position >=
            _videoPlayerController!.value.duration &&
            selectedIndex < widget.videoList.length - 1) {
          changeVideo(selectedIndex + 1);
        }
      });

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
      );

      setState(() {});
    } catch (e) {
      debugPrint('Change video error: $e');
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    final selectedVideo = widget.videoList[selectedIndex];

    return Scaffold(
      appBar: CustomAppBar(title: widget.name, showBackButton: true),
      body: SafeArea(
        child: Column(
          children: [
            10.height,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: dimensions.screenHeight * 0.015),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomContainer(
                    height: dimensions.screenHeight * 0.22,
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    child: _chewieController != null &&
                        _videoPlayerController!.value.isInitialized
                        ? (_videoPlayerController!.value.hasError
                        ? Center(child: Text('Video error'))
                        : Chewie(controller: _chewieController!))
                        : const Center(child: CircularProgressIndicator()),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(selectedVideo.videoName, style: textStyle14(context)),
                        Text(
                          selectedVideo.videoDescription,
                          style: textStyle14(
                            context,
                            fontWeight: FontWeight.w400,
                            color: CustomColor.descriptionColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: selectedIndex > 0 ? () => changeVideo(selectedIndex - 1) : null,
                    icon: const Icon(Icons.skip_previous),
                    label: const Text("Previous"),
                  ),
                  ElevatedButton.icon(
                    onPressed: selectedIndex < widget.videoList.length - 1
                        ? () => changeVideo(selectedIndex + 1)
                        : null,
                    icon: const Icon(Icons.skip_next),
                    label: const Text("Next"),
                  ),
                ],
              ),
            ),
            const Divider(),
            CustomHeadline(headline: 'Video List'),
            Expanded(
              child: ListView.builder(
                itemCount: widget.videoList.length,
                padding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth * 0.03),
                itemBuilder: (context, index) {
                  final video = widget.videoList[index];
                  return GestureDetector(
                    onTap: () => changeVideo(index),
                    child: CustomContainer(
                      border: true,
                      backgroundColor: CustomColor.whiteColor,
                      height: dimensions.screenHeight * 0.12,
                      margin: EdgeInsets.only(bottom: dimensions.screenHeight * 0.015),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                CustomContainer(
                                  width: dimensions.screenWidth * 0.35,
                                  margin: EdgeInsets.zero,
                                  assetsImg: CustomImage.thumbnailImage,
                                  child: Center(
                                      child: Icon(Icons.play_circle,
                                          color: CustomColor.appColor, size: 30)),
                                ),
                                10.width,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(video.videoName, style: textStyle12(context)),
                                      SizedBox(height: dimensions.screenHeight * 0.002),
                                      Text(video.videoDescription,
                                          style: textStyle12(context,
                                              color: CustomColor.descriptionColor)),
                                    ],
                                  ),
                                )
                              ],
                            ),


                          ),
                          Text(
                            selectedIndex == index ? 'Playing' : 'Pending',
                            style: textStyle12(context, color: CustomColor.appColor),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
