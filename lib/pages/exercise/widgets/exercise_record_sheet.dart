import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../data/exercise_data.dart';
import '../../../providers/exercise_records_provider.dart';
import 'exercise_detail_sheet.dart';
import 'package:google_fonts/google_fonts.dart';

class ExerciseRecordSheet extends HookConsumerWidget {
  final Exercise exercise;

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

  const ExerciseRecordSheet({
    super.key,
    required this.exercise,
  });

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    // 既存の記録があるかチェック
    final existingRecord = ref.watch(exerciseRecordsProvider)[exercise.id];
    
    // 回数型の状態管理
    final repetitions = useState(existingRecord?.repetitions ?? 0);
    final repetitionsController = useTextEditingController(
      text: (existingRecord?.repetitions ?? 0).toString()
    );
    
    // 時間型の状態管理
    final isRunning = useState(false);
    final elapsedSeconds = useState(existingRecord?.duration?.inSeconds ?? 0);

    // タイマー効果
    useEffect(() {
      Timer? timer;
      if (isRunning.value) {
        timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          elapsedSeconds.value++;
        });
      }
      return () => timer?.cancel();
    }, [isRunning.value]);

    // 初期値を既存記録から設定
    useEffect(() {
      if (existingRecord != null) {
        if (exercise.isTimeBasedExercise) {
          elapsedSeconds.value = existingRecord.duration?.inSeconds ?? 0;
        } else {
          repetitions.value = existingRecord.repetitions ?? 0;
          repetitionsController.text = (existingRecord.repetitions ?? 0).toString();
        }
      }
      return null;
    }, []);

    // TextFieldの変更を監視
    useEffect(() {
      void listener() {
        final value = int.tryParse(repetitionsController.text) ?? 0;
        repetitions.value = value;
      }
      repetitionsController.addListener(listener);
      return () => repetitionsController.removeListener(listener);
    }, [repetitionsController]);

    return Container(
      decoration: BoxDecoration(
        color: neumorphicBackground,
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
              color: const Color(0xFF2C2C2E).withOpacity(0.3),
              borderRadius: BorderRadius.circular(2.sp),
            ),
          ),

          // 固定ヘッダー
          _buildHeader(context),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.sp),
              child: Column(
                children: [
                  
                  // 記録エリア
                  if (exercise.isTimeBasedExercise)
                    _buildTimerSection(context, isRunning, elapsedSeconds)
                  else
                    _buildRepetitionSection(context, repetitions, repetitionsController),
                  
                  const Spacer(),
                  
                  // ボタンエリア
                  _buildButtons(context, ref, repetitions, elapsedSeconds),
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
        horizontal: 20.sp,
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
          // 左側：メイン部位のアイコン（ニューモーフィック）
          Container(
            width: 40.sp,
            height: 40.sp,
            decoration: neumorphicDecoration,
            child: Icon(
              _getExerciseIcon(),
              color: exercise.mainBodyPart.color,
              size: 20.sp,
            ),
          ),
          
          SizedBox(width: 16.sp),
          
          // 右側：種目情報
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 種目名（省略表示対応）
                Text(
                  exercise.name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2C2C2E),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                
                SizedBox(height: 4.sp),
                
                // 目的部位（3つまで表示、省略表示対応）
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        exercise.detailedTargetParts.take(3).join(' '),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF2C2C2E).withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(width: 8.sp),
          
          // 情報ボタン
          GestureDetector(
            onTap: () => _showExerciseDetail(context),
            child: Container(
              width: 32.sp,
              height: 32.sp,
              decoration: neumorphicDecoration.copyWith(
                borderRadius: BorderRadius.circular(16.sp),
              ),
              child: Icon(
                Icons.info_outline,
                size: 18.sp,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepetitionSection(BuildContext context, ValueNotifier<int> repetitions, TextEditingController controller) {
    return Column(
      children: [
        // 回数表示と+/-ボタンを横並び
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // マイナスボタン
            GestureDetector(
              onTap: () {
                if (repetitions.value > 0) {
                  repetitions.value--;
                  controller.text = repetitions.value.toString();
                }
              },
              child: Container(
                width: 50.sp,
                height: 50.sp,
                decoration: neumorphicDecoration.copyWith(
                  borderRadius: BorderRadius.circular(12.sp),
                ),
                child: Icon(
                  Icons.remove,
                  size: 24.sp,
                  color: const Color(0xFF2C2C2E).withOpacity(0.7),
                ),
              ),
            ),
            
            SizedBox(width: 20.sp),
            
            // 回数入力欄（neumorphic）
            Container(
              width: 100.sp,
              height: 60.sp,
              decoration: neumorphicInsetDecoration,
              child: Center(
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2C2C2E).withOpacity(0.85),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3), // 最大3桁
                  ],
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) {
                    final intValue = int.tryParse(value) ?? 0;
                    repetitions.value = intValue;
                  },
                ),
              ),
            ),
            
            SizedBox(width: 20.sp),
            
            // プラスボタン
            GestureDetector(
              onTap: () {
                repetitions.value++;
                controller.text = repetitions.value.toString();
              },
              child: Container(
                width: 50.sp,
                height: 50.sp,
                decoration: neumorphicDecoration.copyWith(
                  borderRadius: BorderRadius.circular(12.sp),
                ),
                child: Icon(
                  Icons.add,
                  size: 24.sp,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimerSection(
    BuildContext context, 
    ValueNotifier<bool> isRunning, 
    ValueNotifier<int> elapsedSeconds
  ) {
    final minutes = elapsedSeconds.value ~/ 60;
    final seconds = elapsedSeconds.value % 60;
    
    return Column(
      children: [
        // 時間表示（neumorphic）
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // リセットボタン
            GestureDetector(
              onTap: () {
                isRunning.value = false;
                elapsedSeconds.value = 0;
              },
              child: Container(
                width: 50.sp,
                height: 50.sp,
                decoration: neumorphicDecoration.copyWith(
                  borderRadius: BorderRadius.circular(12.sp),
                ),
                child: Icon(
                  Icons.refresh,
                  size: 24.sp,
                  color: const Color(0xFF2C2C2E).withOpacity(0.7),
                ),
              ),
            ),

            SizedBox(width: 20.sp),

            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 24.sp,
                vertical: 16.sp,
              ),
              decoration: neumorphicInsetDecoration,
              child: Text(
                '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2C2C2E).withOpacity(0.85),
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),

            SizedBox(width: 20.sp),

            // タイマーボタン
            GestureDetector(
              onTap: () {
                isRunning.value = !isRunning.value;
              },
              child: Container(
                width: 50.sp,
                height: 50.sp,
                decoration: neumorphicDecoration.copyWith(
                  borderRadius: BorderRadius.circular(12.sp),
                ),
                child: Icon(
                  isRunning.value ? Icons.pause : Icons.play_arrow,
                  size: 24.sp,
                  color: Colors.red,
                ),
              ),
            ),

          ],
        ),
        
        
      ],
    );
  }

  void _showExerciseDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => ExerciseDetailSheet(
          exercise: exercise,
        ),
      ),
    );
  }

  Widget _buildButtons(
    BuildContext context, 
    WidgetRef ref, 
    ValueNotifier<int> repetitions, 
    ValueNotifier<int> elapsedSeconds
  ) {
    return Row(
      children: [
        // キャンセルボタン
        Expanded(
          child: SizedBox(
            height: 44.sp,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCED3D9),
                foregroundColor: const Color(0xFF2C2C2E),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.sp),
                ),
              ),
              child: Text(
                'キャンセル',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        
        SizedBox(width: 12.sp),
        
        // OKボタン
        Expanded(
          child: SizedBox(
            height: 44.sp,
            child: ElevatedButton(
              onPressed: () {
                // 記録保存処理
                if (exercise.isTimeBasedExercise) {
                  if (elapsedSeconds.value > 0) {
                    final record = ExerciseRecord(
                      exerciseId: exercise.id,
                      repetitions: null,
                      duration: Duration(seconds: elapsedSeconds.value),
                      isTimeBasedExercise: exercise.isTimeBasedExercise,
                    );
                    ref.read(exerciseRecordsProvider.notifier).addRecord(record);
                  } else {
                    ref.read(exerciseRecordsProvider.notifier).removeRecord(exercise.id);
                  }
                } else {
                  if (repetitions.value > 0) {
                    final record = ExerciseRecord(
                      exerciseId: exercise.id,
                      repetitions: repetitions.value,
                      duration: null,
                      isTimeBasedExercise: exercise.isTimeBasedExercise,
                    );
                    ref.read(exerciseRecordsProvider.notifier).addRecord(record);
                  } else {
                    ref.read(exerciseRecordsProvider.notifier).removeRecord(exercise.id);
                  }
                }
                
                Navigator.of(context).pop();
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
        ),
      ],
    );
  }
}