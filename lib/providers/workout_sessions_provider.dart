// providers/workout_sessions_provider.dart
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout_session.dart';

// ワークアウトセッションリストの状態管理
class WorkoutSessionsNotifier extends StateNotifier<List<WorkoutSession>> {
  WorkoutSessionsNotifier() : super([]) {
    _loadSessions();
  }

  static const String _storageKey = 'workout_sessions';

  // セッションを追加
  Future<void> addSession(WorkoutSession session) async {
    state = [session, ...state]; // 新しいセッションを先頭に追加（時系列逆順）
    await _saveSessions();
  }

  // セッションを削除
  Future<void> removeSession(String sessionId) async {
    state = state.where((session) => session.id != sessionId).toList();
    await _saveSessions();
  }

  // セッションをクリア
  Future<void> clearAllSessions() async {
    state = [];
    await _saveSessions();
  }

  // セッションを更新
  Future<void> updateSession(WorkoutSession updatedSession) async {
    final index = state.indexWhere((session) => session.id == updatedSession.id);
    if (index != -1) {
      final newList = List<WorkoutSession>.from(state);
      newList[index] = updatedSession;
      // 時系列順でソート（新しいものが先頭）
      newList.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      state = newList;
      await _saveSessions();
    }
  }

  // セッションの保存
  Future<void> _saveSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionsJson = state.map((session) => session.toJson()).toList();
      await prefs.setString(_storageKey, jsonEncode(sessionsJson));
    } catch (e) {
      print('Failed to save workout sessions: $e');
    }
  }

  // セッションの読み込み
  Future<void> _loadSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionsJsonString = prefs.getString(_storageKey);
      
      if (sessionsJsonString != null) {
        final sessionsJson = jsonDecode(sessionsJsonString) as List;
        final sessions = sessionsJson
            .map((json) => WorkoutSession.fromJson(json))
            .toList();
        
        // 時系列順でソート（新しいものが先頭）
        sessions.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        state = sessions;
      }
    } catch (e) {
      print('Failed to load workout sessions: $e');
      state = [];
    }
  }

  // 指定したセッションのXPを取得
  Map<String, int> getSessionXP(String sessionId) {
    final session = state.firstWhere(
      (s) => s.id == sessionId,
      orElse: () => WorkoutSession(
        id: '',
        dateTime: DateTime.now(),
        exerciseRecords: {},
        totalXP: {},
        overallXP: 0,
      ),
    );
    return session.totalXP;
  }
}

// プロバイダー定義
final workoutSessionsProvider = 
    StateNotifierProvider<WorkoutSessionsNotifier, List<WorkoutSession>>((ref) {
  return WorkoutSessionsNotifier();
});