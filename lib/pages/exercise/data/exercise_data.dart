// pages/exercise/data/exercise_data.dart
import 'package:flutter/material.dart';

enum BodyPart {
  arm('腕', Icons.fitness_center, Color(0xFFFF8C00)), // 濃いオレンジ
  chest('胸', Icons.fitness_center, Color(0xFFDC143C)), // 濃い赤
  shoulder('肩', Icons.fitness_center, Color(0xFF228B22)), // 濃い緑
  abs('腹筋', Icons.fitness_center, Color(0xFFFF1493)), // 濃いピンク
  back('背筋', Icons.fitness_center, Color(0xFF9932CC)), // 濃い紫
  leg('脚', Icons.fitness_center, Color(0xFF0066CC)); // 濃い青

  const BodyPart(this.displayName, this.icon, this.color);
  final String displayName;
  final IconData icon;
  final Color color;
}

class Exercise {
  final int id;
  final String name;
  final BodyPart mainBodyPart;
  final List<String> detailedTargetParts; // より詳細な部位名
  final int intensityLevel; // 1-10
  final String description;
  final Duration? duration; // プランクなどの時間系種目用
  final bool isTimeBasedExercise; // 時間基準か回数基準か
  final bool requiresEquipment; // 器具が必要かどうか
  final String? equipment; // 必要な器具名

  const Exercise({
    required this.id,
    required this.name,
    required this.mainBodyPart,
    required this.detailedTargetParts,
    required this.intensityLevel,
    required this.description,
    this.duration,
    this.isTimeBasedExercise = false,
    this.requiresEquipment = false,
    this.equipment,
  });
}

class ExerciseData {
  static const List<Exercise> exercises = [
    // ID: 1
    Exercise(
      id: 1,
      name: 'プッシュアップ',
      mainBodyPart: BodyPart.arm,
      detailedTargetParts: ['上腕三頭筋', '大胸筋', '三角筋前部'],
      intensityLevel: 5,
      description: '基本的な腕立て伏せ。胸と腕を鍛える基礎種目',
      requiresEquipment: false,
    ),
    // ID: 2
    Exercise(
      id: 2,
      name: 'ダイヤモンドプッシュアップ',
      mainBodyPart: BodyPart.arm,
      detailedTargetParts: ['上腕三頭筋', '大胸筋内側', '三角筋前部'],
      intensityLevel: 8,
      description: '手をダイヤモンド型に組んで行う高強度プッシュアップ',
      requiresEquipment: false,
    ),
    // ID: 3
    Exercise(
      id: 3,
      name: 'パイクプッシュアップ',
      mainBodyPart: BodyPart.shoulder,
      detailedTargetParts: ['三角筋', '上腕三頭筋', '僧帽筋'],
      intensityLevel: 7,
      description: 'お尻を高く上げて肩周りを重点的に鍛えるプッシュアップ',
      requiresEquipment: false,
    ),
    // ID: 4
    Exercise(
      id: 4,
      name: 'ワイドプッシュアップ',
      mainBodyPart: BodyPart.chest,
      detailedTargetParts: ['大胸筋', '三角筋前部', '上腕三頭筋'],
      intensityLevel: 6,
      description: '手幅を広げて胸筋を重点的に鍛えるプッシュアップ',
      requiresEquipment: false,
    ),
    // ID: 5
    Exercise(
      id: 5,
      name: 'インクラインプッシュアップ',
      mainBodyPart: BodyPart.chest,
      detailedTargetParts: ['大胸筋下部', '三角筋前部', '上腕三頭筋'],
      intensityLevel: 3,
      description: '台を使って角度をつけた初心者向けプッシュアップ',
      requiresEquipment: false,
    ),
    // ID: 6
    Exercise(
      id: 6,
      name: 'プランク',
      mainBodyPart: BodyPart.abs,
      detailedTargetParts: ['腹直筋', '腹横筋', '脊柱起立筋'],
      intensityLevel: 4,
      description: '体幹を鍛える基本的な静的エクササイズ',
      duration: Duration(seconds: 60),
      isTimeBasedExercise: true,
      requiresEquipment: false,
    ),
    // ID: 7
    Exercise(
      id: 7,
      name: 'クランチ',
      mainBodyPart: BodyPart.abs,
      detailedTargetParts: ['腹直筋上部', '腹横筋', '内腹斜筋'],
      intensityLevel: 4,
      description: '腹筋の上部を重点的に鍛える基本種目',
      requiresEquipment: false,
    ),
    // ID: 8
    Exercise(
      id: 8,
      name: 'マウンテンクライマー',
      mainBodyPart: BodyPart.abs,
      detailedTargetParts: ['腹直筋', '腹斜筋', '腸腰筋'],
      intensityLevel: 6,
      description: '腹筋と有酸素効果を同時に得られる動的エクササイズ',
      requiresEquipment: false,
    ),
    // ID: 9
    Exercise(
      id: 9,
      name: 'レッグレイズ',
      mainBodyPart: BodyPart.abs,
      detailedTargetParts: ['腹直筋下部', '腸腰筋', '大腿直筋'],
      intensityLevel: 5,
      description: '腹筋の下部を重点的に鍛えるエクササイズ',
      requiresEquipment: false,
    ),
    // ID: 10
    Exercise(
      id: 10,
      name: 'バックエクステンション',
      mainBodyPart: BodyPart.back,
      detailedTargetParts: ['脊柱起立筋', '広背筋', '僧帽筋'],
      intensityLevel: 4,
      description: 'うつ伏せで背中を反らせて背筋を鍛える基本種目',
      requiresEquipment: false,
    ),
    // ID: 11
    Exercise(
      id: 11,
      name: 'リバースプランク',
      mainBodyPart: BodyPart.back,
      detailedTargetParts: ['脊柱起立筋', '大殿筋', 'ハムストリング'],
      intensityLevel: 6,
      description: '仰向けで体を支える背筋と体幹のエクササイズ',
      duration: Duration(seconds: 45),
      isTimeBasedExercise: true,
      requiresEquipment: false,
    ),
    // ID: 12
    Exercise(
      id: 12,
      name: 'スクワット',
      mainBodyPart: BodyPart.leg,
      detailedTargetParts: ['大腿四頭筋', '大殿筋', 'ハムストリング'],
      intensityLevel: 5,
      description: '下半身全体を鍛える基本的なエクササイズ',
      requiresEquipment: false,
    ),
    // ID: 13
    Exercise(
      id: 13,
      name: 'ランジ',
      mainBodyPart: BodyPart.leg,
      detailedTargetParts: ['大腿四頭筋', '大殿筋', '中殿筋'],
      intensityLevel: 6,
      description: '片足ずつ前に出して行う下半身強化エクササイズ',
      requiresEquipment: false,
    ),
    // ID: 14
    Exercise(
      id: 14,
      name: 'カーフレイズ',
      mainBodyPart: BodyPart.leg,
      detailedTargetParts: ['腓腹筋', 'ヒラメ筋', '前脛骨筋'],
      intensityLevel: 3,
      description: 'ふくらはぎを重点的に鍛えるエクササイズ',
      requiresEquipment: false,
    ),
    // ID: 15
    Exercise(
      id: 15,
      name: 'ジャンプスクワット',
      mainBodyPart: BodyPart.leg,
      detailedTargetParts: ['大腿四頭筋', '大殿筋', '下腿三頭筋'],
      intensityLevel: 7,
      description: 'ジャンプを加えた高強度スクワット',
      requiresEquipment: false,
    ),
    // ID: 16
    Exercise(
      id: 16,
      name: 'バーピー',
      mainBodyPart: BodyPart.shoulder,
      detailedTargetParts: ['全身筋肉', '三角筋', '協調性'],
      intensityLevel: 9,
      description: '全身を使った高強度有酸素エクササイズ',
      requiresEquipment: false,
    ),
    // ID: 17
    Exercise(
      id: 17,
      name: 'ジャンピングジャック',
      mainBodyPart: BodyPart.shoulder,
      detailedTargetParts: ['三角筋', '下腿三頭筋', '体幹'],
      intensityLevel: 5,
      description: '跳びはねて手足を開閉する有酸素エクササイズ',
      requiresEquipment: false,
    ),
    // ID: 18
    Exercise(
      id: 18,
      name: 'ナロープッシュアップ',
      mainBodyPart: BodyPart.arm,
      detailedTargetParts: ['上腕三頭筋', '大胸筋内側'],
      intensityLevel: 6,
      description: '手幅を狭くして上腕三頭筋を重点的に鍛える',
      requiresEquipment: false,
    ),
    // ID: 19
    Exercise(
      id: 19,
      name: 'デクラインプッシュアップ',
      mainBodyPart: BodyPart.arm,
      detailedTargetParts: ['上腕三頭筋', '大胸筋上部', '三角筋前部'],
      intensityLevel: 7,
      description: '足を台に上げて行う高強度プッシュアップ',
      requiresEquipment: false,
    ),
    // ID: 20
    Exercise(
      id: 20,
      name: 'ダンベルカール',
      mainBodyPart: BodyPart.arm,
      detailedTargetParts: ['上腕二頭筋', '前腕筋群'],
      intensityLevel: 5,
      description: 'ダンベルを使った基本的な上腕二頭筋トレーニング',
      requiresEquipment: true,
      equipment: 'ダンベル',
    ),
    // ID: 21
    Exercise(
      id: 21,
      name: 'トライセップスエクステンション',
      mainBodyPart: BodyPart.arm,
      detailedTargetParts: ['上腕三頭筋'],
      intensityLevel: 6,
      description: 'ダンベルを使って上腕三頭筋を集中的に鍛える',
      requiresEquipment: true,
      equipment: 'ダンベル',
    ),
    // ID: 22
    Exercise(
      id: 22,
      name: 'ハンマーカール',
      mainBodyPart: BodyPart.arm,
      detailedTargetParts: ['上腕二頭筋', '上腕筋', '前腕筋群'],
      intensityLevel: 5,
      description: 'ダンベルを縦に持って行うカール',
      requiresEquipment: true,
      equipment: 'ダンベル',
    ),
    // ID: 23
    Exercise(
      id: 23,
      name: 'ダンベルベンチプレス',
      mainBodyPart: BodyPart.chest,
      detailedTargetParts: ['大胸筋', '三角筋前部', '上腕三頭筋'],
      intensityLevel: 7,
      description: 'ダンベルを使った胸筋の基本種目',
      requiresEquipment: true,
      equipment: 'ダンベル・ベンチ',
    ),
    // ID: 24
    Exercise(
      id: 24,
      name: 'ダンベルフライ',
      mainBodyPart: BodyPart.chest,
      detailedTargetParts: ['大胸筋', '小胸筋'],
      intensityLevel: 6,
      description: '胸筋のストレッチを重視したアイソレーション種目',
      requiresEquipment: true,
      equipment: 'ダンベル・ベンチ',
    ),
    // ID: 25
    Exercise(
      id: 25,
      name: 'インクラインダンベルプレス',
      mainBodyPart: BodyPart.chest,
      detailedTargetParts: ['大胸筋上部', '三角筋前部'],
      intensityLevel: 7,
      description: 'インクラインベンチで大胸筋上部を重点的に鍛える',
      requiresEquipment: true,
      equipment: 'ダンベル・インクラインベンチ',
    ),
    // ID: 26
    Exercise(
      id: 26,
      name: 'ショルダープレス',
      mainBodyPart: BodyPart.shoulder,
      detailedTargetParts: ['三角筋', '僧帽筋', '上腕三頭筋'],
      intensityLevel: 6,
      description: 'ダンベルを使った肩の基本種目',
      requiresEquipment: true,
      equipment: 'ダンベル',
    ),
    // ID: 27
    Exercise(
      id: 27,
      name: 'サイドレイズ',
      mainBodyPart: BodyPart.shoulder,
      detailedTargetParts: ['三角筋中部'],
      intensityLevel: 4,
      description: '三角筋中部を集中的に鍛えるアイソレーション種目',
      requiresEquipment: true,
      equipment: 'ダンベル',
    ),
    // ID: 28
    Exercise(
      id: 28,
      name: 'フロントレイズ',
      mainBodyPart: BodyPart.shoulder,
      detailedTargetParts: ['三角筋前部'],
      intensityLevel: 4,
      description: '三角筋前部を集中的に鍛える',
      requiresEquipment: true,
      equipment: 'ダンベル',
    ),
    // ID: 29
    Exercise(
      id: 29,
      name: 'リアデルトフライ',
      mainBodyPart: BodyPart.shoulder,
      detailedTargetParts: ['三角筋後部', '僧帽筋中部'],
      intensityLevel: 5,
      description: '三角筋後部を重点的に鍛える',
      requiresEquipment: true,
      equipment: 'ダンベル',
    ),
    // ID: 30
    Exercise(
      id: 30,
      name: 'サイドプランク',
      mainBodyPart: BodyPart.abs,
      detailedTargetParts: ['腹斜筋', '腹横筋', '中殿筋'],
      intensityLevel: 5,
      description: '体側の筋肉を鍛える静的エクササイズ',
      duration: Duration(seconds: 45),
      isTimeBasedExercise: true,
      requiresEquipment: false,
    ),
    // ID: 31
    Exercise(
      id: 31,
      name: 'バイシクルクランチ',
      mainBodyPart: BodyPart.abs,
      detailedTargetParts: ['腹直筋', '腹斜筋'],
      intensityLevel: 6,
      description: '自転車を漕ぐような動作で腹筋を鍛える',
      requiresEquipment: false,
    ),
    // ID: 32
    Exercise(
      id: 32,
      name: 'ニートゥエルボー',
      mainBodyPart: BodyPart.abs,
      detailedTargetParts: ['腹直筋', '腹斜筋', '腸腰筋'],
      intensityLevel: 5,
      description: '膝と肘を交互にタッチする動的エクササイズ',
      requiresEquipment: false,
    ),
    // ID: 33
    Exercise(
      id: 33,
      name: 'ダンベルクランチ',
      mainBodyPart: BodyPart.abs,
      detailedTargetParts: ['腹直筋上部'],
      intensityLevel: 6,
      description: 'ダンベルを持って行う高負荷クランチ',
      requiresEquipment: true,
      equipment: 'ダンベル',
    ),
    // ID: 34
    Exercise(
      id: 34,
      name: 'ロシアンツイスト',
      mainBodyPart: BodyPart.abs,
      detailedTargetParts: ['腹斜筋', '腹直筋'],
      intensityLevel: 5,
      description: 'ダンベルを持って体幹をツイストする',
      requiresEquipment: true,
      equipment: 'ダンベル',
    ),
    // ID: 35
    Exercise(
      id: 35,
      name: 'スーパーマン',
      mainBodyPart: BodyPart.back,
      detailedTargetParts: ['脊柱起立筋', '大殿筋', 'ハムストリング'],
      intensityLevel: 5,
      description: '両手足を同時に上げる背筋強化エクササイズ',
      requiresEquipment: false,
    ),
    // ID: 36
    Exercise(
      id: 36,
      name: 'ワンハンドローイング',
      mainBodyPart: BodyPart.back,
      detailedTargetParts: ['広背筋', '僧帽筋', '上腕二頭筋'],
      intensityLevel: 6,
      description: '片手でダンベルを引く背筋の基本種目',
      requiresEquipment: true,
      equipment: 'ダンベル・ベンチ',
    ),
    // ID: 37
    Exercise(
      id: 37,
      name: 'ベントオーバーロウ',
      mainBodyPart: BodyPart.back,
      detailedTargetParts: ['広背筋', '僧帽筋', '後部三角筋'],
      intensityLevel: 7,
      description: '前傾姿勢でダンベルを引く複合種目',
      requiresEquipment: true,
      equipment: 'ダンベル',
    ),
    // ID: 38
    Exercise(
      id: 38,
      name: 'デッドリフト',
      mainBodyPart: BodyPart.back,
      detailedTargetParts: ['脊柱起立筋', '広背筋', '大殿筋', 'ハムストリング'],
      intensityLevel: 9,
      description: '背筋と脚を同時に鍛える高強度複合種目',
      requiresEquipment: true,
      equipment: 'ダンベル',
    ),
    // ID: 39
    Exercise(
      id: 39,
      name: 'サイドランジ',
      mainBodyPart: BodyPart.leg,
      detailedTargetParts: ['大腿四頭筋', '中殿筋', '内転筋群'],
      intensityLevel: 5,
      description: '横方向への動きで内転筋も鍛える',
      requiresEquipment: false,
    ),
    // ID: 40
    Exercise(
      id: 40,
      name: 'シングルレッグスクワット',
      mainBodyPart: BodyPart.leg,
      detailedTargetParts: ['大腿四頭筋', '大殿筋', '中殿筋'],
      intensityLevel: 9,
      description: '片足で行う高難度スクワット',
      requiresEquipment: false,
    ),
    // ID: 41
    Exercise(
      id: 41,
      name: 'ウォールシット',
      mainBodyPart: BodyPart.leg,
      detailedTargetParts: ['大腿四頭筋', '大殿筋'],
      intensityLevel: 6,
      description: '壁に背をつけて座る姿勢をキープする',
      duration: Duration(seconds: 60),
      isTimeBasedExercise: true,
      requiresEquipment: false,
    ),
    // ID: 42
    Exercise(
      id: 42,
      name: 'ダンベルスクワット',
      mainBodyPart: BodyPart.leg,
      detailedTargetParts: ['大腿四頭筋', '大殿筋', 'ハムストリング'],
      intensityLevel: 7,
      description: 'ダンベルを持って行う高負荷スクワット',
      requiresEquipment: true,
      equipment: 'ダンベル',
    ),
    // ID: 43
    Exercise(
      id: 43,
      name: 'ダンベルランジ',
      mainBodyPart: BodyPart.leg,
      detailedTargetParts: ['大腿四頭筋', '大殿筋', '中殿筋'],
      intensityLevel: 7,
      description: 'ダンベルを持って行う高負荷ランジ',
      requiresEquipment: true,
      equipment: 'ダンベル',
    ),
    // ID: 44
    Exercise(
      id: 44,
      name: 'ルーマニアンデッドリフト',
      mainBodyPart: BodyPart.leg,
      detailedTargetParts: ['ハムストリング', '大殿筋', '脊柱起立筋'],
      intensityLevel: 8,
      description: 'ハムストリングを重点的に鍛えるデッドリフト',
      requiresEquipment: true,
      equipment: 'ダンベル',
    ),
    // ID: 45
    Exercise(
      id: 45,
      name: 'ダンベルカーフレイズ',
      mainBodyPart: BodyPart.leg,
      detailedTargetParts: ['腓腹筋', 'ヒラメ筋'],
      intensityLevel: 5,
      description: 'ダンベルを持って行う高負荷カーフレイズ',
      requiresEquipment: true,
      equipment: 'ダンベル',
    ),
    // ID: 46
    Exercise(
      id: 46,
      name: 'ダンベルスラスター',
      mainBodyPart: BodyPart.shoulder,
      detailedTargetParts: ['三角筋', '大腿四頭筋', '大殿筋', '上腕三頭筋'],
      intensityLevel: 8,
      description: 'スクワットからショルダープレスまでの複合動作',
      requiresEquipment: true,
      equipment: 'ダンベル',
    ),
    // ID: 47
    Exercise(
      id: 47,
      name: 'ダンベルクリーン',
      mainBodyPart: BodyPart.back,
      detailedTargetParts: ['広背筋', '僧帽筋', '大腿四頭筋', '大殿筋'],
      intensityLevel: 9,
      description: '床からダンベルを肩まで一気に引き上げる',
      requiresEquipment: true,
      equipment: 'ダンベル',
    ),
    // ここ以降も補完
        // ID: 48
    Exercise(
      id: 48,
      name: 'プルアップ',
      mainBodyPart: BodyPart.back,
      detailedTargetParts: ['広背筋', '上腕二頭筋', '僧帽筋'],
      intensityLevel: 8,
      description: '懸垂バーを使った背筋の基本種目',
      requiresEquipment: true,
      equipment: '懸垂バー',
    ),
    // ID: 49
    Exercise(
      id: 49,
      name: 'トライセプスディップス',
      mainBodyPart: BodyPart.arm,
      detailedTargetParts: ['上腕三頭筋', '三角筋前部'],
      intensityLevel: 7,
      description: '椅子や台を使った上腕三頭筋の集中トレーニング',
      requiresEquipment: false,
    ),
    // ID: 50
    Exercise(
      id: 50,
      name: 'ディップス',
      mainBodyPart: BodyPart.chest,
      detailedTargetParts: ['大胸筋下部', '上腕三頭筋', '三角筋前部'],
      intensityLevel: 8,
      description: '平行棒を使った胸筋下部の高強度トレーニング',
      requiresEquipment: true,
      equipment: '平行棒・ディップスタンド',
    ),
    // ID: 51
    Exercise(
      id: 51,
      name: 'ヒールタッチ',
      mainBodyPart: BodyPart.abs,
      detailedTargetParts: ['腹斜筋', '腹直筋'],
      intensityLevel: 4,
      description: '仰向けで左右のかかとを交互にタッチする腹斜筋運動',
      requiresEquipment: false,
    ),
    // ID: 52
    Exercise(
      id: 52,
      name: 'Vアップ',
      mainBodyPart: BodyPart.abs,
      detailedTargetParts: ['腹直筋', '腸腰筋'],
      intensityLevel: 7,
      description: '手足を同時に上げてV字を作る高強度腹筋運動',
      requiresEquipment: false,
    ),
    // ID: 53
    Exercise(
      id: 53,
      name: 'ダンベルVアップ',
      mainBodyPart: BodyPart.abs,
      detailedTargetParts: ['腹直筋', '腸腰筋'],
      intensityLevel: 8,
      description: 'ダンベルを持って行う高負荷Vアップ',
      requiresEquipment: true,
      equipment: 'ダンベル',
    ),
    // ID: 54
    Exercise(
      id: 54,
      name: 'チンアップ',
      mainBodyPart: BodyPart.arm,
      detailedTargetParts: ['上腕二頭筋', '広背筋', '僧帽筋'],
      intensityLevel: 8,
      description: '逆手で行う懸垂、上腕二頭筋を重点的に鍛える',
      requiresEquipment: true,
      equipment: '懸垂バー',
    ),
    // ID: 55
    Exercise(
      id: 55,
      name: 'ネガティブプルアップ',
      mainBodyPart: BodyPart.back,
      detailedTargetParts: ['広背筋', '上腕二頭筋', '僧帽筋'],
      intensityLevel: 6,
      description: '下降動作のみを行う懸垂の練習方法',
      requiresEquipment: true,
      equipment: '懸垂バー・踏み台',
    ),
    // ID: 56
    Exercise(
      id: 56,
      name: 'パイクウォーク',
      mainBodyPart: BodyPart.shoulder,
      detailedTargetParts: ['三角筋', '腹直筋', '脊柱起立筋'],
      intensityLevel: 6,
      description: 'パイク姿勢で手で歩く肩と体幹の複合運動',
      requiresEquipment: false,
    ),
    // ID: 57
    Exercise(
      id: 57,
      name: 'ベアクロール',
      mainBodyPart: BodyPart.shoulder,
      detailedTargetParts: ['三角筋', '腹直筋', '大腿四頭筋'],
      intensityLevel: 6,
      description: '四つん這いで膝を浮かせて這う全身運動',
      requiresEquipment: false,
    ),
    // ID: 58
    Exercise(
      id: 58,
      name: 'ダンベルプルオーバー',
      mainBodyPart: BodyPart.chest,
      detailedTargetParts: ['大胸筋', '広背筋', '前鋸筋'],
      intensityLevel: 6,
      description: '胸筋と広背筋を同時に鍛える複合種目',
      requiresEquipment: true,
      equipment: 'ダンベル・ベンチ',
    ),
    // ID: 59
    Exercise(
      id: 59,
      name: 'アーノルドプレス',
      mainBodyPart: BodyPart.shoulder,
      detailedTargetParts: ['三角筋', '上腕三頭筋'],
      intensityLevel: 7,
      description: '回転動作を加えた三角筋全体のトレーニング',
      requiresEquipment: true,
      equipment: 'ダンベル',
    ),
    // ID: 60
    Exercise(
      id: 60,
      name: 'ブルガリアンスプリットスクワット',
      mainBodyPart: BodyPart.leg,
      detailedTargetParts: ['大腿四頭筋', '大殿筋', '中殿筋'],
      intensityLevel: 8,
      description: '後ろ足を台に乗せた片足スクワット',
      requiresEquipment: false,
    ),
    // ID: 61
    Exercise(
      id: 61,
      name: 'シシースクワット',
      mainBodyPart: BodyPart.leg,
      detailedTargetParts: ['大腿四頭筋'],
      intensityLevel: 9,
      description: '体を後傾させる大腿四頭筋の高強度種目',
      requiresEquipment: false,
    ),
    // ID: 62
    Exercise(
      id: 62,
      name: 'グルートブリッジ',
      mainBodyPart: BodyPart.leg,
      detailedTargetParts: ['大殿筋', 'ハムストリング'],
      intensityLevel: 4,
      description: '仰向けでお尻を持ち上げる基本的な殿筋運動',
      requiresEquipment: false,
    ),
    // ID: 63
    Exercise(
      id: 63,
      name: 'ヒップスラスト',
      mainBodyPart: BodyPart.leg,
      detailedTargetParts: ['大殿筋', 'ハムストリング'],
      intensityLevel: 6,
      description: 'ベンチを使ったグルートブリッジの強化版',
      requiresEquipment: false,
    ),
    // ID: 64
    Exercise(
      id: 64,
      name: 'ダンベルヒップスラスト',
      mainBodyPart: BodyPart.leg,
      detailedTargetParts: ['大殿筋', 'ハムストリング'],
      intensityLevel: 7,
      description: 'ダンベルを使った高負荷ヒップスラスト',
      requiresEquipment: true,
      equipment: 'ダンベル・ベンチ',
    ),
    // ID: 65
    Exercise(
      id: 65,
      name: 'ダンベルステップアップ',
      mainBodyPart: BodyPart.leg,
      detailedTargetParts: ['大腿四頭筋', '大殿筋', '中殿筋'],
      intensityLevel: 6,
      description: 'ダンベルを持った台昇降運動',
      requiresEquipment: true,
      equipment: 'ダンベル・台',
    ),
    // ID: 66
    Exercise(
      id: 66,
      name: 'ゴブレットスクワット',
      mainBodyPart: BodyPart.leg,
      detailedTargetParts: ['大腿四頭筋', '大殿筋', 'ハムストリング'],
      intensityLevel: 6,
      description: 'ダンベルを胸の前で抱えて行うスクワット',
      requiresEquipment: true,
      equipment: 'ダンベル',
    ),
    // ID: 67
    Exercise(
      id: 67,
      name: 'ダンベルグッドモーニング',
      mainBodyPart: BodyPart.back,
      detailedTargetParts: ['脊柱起立筋', 'ハムストリング', '大殿筋'],
      intensityLevel: 7,
      description: 'ダンベルを肩に担いで行う前傾運動',
      requiresEquipment: true,
      equipment: 'ダンベル',
    ),
    // ID: 68
    Exercise(
      id: 68,
      name: 'プリーチャーカール',
      mainBodyPart: BodyPart.arm,
      detailedTargetParts: ['上腕二頭筋', '前腕筋群'],
      intensityLevel: 6,
      description: 'プリーチャーベンチを使った集中的なカール',
      requiresEquipment: true,
      equipment: 'ダンベル・プリーチャーベンチ',
    ),
    // ID: 69
    Exercise(
      id: 69,
      name: 'コンセントレーションカール',
      mainBodyPart: BodyPart.arm,
      detailedTargetParts: ['上腕二頭筋'],
      intensityLevel: 5,
      description: '座って肘を固定して行う集中カール',
      requiresEquipment: true,
      equipment: 'ダンベル',
    ),
    // ID: 70
    Exercise(
      id: 70,
      name: 'オーバーヘッドトライセプスエクステンション',
      mainBodyPart: BodyPart.arm,
      detailedTargetParts: ['上腕三頭筋'],
      intensityLevel: 6,
      description: '座って頭上で行う上腕三頭筋の種目',
      requiresEquipment: true,
      equipment: 'ダンベル',
    ),
    // ID: 71
    Exercise(
      id: 71,
      name: 'キックバック',
      mainBodyPart: BodyPart.arm,
      detailedTargetParts: ['上腕三頭筋'],
      intensityLevel: 5,
      description: '肘を固定して後方に蹴り上げる上腕三頭筋運動',
      requiresEquipment: true,
      equipment: 'ダンベル・ベンチ',
    ),
    // ID: 72
    Exercise(
      id: 72,
      name: 'アップライトロウ',
      mainBodyPart: BodyPart.shoulder,
      detailedTargetParts: ['三角筋', '僧帽筋'],
      intensityLevel: 5,
      description: 'ダンベルを縦に引き上げる肩と僧帽筋の運動',
      requiresEquipment: true,
      equipment: 'ダンベル',
    ),
    // ID: 73
    Exercise(
      id: 73,
      name: 'シュラッグ',
      mainBodyPart: BodyPart.back,
      detailedTargetParts: ['僧帽筋上部'],
      intensityLevel: 4,
      description: '肩をすくめて僧帽筋上部を鍛える',
      requiresEquipment: true,
      equipment: 'ダンベル',
    ),
    // ID: 74
    Exercise(
      id: 74,
      name: 'デッドバグ',
      mainBodyPart: BodyPart.abs,
      detailedTargetParts: ['腹直筋', '腹横筋', '脊柱起立筋'],
      intensityLevel: 5,
      description: '仰向けで対角の手足を動かす体幹安定運動',
      requiresEquipment: false,
    ),
    // ID: 75
    Exercise(
      id: 75,
      name: 'ハローアップ',
      mainBodyPart: BodyPart.abs,
      detailedTargetParts: ['腹直筋', '腹斜筋'],
      intensityLevel: 6,
      description: '円を描くように動かす腹筋の複合運動',
      requiresEquipment: false,
    ),
    // ID: 76
    Exercise(
      id: 76,
      name: 'バード・ドッグ',
      mainBodyPart: BodyPart.back,
      detailedTargetParts: ['脊柱起立筋', '大殿筋', '腹横筋'],
      intensityLevel: 4,
      description: '四つん這いで対角の手足を伸ばす体幹運動',
      requiresEquipment: false,
    ),
    // ID: 77
    Exercise(
      id: 77,
      name: 'ホローボディホールド',
      mainBodyPart: BodyPart.abs,
      detailedTargetParts: ['腹直筋', '腹横筋', '腸腰筋'],
      intensityLevel: 7,
      description: '体を船のような形にキープする静的腹筋運動',
      duration: Duration(seconds: 45),
      isTimeBasedExercise: true,
      requiresEquipment: false,
    ),
  ];

  // 各エクササイズの負荷データ（腕立て伏せを基準：腕2, 胸2）
  // 負荷レベル: 0-10の整数値
  static const Map<int, Map<String, int>> _exerciseLoadData = {
    1: { // プッシュアップ（基準）
      '腕': 2,
      '胸': 2,
      '肩': 0,
      '腹筋': 0,
      '背筋': 0,
      '脚': 0,
    },
    2: { // ダイヤモンドプッシュアップ
      '腕': 4,
      '胸': 1,
      '肩': 1,
      '腹筋': 1,
      '背筋': 0,
      '脚': 0,
    },
    3: { // パイクプッシュアップ
      '腕': 3,
      '胸': 1,
      '肩': 4,
      '腹筋': 2,
      '背筋': 1,
      '脚': 0,
    },
    4: { // ワイドプッシュアップ
      '腕': 1,
      '胸': 4,
      '肩': 1,
      '腹筋': 0,
      '背筋': 0,
      '脚': 0,
    },
    5: { // インクラインプッシュアップ
      '腕': 1,
      '胸': 2,
      '肩': 1,
      '腹筋': 0,
      '背筋': 0,
      '脚': 0,
    },
    6: { // プランク
      '腕': 1,
      '胸': 0,
      '肩': 1,
      '腹筋': 4,
      '背筋': 2,
      '脚': 0,
    },
    7: { // クランチ
      '腕': 0,
      '胸': 0,
      '肩': 0,
      '腹筋': 3,
      '背筋': 0,
      '脚': 0,
    },
    8: { // マウンテンクライマー
      '腕': 2,
      '胸': 1,
      '肩': 2,
      '腹筋': 3,
      '背筋': 1,
      '脚': 2,
    },
    9: { // レッグレイズ
      '腕': 0,
      '胸': 0,
      '肩': 0,
      '腹筋': 4,
      '背筋': 0,
      '脚': 1,
    },
    10: { // バックエクステンション
      '腕': 0,
      '胸': 0,
      '肩': 0,
      '腹筋': 0,
      '背筋': 3,
      '脚': 0,
    },
    11: { // リバースプランク
      '腕': 1,
      '胸': 0,
      '肩': 2,
      '腹筋': 2,
      '背筋': 4,
      '脚': 2,
    },
    12: { // スクワット
      '腕': 0,
      '胸': 0,
      '肩': 0,
      '腹筋': 1,
      '背筋': 1,
      '脚': 4,
    },
    13: { // ランジ
      '腕': 0,
      '胸': 0,
      '肩': 0,
      '腹筋': 2,
      '背筋': 1,
      '脚': 3,
    },
    14: { // カーフレイズ
      '腕': 0,
      '胸': 0,
      '肩': 0,
      '腹筋': 0,
      '背筋': 0,
      '脚': 2,
    },
    15: { // ジャンプスクワット
      '腕': 0,
      '胸': 0,
      '肩': 0,
      '腹筋': 2,
      '背筋': 1,
      '脚': 4,
    },
    16: { // バーピー
      '腕': 3,
      '胸': 2,
      '肩': 4,
      '腹筋': 3,
      '背筋': 1,
      '脚': 3,
    },
    17: { // ジャンピングジャック
      '腕': 1,
      '胸': 0,
      '肩': 2,
      '腹筋': 1,
      '背筋': 0,
      '脚': 2,
    },
    18: { // ナロープッシュアップ
      '腕': 3,
      '胸': 2,
      '肩': 1,
      '腹筋': 0,
      '背筋': 0,
      '脚': 0,
    },
    19: { // デクラインプッシュアップ
      '腕': 3,
      '胸': 3,
      '肩': 1,
      '腹筋': 1,
      '背筋': 0,
      '脚': 0,
    },
    20: { // ダンベルカール
      '腕': 4,
      '胸': 0,
      '肩': 0,
      '腹筋': 0,
      '背筋': 0,
      '脚': 0,
    },
    21: { // トライセップスエクステンション
      '腕': 5,
      '胸': 0,
      '肩': 1,
      '腹筋': 0,
      '背筋': 0,
      '脚': 0,
    },
    22: { // ハンマーカール
      '腕': 4,
      '胸': 0,
      '肩': 0,
      '腹筋': 0,
      '背筋': 0,
      '脚': 0,
    },
    23: { // ダンベルベンチプレス
      '腕': 3,
      '胸': 5,
      '肩': 2,
      '腹筋': 1,
      '背筋': 0,
      '脚': 0,
    },
    24: { // ダンベルフライ
      '腕': 1,
      '胸': 5,
      '肩': 1,
      '腹筋': 1,
      '背筋': 0,
      '脚': 0,
    },
    25: { // インクラインダンベルプレス
      '腕': 3,
      '胸': 5,
      '肩': 2,
      '腹筋': 1,
      '背筋': 0,
      '脚': 0,
    },
    26: { // ショルダープレス
      '腕': 2,
      '胸': 1,
      '肩': 5,
      '腹筋': 1,
      '背筋': 1,
      '脚': 0,
    },
    27: { // サイドレイズ
      '腕': 1,
      '胸': 0,
      '肩': 4,
      '腹筋': 1,
      '背筋': 0,
      '脚': 0,
    },
    28: { // フロントレイズ
      '腕': 1,
      '胸': 1,
      '肩': 3,
      '腹筋': 1,
      '背筋': 0,
      '脚': 0,
    },
    29: { // リアデルトフライ
      '腕': 1,
      '胸': 0,
      '肩': 4,
      '腹筋': 0,
      '背筋': 2,
      '脚': 0,
    },
    30: { // サイドプランク
      '腕': 1,
      '胸': 0,
      '肩': 2,
      '腹筋': 4,
      '背筋': 1,
      '脚': 1,
    },
    31: { // バイシクルクランチ
      '腕': 0,
      '胸': 0,
      '肩': 0,
      '腹筋': 4,
      '背筋': 0,
      '脚': 1,
    },
    32: { // ニートゥエルボー
      '腕': 1,
      '胸': 0,
      '肩': 1,
      '腹筋': 3,
      '背筋': 0,
      '脚': 2,
    },
    33: { // ダンベルクランチ
      '腕': 1,
      '胸': 0,
      '肩': 0,
      '腹筋': 4,
      '背筋': 0,
      '脚': 0,
    },
    34: { // ロシアンツイスト
      '腕': 1,
      '胸': 0,
      '肩': 1,
      '腹筋': 4,
      '背筋': 1,
      '脚': 0,
    },
    35: { // スーパーマン
      '腕': 0,
      '胸': 0,
      '肩': 1,
      '腹筋': 1,
      '背筋': 4,
      '脚': 1,
    },
    36: { // ワンハンドローイング
      '腕': 3,
      '胸': 0,
      '肩': 1,
      '腹筋': 1,
      '背筋': 5,
      '脚': 0,
    },
    37: { // ベントオーバーロウ
      '腕': 2,
      '胸': 0,
      '肩': 2,
      '腹筋': 2,
      '背筋': 4,
      '脚': 1,
    },
    38: { // デッドリフト
      '腕': 2,
      '胸': 0,
      '肩': 1,
      '腹筋': 2,
      '背筋': 5,
      '脚': 4,
    },
    39: { // サイドランジ
      '腕': 0,
      '胸': 0,
      '肩': 0,
      '腹筋': 2,
      '背筋': 1,
      '脚': 4,
    },
    40: { // シングルレッグスクワット
      '腕': 0,
      '胸': 0,
      '肩': 0,
      '腹筋': 3,
      '背筋': 1,
      '脚': 5,
    },
    41: { // ウォールシット
      '腕': 0,
      '胸': 0,
      '肩': 0,
      '腹筋': 1,
      '背筋': 1,
      '脚': 4,
    },
    42: { // ダンベルスクワット
      '腕': 1,
      '胸': 0,
      '肩': 1,
      '腹筋': 2,
      '背筋': 1,
      '脚': 5,
    },
    43: { // ダンベルランジ
      '腕': 1,
      '胸': 0,
      '肩': 1,
      '腹筋': 2,
      '背筋': 1,
      '脚': 4,
    },
    44: { // ルーマニアンデッドリフト
      '腕': 2,
      '胸': 0,
      '肩': 1,
      '腹筋': 2,
      '背筋': 4,
      '脚': 5,
    },
    45: { // ダンベルカーフレイズ
      '腕': 1,
      '胸': 0,
      '肩': 0,
      '腹筋': 0,
      '背筋': 0,
      '脚': 4,
    },
    46: { // ダンベルスラスター
      '腕': 3,
      '胸': 1,
      '肩': 5,
      '腹筋': 2,
      '背筋': 2,
      '脚': 4,
    },
    47: { // ダンベルクリーン
      '腕': 2,
      '胸': 1,
      '肩': 2,
      '腹筋': 3,
      '背筋': 5,
      '脚': 4,
    },
    // ここ以降も補完
        48: { // プルアップ
      '腕': 3,
      '胸': 1,
      '肩': 2,
      '腹筋': 2,
      '背筋': 5,
      '脚': 0,
    },
    49: { // トライセプスディップス
      '腕': 4,
      '胸': 1,
      '肩': 2,
      '腹筋': 1,
      '背筋': 0,
      '脚': 0,
    },
    50: { // ディップス
      '腕': 3,
      '胸': 4,
      '肩': 2,
      '腹筋': 1,
      '背筋': 0,
      '脚': 0,
    },
    51: { // ヒールタッチ
      '腕': 0,
      '胸': 0,
      '肩': 0,
      '腹筋': 3,
      '背筋': 0,
      '脚': 0,
    },
    52: { // Vアップ
      '腕': 1,
      '胸': 0,
      '肩': 0,
      '腹筋': 5,
      '背筋': 0,
      '脚': 2,
    },
    53: { // ダンベルVアップ
      '腕': 2,
      '胸': 0,
      '肩': 1,
      '腹筋': 5,
      '背筋': 0,
      '脚': 2,
    },
    54: { // チンアップ
      '腕': 4,
      '胸': 1,
      '肩': 2,
      '腹筋': 2,
      '背筋': 4,
      '脚': 0,
    },
    55: { // ネガティブプルアップ
      '腕': 3,
      '胸': 1,
      '肩': 2,
      '腹筋': 2,
      '背筋': 4,
      '脚': 0,
    },
    56: { // パイクウォーク
      '腕': 2,
      '胸': 1,
      '肩': 4,
      '腹筋': 3,
      '背筋': 1,
      '脚': 1,
    },
    57: { // ベアクロール
      '腕': 2,
      '胸': 1,
      '肩': 3,
      '腹筋': 3,
      '背筋': 2,
      '脚': 2,
    },
    58: { // ダンベルプルオーバー
      '腕': 2,
      '胸': 4,
      '肩': 1,
      '腹筋': 2,
      '背筋': 3,
      '脚': 0,
    },
    59: { // アーノルドプレス
      '腕': 2,
      '胸': 1,
      '肩': 5,
      '腹筋': 1,
      '背筋': 1,
      '脚': 0,
    },
    60: { // ブルガリアンスプリットスクワット
      '腕': 0,
      '胸': 0,
      '肩': 0,
      '腹筋': 3,
      '背筋': 1,
      '脚': 5,
    },
    61: { // シシースクワット
      '腕': 0,
      '胸': 0,
      '肩': 0,
      '腹筋': 2,
      '背筋': 1,
      '脚': 5,
    },
    62: { // グルートブリッジ
      '腕': 0,
      '胸': 0,
      '肩': 0,
      '腹筋': 1,
      '背筋': 1,
      '脚': 3,
    },
    63: { // ヒップスラスト
      '腕': 0,
      '胸': 0,
      '肩': 1,
      '腹筋': 2,
      '背筋': 1,
      '脚': 4,
    },
    64: { // ダンベルヒップスラスト
      '腕': 1,
      '胸': 0,
      '肩': 1,
      '腹筋': 2,
      '背筋': 1,
      '脚': 5,
    },
    65: { // ダンベルステップアップ
      '腕': 1,
      '胸': 0,
      '肩': 1,
      '腹筋': 2,
      '背筋': 1,
      '脚': 4,
    },
    66: { // ゴブレットスクワット
      '腕': 2,
      '胸': 0,
      '肩': 1,
      '腹筋': 2,
      '背筋': 1,
      '脚': 4,
    },
    67: { // ダンベルグッドモーニング
      '腕': 1,
      '胸': 0,
      '肩': 1,
      '腹筋': 2,
      '背筋': 4,
      '脚': 3,
    },
    68: { // プリーチャーカール
      '腕': 5,
      '胸': 0,
      '肩': 0,
      '腹筋': 0,
      '背筋': 0,
      '脚': 0,
    },
    69: { // コンセントレーションカール
      '腕': 4,
      '胸': 0,
      '肩': 0,
      '腹筋': 0,
      '背筋': 0,
      '脚': 0,
    },
    70: { // オーバーヘッドトライセプスエクステンション
      '腕': 5,
      '胸': 0,
      '肩': 1,
      '腹筋': 1,
      '背筋': 0,
      '脚': 0,
    },
    71: { // キックバック
      '腕': 4,
      '胸': 0,
      '肩': 1,
      '腹筋': 0,
      '背筋': 0,
      '脚': 0,
    },
    72: { // アップライトロウ
      '腕': 1,
      '胸': 0,
      '肩': 4,
      '腹筋': 1,
      '背筋': 2,
      '脚': 0,
    },
    73: { // シュラッグ
      '腕': 1,
      '胸': 0,
      '肩': 1,
      '腹筋': 0,
      '背筋': 3,
      '脚': 0,
    },
    74: { // デッドバグ
      '腕': 0,
      '胸': 0,
      '肩': 1,
      '腹筋': 3,
      '背筋': 2,
      '脚': 1,
    },
    75: { // ハローアップ
      '腕': 0,
      '胸': 0,
      '肩': 0,
      '腹筋': 4,
      '背筋': 0,
      '脚': 0,
    },
    76: { // バード・ドッグ
      '腕': 0,
      '胸': 0,
      '肩': 1,
      '腹筋': 2,
      '背筋': 3,
      '脚': 1,
    },
    77: { // ホローボディホールド
      '腕': 0,
      '胸': 0,
      '肩': 0,
      '腹筋': 5,
      '背筋': 1,
      '脚': 1,
    },
  };

  // 詳細な説明データ（全エクササイズ分）
  static const Map<int, String> _detailedDescriptions = {
    1: '''【基本的なプッシュアップの正しいやり方】

1. 両手を肩幅に開き、肩の真下に手をつく
2. 足のつま先を床につけ、体を一直線に保つ
3. 胸が床につく手前まで体を下げる
4. 胸を張りながらゆっくりと体を押し上げる

【ポイント】
• 体は一直線をキープ
• 呼吸を止めずに行う
• 肘は45度程度開く''',

    2: '''【ダイヤモンドプッシュアップの正しいやり方】

1. 両手で菱形（ダイヤモンド）を作り床につく
2. 足のつま先を床につけ、体を一直線に保つ
3. 胸がダイヤモンドに触れるまで体を下げる
4. 上腕三頭筋を意識して押し上げる

【ポイント】
• 手の形をしっかりキープ
• 通常より負荷が高いため無理をしない
• 肘は体に近づけて動かす''',

    3: '''【パイクプッシュアップの正しいやり方】

1. 腕立ての姿勢からお尻を高く上げる
2. 足は肩幅に開き、頭は手の間を見る
3. 頭が床に近づくまで体を下げる
4. 肩の筋肉を使って押し上げる

【ポイント】
• お尻を高く保つ
• 頭を床に向けて動かす
• 肩周りの筋肉を意識する''',

    4: '''【ワイドプッシュアップの正しいやり方】

1. 手幅を肩幅より広く開いて床につく
2. 足のつま先を床につけ、体を一直線に保つ
3. 胸を開くように体を下げる
4. 大胸筋を意識して押し上げる

【ポイント】
• 手幅は肩幅の1.5倍程度
• 胸の筋肉をしっかり伸ばす
• 肘は外側に開く''',

    5: '''【インクラインプッシュアップの正しいやり方】

1. 台や段差に両手をつく
2. 足を床につけ、体を斜めの一直線に保つ
3. 胸が台に近づくまで体を下げる
4. しっかりと押し上げる

【ポイント】
• 台は膝から腰の高さ
• 初心者におすすめの種目
• 角度が緩いほど負荷が軽くなる''',

    6: '''【プランクの正しいやり方】

1. うつ伏せになり、肘を肩の真下につく
2. つま先を立て、体を一直線に保つ
3. この姿勢を決められた時間キープ
4. 呼吸は止めずに自然に行う

【ポイント】
• お尻を上げ下げしない
• 体幹全体を意識する
• 最初は30秒から始める''',

    7: '''【クランチの正しいやり方】

1. 仰向けに寝て膝を90度に曲げる
2. 手は頭の後ろまたは胸の前に置く
3. 腹筋を使って上体を起こす
4. ゆっくりと元の位置に戻る

【ポイント】
• 首に力を入れない
• 腹筋の収縮を意識する
• 呼吸に合わせて動作する''',

    8: '''【マウンテンクライマーの正しいやり方】

1. プランクの姿勢を作る
2. 片足ずつ交互に胸に引き寄せる
3. 山登りのような動作を繰り返す
4. リズミカルに動作を続ける

【ポイント】
• 体幹を安定させる
• 足の切り替えを素早く
• 肩の安定性を意識する''',

    9: '''【レッグレイズの正しいやり方】

1. 仰向けに寝て両手を体の横に置く
2. 両足を揃えて持ち上げる
3. 90度まで上げたらゆっくり下ろす
4. 足は床につけずに繰り返す

【ポイント】
• 腰を浮かせない
• 下腹部を意識する
• 足は真っ直ぐ保つ''',

    10: '''【バックエクステンションの正しいやり方】

1. うつ伏せになり、手は頭の後ろに置く
2. 胸と足を同時に浮かせる
3. 背筋を使って体を反らせる
4. ゆっくりと元の位置に戻る

【ポイント】
• 無理に反らせすぎない
• 背筋全体を意識する
• 首を反らせすぎない''',

    11: '''【リバースプランクの正しいやり方】

1. お尻を床につけ、手を後ろにつく
2. 足を伸ばし、お尻を持ち上げる
3. 体を一直線に保ってキープ
4. 決められた時間維持する

【ポイント】
• お尻を高く保ち、体を一直線にする
• 肩甲骨を寄せ、胸を張る
• 肩の安定性を重視し、手首への負担を軽減
• 呼吸は自然に続ける''',

    12: '''【スクワットの正しいやり方】

1. 足を肩幅に開いて立つ
2. つま先を少し外側に向ける
3. お尻を後ろに引きながら腰を下ろす
4. 太ももが床と平行になるまで下げる
5. かかとで床を押すように立ち上がる

【ポイント】
• 膝がつま先より前に出ないよう注意
• 背筋を伸ばし、胸を張る
• 呼吸：下げる時に息を吸い、上げる時に息を吐く
• かかとに重心を置く''',

    13: '''【ランジの正しいやり方】

1. 直立の姿勢から片足を前に踏み出す
2. 両膝を90度まで曲げて腰を下ろす
3. 前足のかかとで床を押して戻る
4. 反対の足でも同様に行う

【ポイント】
• 上体をまっすぐ保ち、前傾しない
• 前膝がつま先より前に出ないよう注意
• バランスを崩さないよう体幹を安定させる
• 後ろ足の膝が床に触れる手前で止める''',

    14: '''【カーフレイズの正しいやり方】

1. 足を腰幅に開いて立つ
2. かかとをゆっくりと上げる
3. つま先立ちの状態を1秒キープ
4. ゆっくりとかかとを下ろす

【ポイント】
• ふくらはぎの収縮を意識する
• 勢いをつけずに行い、コントロールする
• 台を使うとより効果的で可動域が広がる
• バランスを保つため壁などを支えにしても良い''',

    15: '''【ジャンプスクワットの正しいやり方】

1. 通常のスクワットの姿勢を作る
2. 腰を下ろしたら勢いよくジャンプ
3. 着地と同時に再びスクワット
4. リズミカルに繰り返す

【ポイント】
• 着地時の衝撃に注意し、膝を痛めないよう調整
• 膝を痛めないよう無理をしない
• 高い心拍数維持が可能で有酸素効果も期待
• 着地は足全体で行い、つま先だけにしない''',

    16: '''【バーピーの正しいやり方】

1. 直立から素早くしゃがみ込む
2. 手を床につけて足を後ろに伸ばす
3. プッシュアップを1回行う
4. 足を手元に引き寄せる
5. 立ち上がってジャンプする

【ポイント】
• 動作を流れるように連続で行う
• 肩の安定性を保ち、手首への負担を軽減
• 高強度なので無理は禁物、自分のペースで行う
• 各動作を正確に行うことを重視''',

    17: '''【ジャンピングジャックの正しいやり方】

1. 足を揃えて直立する
2. ジャンプして足を開き、手を上に
3. 再びジャンプして足を閉じ、手を下ろす
4. リズミカルに繰り返す

【ポイント】
• 軽やかにジャンプし、膝への負担を軽減
• 肩の動きを意識し、腕全体を動かす
• ウォーミングアップにも最適
• 一定のリズムを保つ''',

    18: '''【ナロープッシュアップの正しいやり方】

1. 両手を肩幅より狭く床につく
2. 足のつま先を床につけ、体を一直線に保つ
3. 肘を体に近づけながら体を下げる
4. 上腕三頭筋を意識して押し上げる

【ポイント】
• 肘は体の側面を沿うように動かす
• 上腕三頭筋の収縮を意識し、効果を高める
• 手首の角度に注意し、痛みがあれば中止
• 通常のプッシュアップより負荷が高い''',

    19: '''【デクラインプッシュアップの正しいやり方】

1. 足を台や椅子に上げる
2. 両手を床につき、体を一直線に保つ
3. 胸が床に近づくまで下げる
4. 力強く押し上げる

【ポイント】
• 台の高さで負荷を調整可能
• 胸と上腕三頭筋を意識する
• バランスを保ち、台から足が落ちないよう注意
• 通常のプッシュアップより高負荷''',

    20: '''【ダンベルカールの正しいやり方】

1. 両手にダンベルを持ち直立する
2. 肘を体の側面に固定する
3. 上腕二頭筋を使ってダンベルを上げる
4. ゆっくりとコントロールして下ろす

【ポイント】
• 肘の位置を固定し、前後に動かさない
• 反動を使わず、筋肉の力のみで動作
• 上腕二頭筋の収縮を感じながら行う
• 下ろす動作も意識して行う''',

    21: '''【トライセップスエクステンションの正しいやり方】

1. 片手または両手でダンベルを持つ
2. 腕を頭上に伸ばす
3. 肘を固定して前腕のみ下げる
4. 上腕三頭筋で押し上げる

【ポイント】
• 肘の位置を固定し、上腕を動かさない
• 上腕三頭筋のストレッチを感じる
• 肩を動かさず、前腕のみを動作させる
• 重量は軽めから始める''',

    22: '''【ハンマーカールの正しいやり方】

1. ダンベルを縦に持ち直立する
2. 肘を体の側面に固定
3. ハンマーのような握り方で上げる
4. ゆっくりと下ろす

【ポイント】
• 手首は真っ直ぐ保ち、曲げない
• 上腕筋を意識し、二頭筋との違いを感じる
• 肘の位置を固定し、前後に動かさない
• 両手同時または交互に行う''',

    23: '''【ダンベルベンチプレスの正しいやり方】

1. ベンチに仰向けになりダンベルを持つ
2. 胸を張り肩甲骨を寄せる
3. ダンベルを胸まで下げる
4. 大胸筋を使って押し上げる

【ポイント】
• 肩甲骨を寄せて安定させ、ベンチに密着
• 胸の筋肉を意識し、効果的な刺激を与える
• 軌道を安定させ、左右のバランスを保つ
• 足はしっかりと床につける''',

    24: '''【ダンベルフライの正しいやり方】

1. ベンチに仰向けになりダンベルを持つ
2. 腕を軽く曲げて横に開く
3. 大胸筋のストレッチを感じながら下げる
4. 胸の筋肉で弧を描くように上げる

【ポイント】
• 肘の角度を保ち、曲げすぎない
• 胸筋のストレッチを重視し、可動域を大きく
• 肩を下げて安定させ、肩関節を保護
• 重量は軽めから始める''',

    25: '''【インクラインダンベルプレスの正しいやり方】

1. インクラインベンチに座りダンベルを持つ
2. 胸を張り肩甲骨を寄せる
3. ダンベルを胸上部まで下げる
4. 大胸筋上部を意識して押し上げる

【ポイント】
• ベンチ角度は30-45度が効果的
• 胸上部を意識し、普通のプレスとの違いを感じる
• 肩を下げて安定させ、肩関節を保護
• 足はしっかりと床につける''',

    26: '''【ショルダープレスの正しいやり方】

1. 背筋を伸ばして座るか立つ
2. ダンベルを肩の高さに構える
3. 三角筋を使って真上に押し上げる
4. ゆっくりとコントロールして下ろす

【ポイント】
• 背筋をまっすぐ保ち、反り返らない
• 肩の筋肉を意識し、腕だけでなく肩で押し上げる
• 頭上で完全に伸ばし、可動域を大きく
• 体幹を安定させる''',

    27: '''【サイドレイズの正しいやり方】

1. 両手にダンベルを持ち直立する
2. 軽く肘を曲げて体の横に構える
3. 肩の高さまで横に上げる
4. ゆっくりと下ろす

【ポイント】
• 肩の力だけで上げ、反動を使わない
• 反動を使わず、筋肉の力のみで動作
• 肩甲骨を動かさず、三角筋中部を意識
• 肩の高さで止め、それ以上上げない''',

    28: '''【フロントレイズの正しいやり方】

1. ダンベルを体の前で持つ
2. 腕を軽く曲げて前方に上げる
3. 肩の高さまで上げる
4. ゆっくりと下ろす

【ポイント】
• 三角筋前部を意識し、胸の筋肉は使わない
• 反動を使わず、コントロールして動作
• 肩の高さで止め、それ以上上げない
• 体幹を安定させ、体の揺れを防ぐ''',

    29: '''【リアデルトフライの正しいやり方】

1. 前傾姿勢でダンベルを持つ
2. 軽く肘を曲げて後方に開く
3. 肩甲骨を寄せるように上げる
4. ゆっくりと戻す

【ポイント】
• 三角筋後部を意識し、背筋との違いを感じる
• 肩甲骨の動きを重視し、寄せる動作を意識
• 前傾姿勢を保ち、体を起こさない
• 軽い重量から始める''',

    30: '''【サイドプランクの正しいやり方】

1. 横向きに寝て肘を肩の下につく
2. 体を一直線に保ちお尻を上げる
3. この姿勢をキープする
4. 呼吸は止めずに自然に行う

【ポイント】
• 体側の筋肉（腹斜筋）を意識する
• お尻が下がらないよう注意し、一直線を保つ
• 首の角度を保ち、頭が下がらないようにする
• 両側均等に行う''',

    31: '''【バイシクルクランチの正しいやり方】

1. 仰向けに寝て膝を90度に曲げる
2. 手を頭の後ろに置く
3. 対角の肘と膝を近づける
4. 自転車を漕ぐように交互に行う

【ポイント】
• 腹斜筋を意識し、体をしっかりひねる
• リズミカルに行い、一定のペースを保つ
• 首に力を入れず、腹筋で体をひねる
• 対角の肘膝を確実に近づける''',

    32: '''【ニートゥエルボーの正しいやり方】

1. 直立して手を頭の後ろに置く
2. 右膝と左肘を近づける
3. 元の位置に戻る
4. 左膝と右肘で同様に行う

【ポイント】
• 腹斜筋を意識し、体幹をひねる
• バランスを保ち、軸足をしっかり安定させる
• リズミカルに交互に行う
• 肘と膝を確実に近づける''',

    33: '''【ダンベルクランチの正しいやり方】

1. 仰向けに寝てダンベルを胸に抱える
2. 膝を90度に曲げる
3. 腹筋を使って上体を起こす
4. ゆっくりと戻す

【ポイント】
• 負荷を感じながら行い、効果を高める
• 腹筋の収縮を意識し、筋肉の働きを感じる
• 首に力を入れず、腹筋で体を起こす
• 重量は適切に調整する''',

    34: '''【ロシアンツイストの正しいやり方】

1. 座った状態でダンベルを持つ
2. 足を浮かせてバランスを取る
3. 体幹を左右にツイストする
4. ダンベルで床をタッチするように

【ポイント】
• 体幹の回旋を意識し、腹斜筋を使う
• バランスを保ち、安定した姿勢をキープ
• 腹斜筋を使い、効果的な刺激を与える
• 重量は軽めから始める''',

    35: '''【スーパーマンの正しいやり方】

1. うつ伏せになり手足を伸ばす
2. 対角の手足を同時に上げる
3. 2-3秒キープする
4. ゆっくりと下ろす

【ポイント】
• 背筋全体を使い、バランスよく鍛える
• 対角の手足を意識し、体幹の安定性を高める
• 無理に反らせすぎず、自然な範囲で行う
• 呼吸を止めずに行う''',

    36: '''【ワンハンドローイングの正しいやり方】

1. ベンチに片手片膝をつく
2. 反対の手でダンベルを持つ
3. 肘を後ろに引いて上げる
4. ゆっくりと下ろす

【ポイント】
• 広背筋を意識し、背中の筋肉で引く
• 肘を体に近づけ、後方に引く動作を重視
• 肩甲骨を寄せ、背中の収縮を感じる
• 反対の手でバランスを保つ''',

    37: '''【ベントオーバーロウの正しいやり方】

1. 前傾姿勢で両手にダンベルを持つ
2. 背筋を伸ばして構える
3. 肘を後ろに引いて上げる
4. ゆっくりと下ろす

【ポイント】
• 前傾姿勢を保ち、背中を丸めない
• 肩甲骨を寄せ、背筋の収縮を意識
• 背筋全体を使い、バランスよく鍛える
• 膝を軽く曲げて安定させる''',

    38: '''【デッドリフトの正しいやり方】

1. 足を腰幅に開きダンベルを持つ
2. 背筋を伸ばし胸を張る
3. お尻を後ろに引きながら前傾
4. 背筋と脚の力で立ち上がる

【ポイント】
• 背中を丸めず、常に真っ直ぐ保つ
• ダンベルを体に近づけ、軌道を安定させる
• 呼吸のタイミングに注意し、力を入れる時に息を吐く
• 全身の複合動作を意識する''',

    39: '''【サイドランジの正しいやり方】

1. 足を大きく左右に開いて立つ
2. 片足に体重を移しながら腰を下ろす
3. 太ももが床と平行になるまで下げる
4. 反対足でも同様に行う

【ポイント】
• 内転筋を意識し、股関節周りを鍛える
• 膝をつま先の方向に向け、内側に入れない
• 上体をまっすぐ保ち、前傾しない
• 片足ずつ確実に動作を行う''',

    40: '''【シングルレッグスクワットの正しいやり方】

1. 片足で立ち、もう片足を前に上げる
2. 支持脚でゆっくりと腰を下ろす
3. 太ももが床と平行になるまで下げる
4. 支持脚の力で立ち上がる

【ポイント】
• バランスを保ち、体幹を安定させる
• 膝が内側に入らないよう注意
• 壁や椅子を補助に使っても良い
• 片足の筋力を集中的に鍛える''',

    41: '''【ウォールシットの正しいやり方】

1. 背中を壁につけて立つ
2. 足を前に出し膝を90度に曲げる
3. 太ももが床と平行になる位置で止める
4. この姿勢をキープする

【ポイント】
• 大腿四頭筋を意識し、筋持久力を高める
• 背中を壁にしっかりつけ、離れないようにする
• 膝が90度になるよう足の位置を調整
• 呼吸を止めずに行う''',

    42: '''【ダンベルスクワットの正しいやり方】

1. 両手にダンベルを持ち直立する
2. 足を肩幅に開く
3. お尻を後ろに引きながら腰を下ろす
4. 太ももが床と平行になるまで下げる

【ポイント】
• ダンベルの重量で負荷を増加
• 正しいスクワットフォームを維持
• 膝がつま先より前に出ないよう注意
• 背筋を伸ばし、胸を張る''',

    43: '''【ダンベルランジの正しいやり方】

1. 両手にダンベルを持ち直立する
2. 片足を前に大きく踏み出す
3. 両膝を90度まで曲げる
4. 前足で床を押して戻る

【ポイント】
• ダンベルで負荷を増加し、効果を高める
• 前膝がつま先より前に出ないよう注意
• 上体をまっすぐ保ち、バランスを崩さない
• 後ろ足の膝が床に触れる手前で止める''',

    44: '''【ルーマニアンデッドリフトの正しいやり方】

1. 両手にダンベルを持ち直立する
2. 膝を軽く曲げお尻を後ろに引く
3. ハムストリングのストレッチを感じる
4. お尻の力で立ち上がる

【ポイント】
• ハムストリングを重視し、太もも裏を意識
• 背中は真っ直ぐ保ち、丸めない
• お尻の動きを意識し、股関節を使う
• 膝の曲げすぎに注意する''',

    45: '''【ダンベルカーフレイズの正しいやり方】

1. 両手にダンベルを持ち直立する
2. かかとをゆっくりと上げる
3. つま先立ちの状態を1秒キープ
4. ゆっくりとかかとを下ろす

【ポイント】
• ダンベルで負荷を追加し、効果を高める
• ふくらはぎの収縮を意識する
• 台を使うとより効果的で可動域が広がる
• バランスを保つため適切な重量を選ぶ''',

    46: '''【ダンベルスラスターの正しいやり方】

1. 両手にダンベルを持ち肩に構える
2. スクワットの動作で腰を下ろす
3. 立ち上がりながらダンベルを頭上に
4. 一連の動作を流れるように行う

【ポイント】
• 全身の連動を意識し、複合動作を重視
• スクワットとプレスを連続で行う
• 高強度な複合種目なので適切な重量を選ぶ
• 動作を流れるように行う''',

    47: '''【ダンベルクリーンの正しいやり方】

1. ダンベルを床に置き足元に構える
2. デッドリフトのように引き上げる
3. 膝の高さで爆発的に加速
4. 肩まで一気に引き上げる

【ポイント】
• 爆発的な力を使い、瞬発力を鍛える
• 全身の連動が重要で、技術を要する
• 高度な技術を要する種目なので段階的に習得
• 軽い重量から始めて動作を覚える''',

    // ===== 新規追加エクササイズの詳細説明 =====

    48: '''【プルアップの正しいやり方】

1. 懸垂バーを順手で肩幅より少し広く握る
2. 腕を伸ばしてぶら下がる
3. 胸をバーに近づけるように体を引き上げる
4. ゆっくりと元の位置に戻る

【ポイント】
• 広背筋を意識し、背中の力で体を引き上げる
• 肩甲骨を寄せ、胸を張りながら行う
• 反動を使わず、筋力のみで動作する
• 完全に腕を伸ばした状態から始める''',

    49: '''【トライセプスディップスの正しいやり方】

1. 椅子や台の端に手をつく
2. 足を前に出し、体重を腕で支える
3. 肘を曲げて体を下げる
4. 上腕三頭筋の力で押し上げる

【ポイント】
• 上腕三頭筋を集中的に鍛える
• 肘は体に近づけて動かす
• 肩の前側に痛みを感じたら中止する
• 足の位置で負荷を調整できる''',

    50: '''【ディップスの正しいやり方】

1. 平行棒に手をつき体を支える
2. 体をやや前傾させる
3. 肘を曲げて体を下げる
4. 胸と腕の力で押し上げる

【ポイント】
• 胸筋下部と上腕三頭筋を同時に鍛える
• 体を前傾させることで胸筋により効かせる
• 肩関節への負担が大きいので無理をしない
• 完全な可動域で行う''',

    51: '''【ヒールタッチの正しいやり方】

1. 仰向けに寝て膝を90度に曲げる
2. 手を体の横に置く
3. 体を側屈させて左右のかかとを交互にタッチ
4. リズミカルに繰り返す

【ポイント】
• 腹斜筋を意識し、体の側屈を重視
• 肩甲骨を床から離し、上体を少し起こす
• 首に力を入れず、腹筋で動作する
• 左右均等に行う''',

    52: '''【Vアップの正しいやり方】

1. 仰向けに寝て手足を伸ばす
2. 手と足を同時に上げてV字を作る
3. 指先でつま先をタッチする
4. ゆっくりと元の位置に戻る

【ポイント】
• 腹直筋全体を使い、体をV字に折りたたむ
• 反動を使わず、腹筋の力のみで動作
• 手足は真っ直ぐ保つ
• 腰への負担に注意し、痛みがあれば中止''',

    53: '''【ダンベルVアップの正しいやり方】

1. 仰向けに寝てダンベルを頭上で持つ
2. 手と足を同時に上げてV字を作る
3. ダンベルでつま先をタッチする
4. ゆっくりと元の位置に戻る

【ポイント】
• 通常のVアップより高負荷で効果的
• 腹直筋全体に強い刺激を与える
• 適切な重量を選び、フォームを重視
• 動作をコントロールして行う''',

    54: '''【チンアップの正しいやり方】

1. 懸垂バーを逆手で肩幅程度に握る
2. 腕を伸ばしてぶら下がる
3. 胸をバーに近づけるように体を引き上げる
4. ゆっくりと元の位置に戻る

【ポイント】
• 上腕二頭筋により負荷がかかる握り方
• 背筋と上腕二頭筋を同時に鍛える
• 肩甲骨を寄せながら行う
• プルアップより上腕二頭筋を意識''',

    55: '''【ネガティブプルアップの正しいやり方】

1. 椅子などを使ってバーの上に位置する
2. 懸垂の完了姿勢から開始
3. ゆっくりと体を下げる
4. 完全に腕が伸びるまで下ろす

【ポイント】
• 下降動作のみを行う懸垂の練習方法
• 5-10秒かけてゆっくり下ろす
• 通常の懸垂ができない人に最適
• 背筋の筋力を効果的に鍛える''',

    56: '''【パイクウォークの正しいやり方】

1. パイク姿勢（お尻を高く上げた状態）を作る
2. 手で前に歩いて進む
3. 一定距離進んだら手で後ろに戻る
4. お尻を高く保ったまま行う

【ポイント】
• 肩と体幹を同時に鍛える複合運動
• お尻を高く保ち、逆V字をキープ
• 手首への負担に注意する
• 肩の安定性を重視する''',

    57: '''【ベアクロールの正しいやり方】

1. 四つん這いになり膝を少し浮かせる
2. 対角の手足を同時に前に出す
3. 低い姿勢を保ったまま這って進む
4. 一定距離進んだら後ろ向きに戻る

【ポイント】
• 全身の協調性と筋力を鍛える
• 膝は常に浮かせた状態を保つ
• 体幹を安定させ、お尻の上下動を避ける
• ゆっくりとコントロールして動作''',

    58: '''【ダンベルプルオーバーの正しいやり方】

1. ベンチに仰向けになりダンベルを両手で持つ
2. ダンベルを胸の上に構える
3. 弧を描くように頭の後ろに下ろす
4. 胸の筋肉で元の位置に戻す

【ポイント】
• 胸筋と広背筋を同時に鍛える
• 胸郭を広げる効果も期待できる
• 肩関節の可動域を活用する
• 重量は軽めから始める''',

    59: '''【アーノルドプレスの正しいやり方】

1. ダンベルを逆手で肩の前に構える
2. 押し上げながら手のひらを前に回転
3. 頭上で完全に伸ばす
4. 回転させながらゆっくり戻す

【ポイント】
• 回転動作で三角筋全体を刺激
• 通常のプレスより可動域が大きい
• 肩関節への負担に注意する
• 軽い重量から始めて動作を覚える''',

    60: '''【ブルガリアンスプリットスクワットの正しいやり方】

1. 台の前に立ち、後ろ足を台に乗せる
2. 前足一本で体重を支える
3. 前足の膝を曲げて体を下げる
4. 前足の力で立ち上がる

【ポイント】
• 片足に集中的に負荷をかける
• 前足に体重の大部分をかける
• バランスを保ち、体幹を安定させる
• 膝が内側に入らないよう注意''',

    61: '''【シシースクワットの正しいやり方】

1. 直立して壁や柱を軽く握る
2. かかとを上げてつま先立ちになる
3. 体を後ろに傾けながら膝を曲げる
4. 大腿四頭筋の力で立ち上がる

【ポイント】
• 大腿四頭筋を集中的に鍛える高強度種目
• 体を一直線に保ったまま後傾する
• 膝の負担が大きいので注意深く行う
• 壁や柱を軽く支えにしても良い''',

    62: '''【グルートブリッジの正しいやり方】

1. 仰向けに寝て膝を90度に曲げる
2. 手は体の横に置く
3. お尻の力で腰を持ち上げる
4. 体を一直線にしてキープ後、ゆっくり下ろす

【ポイント】
• 大殿筋を集中的に鍛える基本種目
• お尻の収縮を意識する
• 腰を反らせすぎないよう注意
• かかとに重心を置く''',

    63: '''【ヒップスラストの正しいやり方】

1. 肩をベンチにつけて座る
2. 膝を90度に曲げて足を床につける
3. お尻の力で腰を持ち上げる
4. 体を一直線にしてからゆっくり下ろす

【ポイント】
• グルートブリッジの強化版
• 大殿筋により強い刺激を与える
• 肩甲骨でベンチを押すように支える
• お尻の最大収縮を意識する''',

    64: '''【ダンベルヒップスラストの正しいやり方】

1. 肩をベンチにつけてダンベルを腰に乗せる
2. 膝を90度に曲げて足を床につける
3. お尻の力で腰を持ち上げる
4. 体を一直線にしてからゆっくり下ろす

【ポイント】
• ダンベルの重量で負荷を増加
• 大殿筋に高強度の刺激を与える
• ダンベルがずれないよう注意
• 適切な重量を選択する''',

    65: '''【ダンベルステップアップの正しいやり方】

1. 両手にダンベルを持ち台の前に立つ
2. 片足を台に乗せる
3. 台に乗せた足の力で体を押し上げる
4. ゆっくりと元の位置に戻る

【ポイント】
• 片足の筋力を集中的に鍛える
• 台に乗せた足で体重を支える
• バランスを保ち、体幹を安定させる
• 左右均等に行う''',

    66: '''【ゴブレットスクワットの正しいやり方】

1. ダンベルを縦に持ち胸の前で抱える
2. 足を肩幅に開いて立つ
3. お尻を後ろに引きながら腰を下ろす
4. かかとで床を押すように立ち上がる

【ポイント】
• ダンベルを胸の前で安定させる
• 正しいスクワットフォームを維持
• 体幹の安定性も同時に鍛える
• 重量は適切に調整する''',

    67: '''【ダンベルグッドモーニングの正しいやり方】

1. ダンベルを肩に担ぐように持つ
2. 足を肩幅に開いて立つ
3. お尻を後ろに引きながら前傾
4. 背筋とお尻の力で立ち上がる

【ポイント】
• 脊柱起立筋とハムストリングを重点的に鍛える
• 背中を真っ直ぐ保ち、丸めない
• お尻の動きを意識し、股関節を使う
• 前傾角度は45度程度まで''',

    68: '''【プリーチャーカールの正しいやり方】

1. プリーチャーベンチに座り胸をパッドにつける
2. ダンベルを持ち腕をパッドに置く
3. 上腕二頭筋を使ってダンベルを上げる
4. ゆっくりとコントロールして下ろす

【ポイント】
• 上腕二頭筋を集中的に鍛えるアイソレーション種目
• 肘の位置を固定し、前腕のみを動かす
• パッドに腕をしっかりつける
• 反動を使わず筋力のみで動作''',

    69: '''【コンセントレーションカールの正しいやり方】

1. ベンチに座り片手でダンベルを持つ
2. 肘を太ももの内側に固定
3. 上腕二頭筋を使ってダンベルを上げる
4. ゆっくりと下ろす

【ポイント】
• 上腕二頭筋に集中した刺激を与える
• 肘を太ももで固定し、動かさない
• 反動を使わず、筋肉の収縮を感じる
• 片手ずつ集中して行う''',

    70: '''【オーバーヘッドトライセプスエクステンションの正しいやり方】

1. 座った状態でダンベルを頭上に持つ
2. 肘を固定し前腕のみを下げる
3. 頭の後ろまでダンベルを下ろす
4. 上腕三頭筋の力で押し上げる

【ポイント】
• 上腕三頭筋を集中的に鍛える
• 肘の位置を固定し、上腕を動かさない
• 頭の後ろまでしっかり下ろす
• 重量は軽めから始める''',

    71: '''【キックバックの正しいやり方】

1. ベンチに片手と片膝をつく
2. 反対の手でダンベルを持つ
3. 肘を90度に曲げた状態から開始
4. 後方にダンベルを蹴り上げる

【ポイント】
• 上腕三頭筋の収縮を強く感じる種目
• 肘の位置を固定し、前腕のみを動かす
• 後方に真っ直ぐ蹴り上げる
• 軽い重量で正確な動作を重視''',

    72: '''【アップライトロウの正しいやり方】

1. 両手でダンベルを体の前で持つ
2. 足を肩幅に開いて立つ
3. 肘を高く上げながらダンベルを引き上げる
4. 胸の高さまで上げたらゆっくり下ろす

【ポイント】
• 三角筋と僧帽筋を同時に鍛える
• 肘を高く上げ、手よりも高い位置に
• 体に沿ってダンベルを引き上げる
• 肩の痛みがある場合は中止''',

    73: '''【シュラッグの正しいやり方】

1. 両手にダンベルを持ち直立する
2. 腕は自然に下ろした状態
3. 肩をすくめるように上に上げる
4. 僧帽筋の収縮を感じて下ろす

【ポイント】
• 僧帽筋上部を集中的に鍛える
• 肩を真上に上げ、前後に動かさない
• 腕の力は使わず、肩の動きのみ
• 収縮を1秒キープする''',

    74: '''【デッドバグの正しいやり方】

1. 仰向けに寝て膝と腰を90度に曲げる
2. 両腕を天井に向けて伸ばす
3. 対角の手足をゆっくり伸ばす
4. 元の位置に戻して反対側も行う

【ポイント】
• 体幹の安定性を高める基本種目
• 腰を床につけたまま行う
• 対角の動きで協調性を養う
• ゆっくりとコントロールして動作''',

    75: '''【ハローアップの正しいやり方】

1. 仰向けに寝て膝を軽く曲げる
2. 手を頭の後ろに置く
3. 上体を起こしながら円を描くように動かす
4. 左右に大きく動かしてから戻る

【ポイント】
• 腹直筋と腹斜筋を同時に鍛える
• 円を描くような動作で可動域を大きく
• 首に力を入れず、腹筋で動作
• リズミカルに行う''',

    76: '''【バード・ドッグの正しいやり方】

1. 四つん這いになる
2. 対角の手足を同時に伸ばす
3. 体を一直線に保ってキープ
4. ゆっくり戻して反対側も行う

【ポイント】
• 体幹の安定性と背筋を同時に鍛える
• 体を一直線に保ち、バランスを取る
• 対角の手足で協調性を養う
• 腰の反りすぎに注意''',

    77: '''【ホローボディホールドの正しいやり方】

1. 仰向けに寝て膝を胸に引き寄せる
2. 手足を伸ばし体を船のように反らせる
3. 腰を床につけたまま姿勢をキープ
4. 決められた時間維持する

【ポイント】
• 腹筋全体を使った静的エクササイズ
• 腰は床につけ、浮かせない
• 体を船のような形に保つ
• 呼吸を止めずに行う'''
  };

  // フィルタリング用メソッド
  static List<Exercise> getFilteredExercises({
    String? searchQuery,
    Set<BodyPart>? selectedBodyParts,
    bool? equipmentFilter, // null: 全て, true: 器具あり, false: 器具なし
  }) {
    var filteredExercises = exercises;

    // 検索クエリでフィルタリング
    if (searchQuery != null && searchQuery.isNotEmpty) {
      filteredExercises = filteredExercises.where((exercise) {
        return exercise.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            exercise.description.toLowerCase().contains(searchQuery.toLowerCase()) ||
            exercise.detailedTargetParts.any((part) => part.toLowerCase().contains(searchQuery.toLowerCase()));
      }).toList();
    }

    // 器具フィルタリング
    if (equipmentFilter != null) {
      filteredExercises = filteredExercises.where((exercise) {
        return exercise.requiresEquipment == equipmentFilter;
      }).toList();
    }

    // 部位でフィルタリング（正しいAND実装：各部位の個別結果の積集合）
    if (selectedBodyParts != null && selectedBodyParts.isNotEmpty) {
      // 各部位ごとに該当するエクササイズのリストを作成
      List<Set<Exercise>> bodyPartResults = [];
      
      for (BodyPart selectedPart in selectedBodyParts) {
        Set<Exercise> partExercises = filteredExercises.where((exercise) {
          return exercise.mainBodyPart == selectedPart ||
              exercise.detailedTargetParts.any((targetPart) => 
                _isRelatedBodyPart(selectedPart, targetPart)
              );
        }).toSet();
        bodyPartResults.add(partExercises);
      }
      
      // 全ての部位結果の積集合を取る
      if (bodyPartResults.isNotEmpty) {
        Set<Exercise> intersection = bodyPartResults.first;
        for (int i = 1; i < bodyPartResults.length; i++) {
          intersection = intersection.intersection(bodyPartResults[i]);
        }
        filteredExercises = intersection.toList();
      }
    }

    return filteredExercises;
  }

  // エクササイズの負荷データを取得
  static Map<String, int> getExerciseLoadData(int exerciseId) {
    return _exerciseLoadData[exerciseId] ?? {
      '腕': 0,
      '胸': 0,
      '肩': 0,
      '腹筋': 0,
      '背筋': 0,
      '脚': 0,
    };
  }

  // やり方部分のみを取得
  static String getTrainingMethod(int exerciseId) {
    final fullDescription = _detailedDescriptions[exerciseId] ?? '';
    String methodPart = '';
    
    if (fullDescription.contains('【ポイント】')) {
      methodPart = fullDescription.split('【ポイント】')[0].trim();
    } else {
      methodPart = fullDescription;
    }
    
    // 【○○の正しいやり方】の部分を削除
    final lines = methodPart.split('\n');
    final filteredLines = lines.where((line) {
      final trimmedLine = line.trim();
      return !(trimmedLine.startsWith('【') && trimmedLine.endsWith('の正しいやり方】'));
    }).toList();
    
    return filteredLines.join('\n').trim();
  }

  // ポイント部分のみを取得
  static String getTrainingPoints(int exerciseId) {
    final fullDescription = _detailedDescriptions[exerciseId] ?? '';
    if (fullDescription.contains('【ポイント】')) {
      final parts = fullDescription.split('【ポイント】');
      if (parts.length > 1) {
        return parts[1].trim();
      }
    }
    return '';
  }

  // 部位と詳細部位の関連性をチェック
  static bool _isRelatedBodyPart(BodyPart bodyPart, String detailedPart) {
    switch (bodyPart) {
      case BodyPart.arm:
        return detailedPart.contains('腕') || 
               detailedPart.contains('上腕') || 
               detailedPart.contains('三角筋');
      case BodyPart.chest:
        return detailedPart.contains('大胸筋') || 
               detailedPart.contains('胸');
      case BodyPart.shoulder:
        return detailedPart.contains('三角筋') || 
               detailedPart.contains('肩') ||
               detailedPart.contains('僧帽筋');
      case BodyPart.abs:
        return detailedPart.contains('腹') || 
               detailedPart.contains('腸腰筋');
      case BodyPart.back:
        return detailedPart.contains('背') || 
               detailedPart.contains('脊柱') || 
               detailedPart.contains('僧帽筋') ||
               detailedPart.contains('広背筋');
      case BodyPart.leg:
        return detailedPart.contains('大腿') || 
               detailedPart.contains('大殿筋') || 
               detailedPart.contains('ハムストリング') ||
               detailedPart.contains('腓腹筋') ||
               detailedPart.contains('ヒラメ筋') ||
               detailedPart.contains('下腿') ||
               detailedPart.contains('中殿筋') ||
               detailedPart.contains('前脛骨筋');
    }
  }

  // 強度レベルでソート
  static List<Exercise> sortByIntensity(List<Exercise> exercises, {bool ascending = true}) {
    var sortedList = List<Exercise>.from(exercises);
    sortedList.sort((a, b) => ascending ? a.intensityLevel.compareTo(b.intensityLevel) : b.intensityLevel.compareTo(a.intensityLevel));
    return sortedList;
  }

  // IDで検索
  static Exercise? getExerciseById(int id) {
    try {
      return exercises.firstWhere((exercise) => exercise.id == id);
    } catch (e) {
      return null;
    }
  }
}