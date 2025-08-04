import 'dart:convert';
import 'package:fetchtrue/practice/bloc/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../model.dart';
import 'event.dart';

class UBloc extends Bloc<UEvent, UState> {
  UBloc() : super(UInitial()) {
    on<ULoad>(_onLoadUser);
    on<UUpdate>(_onUpdateUser);
  }

  Future<void> _onLoadUser(ULoad event, Emitter<UState> emit) async {
    emit(ULoading());
    try {
      final res = await http.get(
        Uri.parse("https://biz-booster.vercel.app/api/users/${event.userId}"),
      );
      final json = jsonDecode(res.body);
      final user = UModel.fromJson(json['data']);
      emit(ULoaded(user));
    } catch (e) {
      emit(UError("Failed to load user"));
    }
  }

  Future<void> _onUpdateUser(UUpdate event, Emitter<UState> emit) async {
    emit(ULoading());
    try {
      final res = await http.put(
        Uri.parse("https://biz-booster.vercel.app/api/users/update-info/${event.updatedUser.id}"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(event.updatedUser.toJson()),
      );
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        final user = UModel.fromJson(json['data']);
        emit(ULoaded(user));
      } else {
        emit(UError("Failed to update user"));
      }
    } catch (e) {
      emit(UError("Update error: ${e.toString()}"));
    }
  }
}
