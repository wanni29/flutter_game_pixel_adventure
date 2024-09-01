import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
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

  @override
  FutureOr<void> onLoad() async {
    // Load all Images into cache
    await images.loadAllImages();

    final world = Level(
      player: player,
      levelName: 'level-01.tmx',
    );

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
