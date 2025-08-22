// providers/exercise_records_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../pages/exercise/data/exercise_data.dart';

part 'exercise_records_provider.g.dart';

class ExerciseRecord {
  final int exerciseId;
  final int? repetitions; // 回数（回数型の場合）
  final Duration? duration; // 時間（時間型の場合）
  final bool isTimeBasedExercise;

  ExerciseRecord({
    required this.exerciseId,
    this.repetitions,
    this.duration,
    required this.isTimeBasedExercise,
  });

  ExerciseRecord copyWith({
    int? exerciseId,
    int? repetitions,
    Duration? duration,
    bool? isTimeBasedExercise,
  }) {
    return ExerciseRecord(
      exerciseId: exerciseId ?? this.exerciseId,
      repetitions: repetitions ?? this.repetitions,
      duration: duration ?? this.duration,
      isTimeBasedExercise: isTimeBasedExercise ?? this.isTimeBasedExercise,
    );
  }

  // 記録値の表示用文字列を取得
  String get displayValue {
    if (isTimeBasedExercise && duration != null) {
      final minutes = duration!.inMinutes;
      final seconds = duration!.inSeconds % 60;
      if (minutes > 0) {
        return '$minutes分$seconds秒';
      } else {
        return '$seconds秒';
      }
    } else if (!isTimeBasedExercise && repetitions != null) {
      return '$repetitions回';
    }
    return '';
  }
}

@riverpod
class ExerciseRecords extends _$ExerciseRecords {
  @override
  Map<int, ExerciseRecord> build() => {};

  void addRecord(ExerciseRecord record) {
    state = {...state, record.exerciseId: record};
  }

  void removeRecord(int exerciseId) {
    final newState = Map<int, ExerciseRecord>.from(state);
    newState.remove(exerciseId);
    state = newState;
  }

  void clearAllRecords() {
    state = {};
  }

  // 記録された種目のXP計算
  Map<String, int> calculateTotalXP() {
    final totalXP = <String, int>{
      '腕': 0,
      '胸': 0,
      '肩': 0,
      '腹筋': 0,
      '背筋': 0,
      '脚': 0,
    };

    for (final record in state.values) {
      final exercise = ExerciseData.getExerciseById(record.exerciseId);
      if (exercise == null) continue;

      final loadData = ExerciseData.getExerciseLoadData(exercise.id);
      
      // 基本XP計算
      int baseXP = 0;
      if (record.isTimeBasedExercise && record.duration != null) {
        // 時間型：10秒で1XP
        baseXP = (record.duration!.inSeconds / 10).round();
      } else if (!record.isTimeBasedExercise && record.repetitions != null) {
        // 回数型：1回で1XP
        baseXP = record.repetitions!;
      }

      // 各部位への負荷に応じてXPを分配
      for (final entry in loadData.entries) {
        final bodyPart = entry.key;
        final load = entry.value;
        if (load > 0) {
          // 負荷レベル × 基本XP = その部位への獲得XP
          final xp = (load * baseXP).round();
          totalXP[bodyPart] = (totalXP[bodyPart] ?? 0) + xp;
        }
      }
    }

    return totalXP;
  }

  // 総合XPを計算
  int calculateTotalOverallXP() {
    final xpMap = calculateTotalXP();
    return xpMap.values.fold(0, (sum, xp) => sum + xp);
  }
}