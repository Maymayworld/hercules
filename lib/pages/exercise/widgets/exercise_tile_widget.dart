// pages/exercise/widgets/exercise_tile_widget.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sizer/sizer.dart';
import '../data/exercise_data.dart';
import '../../../providers/recording_state_provider.dart';
import '../../../providers/exercise_records_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class ExerciseTileWidget extends HookConsumerWidget {
  final Exercise exercise;
  final VoidCallback? onTap;

  // ダークテーマ用の色定義
  static const Color darkBackground = Color(0xFF1C1C1C);
  static const Color darkCardColor = Color(0xFF2C2C2C);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);

  // ダークテーマ用のBoxDecoration
  BoxDecoration get darkCardDecoration => BoxDecoration(
    color: darkCardColor,
    borderRadius: BorderRadius.circular(10.sp),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        offset: Offset(0, 1.sp),
        blurRadius: 4.sp,
        spreadRadius: 0,
      ),
    ],
  );

  const ExerciseTileWidget({
    super.key,
    required this.exercise,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isRecording = ref.watch(recordingStateProvider);
    final exerciseRecord = ref.watch(exerciseRecordsProvider)[exercise.id];
    
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.sp,
          vertical: 8.sp, // 縦幅を狭く調整
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: darkTextSecondary.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // 左側：メイン部位のアイコン（ダークテーマ）
            Container(
              width: 40.sp,
              height: 40.sp,
              decoration: darkCardDecoration,
              child: Icon(
                _getExerciseIcon(),
                color: exercise.mainBodyPart.color, // 部位別の色
                size: 20.sp,
              ),
            ),
            
            SizedBox(width: 16.sp),
            
            // 右側：種目情報
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 種目名と記録表示を同じ行に配置
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 種目名
                      Expanded(
                        child: Text(
                          exercise.name,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: darkTextPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      
                      SizedBox(width: 8.sp),
                      
                      // 記録表示（右上）- ダークテーマボックス内に配置
                      if (isRecording && exerciseRecord != null && 
                          (exerciseRecord.repetitions != null && exerciseRecord.repetitions! > 0 ||
                           exerciseRecord.duration != null && exerciseRecord.duration!.inSeconds > 0))
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.sp,
                            vertical: 4.sp,
                          ),
                          decoration: darkCardDecoration.copyWith(
                            borderRadius: BorderRadius.circular(8.sp),
                          ),
                          child: Text(
                            exerciseRecord.displayValue,
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  SizedBox(height: 4.sp),
                  
                  // 目的部位（3つまで表示）
                  Row(
                    children: exercise.detailedTargetParts
                        .take(3)
                        .map((part) => Padding(
                              padding: EdgeInsets.only(
                                right: exercise.detailedTargetParts.indexOf(part) < 
                                  (exercise.detailedTargetParts.length > 3 ? 2 : exercise.detailedTargetParts.length - 1) 
                                  ? 4.sp : 0,
                              ),
                              child: Text(
                                part,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: darkTextSecondary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11.sp,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            
            SizedBox(width: 8.sp),
            
            // 右端：矢印アイコン（通常モードのみ）
            if (!isRecording)
              Icon(
                Icons.chevron_right,
                color: darkTextSecondary,
                size: 20.sp,
              ),
          ],
        ),
      ),
    );
  }

  // エクササイズの種類に応じたアイコンを返す
  IconData _getExerciseIcon() {
    if (exercise.requiresEquipment) {
      // 器具ありの場合
      if (exercise.equipment?.contains('ダンベル') == true) {
        return Icons.fitness_center; // ダンベルアイコン
      } else if (exercise.equipment?.contains('ベンチ') == true) {
        return Icons.fitness_center; // ベンチアイコン
      } else {
        return Icons.fitness_center; // その他器具アイコン
      }
    } else {
      // 自重トレーニングの場合、部位に応じたアイコン（全て統一：ハートに心拍数）
      switch (exercise.mainBodyPart) {
        case BodyPart.arm:
          return Icons.accessibility;
        case BodyPart.chest:
          return Icons.accessibility;
        case BodyPart.shoulder:
          return Icons.accessibility;
        case BodyPart.abs:
          return Icons.accessibility;
        case BodyPart.back:
          return Icons.accessibility;
        case BodyPart.leg:
          return Icons.accessibility;
        default:
          return Icons.fitness_center;
      }
    }
  }
}