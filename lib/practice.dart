import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:flutter/material.dart';
import 'package:pixel_adventure/components/level.dart';
import 'package:pixel_adventure/components/player.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  late final CameraComponent cam;
  late JoystickComponent joystick;
  bool showJoystick = false;

  Player player = Player(character: "Mask Dude");

  @override
  FutureOr<void> onLoad() async {
    // Load all Images into cache
    await images.loadAllImages();

    final world = Level(
      player: player,
      levelName: "level-01.tmx",
    );

    cam = CameraComponent.withFixedResolution(
        width: 640, height: 360, world: world);

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
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
        knob: SpriteComponent(
          sprite: Sprite(
            images.fromCache('HUD/JoyStick.png'),
          ),
        ),
        background: SpriteComponent(
          sprite: Sprite(images.fromCache("HUD/JoyStick.png")),
        ),
        margin: const EdgeInsets.only(
          left: 32,
          bottom: 32,
        ));
    add(joystick);
  }

  void updateJoystick() {
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
