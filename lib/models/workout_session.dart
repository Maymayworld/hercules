// models/workout_session.dart
import '../pages/exercise/data/exercise_data.dart';
import '../providers/exercise_records_provider.dart';

// ExerciseRecordのヘルパー関数
Map<String, dynamic> _exerciseRecordToJson(ExerciseRecord record) {
  return {
    'exerciseId': record.exerciseId,
    'repetitions': record.repetitions,
    'duration': record.duration?.inSeconds,
    'isTimeBasedExercise': record.isTimeBasedExercise,
  };
}

ExerciseRecord _exerciseRecordFromJson(Map<String, dynamic> json) {
  return ExerciseRecord(
    exerciseId: json['exerciseId'],
    repetitions: json['repetitions'],
    duration: json['duration'] != null 
        ? Duration(seconds: json['duration'])
        : null,
    isTimeBasedExercise: json['isTimeBasedExercise'],
  );
}

class WorkoutSession {
  final String id;
  final DateTime dateTime;
  final Map<int, ExerciseRecord> exerciseRecords;
  final Map<String, int> totalXP;
  final int overallXP;

  WorkoutSession({
    required this.id,
    required this.dateTime,
    required this.exerciseRecords,
    required this.totalXP,
    required this.overallXP,
  });

  // JSON変換用
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'exerciseRecords': exerciseRecords.map(
        (key, value) => MapEntry(key.toString(), _exerciseRecordToJson(value)),
      ),
      'totalXP': totalXP,
      'overallXP': overallXP,
    };
  }

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    final exerciseRecordsJson = json['exerciseRecords'] as Map<String, dynamic>;
    final exerciseRecords = <int, ExerciseRecord>{};
    
    exerciseRecordsJson.forEach((key, value) {
      exerciseRecords[int.parse(key)] = _exerciseRecordFromJson(value);
    });

    return WorkoutSession(
      id: json['id'],
      dateTime: DateTime.parse(json['dateTime']),
      exerciseRecords: exerciseRecords,
      totalXP: Map<String, int>.from(json['totalXP']),
      overallXP: json['overallXP'],
    );
  }

  // 表示用の日時フォーマット
  String get formattedDateTime {
    return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // 総獲得XPの計算
  int get totalXPSum => totalXP.values.fold(0, (sum, xp) => sum + xp);

  // エクササイズの詳細リスト取得
  List<ExerciseWithRecord> get exerciseDetails {
    return exerciseRecords.entries.map((entry) {
      final exercise = ExerciseData.getExerciseById(entry.key);
      return ExerciseWithRecord(
        exercise: exercise!,
        record: entry.value,
      );
    }).toList();
  }
}

class ExerciseWithRecord {
  final Exercise exercise;
  final ExerciseRecord record;

  ExerciseWithRecord({
    required this.exercise,
    required this.record,
  });
}