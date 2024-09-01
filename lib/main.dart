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
    // 릴리즈 모드에서는 PixelAdventure game = PixelAdventure();
    //  라는 코드를 미리 만들어 둠으로써 객체를 싱글톤으로 관리함으로 자원의 누유를 막는데 초점을 둠

    // 디버그 모드에서는 지속적으로 다시 시작됨에 따라 객체가 새로 만들어지기때문에
    // GameWidget(game: kDebugMode ? PixelAdventure()) 로 설정을 해둠
    GameWidget(game: kDebugMode ? PixelAdventure() : game),
  );
}
