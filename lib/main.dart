import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

void main() async {
  // 플러터 프레임 워크가 초기화 될때까지 기다리는 것을 의미
  WidgetsFlutterBinding.ensureInitialized();
  // Flame게임이 실행될때 전체 화면을 실행되도록 만들어주는 역할
  await Flame.device.fullScreen();
  // Flame 게임이 실행될때 가로로 실행 할 수 있도록  만들어주는 역할
  await Flame.device.setLandscape();

  PixelAdventure game = PixelAdventure();
  runApp(
    GameWidget(game: kDebugMode ? PixelAdventure() : game),
  );
}
