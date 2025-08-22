// providers/xp_level_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'persistent_xp_provider.dart';

part 'xp_level_provider.g.dart';

class LevelInfo {
  final int level;
  final int currentXP;
  final int currentLevelXP;
  final int nextLevelXP;
  final double progress;
  final String rank;

  LevelInfo({
    required this.level,
    required this.currentXP,
    required this.currentLevelXP,
    required this.nextLevelXP,
    required this.progress,
    required this.rank,
  });
}

@riverpod
Future<Map<String, LevelInfo>> xpLevelManager(XpLevelManagerRef ref) async {
  // 永続化されたXPを監視
  final persistentXPAsync = ref.watch(persistentXpProvider);
  
  return persistentXPAsync.when(
    data: (xpMap) {
      final levelInfo = <String, LevelInfo>{};
      
      // 各部位のレベル情報を計算
      for (final entry in xpMap.entries) {
        final bodyPart = entry.key;
        final totalXP = entry.value;
        levelInfo[bodyPart] = _calculateLevelInfo(totalXP);
      }
      
      // 総合レベルを計算（平均XPを使用）
      final averageXP = _calculateAverageXP(xpMap);
      levelInfo['総合'] = _calculateLevelInfo(averageXP);
      
      return levelInfo;
    },
    loading: () {
      // ローディング中はデフォルト値を返す
      final defaultLevelInfo = <String, LevelInfo>{};
      final bodyParts = ['腕', '胸', '肩', '腹筋', '背筋', '脚', '総合'];
      
      for (final bodyPart in bodyParts) {
        defaultLevelInfo[bodyPart] = _calculateLevelInfo(0);
      }
      
      return defaultLevelInfo;
    },
    error: (error, stack) {
      // エラー時もデフォルト値を返す
      final defaultLevelInfo = <String, LevelInfo>{};
      final bodyParts = ['腕', '胸', '肩', '腹筋', '背筋', '脚', '総合'];
      
      for (final bodyPart in bodyParts) {
        defaultLevelInfo[bodyPart] = _calculateLevelInfo(0);
      }
      
      return defaultLevelInfo;
    },
  );
}

// 平均XPを計算（総合レベル用）
int _calculateAverageXP(Map<String, int> xpMap) {
  final totalXP = xpMap.values.fold(0, (sum, xp) => sum + xp);
  return xpMap.values.isEmpty ? 0 : totalXP ~/ xpMap.values.length;
}

LevelInfo _calculateLevelInfo(int totalXP) {
  final level = _calculateLevelFromXP(totalXP);
  final currentLevelXP = _calculateCurrentLevelXP(totalXP, level);
  final nextLevelXP = _calculateNextLevelXP(level);
  final progress = _calculateProgress(currentLevelXP, nextLevelXP, level);
  final rank = _calculateRank(level);
  
  return LevelInfo(
    level: level,
    currentXP: totalXP,
    currentLevelXP: currentLevelXP,
    nextLevelXP: nextLevelXP,
    progress: progress,
    rank: rank,
  );
}

int _calculateLevelFromXP(int totalXP) {
  if (totalXP == 0) return 1;
  
  // レベルnに到達するのに必要な累積XP = 100 * (n-1) * n / 2
  // この逆算で現在のレベルを求める
  int level = 1;
  int cumulativeXP = 0;
  
  while (level < 99) {
    final xpForNextLevel = level * 100; // レベルnからn+1に必要なXP
    if (cumulativeXP + xpForNextLevel > totalXP) {
      break;
    }
    cumulativeXP += xpForNextLevel;
    level++;
  }
  
  return level;
}

int _calculateCurrentLevelXP(int totalXP, int level) {
  if (level == 1) return totalXP;
  
  // 現在のレベルまでに必要だった累積XPを計算
  int cumulativeXP = 0;
  for (int i = 1; i < level; i++) {
    cumulativeXP += i * 100;
  }
  
  return totalXP - cumulativeXP;
}

int _calculateNextLevelXP(int level) {
  if (level >= 99) {
    // レベル99の場合、表示用に適当な値を返す（実際は使われない）
    return level * 100;
  }
  return level * 100; // レベルnからn+1に必要なXP
}

double _calculateProgress(int currentLevelXP, int nextLevelXP, int level) {
  if (level >= 99) {
    // レベル99の場合、常にプログレスバーは最大
    return 1.0;
  }
  return currentLevelXP / nextLevelXP;
}

String _calculateRank(int level) {
  if (level >= 90) return 'Z';
  if (level >= 80) return 'X';
  if (level >= 70) return 'SSS';
  if (level >= 60) return 'SS';
  if (level >= 50) return 'S';
  if (level >= 40) return 'A';
  if (level >= 30) return 'B';
  if (level >= 20) return 'C';
  if (level >= 10) return 'D';
  return 'E';
}