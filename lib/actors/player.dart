import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

//  idle : 캐릭터가 움직이지 않고 가만히 있는 상태
// running : 캐릭터가 움직이는 상태
enum PlayerState { idle, running }

// Player의 움직임의 방향을 설정
enum PlayerDirection { left, right, none }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler {
  String character;
  Player({
    position,
    this.character = 'Ninja Frog',
  }) : super(position: position);

  // idle, running
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime = 0.05;

  // PlayerDirection
  PlayerDirection playerDirection = PlayerDirection.none;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;

  // 화면에 나오게 하도록 초기값 셋팅  (initState())
  @override
  FutureOr<void> onLoad() {
    _onLoadAllAnimations();
    return super.onLoad();
  }

  // 어떻게  움직일지 초기값 셋팅 (initState())
  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  // 키보드로 이동을 어떻게 할지 초기값 셋팅 (initState())
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    if (isLeftKeyPressed && isRightKeyPressed) {
      playerDirection = PlayerDirection.none;
    } else if (isLeftKeyPressed) {
      playerDirection = PlayerDirection.left;
    } else if (isRightKeyPressed) {
      playerDirection = PlayerDirection.right;
    } else {
      playerDirection = PlayerDirection.none;
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void _onLoadAllAnimations() {
    //  가만히 있을때 : idle state
    idleAnimation = _spriteAnimation('Idle', 11);
    // 달릴때 : running state
    runningAnimation = _spriteAnimation('Run', 12);

    // List of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
    };

    // Set current animation
    current = PlayerState.running;
  }

  // 이렇게 메소드로 만들어두면 일일히 idle, running 상황에서 로직을 만들 필요없으니까
  // 깔끔하고 좋지 : )
  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache("Main Characters/$character/$state (32x32).png"),
      SpriteAnimationData.sequenced(
        amount: amount, // 이미지의 갯수에따라 값을 넣어주면 됌
        stepTime: stepTime, // 각각의 이미지에 대해서 몇초를 주기로 넘어갈것인가
        textureSize: Vector2.all(32), // 이미지에 대한 사이즈를 조절하는거 같음
      ),
    );
  }

  void _updatePlayerMovement(double dt) {
    double dirX = 0.0;
    switch (playerDirection) {
      case PlayerDirection.left:
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        current = PlayerState.running;
        dirX -= moveSpeed;
        break;
      case PlayerDirection.right:
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        current = PlayerState.running;
        dirX += moveSpeed;
        break;
      case PlayerDirection.none:
        current = PlayerState.idle;
        break;
      default:
    }

    velocity = Vector2(dirX, 0.0);
    position += velocity * dt;
  }
}
