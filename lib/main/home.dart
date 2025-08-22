import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:ui';

// 各画面のインポート
import '../pages/profile/profile_screen.dart';
import '../pages/exercise/exercise_screen.dart';
import '../pages/quest/quest_screen.dart';
import '../pages/news/news_screen.dart';
import '../pages/shop/shop_screen.dart';

class Home extends HookConsumerWidget {
  final int selectedNumber;

  const Home({
    super.key,
    this.selectedNumber = 0, // デフォルトでプロフィール画面
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = useState<int>(selectedNumber);

    final pages = [
      const ProfileScreen(),     // index 0: プロフィール
      const ExerciseScreen(),    // index 1: 筋トレ図鑑
      const QuestScreen(),       // index 2: クエスト
      const NewsScreen(),        // index 3: 筋トレニュース
      const ShopScreen(),        // index 4: ショップ
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBody: true,
      body: pages[currentIndex.value],
      bottomNavigationBar: GlassBottomNavigationBar(
        currentIndex: currentIndex.value,
        onTap: (index) => currentIndex.value = index,
      ),
    );
  }
}

// ガラス効果ボトムナビゲーション
class GlassBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const GlassBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: 49,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFE0E5EC),
              // border: Border(
              //   top: BorderSide(
              //     color: Color(0xFF2C2C2E).withOpacity(0.7),
              //     width: 0.5,
              //   ),
              // ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildGlassNavItem(
                  context: context,
                  icon: Icons.person,
                  outlineIcon: Icons.person_outline,
                  index: 0,
                  isSelected: currentIndex == 0,
                ),
                _buildGlassNavItem(
                  context: context,
                  icon: Icons.fitness_center,
                  outlineIcon: Icons.fitness_center_outlined,
                  index: 1,
                  isSelected: currentIndex == 1,
                ),
                _buildGlassNavItem(
                  context: context,
                  icon: Icons.assignment,
                  outlineIcon: Icons.assignment_outlined,
                  index: 2,
                  isSelected: currentIndex == 2,
                ),
                _buildGlassNavItem(
                  context: context,
                  icon: Icons.newspaper,
                  outlineIcon: Icons.newspaper_outlined,
                  index: 3,
                  isSelected: currentIndex == 3,
                ),
                _buildGlassNavItem(
                  context: context,
                  icon: Icons.shopping_cart,
                  outlineIcon: Icons.shopping_cart_outlined,
                  index: 4,
                  isSelected: currentIndex == 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData outlineIcon,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            icon, // 常に同じアイコンを使用
            size: 24,
            color: isSelected ? Colors.red : const Color(0xFF2C2C2E).withOpacity(0.7), // テーマの色を使用
          ),
        ),
      ),
    );
  }
}