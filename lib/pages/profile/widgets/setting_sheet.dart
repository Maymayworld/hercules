import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../providers/workout_sessions_provider.dart';
import '../../../providers/persistent_xp_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingSheet extends ConsumerStatefulWidget {
  final String currentUsername;
  final String currentComment;
  final Future<void> Function(String) onUsernameChanged;
  final Future<void> Function(String) onCommentChanged;

  const SettingSheet({
    super.key,
    required this.currentUsername,
    required this.currentComment,
    required this.onUsernameChanged,
    required this.onCommentChanged,
  });

  @override
  ConsumerState<SettingSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends ConsumerState<SettingSheet> {
  late TextEditingController _usernameController;
  late TextEditingController _commentController;
  bool _isSaving = false; // 保存中フラグ

  // ダークテーマ用の色定義
  static const Color darkBackground = Color(0xFF1C1C1C);
  static const Color darkCardColor = Color(0xFF2C2C2C);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);

  // SharedPreferencesキー
  static const String _usernameKey = 'user_profile_username';
  static const String _commentKey = 'user_profile_comment';

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.currentUsername);
    _commentController = TextEditingController(text: widget.currentComment);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _commentController.dispose();
    super.dispose();
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

  // 入力フィールド用のダークテーマスタイル
  BoxDecoration get darkInputDecoration => BoxDecoration(
    color: darkBackground,
    borderRadius: BorderRadius.circular(12.sp),
    border: Border.all(
      color: darkTextSecondary.withOpacity(0.3),
      width: 1,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: darkBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ヘッダー
              Row(
                children: [
                  Text(
                    '設定',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                      color: darkTextPrimary,
                    ),
                  ),
                  const Spacer(),
                  Container(
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
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        color: darkTextSecondary,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 32.sp),
              
              // ユーザー名設定
              _buildSettingSection(
                title: 'ユーザー名',
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 4.sp),
                  decoration: darkInputDecoration,
                  child: TextField(
                    controller: _usernameController,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: darkTextPrimary,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'ユーザー名を入力',
                      hintStyle: TextStyle(
                        color: darkTextSecondary,
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                    enabled: !_isSaving, // 保存中は無効化
                  ),
                ),
              ),
              
              SizedBox(height: 24.sp),
              
              // データ管理設定
              _buildSettingSection(
                title: 'データ管理',
                child: Container(
                  decoration: darkCardDecoration,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _isSaving ? null : () => _showDeleteConfirmDialog(context), // 保存中は無効化
                      borderRadius: BorderRadius.circular(12.sp),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 16.sp),
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_forever,
                              color: _isSaving ? Colors.red.withOpacity(0.5) : Colors.red,
                              size: 20.sp,
                            ),
                            SizedBox(width: 12.sp),
                            Text(
                              'すべての記録を削除',
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                color: _isSaving ? Colors.red.withOpacity(0.5) : Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: _isSaving 
                                  ? Colors.red.withOpacity(0.3) 
                                  : Colors.red.withOpacity(0.7),
                              size: 16.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              const Spacer(),
              
              // 保存ボタン
              SizedBox(
                width: double.infinity,
                height: 44.sp,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : () => _saveSettings(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSaving ? Colors.red.withOpacity(0.6) : Colors.red,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.sp),
                    ),
                  ),
                  child: _isSaving
                      ? SizedBox(
                          width: 20.sp,
                          height: 20.sp,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          '設定を保存',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: darkTextSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.sp),
        child,
      ],
    );
  }

  Future<void> _saveSettings(BuildContext context) async {
    setState(() {
      _isSaving = true;
    });

    try {
      // ユーザー名が変更されている場合は更新
      if (_usernameController.text != widget.currentUsername) {
        await widget.onUsernameChanged(_usernameController.text);
      }
      
      // コメントが変更されている場合は更新
      if (_commentController.text != widget.currentComment) {
        await widget.onCommentChanged(_commentController.text);
      }
      
      if (mounted) {
        // 成功メッセージを表示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '設定を保存しました',
              style: GoogleFonts.inter(
                color: darkTextPrimary,
                fontSize: 12.sp,
              ),
            ),
            backgroundColor: darkCardColor,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        // エラーメッセージを表示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '設定の保存に失敗しました',
              style: GoogleFonts.inter(
                color: darkTextPrimary,
                fontSize: 12.sp,
              ),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
    
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: darkCardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.sp),
          ),
          title: Text(
            'すべてのデータを削除',
            style: GoogleFonts.inter(
              color: darkTextPrimary,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'すべてのワークアウト記録とXPが削除されます。\nこの操作は取り消せません。',
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
                        _deleteAllData();
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
        );
      },
    );
  }

  Future<void> _deleteAllData() async {
    try {
      setState(() {
        _isSaving = true;
      });

      // すべてのワークアウトセッションを削除
      await ref.read(workoutSessionsProvider.notifier).clearAllSessions();
      
      // すべてのXPをリセット
      await ref.read(persistentXpProvider.notifier).resetXP();

      // ユーザー名もリセット（オプション）
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.remove(_usernameKey);
      
      if (mounted) {
        // 成功メッセージを表示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'すべてのデータを削除しました',
              style: GoogleFonts.inter(
                color: darkTextPrimary,
                fontSize: 12.sp,
              ),
            ),
            backgroundColor: darkCardColor,
            duration: const Duration(seconds: 2),
          ),
        );
        
        // モーダルを閉じる
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Failed to delete all data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'データの削除に失敗しました',
              style: GoogleFonts.inter(
                color: darkTextPrimary,
                fontSize: 12.sp,
              ),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}