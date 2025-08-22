// pages/exercise/exercise_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'data/exercise_data.dart';
import 'widgets/exercise_tile_widget.dart';
import 'widgets/exercise_detail_sheet.dart';
import 'widgets/exercise_record_sheet.dart';
import 'widgets/result_dialog_widget.dart';
import '../../providers/recording_state_provider.dart';
import '../../providers/exercise_records_provider.dart';
import '../../providers/favorites_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class ExerciseScreen extends HookConsumerWidget {
  const ExerciseScreen({super.key});

  // ダークテーマ用の色定義
  static const Color darkBackground = Color(0xFF1C1C1C);
  static const Color darkCardColor = Color(0xFF2C2C2C);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);

  // 50音順でソートされたエクササイズリストを取得
  static List<Exercise> get sortedExercises {
    final exercises = List<Exercise>.from(ExerciseData.exercises);
    exercises.sort((a, b) => a.name.compareTo(b.name));
    return exercises;
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
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final selectedBodyParts = useState<Set<BodyPart>>(<BodyPart>{});
    final equipmentFilter = useState<bool?>(null); // null: 全て, true: 器具あり, false: 器具なし
    final favoritesFilter = useState<bool>(false); // お気に入りフィルター
    final filteredExercises = useState<List<Exercise>>(sortedExercises); // ソート済みリストで初期化
    
    // 記録モードの状態を監視
    final isRecording = ref.watch(recordingStateProvider);
    final exerciseRecords = ref.watch(exerciseRecordsProvider);
    final favorites = ref.watch(favoritesProvider);

    void updateFilteredExercises() {
      var filtered = ExerciseData.getFilteredExercises(
        searchQuery: searchController.text,
        selectedBodyParts: selectedBodyParts.value.isEmpty ? null : selectedBodyParts.value,
        equipmentFilter: equipmentFilter.value,
      );
      
      // お気に入りフィルターを適用
      if (favoritesFilter.value) {
        filtered = filtered.where((exercise) => favorites.contains(exercise.id)).toList();
      }
      
      // 変更可能なリストに変換してからソート
      var mutableFiltered = List<Exercise>.from(filtered);
      mutableFiltered.sort((a, b) => a.name.compareTo(b.name));
      filteredExercises.value = mutableFiltered;
    }

    void toggleBodyPartFilter(BodyPart bodyPart) {
      final newSet = Set<BodyPart>.from(selectedBodyParts.value);
      if (newSet.contains(bodyPart)) {
        newSet.remove(bodyPart);
      } else {
        newSet.add(bodyPart);
      }
      selectedBodyParts.value = newSet;
      updateFilteredExercises();
    }

    void toggleEquipmentFilter(bool? filter) {
      if (equipmentFilter.value == filter) {
        equipmentFilter.value = null; // 同じフィルターをタップした場合は解除
      } else {
        equipmentFilter.value = filter;
      }
      updateFilteredExercises();
    }

    void toggleFavoritesFilter() {
      favoritesFilter.value = !favoritesFilter.value;
      updateFilteredExercises();
    }

    void clearAllFilters() {
      selectedBodyParts.value = <BodyPart>{};
      equipmentFilter.value = null;
      favoritesFilter.value = false;
      searchController.clear();
      filteredExercises.value = sortedExercises; // ソート済みの全リストに戻す
    }

    useEffect(() {
      void listener() => updateFilteredExercises();
      searchController.addListener(listener);
      return () => searchController.removeListener(listener);
    }, [searchController]);

    // お気に入りの変更を監視
    useEffect(() {
      updateFilteredExercises();
      return null;
    }, [favorites]);

    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: darkBackground,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // 検索バー
                Container(
                  padding: EdgeInsets.only(top: 16.sp, bottom: 4.sp, right: 16.sp, left: 16.sp),
                  child: Container(
                    decoration: darkInputDecoration,
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: '種目名で検索...',
                        hintStyle: GoogleFonts.inter(
                          color: darkTextSecondary,
                          fontSize: 14.sp,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: darkTextSecondary,
                          size: 20.sp,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.sp,
                          vertical: 12.sp,
                        ),
                      ),
                      style: GoogleFonts.inter(
                        color: darkTextPrimary,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),

                // フィルターチップ
                SizedBox(
                  height: 60.sp,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(width: 16.sp), // 左側の余白
                        
                        // 全て表示チップ
                        _buildFilterChip(
                          context: context,
                          label: '全て',
                          isSelected: selectedBodyParts.value.isEmpty && 
                                     equipmentFilter.value == null && 
                                     !favoritesFilter.value,
                          onTap: clearAllFilters,
                          isAllChip: true,
                        ),
                        SizedBox(width: 8.sp),
                        
                        // 自重チップ
                        _buildFilterChip(
                          context: context,
                          label: '自重',
                          isSelected: equipmentFilter.value == false,
                          onTap: () => toggleEquipmentFilter(false),
                          isEquipmentChip: true,
                          equipmentType: false,
                        ),
                        SizedBox(width: 8.sp),
                        
                        // 器具チップ
                        _buildFilterChip(
                          context: context,
                          label: '器具',
                          isSelected: equipmentFilter.value == true,
                          onTap: () => toggleEquipmentFilter(true),
                          isEquipmentChip: true,
                          equipmentType: true,
                        ),
                        SizedBox(width: 8.sp),
                        
                        // 各部位チップ
                        ...BodyPart.values.map((bodyPart) => Padding(
                          padding: EdgeInsets.only(right: 8.sp),
                          child: _buildFilterChip(
                            context: context,
                            label: bodyPart.displayName,
                            isSelected: selectedBodyParts.value.contains(bodyPart),
                            onTap: () => toggleBodyPartFilter(bodyPart),
                            bodyPart: bodyPart,
                          ),
                        )),
                        
                        // お気に入りチップ（一番右）
                        _buildFilterChip(
                          context: context,
                          label: '', // テキストなし
                          isSelected: favoritesFilter.value,
                          onTap: toggleFavoritesFilter,
                          isFavoritesChip: true,
                        ),
                        
                        SizedBox(width: 16.sp), // 右側の余白
                      ],
                    ),
                  ),
                ),

                // 結果表示
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.sp),
                  child: Row(
                    children: [
                      Text(
                        '${filteredExercises.value.length}件',
                        style: GoogleFonts.inter(
                          color: Colors.red,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      if (selectedBodyParts.value.isNotEmpty || equipmentFilter.value != null || favoritesFilter.value)
                        Expanded(
                          flex: 3,
                          child: Text(
                            _buildFilterStatusText(selectedBodyParts.value, equipmentFilter.value, favoritesFilter.value),
                            style: GoogleFonts.inter(
                              color: Colors.red,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.right,
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: 8.sp),

                // 種目リスト
                Expanded(
                  child: Container(
                    color: darkBackground, // 背景色を統一
                    child: filteredExercises.value.isEmpty
                        ? _buildEmptyState(context, clearAllFilters)
                        : ListView.builder(
                            padding: EdgeInsets.zero, // 上部余白を削除
                            itemCount: filteredExercises.value.length,
                            itemBuilder: (context, index) {
                              final exercise = filteredExercises.value[index];
                              return ExerciseTileWidget(
                                exercise: exercise,
                                onTap: () => _handleExerciseTap(context, ref, exercise),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
            
            // アニメーションFAB
            _buildAnimatedFAB(context, ref, isRecording, exerciseRecords),
          ],
        ),
      ),
    );
  }

  String _buildFilterStatusText(Set<BodyPart> selectedBodyParts, bool? equipmentFilter, bool favoritesFilter) {
    List<String> filters = [];
    
    if (favoritesFilter) {
      filters.add('お気に入り');
    }
    
    if (equipmentFilter != null) {
      filters.add(equipmentFilter ? '器具' : '自重');
    }
    
    if (selectedBodyParts.isNotEmpty) {
      filters.add(selectedBodyParts.map((e) => e.displayName).join('・'));
    }
    
    return '${filters.join('・')} でフィルタリング中';
  }

  Widget _buildAnimatedFAB(
    BuildContext context, 
    WidgetRef ref, 
    bool isRecording, 
    Map<int, ExerciseRecord> exerciseRecords
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final expandedWidth = screenWidth - 32.sp; // 左右16.spずつの余白
    final hasRecords = exerciseRecords.isNotEmpty;
    
    return Positioned(
      bottom: 16.sp, // 位置をさらに下に変更
      right: 16.sp,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: isRecording ? expandedWidth : 48.sp, // 56.sp → 48.spに変更
        height: 48.sp, // 56.sp → 48.spに変更
        child: isRecording
          ? FloatingActionButton.extended(
              onPressed: () => _handleFABPress(context, ref, isRecording, exerciseRecords),
              backgroundColor: hasRecords ? Colors.red : darkTextSecondary,
              foregroundColor: hasRecords ? Colors.white : darkBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.sp), // 28.sp → 24.spに変更
              ),
              label: Text(
                hasRecords ? '記録完了' : 'エクササイズを選択してください',
                style: GoogleFonts.inter(
                  fontSize: 14.sp, // 16.sp → 14.spに変更
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            )
          : FloatingActionButton(
              onPressed: () => _handleFABPress(context, ref, isRecording, exerciseRecords),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.sp), // 28.sp → 24.spに変更
              ),
              child: Icon(
                Icons.fitness_center,
                size: 24.sp, // 28.sp → 24.spに変更
              ),
            ),
      ),
    );
  }

Widget _buildFilterChip({
  required BuildContext context,
  required String label,
  required bool isSelected,
  required VoidCallback onTap,
  BodyPart? bodyPart,
  bool isAllChip = false,
  bool isEquipmentChip = false,
  bool isFavoritesChip = false,
  bool? equipmentType, // true: 器具あり, false: 器具なし
}) {
  IconData chipIcon;
  
  if (isAllChip) {
    chipIcon = Icons.apps; // 元のままのアイコン
  } else if (isFavoritesChip) {
    chipIcon = Icons.favorite; // お気に入りアイコン
  } else if (isEquipmentChip) {
    chipIcon = equipmentType == true ? Icons.fitness_center : Icons.accessibility; // ダンベル・自重忍者
  } else if (bodyPart != null) {
    // 部位別のアイコン（全て統一：ハートに心拍数）
    switch (bodyPart) {
      case BodyPart.arm:
        chipIcon = Icons.bolt;
        break;
      case BodyPart.chest:
        chipIcon = Icons.bolt;
        break;
      case BodyPart.shoulder:
        chipIcon = Icons.bolt;
        break;
      case BodyPart.abs:
        chipIcon = Icons.bolt;
        break;
      case BodyPart.back:
        chipIcon = Icons.bolt;
        break;
      case BodyPart.leg:
        chipIcon = Icons.bolt;
        break;
      default:
        chipIcon = Icons.fitness_center;
    }
  } else {
    chipIcon = Icons.fitness_center; // デフォルト
  }

  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 60.sp, // 固定幅で統一
      padding: EdgeInsets.symmetric(
        horizontal: 6.sp,
        vertical: 8.sp,
      ),
      decoration: BoxDecoration(
        color: isSelected ? Colors.red.withOpacity(0.2) : darkCardColor,
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(
          color: isSelected ? Colors.red : darkTextSecondary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // アイコンを常に表示（左側）
          Icon(
            chipIcon,
            size: 14.sp,
            color: isSelected 
              ? Colors.red
              : darkTextSecondary,
          ),
          if (label.isNotEmpty) ...[
            SizedBox(width: 2.sp),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: isSelected 
                    ? Colors.red
                    : darkTextSecondary,
                  fontSize: 11.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

  Widget _buildEmptyState(BuildContext context, VoidCallback clearAllFilters) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 48.sp,
            color: darkTextSecondary,
          ),
          SizedBox(height: 16.sp),
          Text(
            '検索条件に一致する種目が見つかりません',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: darkTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.sp),
          TextButton(
            onPressed: clearAllFilters,
            child: Text(
              'フィルターをクリア',
              style: GoogleFonts.inter(
                color: Colors.red,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleExerciseTap(BuildContext context, WidgetRef ref, Exercise exercise) {
    final isRecording = ref.read(recordingStateProvider);
    
    if (isRecording) {
      // 記録モード：RecordSheetを表示
      _showExerciseRecord(context, exercise);
    } else {
      // 通常モード：DetailSheetを表示
      _showExerciseDetail(context, exercise);
    }
  }

  void _handleFABPress(
    BuildContext context, 
    WidgetRef ref, 
    bool isRecording, 
    Map<int, ExerciseRecord> exerciseRecords
  ) {
    if (isRecording) {
      if (exerciseRecords.isNotEmpty) {
        // 記録完了処理
        _completeRecording(context, ref, exerciseRecords);
      } else {
        // 記録がない場合は記録モードを終了
        ref.read(recordingStateProvider.notifier).stopRecording();
      }
    } else {
      // 記録モード開始
      ref.read(recordingStateProvider.notifier).startRecording();
    }
  }

  void _showExerciseDetail(BuildContext context, Exercise exercise) {
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

  void _showExerciseRecord(BuildContext context, Exercise exercise) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4, // 高さを低く変更
        minChildSize: 0.3,
        maxChildSize: 0.4,
        builder: (context, scrollController) => ExerciseRecordSheet(
          exercise: exercise,
        ),
      ),
    );
  }

  void _completeRecording(
    BuildContext context, 
    WidgetRef ref, 
    Map<int, ExerciseRecord> exerciseRecords
  ) {
    // 記録完了ダイアログを表示
    showDialog(
      context: context,
      builder: (context) => ResultDialogWidget(
        exerciseRecords: exerciseRecords,
        onComplete: () {
          // 記録をクリアして記録モードを終了
          ref.read(exerciseRecordsProvider.notifier).clearAllRecords();
          ref.read(recordingStateProvider.notifier).stopRecording();
        },
      ),
    );
  }
}