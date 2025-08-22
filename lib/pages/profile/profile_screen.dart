// pages/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:hercules_5/main/home.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../../providers/xp_level_provider.dart';
import '../../providers/workout_sessions_provider.dart';
import '../../providers/persistent_xp_provider.dart';
import '../../providers/exercise_records_provider.dart';
import '../../models/workout_session.dart';
import '../../pages/exercise/data/exercise_data.dart';
import 'widgets/expandable_workout_tile.dart';
import 'widgets/setting_sheet.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final VoidCallback? onNavigateToExercise;
  
  const ProfileScreen({
    super.key,
    this.onNavigateToExercise,
  });

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _username = 'ユーザー名'; // デフォルト値
  String _comment = '今日も頑張ろう！'; // デフォルトコメント
  String? _profileImageData; // プロフィール画像のbase64データ
  bool _isLoadingUsername = true; // ユーザー名読み込み中フラグ
  bool _isLoadingComment = true; // コメント読み込み中フラグ
  bool _isLoadingProfileImage = true; // プロフィール画像読み込み中フラグ

  // ダークテーマ用の色定義
  static const Color darkBackground = Color(0xFF1C1C1C);
  static const Color darkCardColor = Color(0xFF2C2C2C);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);

  // SharedPreferencesキー
  static const String _usernameKey = 'user_profile_username';
  static const String _commentKey = 'user_profile_comment';
  static const String _profileImageKey = 'user_profile_image_data';



  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _loadUsername(); // ユーザー名を読み込み
    _loadComment(); // コメントを読み込み
    _loadProfileImage(); // プロフィール画像を読み込み
  }

  @override
  void didUpdateWidget(ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_tabController.length != 2) {
      _tabController.dispose();
      _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // SharedPreferencesからユーザー名を読み込み
  Future<void> _loadUsername() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUsername = prefs.getString(_usernameKey);
      
      if (mounted) {
        setState(() {
          if (savedUsername != null && savedUsername.isNotEmpty) {
            _username = savedUsername;
          }
          _isLoadingUsername = false;
        });
      }
    } catch (e) {
      print('Failed to load username: $e');
      if (mounted) {
        setState(() {
          _isLoadingUsername = false;
        });
      }
    }
  }

  // SharedPreferencesからコメントを読み込み
  Future<void> _loadComment() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedComment = prefs.getString(_commentKey);
      
      if (mounted) {
        setState(() {
          if (savedComment != null && savedComment.isNotEmpty) {
            _comment = savedComment;
          }
          _isLoadingComment = false;
        });
      }
    } catch (e) {
      print('Failed to load comment: $e');
      if (mounted) {
        setState(() {
          _isLoadingComment = false;
        });
      }
    }
  }

  // SharedPreferencesからプロフィール画像を読み込み
  Future<void> _loadProfileImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedImageData = prefs.getString(_profileImageKey);
      
      if (mounted) {
        setState(() {
          _profileImageData = savedImageData;
          _isLoadingProfileImage = false;
        });
      }
    } catch (e) {
      print('Failed to load profile image: $e');
      if (mounted) {
        setState(() {
          _isLoadingProfileImage = false;
        });
      }
    }
  }

  // SharedPreferencesにユーザー名を保存
  Future<void> _saveUsername(String newUsername) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_usernameKey, newUsername);
      
      if (mounted) {
        setState(() {
          _username = newUsername;
        });
      }
    } catch (e) {
      print('Failed to save username: $e');
      // エラーが発生した場合でも状態は更新する（UI応答性のため）
      if (mounted) {
        setState(() {
          _username = newUsername;
        });
      }
    }
  }

  // SharedPreferencesにコメントを保存
  Future<void> _saveComment(String newComment) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_commentKey, newComment);
      
      if (mounted) {
        setState(() {
          _comment = newComment;
        });
      }
    } catch (e) {
      print('Failed to save comment: $e');
      // エラーが発生した場合でも状態は更新する（UI応答性のため）
      if (mounted) {
        setState(() {
          _comment = newComment;
        });
      }
    }
  }

  // SharedPreferencesにプロフィール画像データを保存
  Future<void> _saveProfileImageData(String imageData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_profileImageKey, imageData);
      
      if (mounted) {
        setState(() {
          _profileImageData = imageData;
        });
      }
    } catch (e) {
      print('Failed to save profile image data: $e');
      // エラーが発生した場合でも状態は更新する（UI応答性のため）
      if (mounted) {
        setState(() {
          _profileImageData = imageData;
        });
      }
    }
  }

  // プロフィール画像を選択
  Future<void> _pickProfileImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      
      if (result != null && result.files.single.bytes != null) {
        final imageBytes = result.files.single.bytes!;
        final imageData = base64Encode(imageBytes);
        await _saveProfileImageData(imageData);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'プロフィール画像を更新しました',
                style: GoogleFonts.inter(
                  color: darkTextPrimary,
                  fontSize: 12.sp,
                ),
              ),
              backgroundColor: darkCardColor,
            ),
          );
        }
      }
    } catch (e) {
      print('Failed to pick profile image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '画像の選択に失敗しました',
              style: GoogleFonts.inter(
                color: darkTextPrimary,
                fontSize: 12.sp,
              ),
            ),
            backgroundColor: darkCardColor,
          ),
        );
      }
    }
  }

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

  // 押し込まれたダークテーマスタイル
  BoxDecoration get darkCardInsetDecoration => BoxDecoration(
    color: darkCardColor,
    borderRadius: BorderRadius.circular(12.sp),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.5),
        offset: Offset(0, 1.sp),
        blurRadius: 4.sp,
        spreadRadius: 0,
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final levelInfoAsync = ref.watch(xpLevelManagerProvider);
    
    return Scaffold(
      backgroundColor: darkBackground,
      body: SafeArea(
        child: levelInfoAsync.when(
          data: (levelInfo) => _buildContent(context, levelInfo),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48.sp,
                  color: Colors.red,
                ),
                SizedBox(height: 4.sp),
                Text(
                  'データの読み込みに失敗しました',
                  style: GoogleFonts.inter(
                    color: darkTextPrimary,
                    fontSize: 14.sp,
                  ),
                ),
                        
        SizedBox(height: 4.sp),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(xpLevelManagerProvider);
                  },
                  child: const Text('再試行'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Map<String, LevelInfo> levelInfo) {
    final theme = Theme.of(context);
    
    return Stack(
      children: [
        // メインコンテンツ
        Column(
          children: [
            SizedBox(height: 32.sp),
            // プロフィール上部（修正版 - 縦並び）
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
              child: Column(
                children: [
                  // プロフィール写真（タップで変更可能）- 中央配置
                  GestureDetector(
                    onTap: _pickProfileImage,
                    child: Container(
                      width: 80.sp,
                      height: 80.sp,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: Offset(0, 4.sp),
                            blurRadius: 8.sp,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: _isLoadingProfileImage
                            ? Container(
                                color: darkCardColor,
                                child: Icon(
                                  Icons.person,
                                  size: 40.sp,
                                  color: darkTextSecondary,
                                ),
                              )
                            : _profileImageData != null
                                ? Image.memory(
                                    base64Decode(_profileImageData!),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: darkCardColor,
                                        child: Icon(
                                          Icons.person,
                                          size: 40.sp,
                                          color: darkTextSecondary,
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    color: darkCardColor,
                                    child: Icon(
                                      Icons.person,
                                      size: 40.sp,
                                      color: darkTextSecondary,
                                    ),
                                  ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 12.sp),
                  
                  // ユーザー名（プロフィール画像の下）- 中央配置
                  _isLoadingUsername
                      ? Container(
                          height: 24.sp,
                          width: 120.sp,
                          decoration: BoxDecoration(
                            color: darkCardColor,
                            borderRadius: BorderRadius.circular(4.sp),
                          ),
                        )
                      : Text(
                          _username,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: darkTextPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                ],
              ),
            ),
            
            SizedBox(height: 8.sp),
            
            // タブバー（アイコン版）
            Container(
              child: TabBar(
                controller: _tabController,
                labelColor: darkTextPrimary,
                unselectedLabelColor: darkTextSecondary,
                dividerColor: darkTextSecondary.withOpacity(0.3),
                dividerHeight: 0.5,
                indicatorColor: Colors.red,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                splashFactory: NoSplash.splashFactory,
                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.trending_up,
                      size: 20.sp,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.history,
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
            ),
            
            // タブビュー
            Expanded(
              child: Container(
                color: darkBackground,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLevelTab(context, levelInfo),
                    _buildRecordTab(context),
                  ],
                ),
              ),
            ),
          ],
        ),
        
        // 設定ボタン（右上に配置）
        Positioned(
          top: 16.sp,
          right: 16.sp,
          child: Container(
            width: 32.sp,
            height: 32.sp,
            decoration: BoxDecoration(
              color: darkCardColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: Offset(0, 2.sp),
                  blurRadius: 4.sp,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => _showSettingsModal(context),
              icon: Icon(
                Icons.settings,
                color: darkTextSecondary,
                size: 16.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

Widget _buildLevelTab(BuildContext context, Map<String, LevelInfo> levelInfo) {
  final theme = Theme.of(context);
  final bodyPartNames = ['腕', '胸', '肩', '腹筋', '背筋', '脚'];

  return LayoutBuilder(
    builder: (context, constraints) {
      final availableWidth = constraints.maxWidth;
      final availableHeight = constraints.maxHeight;
      
      final horizontalPadding = 32.sp;
      final verticalPadding = 32.sp;
      const crossAxisSpacing = 12.0;
      const mainAxisSpacing = 12.0;
      const crossAxisCount = 2;
      const mainAxisCount = 3;
      
      final gridWidth = availableWidth - horizontalPadding;
      final gridHeight = availableHeight - verticalPadding;
      
      final itemWidth = (gridWidth - crossAxisSpacing) / crossAxisCount;
      final itemHeight = (gridHeight - (mainAxisSpacing * (mainAxisCount - 1))) / mainAxisCount;
      
      // デバイスサイズに合わせてアスペクト比を動的に計算
      final aspectRatio = itemWidth / itemHeight;

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.sp),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(vertical: 16.sp),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
            childAspectRatio: aspectRatio, // 動的に計算されたアスペクト比を使用
          ),
          itemCount: bodyPartNames.length,
          itemBuilder: (context, index) {
            final bodyPartName = bodyPartNames[index];
            final info = levelInfo[bodyPartName];
            
            if (info == null) {
              // デフォルトの初期状態
              return Container(
                padding: EdgeInsets.all(16.sp),
                decoration: darkCardDecoration,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // サークルゲージ（背景）- 正円を保つ
                    AspectRatio(
                      aspectRatio: 1.0,
                      child: SizedBox(
                        width: 80.sp,
                        height: 80.sp,
                        child: CircularProgressIndicator(
                          value: 0.0,
                          strokeWidth: 6.sp,
                          strokeCap: StrokeCap.round,
                          backgroundColor: darkTextSecondary.withOpacity(0.3),
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                      ),
                    ),
                    // 中央のテキスト
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 部位名（サブテキスト）
                        Text(
                          bodyPartName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: darkTextSecondary,
                          ),
                        ),
                        SizedBox(height: 2.sp),
                        // レベル（メインテキスト）
                        Text(
                          'Lv.1',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: darkTextPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            
            return Container(
              padding: EdgeInsets.all(16.sp),
              decoration: darkCardDecoration,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // サークルゲージ - 正円を保つ
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: SizedBox(
                      width: 80.sp,
                      height: 80.sp,
                      child: CircularProgressIndicator(
                        value: info.progress,
                        strokeWidth: 6.sp,
                        strokeCap: StrokeCap.round,
                        backgroundColor: darkTextSecondary.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    ),
                  ),
                  // 中央のテキスト
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 部位名（サブテキスト）
                      Text(
                        bodyPartName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: darkTextSecondary,
                        ),
                      ),
                      SizedBox(height: 2.sp),
                      // レベル（メインテキスト）
                      Text(
                        'Lv.${info.level}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: darkTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

  // 記録タブ（個別削除機能付き）
  Widget _buildRecordTab(BuildContext context) {
    final theme = Theme.of(context);
    final workoutSessions = ref.watch(workoutSessionsProvider);

    if (workoutSessions.isEmpty) {
      return _buildEmptyRecordState(context);
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 16.sp),
      itemCount: workoutSessions.length,
      itemBuilder: (context, index) {
        final session = workoutSessions[index];
        
        return ExpandableWorkoutTile(
          session: session,
          onDelete: () => _deleteWorkoutSession(session),
          onDeleteExercise: (exerciseId) => _deleteExerciseFromSession(session, exerciseId),
        );
      },
    );
  }

  Widget _buildEmptyRecordState(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.sp,
            height: 80.sp,
            decoration: darkCardDecoration,
            child: Icon(
              Icons.history,
              size: 40.sp,
              color: darkTextSecondary,
            ),
          ),
          
          SizedBox(height: 20.sp),
          
          Text(
            'ワークアウト記録がありません',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: darkTextPrimary,
              fontSize: 16.sp,
            ),
          ),
          
          SizedBox(height: 8.sp),
          
          Text(
            'エクササイズを記録して\n成長の軌跡を追跡しましょう',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: darkTextSecondary,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }

  // セッション全体削除
  Future<void> _deleteWorkoutSession(WorkoutSession session) async {
    try {
      await ref.read(workoutSessionsProvider.notifier).removeSession(session.id);
      
      final negativeXP = session.totalXP.map((key, value) => MapEntry(key, -value));
      await ref.read(persistentXpProvider.notifier).addXP(negativeXP);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '記録を削除しました（${session.totalXPSum}XP減少）',
              style: GoogleFonts.inter(
                color: darkTextPrimary,
                fontSize: 12.sp,
              ),
            ),
            backgroundColor: darkCardColor,
          ),
        );
      }
    } catch (e) {
      print('Failed to delete workout session: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '記録の削除に失敗しました',
              style: GoogleFonts.inter(
                color: darkTextPrimary,
                fontSize: 12.sp,
              ),
            ),
            backgroundColor: darkCardColor,
          ),
        );
      }
    }
  }

  // 個別エクササイズ削除
  Future<void> _deleteExerciseFromSession(WorkoutSession session, int exerciseId) async {
    try {
      final exercise = ExerciseData.getExerciseById(exerciseId);
      final record = session.exerciseRecords[exerciseId];
      
      if (exercise == null || record == null) return;

      // 削除するエクササイズのXPを計算
      final loadData = ExerciseData.getExerciseLoadData(exerciseId);
      int baseXP = 0;
      if (record.isTimeBasedExercise && record.duration != null) {
        baseXP = (record.duration!.inSeconds / 10).round();
      } else if (!record.isTimeBasedExercise && record.repetitions != null) {
        baseXP = record.repetitions!;
      }

      final deletedXP = <String, int>{
        '腕': 0, '胸': 0, '肩': 0, '腹筋': 0, '背筋': 0, '脚': 0,
      };

      for (final entry in loadData.entries) {
        final bodyPart = entry.key;
        final load = entry.value;
        if (load > 0) {
          deletedXP[bodyPart] = (deletedXP[bodyPart]! + (load * baseXP).round());
        }
      }

      // セッションから該当エクササイズを削除
      final newExerciseRecords = Map<int, ExerciseRecord>.from(session.exerciseRecords);
      newExerciseRecords.remove(exerciseId);

      // セッションが空になった場合は完全に削除
      if (newExerciseRecords.isEmpty) {
        await _deleteWorkoutSession(session);
        return;
      }

      // 新しいtotalXPを計算
      final newTotalXP = Map<String, int>.from(session.totalXP);
      for (final entry in deletedXP.entries) {
        final bodyPart = entry.key;
        final xpToDelete = entry.value;
        newTotalXP[bodyPart] = (newTotalXP[bodyPart]! - xpToDelete).clamp(0, double.infinity).toInt();
      }

      final newOverallXP = newTotalXP.values.fold(0, (sum, xp) => sum + xp);

      // 新しいセッションを作成
      final updatedSession = WorkoutSession(
        id: session.id,
        dateTime: session.dateTime,
        exerciseRecords: newExerciseRecords,
        totalXP: newTotalXP,
        overallXP: newOverallXP,
      );

      // セッションを更新（削除→追加ではなく直接更新）
      await ref.read(workoutSessionsProvider.notifier).updateSession(updatedSession);

      // XPを減算
      final negativeXP = deletedXP.map((key, value) => MapEntry(key, -value));
      await ref.read(persistentXpProvider.notifier).addXP(negativeXP);

      // スナックバーで確認メッセージ
      if (mounted) {
        final totalDeletedXP = deletedXP.values.fold(0, (sum, xp) => sum + xp);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${exercise.name}を削除しました（${totalDeletedXP}XP減少）',
              style: GoogleFonts.inter(
                color: darkTextPrimary,
                fontSize: 12.sp,
              ),
            ),
            backgroundColor: darkCardColor,
          ),
        );
      }
    } catch (e) {
      print('Failed to delete exercise from session: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'エクササイズの削除に失敗しました',
              style: GoogleFonts.inter(
                color: darkTextPrimary,
                fontSize: 12.sp,
              ),
            ),
            backgroundColor: darkCardColor,
          ),
        );
      }
    }
  }

  // 設定モーダルを開く
  void _showSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SettingSheet(
        currentUsername: _username,
        currentComment: _comment,
        onUsernameChanged: (newUsername) async {
          await _saveUsername(newUsername); // SharedPreferencesに保存
        },
        onCommentChanged: (newComment) async {
          await _saveComment(newComment); // SharedPreferencesに保存
        },
      ),
    );
  }
}