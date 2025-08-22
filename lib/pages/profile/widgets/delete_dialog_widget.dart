// pages/profile/widgets/delete_dialog_widget.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../exercise/data/exercise_data.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteDialogWidget {
  // ダークテーマ用の色定義
  static const Color darkBackground = Color(0xFF1C1C1C);
  static const Color darkCardColor = Color(0xFF2C2C2C);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);

  /// ワークアウトセッション全体を削除する確認ダイアログを表示
  static void showDeleteWorkoutDialog({
    required BuildContext context,
    required int totalXP,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: darkCardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.sp),
        ),
        title: Text(
          '記録を削除',
          style: GoogleFonts.inter(
            color: darkTextPrimary,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'この記録を削除しますか？\n獲得した${totalXP}XPも失われます。',
          style: GoogleFonts.inter(
            color: darkTextSecondary,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Row(
            children: [
              // キャンセルボタン
              Expanded(
                child: SizedBox(
                  height: 44.sp,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkTextSecondary,
                      foregroundColor: darkBackground,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.sp),
                      ),
                    ),
                    child: Text(
                      '戻る',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.sp),
              // 削除ボタン
              Expanded(
                child: SizedBox(
                  height: 44.sp,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.sp),
                      ),
                    ),
                    child: Text(
                      '削除',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 個別のエクササイズを削除する確認ダイアログを表示
  static void showDeleteExerciseDialog({
    required BuildContext context,
    required Exercise exercise,
    required int exerciseXP,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: darkCardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.sp),
        ),
        title: Text(
          'エクササイズを削除',
          style: GoogleFonts.inter(
            color: darkTextPrimary,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          '${exercise.name}をこの記録から削除しますか？\n獲得した${exerciseXP}XPも失われます。',
          style: GoogleFonts.inter(
            color: darkTextSecondary,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Row(
            children: [
              // キャンセルボタン
              Expanded(
                child: SizedBox(
                  height: 44.sp,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkTextSecondary,
                      foregroundColor: darkBackground,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.sp),
                      ),
                    ),
                    child: Text(
                      '戻る',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.sp),
              // 削除ボタン
              Expanded(
                child: SizedBox(
                  height: 44.sp,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.sp),
                      ),
                    ),
                    child: Text(
                      '削除',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}