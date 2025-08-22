// pages/exercise/widgets/exercise_detail_sheet.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../data/exercise_data.dart';
import 'package:google_fonts/google_fonts.dart';

class ExerciseDetailSheet extends StatelessWidget {
  final Exercise exercise;

  // ダークテーマ用の色定義
  static const Color darkBackground = Color(0xFF1C1C1C);
  static const Color darkCardColor = Color(0xFF2C2C2C);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);

  // ダークテーマ用のBoxDecoration
  BoxDecoration get darkCardDecoration => BoxDecoration(
    color: darkCardColor,
    borderRadius: BorderRadius.circular(12.sp),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        offset: Offset(0, 2.sp),
        blurRadius: 8.sp,
        spreadRadius: 0,
      ),
    ],
  );

  const ExerciseDetailSheet({
    super.key,
    required this.exercise,
  });

  // 各エクササイズの負荷データを取得
  Map<String, int> _getLoadData() {
    return ExerciseData.getExerciseLoadData(exercise.id);
  }

  // トレーニング方法（やり方）を取得
  String _getTrainingMethod() {
    return ExerciseData.getTrainingMethod(exercise.id);
  }

  // トレーニングポイントを取得
  String _getTrainingPoints() {
    return ExerciseData.getTrainingPoints(exercise.id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loadData = _getLoadData();
    
    // チャート用のデータを準備
    final chartData = loadData.entries.map((entry) => {
      'bodyPart': entry.key,
      'load': entry.value,
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: darkBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.sp),
          topRight: Radius.circular(20.sp),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ハンドルバー
          Container(
            margin: EdgeInsets.only(top: 12.sp),
            width: 40.sp,
            height: 4.sp,
            decoration: BoxDecoration(
              color: darkTextSecondary,
              borderRadius: BorderRadius.circular(2.sp),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(8.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 左揃えに変更
                children: [
                  // ヘッダー部分（タイルと同じデザイン）
                  _buildHeader(context),
                  
                  SizedBox(height: 12.sp),
                  
                  // 概要文
                  _buildOverview(),
                  
                  SizedBox(height: 12.sp),
                  
                  // GIF動画プレースホルダー（16:9）
                  _buildVideoPlaceholder(),
                  
                  SizedBox(height: 12.sp),
                  
                  // 負荷チャート
                  _buildLoadChart(chartData),
                  
                  SizedBox(height: 12.sp),
                  
                  // トレーニング方法
                  _buildTrainingMethod(),
                  
                  SizedBox(height: 12.sp),
                  
                  // ポイント
                  _buildTrainingPoints(),
                  
                  SizedBox(height: 16.sp),
                  
                  // 閉じるボタン
                  _buildCloseButton(context),

                  SizedBox(height: 8.sp), // 最後に余白を追加
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 12.sp,
        vertical: 12.sp,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: darkTextSecondary.withOpacity(0.3),
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
              color: Colors.red, // 赤で統一
              size: 20.sp,
            ),
          ),
          
          SizedBox(width: 16.sp),
          
          // 右側：種目情報
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 種目名
                Text(
                  exercise.name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: darkTextPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
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
        ],
      ),
    );
  }

  Widget _buildOverview() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '概要',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: darkTextPrimary,
            ),
          ),
          SizedBox(height: 4.sp),
          Text(
            exercise.description,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: darkTextSecondary,
              height: 1.4,
              fontWeight: FontWeight.w500, // 太さを追加
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlaceholder() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.sp),
      width: double.infinity,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            color: darkCardColor,
            borderRadius: BorderRadius.circular(12.sp),
            border: Border.all(
              color: darkTextSecondary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.play_circle_outline,
                size: 48.sp,
                color: darkTextSecondary,
              ),
              SizedBox(height: 8.sp),
              Text(
                'トレーニング動画',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: darkTextSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '（実装予定）',
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  color: darkTextSecondary.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadChart(List<Map<String, dynamic>> chartData) {
    // 負荷が0でないもののみをフィルタリングし、負荷の大きい順にソート
    final filteredData = chartData
        .where((data) => (data['load'] as int) > 0)
        .toList()
      ..sort((a, b) => (b['load'] as int).compareTo(a['load'] as int));

    if (filteredData.isEmpty) {
      return Container();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '負荷レベル',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: darkTextPrimary,
            ),
          ),
          SizedBox(height: 4.sp),
          
          // 1列の負荷レベル表示
          ...filteredData.map((data) {
            final bodyPart = data['bodyPart'] as String;
            final load = data['load'] as int;
            
            return Padding(
              padding: EdgeInsets.only(bottom: 8.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 上部：部位名と負荷値
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        bodyPart,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: darkTextSecondary,
                        ),
                      ),
                      Text(
                        '$load/10',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: darkTextSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.sp),
                  
                  // プログレスバー（ダークテーマ）
                  Container(
                    height: 6.sp,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.sp),
                      color: darkCardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(0, 1.sp),
                          blurRadius: 2.sp,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3.sp),
                      child: LinearProgressIndicator(
                        value: load / 10.0,
                        backgroundColor: darkCardColor,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
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

  Widget _buildTrainingMethod() {
    final methodText = _getTrainingMethod();
    if (methodText.isEmpty) return Container();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'トレーニング方法',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: darkTextPrimary,
            ),
          ),
          SizedBox(height: 4.sp),
          Text(
            methodText,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: darkTextSecondary,
              height: 1.6,
              fontWeight: FontWeight.w500, // 太さを追加
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingPoints() {
    final pointsText = _getTrainingPoints();
    if (pointsText.isEmpty) return Container();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ポイント',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: darkTextPrimary,
            ),
          ),
          SizedBox(height: 4.sp),
          Text(
            pointsText,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: darkTextSecondary,
              height: 1.6,
              fontWeight: FontWeight.w500, // 太さを追加
            ),
            textAlign: TextAlign.left,
          ),
        ],
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
          return Icons.accessibility; // ハートに心拍数
        case BodyPart.chest:
          return Icons.accessibility; // ハートに心拍数
        case BodyPart.shoulder:
          return Icons.accessibility; // ハートに心拍数
        case BodyPart.abs:
          return Icons.accessibility; // ハートに心拍数
        case BodyPart.back:
          return Icons.accessibility; // ハートに心拍数
        case BodyPart.leg:
          return Icons.accessibility; // ハートに心拍数
        default:
          return Icons.fitness_center;
      }
    }
  }

  Widget _buildCloseButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.sp),
      width: double.infinity,
      height: 48.sp,
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
          '閉じる',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}