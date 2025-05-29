import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../bloc/two_minigyan/shorts_bloc.dart';
import '../bloc/two_minigyan/shorts_event.dart';
import '../bloc/two_minigyan/shorts_state.dart';
import '../model/youtube_short_model.dart';

class TwoMinGyanScreen extends StatelessWidget {
  const TwoMinGyanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ShortsBloc()..add(FetchShorts()),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: BlocBuilder<ShortsBloc, ShortsState>(
            builder: (context, state) {
              if (state is ShortsLoading) {
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              } else if (state is ShortsLoaded) {
                return PageView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: state.shorts.length,
                  itemBuilder: (context, index) => ShortVideoPlayer(video: state.shorts[index]),
                  physics: const BouncingScrollPhysics(),
                );
              } else if (state is ShortsError) {
                return Center(child: Text(state.message, style: textStyle16(context, color: Colors.white)));
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }
}

class ShortVideoPlayer extends StatefulWidget {
  final YouTubeShortModel video;
  const ShortVideoPlayer({super.key, required this.video});

  @override
  State<ShortVideoPlayer> createState() => _ShortVideoPlayerState();
}

class _ShortVideoPlayerState extends State<ShortVideoPlayer> {
  late YoutubePlayerController _controller;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.video.id,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        loop: true,
        enableCaption: false,
        controlsVisibleAtStart: false,
        hideControls: true,
        mute: false,
        forceHD: true,
      ),
    );
    _controller.addListener(_videoListener);
  }

  void _videoListener() {
    if (!mounted) return;
    setState(() {
      _isPlaying = _controller.value.isPlaying;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: false,
        ),
        Positioned(
          bottom: 20,
          left: 10,
          right: 60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  final url = Uri.parse('https://www.youtube.com/watch?v=${widget.video.id}');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                child: Text(
                  '@${widget.video.channelTitle}',
                  style: textStyle22(
                    context,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.video.title,
                style: textStyle16(
                  context,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (widget.video.viewCount != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    '${widget.video.viewCount} views',
                    style: textStyle16(
                      context,
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.4,
          left: MediaQuery.of(context).size.width * 0.4,
          child: GestureDetector(
            onTap: _togglePlayPause,
            child: Icon(
              _isPlaying ? Icons.pause_circle : Icons.play_circle,
              size: 64,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }
}
