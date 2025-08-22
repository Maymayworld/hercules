// pages/news/news_screen.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  // ニューモーフィック用の色定義
  static const Color neumorphicBackground = Color(0xFFE0E5EC);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: neumorphicBackground,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // アイコン
              Icon(
                Icons.newspaper,
                size: 80.sp,
                color: const Color(0xFF2C2C2E).withOpacity(0.6),
              ),
              
              SizedBox(height: 12.sp),
              
              // 開発中表示
              Text(
                '開発中',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 20.sp,
                  color: const Color(0xFF2C2C2E).withOpacity(0.5),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}