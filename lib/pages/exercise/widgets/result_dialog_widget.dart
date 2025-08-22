// pages/exercise/widgets/result_dialog_widget.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sizer/sizer.dart';
import '../data/exercise_data.dart';
import '../../../providers/exercise_records_provider.dart';
import '../../../providers/persistent_xp_provider.dart';
import '../../../providers/workout_sessions_provider.dart';
import '../../../models/workout_session.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultDialogWidget extends ConsumerWidget {
  final Map<int, ExerciseRecord> exerciseRecords;
  final VoidCallback onComplete;

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

  const ResultDialogWidget({
    super.key,
    required this.exerciseRecords,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // XP計算
    final totalXP = ref.read(exerciseRecordsProvider.notifier).calculateTotalXP();
    final overallXP = ref.read(exerciseRecordsProvider.notifier).calculateTotalOverallXP();

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6, // 6割に制限
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        decoration: BoxDecoration(
          color: neumorphicBackground,
          borderRadius: BorderRadius.circular(20.sp),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ヘッダー
            _buildHeader(context),
            
            // コンテンツ（スクロール可能）
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12.sp),
                    
                    _buildXPSection(totalXP),
                    
                    SizedBox(height: 8.sp),
                  ],
                ),
              ),
            ),
            
            // ボタンエリア
            _buildButtonArea(context, ref, totalXP, overallXP),
            SizedBox(height: 12.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 12.sp,
        vertical: 12.sp,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF2C2C2E).withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // 成功アイコン
          Container(
            width: 40.sp,
            height: 40.sp,
            decoration: neumorphicDecoration,
            child: Icon(
              Icons.check_circle_outline,
              color: Colors.red,
              size: 24.sp,
            ),
          ),
          
          // タイトル（アイコンを除いた残りのスペースでセンタリング）
          Expanded(
            child: Center(
              child: Text(
                '獲得XP',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2C2C2E),
                ),
              ),
            ),
          ),
          
          // 右側の空きスペース（左右対称にするため）
          SizedBox(width: 40.sp),
        ],
      ),
    );
  }

  Widget _buildXPSection(Map<String, int> totalXP) {
    final xpEntries = totalXP.entries.where((entry) => entry.value > 0).toList();
    
    if (xpEntries.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // XPリスト
        Column(
          children: xpEntries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 部位名
                  Row(
                    children: [
                      Container(
                        width: 7.sp,
                        height: 7.sp,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF2C2C2E).withOpacity(0.7),
                        ),
                      ),
                      SizedBox(width: 12.sp),
                      Text(
                        entry.key,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2C2C2E),
                        ),
                      ),
                    ],
                  ),
                  
                  // XP値
                  Text(
                    '+${entry.value} XP',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildButtonArea(BuildContext context, WidgetRef ref, Map<String, int> totalXP, int overallXP) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.sp),
      child: SizedBox(
        width: double.infinity,
        height: 44.sp,
        child: ElevatedButton(
          onPressed: () async {
            try {
              // ワークアウトセッションを作成
              final session = WorkoutSession(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                dateTime: DateTime.now(),
                exerciseRecords: exerciseRecords,
                totalXP: totalXP,
                overallXP: overallXP,
              );

              // セッションを保存
              await ref.read(workoutSessionsProvider.notifier).addSession(session);

              // 永続的なXPプロバイダーにXPを追加
              await ref.read(persistentXpProvider.notifier).addXP(totalXP);
              
              Navigator.of(context).pop();
              onComplete();
            } catch (e) {
              print('Failed to save workout session: $e');
              // エラーが発生してもダイアログは閉じる
              Navigator.of(context).pop();
              onComplete();
            }
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
            'OK',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}