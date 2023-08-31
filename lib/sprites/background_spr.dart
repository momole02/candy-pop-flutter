import 'dart:async';

import 'package:flame/components.dart';

/// Sprite du fond
class BackgroundSprite extends SpriteComponent {
  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load("Background.jpg");
  }
}
