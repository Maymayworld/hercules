// pages/profile/widgets/expandable_workout_tile.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sizer/sizer.dart';
import '../../../models/workout_session.dart';
import '../../exercise/data/exercise_data.dart';
import 'delete_dialog_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpandableWorkoutTile extends HookConsumerWidget {
  final WorkoutSession session;
  final VoidCallback onDelete;
  final Function(int exerciseId)? onDeleteExercise; // 個別エクササイズ削除用コールバック

  // ニューモーフィック用の色定義
  static const Color neumorphicBackground = Color(0xFFE0E5EC);
  static const Color neumorphicShadowDark = Color(0xFFA3B1C6);
  static const Color neumorphicShadowLight = Color(0xFFFFFFFF);

  // ニューモーフィックスタイル用のBoxDecoration
  BoxDecoration get neumorphicDecoration => BoxDecoration(
    color: neumorphicBackground,
    borderRadius: BorderRadius.circular(12.sp),
    boxShadow: [
      BoxShadow(
        color: neumorphicShadowDark,
        offset: Offset(4.sp, 4.sp),
        blurRadius: 8.sp,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: neumorphicShadowLight,
        offset: Offset(-4.sp, -4.sp),
        blurRadius: 8.sp,
        spreadRadius: 0,
      ),
    ],
  );

  // 押し込まれたニューモーフィックスタイル
  BoxDecoration get neumorphicInsetDecoration => BoxDecoration(
    color: neumorphicBackground,
    borderRadius: BorderRadius.circular(12.sp),
    boxShadow: [
      BoxShadow(
        color: neumorphicShadowLight,
        offset: Offset(2.sp, 2.sp),
        blurRadius: 4.sp,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: neumorphicShadowDark,
        offset: Offset(-2.sp, -2.sp),
        blurRadius: 4.sp,
        spreadRadius: 0,
      ),
    ],
  );

  const ExpandableWorkoutTile({
    super.key,
    required this.session,
    required this.onDelete,
    this.onDeleteExercise,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Container(
      margin: EdgeInsets.only(bottom: 12.sp),
      decoration: neumorphicDecoration,
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(
          horizontal: 16.sp,
          vertical: 8.sp,
        ),
        backgroundColor: neumorphicBackground,
        collapsedBackgroundColor: neumorphicBackground,
        iconColor: Colors.red,
        collapsedIconColor: const Color(0xFF2C2C2E).withOpacity(0.6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.sp),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.sp),
        ),
        title: Row(
          children: [
            // ゴミ箱アイコン（削除ボタンとして機能）
            GestureDetector(
              onTap: () => DeleteDialogWidget.showDeleteWorkoutDialog(
                context: context,
                totalXP: session.totalXPSum,
                onConfirm: onDelete,
              ),
              child: Container(
                width: 32.sp,
                height: 32.sp,
                decoration: neumorphicDecoration.copyWith(
                  borderRadius: BorderRadius.circular(8.sp),
                ),
                child: Icon(
                  Icons.delete_outline,
                  size: 16.sp,
                  color: const Color(0xFF2C2C2E).withOpacity(0.7),
                ),
              ),
            ),
            
            SizedBox(width: 12.sp),
            
            // 日時とXP
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.formattedDateTime,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2C2C2E),
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 2.sp),
                  Text(
                    '${session.totalXPSum}XP',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        children: [
          // Divider
          Divider(
            color: const Color(0xFF2C2C2E).withOpacity(0.2),
            thickness: 0.5,
            height: 1,
          ),
          
          // エクササイズ詳細リスト
          Padding(
            padding: EdgeInsets.only(left: 16.sp, top: 12.sp, bottom: 8.sp),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '種目',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2C2C2E),
                  fontSize: 13.sp,
                ),
              ),
            ),
          ),
          ...session.exerciseDetails.map((exerciseWithRecord) {
            return _buildExerciseDetailItem(context, exerciseWithRecord);
          }),
          
          // XP詳細
          _buildXPDetails(context),
        ],
      ),
    );
  }

  Widget _buildExerciseDetailItem(BuildContext context, ExerciseWithRecord exerciseWithRecord) {
    final theme = Theme.of(context);
    final exercise = exerciseWithRecord.exercise;
    final record = exerciseWithRecord.record;
    
    return Container(
      padding: EdgeInsets.only(bottom: 16.sp, right: 16.sp, left: 16.sp),
      child: Row(
        children: [
          // エクササイズアイコン（ゴミ箱アイコンに変更）
          GestureDetector(
            onTap: () => DeleteDialogWidget.showDeleteExerciseDialog(
              context: context,
              exercise: exercise,
              exerciseXP: _getExerciseXP(exercise.id),
              onConfirm: () {
                if (onDeleteExercise != null) {
                  onDeleteExercise!(exercise.id);
                }
              },
            ),
            child: Container(
              width: 32.sp,
              height: 32.sp,
              decoration: neumorphicDecoration.copyWith(
                borderRadius: BorderRadius.circular(8.sp),
              ),
              child: Icon(
                Icons.delete_outline,
                color: const Color(0xFF2C2C2E).withOpacity(0.7),
                size: 18.sp,
              ),
            ),
          ),
          
          SizedBox(width: 16.sp),
          
          // エクササイズ名と記録
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2C2C2E),
                    fontSize: 14.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 2.sp),
                Text(
                  record.displayValue,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF2C2C2E).withOpacity(0.7),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // 部位別XP（簡略表示）
          Text(
            '+${_getExerciseXP(exercise.id)} XP',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.red,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildXPDetails(BuildContext context) {
    final theme = Theme.of(context);
    final xpEntries = session.totalXP.entries.where((entry) => entry.value > 0).toList();
    
    if (xpEntries.isEmpty) {
      return Container();
    }

    return Container(
      padding: EdgeInsets.only(bottom: 12.sp, left: 16.sp, right: 16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '獲得XP詳細',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2C2C2E),
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 12.sp),
          ...xpEntries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 6.sp,
                        height: 6.sp,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF2c2c2e).withOpacity(0.7),
                        ),
                      ),
                      SizedBox(width: 12.sp),
                      Text(
                        entry.key,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF2C2C2E),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '+${entry.value} XP',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  int _getExerciseXP(int exerciseId) {
    // セッションのtotalXPから該当エクササイズのXPを計算
    final loadData = ExerciseData.getExerciseLoadData(exerciseId);
    
    // 該当エクササイズの記録を取得
    final record = session.exerciseRecords[exerciseId];
    if (record == null) return 0;
    
    // 基本XP計算
    int baseXP = 0;
    if (record.isTimeBasedExercise && record.duration != null) {
      // 時間型：10秒で1XP
      baseXP = (record.duration!.inSeconds / 10).round();
    } else if (!record.isTimeBasedExercise && record.repetitions != null) {
      // 回数型：1回で1XP
      baseXP = record.repetitions!;
    }
    
    // 各部位への負荷の合計XP
    int totalExerciseXP = 0;
    for (final entry in loadData.entries) {
      final load = entry.value;
      if (load > 0) {
        totalExerciseXP += (load * baseXP).round();
      }
    }
    
    return totalExerciseXP;
  }
}