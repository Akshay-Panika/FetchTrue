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
      String fileName,
      List<Map<String, String>> allVideos,
      ) {
    final videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => YoutubePlayerScreen(
            videoId: videoId,
            videoName: fileName,
            uploaderName: fullName,
            allVideos: allVideos,
          ),
        ),
      );
    }
  }

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

        // Parse all videos
        final allVideos = dataList
            .expand(
              (item) => item.videos.map(
                (v) => {
              "url": v.filePath,
              "fullName": item.fullName,
              "fileName": v.fileName,
            },
          ),
        )
            .toList();

        return SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              final item = dataList[index];
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
                      child: item.videos.isNotEmpty
                          ? CustomContainer(
                        networkImg:
                        "https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(item.videos.first.filePath)}/0.jpg",
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
                  if (item.videos.isNotEmpty) {
                    playVideo(
                      context,
                      item.videos.first.filePath,
                      item.fullName,
                      item.videos.first.fileName,
                      allVideos,
                    );
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
              child: Text(
                "$currentUploader - $currentVideoName",
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
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

                return ListTile(
                  tileColor: isPlaying ? Colors.blue.shade50 : null,
                  leading: Image.network(
                    "https://img.youtube.com/vi/$vidId/0.jpg",
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                  title: Text(video["fileName"] ?? "No Name"),
                  subtitle: Text(video["fullName"] ?? ""),
                  trailing: Icon(
                    isPlaying
                        ? Icons.play_circle_fill
                        : Icons.pause_circle,
                    color: isPlaying ? Colors.blue : Colors.black54,
                  ),
                  onTap: () => playAnotherVideo(video),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
