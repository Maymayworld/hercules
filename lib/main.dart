import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'main/app_theme.dart';
import 'main/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: 'https://xxxxx',
      anonKey: 'XXXXX',
    );
  } catch (e) {
    print('Supabaseの初期化に失敗しました: $e');
    // TODO: エラーページに遷移など
  }

  runApp(
    ProviderScope(
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return const MyApp();
        },
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Hercules',
      theme: AppTheme.lightTheme,     // ← 必ずこれを確認
      darkTheme: AppTheme.darkTheme,  // ← 必ずこれを確認
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const Home(selectedNumber: 0),
    );
  }
}