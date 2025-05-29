
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bizbooster2x/feature/academy/bloc/two_minigyan/shorts_event.dart';
import 'package:bizbooster2x/feature/academy/bloc/two_minigyan/shorts_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/youtube_short_model.dart';

class ShortsBloc extends Bloc<ShortsEvent, ShortsState> {
  final String channelId = 'UCKpwgpO9-c_ISAJzNxgHkUw';
  final String apiKey = 'AIzaSyAVIXa894w3LGWaUFFIDBPu-4mHTOt5OKY';

  ShortsBloc() : super(ShortsLoading()) {
    on<FetchShorts>(_onFetchShorts);
  }

  Future<void> _onFetchShorts(FetchShorts event, Emitter<ShortsState> emit) async {
    emit(ShortsLoading());
    try {
      final searchUrl = Uri.parse(
        'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$channelId&maxResults=10&order=date&type=video&key=$apiKey',
      );
      final searchResponse = await http.get(searchUrl);

      if (searchResponse.statusCode == 200) {
        final searchData = json.decode(searchResponse.body);
        final List items = searchData['items'] ?? [];
        final videoIds = items.map((item) => item['id']['videoId']).where((id) => id != null).join(',');

        final detailsUrl = Uri.parse(
          'https://www.googleapis.com/youtube/v3/videos?part=contentDetails,statistics&id=$videoIds&key=$apiKey',
        );
        final detailsResponse = await http.get(detailsUrl);
        final detailsData = json.decode(detailsResponse.body);
        final List detailsItems = detailsData['items'] ?? [];
        final detailsMap = { for (var item in detailsItems) item['id']: item };

        final List<YouTubeShortModel> videos = items
            .map((json) => YouTubeShortModel.fromJson(
          json, videoDetails: detailsMap[json['id']['videoId']],
        ))
            .where((video) => video.id.isNotEmpty)
            .toList();

        emit(ShortsLoaded(videos));
      } else {
        emit(ShortsError('Failed to load shorts'));
      }
    } catch (e) {
      emit(ShortsError(e.toString()));
    }
  }
}