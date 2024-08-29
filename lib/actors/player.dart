import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

//  idle : 캐릭터가 움직이지 않고 가만히 있는 상태
// running : 캐릭터가 움직이는 상태
enum PlayerState { idle, running }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure> {
  String character;
  Player({position, required this.character}) : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime = 0.05;

  @override
  FutureOr<void> onLoad() {
    _onLoadAllAnimations();
    return super.onLoad();
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
    current = PlayerState.idle;
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
}
