// providers/persistent_xp_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'persistent_xp_provider.g.dart';

@riverpod
class PersistentXp extends _$PersistentXp {
  static const String _keyPrefix = 'xp_';
  static const List<String> _bodyParts = ['腕', '胸', '肩', '腹筋', '背筋', '脚'];

  @override
  Future<Map<String, int>> build() async {
    return await _loadXP();
  }

  // SharedPreferencesからXPを読み込み
  Future<Map<String, int>> _loadXP() async {
    final prefs = await SharedPreferences.getInstance();
    final xpMap = <String, int>{};
    
    for (final bodyPart in _bodyParts) {
      xpMap[bodyPart] = prefs.getInt('$_keyPrefix$bodyPart') ?? 0;
    }
    
    return xpMap;
  }

  // SharedPreferencesにXPを保存
  Future<void> _saveXP(Map<String, int> xpMap) async {
    final prefs = await SharedPreferences.getInstance();
    
    for (final entry in xpMap.entries) {
      await prefs.setInt('$_keyPrefix${entry.key}', entry.value);
    }
  }

  // XPを追加
  Future<void> addXP(Map<String, int> gainedXP) async {
    final currentState = await future;
    final newXPMap = Map<String, int>.from(currentState);
    
    for (final entry in gainedXP.entries) {
      final bodyPart = entry.key;
      final xp = entry.value;
      
      // 正の値でも負の値でも処理する
      if (xp != 0) {
        final currentXP = newXPMap[bodyPart] ?? 0;
        final newXP = currentXP + xp;
        
        // XPが負の値にならないようにする（最小値は0）
        newXPMap[bodyPart] = newXP < 0 ? 0 : newXP;
      }
    }
    
    await _saveXP(newXPMap);
    state = AsyncValue.data(newXPMap);
  }

  // XPをリセット（デバッグ用）
  Future<void> resetXP() async {
    final resetXPMap = <String, int>{};
    for (final bodyPart in _bodyParts) {
      resetXPMap[bodyPart] = 0;
    }
    
    await _saveXP(resetXPMap);
    state = AsyncValue.data(resetXPMap);
  }

  // すべてのXPをリセット（設定画面用）
  Future<void> resetAllXP() async {
    await resetXP(); // 既存のresetXPメソッドを利用
  }

  // 総合XPを計算
  int calculateTotalXP(Map<String, int> xpMap) {
    return xpMap.values.fold(0, (sum, xp) => sum + xp);
  }

  // 平均XPを計算（総合レベル用）
  int calculateAverageXP(Map<String, int> xpMap) {
    final totalXP = calculateTotalXP(xpMap);
    return xpMap.values.isEmpty ? 0 : totalXP ~/ xpMap.values.length;
  }
}