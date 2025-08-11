import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../model/understanding_fetch_true_model.dart';
import '../repository/UnderstandingFetchTrueService.dart';

class UnderstandingFetchTrueScreen extends StatefulWidget {
  const UnderstandingFetchTrueScreen({super.key});

  @override
  State<UnderstandingFetchTrueScreen> createState() =>
      _UnderstandingFetchTrueScreenState();
}

class _UnderstandingFetchTrueScreenState
    extends State<UnderstandingFetchTrueScreen> {
  late Future<UnderstandingFetchTrueModel> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = UnderstandingFetchTrueService.fetchData();
  }

  void playVideo(
      BuildContext context,
      String url,
      String fullName,
      ) {
    final videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => YoutubePlayerScreen(
            videoId: videoId,
            videoName: fullName,
            uploaderName: fullName,
            allVideos: dataListVideos, // यह नीचे परिभाषित किया गया है
          ),
        ),
      );
    }
  }

  late List<Map<String, String>> dataListVideos;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UnderstandingFetchTrueModel>(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return SizedBox(
            height: 200,
            child: Center(child: Text("Error: ${snapshot.error}")),
          );
        }

        final dataList = snapshot.data?.data ?? [];
        if (dataList.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(child: Text("No Data Found")),
          );
        }

        // सभी वीडियो urls की लिस्ट बनाएं
        dataListVideos = dataList
            .map(
              (item) => {
            "url": item.videoUrl,
            "fullName": item.fullName,
            "fileName": item.fullName,
          },
        )
            .toList();

        return SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              final item = dataList[index];
              final videoId = YoutubePlayer.convertUrlToId(item.videoUrl) ?? '';

              return CustomContainer(
                width: 250,
                border: true,
                color: Colors.white,
                padding: EdgeInsets.zero,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: videoId.isNotEmpty
                          ? CustomContainer(
                        networkImg:
                        "https://img.youtube.com/vi/$videoId/0.jpg",
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                      )
                          : const Center(
                        child: Icon(Icons.video_library,
                            size: 60, color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item.fullName),
                    ),
                  ],
                ),
                onTap: () {
                  if (videoId.isNotEmpty) {
                    playVideo(context, item.videoUrl, item.fullName);
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}



class YoutubePlayerScreen extends StatefulWidget {
  final String videoId;
  final String videoName;
  final String uploaderName;
  final List<Map<String, String>> allVideos;

  const YoutubePlayerScreen({
    super.key,
    required this.videoId,
    required this.videoName,
    required this.uploaderName,
    required this.allVideos,
  });

  @override
  State<YoutubePlayerScreen> createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  late YoutubePlayerController _controller;
  late String currentVideoId;
  late String currentVideoName;
  late String currentUploader;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    currentVideoId = widget.videoId;
    currentVideoName = widget.videoName;
    currentUploader = widget.uploaderName;
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(autoPlay: true),
    );

    _controller.addListener(() {
      if (_controller.value.isFullScreen != _isFullScreen) {
        setState(() {
          _isFullScreen = _controller.value.isFullScreen;
        });
      }
    });
  }

  void playAnotherVideo(Map<String, String> video) {
    final videoId = YoutubePlayer.convertUrlToId(video["url"]!);
    if (videoId != null) {
      setState(() {
        currentVideoId = videoId;
        currentVideoName = video["fileName"] ?? "No Name";
        currentUploader = video["fullName"] ?? "";
      });
      _controller.load(videoId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _isFullScreen ? null : CustomAppBar(title: currentUploader, showBackButton: true,),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
            ),
          ),
          if (!_isFullScreen)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$currentUploader",
                    style: textStyle14(context)),
                  Text(
                    "$currentVideoName",
                    style: textStyle14(context, color: CustomColor.descriptionColor)),
                ],
              ),
            ),
          if (!_isFullScreen) const Divider(),
          if (!_isFullScreen)
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: widget.allVideos.length,
              itemBuilder: (context, index) {
                final video = widget.allVideos[index];
                final vidId =
                    YoutubePlayer.convertUrlToId(video["url"]!) ?? "";
                final isPlaying = vidId == currentVideoId;

                return CustomContainer(
                  border: true,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                  padding: EdgeInsets.zero,
                  onTap: () => playAnotherVideo(video),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(  // <-- यहाँ Expanded लगाएं
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomContainer(
                              margin: EdgeInsets.zero,
                              height: 100,
                              width: 150,
                              networkImg: "https://img.youtube.com/vi/$vidId/0.jpg",
                            ),
                            10.width,
                            Flexible(  // <-- यहाँ Flexible भी लगाना अच्छा रहता है
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  10.height,
                                  Text(
                                    video["fileName"] ?? "No Name",
                                    style: textStyle14(context),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  Text(
                                    video["fullName"] ?? "",
                                    style: textStyle14(context, color: CustomColor.descriptionColor),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Icon(
                          size: 30,
                          isPlaying ? Icons.play_circle_fill : Icons.pause_circle,
                          color: isPlaying ? Colors.blue : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                );

              },
            ),
          ),
        ],
      ),
    );
  }
}
