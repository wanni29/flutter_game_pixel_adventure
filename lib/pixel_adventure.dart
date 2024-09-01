import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
//  package: flame / game.dart  -> 이 라이브러리가 update, onLoad라는 메소드를 가지고 있음
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/level.dart';

// HasKeyboardHandlerComponents => 키보드에 대하여 제어하도록 컴포넌트 가져옴
// DragCallbacks => 모바일 조이스틱에 대하여 제어하도록 컴포넌트 가져옴
class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  late final CameraComponent cam;
  late JoystickComponent joystick;
  // 모바일로 게임을 만들때는 true로 설정
  // 웹, 컴퓨터로 만들때는 false로 설정
  bool showJoystick = false;

  Player player = Player(character: 'Mask Dude');

  // FutureOr<void> onLoad => 게임의 처음 초기값 셋팅 메소드
  @override
  FutureOr<void> onLoad() async {
    // Load all Images into cache
    // assets안에 있는 이미지를 미리 캐싱 해둠으로써
    // 데이터를 효율적으로 관리하도록 관리
    await images.loadAllImages();

    final world = Level(
      player: player,
      levelName: 'level-01.tmx',
    );

    // cam이란 ?
    // 게임을 플레이하는 유저들에게 화면을 어떻게 보여줄것인가를 정하는거임
    cam = CameraComponent.withFixedResolution(
        world: world, width: 640, height: 360);

    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);

    if (showJoystick) {
      addJoystick();
    }

    addJoystick();

    return super.onLoad();
  }

  // 매 프레임 마다 게임의 상태를 업데이트 하는 로직
  @override
  void update(double dt) {
    if (showJoystick) {
      updateJoystck();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      // knobRadius: 16, // 조이스틱 배경 밖으로 튀어가도록 하는 기능
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/JoyStick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );

    add(joystick);
  }

  void updateJoystck() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }
}
