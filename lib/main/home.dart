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
      body: pages[currentIndex.value],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex.value,
        onTap: (index) => currentIndex.value = index,
        backgroundColor: const Color(0xFF2C2C2C), // ダークテーマ用の背景色
        selectedItemColor: Colors.red, // 選択されたアイテムの色
        unselectedItemColor: const Color(0xFFB0B0B0), // 未選択アイテムの色
        showSelectedLabels: false, // ラベルを非表示
        showUnselectedLabels: false, // ラベルを非表示
        elevation: 0, // 影を削除
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'プロフィール',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: '筋トレ図鑑',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'クエスト',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'ニュース',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'ショップ',
          ),
        ],
      ),
    );
  }
}