import 'dart:async';

import 'package:candy_pop_flutter/state/game_state.dart';
import 'package:flame/components.dart';

/// Sprite associé à une pièce
class PieceSprite extends SpriteComponent {
  PieceType pieceType;
  PieceSprite({
    required this.pieceType,
    required super.position,
    required super.size,
  });

  @override
  FutureOr<void> onLoad() async {
    switch (pieceType) {
      case PieceType.clover:
        sprite = await Sprite.load("Match3Clover.png");
        break;
      case PieceType.heart:
        sprite = await Sprite.load("Match3Heart.png");
        break;
      case PieceType.moon:
        sprite = await Sprite.load("Match3Moon.png");
        break;
      case PieceType.star:
        sprite = await Sprite.load("Match3Star.png");
        break;
      case PieceType.water:
        sprite = await Sprite.load("Match3Water.png");
        break;
    }
  }
}
