import 'dart:async';
import 'dart:math';

import 'package:candy_pop_flutter/game/constants.dart';
import 'package:candy_pop_flutter/sprites/background_spr.dart';
import 'package:candy_pop_flutter/sprites/piece_spr.dart';
import 'package:flame/game.dart';

/// Classe de base du jeu
///
class CandyGame extends FlameGame {
  late BackgroundSprite backgroundSprite;
  late List<Aabb2> pieceSlots;
  late List<PieceSprite> pieces;

  CandyGame() {
    backgroundSprite = BackgroundSprite();
  }

  Aabb2 _computeSlotAabb(int index) {
    int j = (index / kPieceCountWidth).floor();
    int i = index % kPieceCountWidth;
    double pieceSize = size.x / kPieceCountWidth;
    double x = i * pieceSize;
    double y = j * pieceSize;
    return Aabb2.minMax(
      Vector2(x, y),
      Vector2(x + pieceSize, y + pieceSize),
    );
  }

  PieceType _randomPieceType() {
    int rand = Random().nextInt(PieceType.values.length);
    return PieceType.values[rand];
  }

  PieceSprite _computePieceSprite(int index) {
    double pieceSize = size.x / kPieceCountWidth;
    return PieceSprite(
      pieceType: _randomPieceType(),
      position: pieceSlots[index].min,
      size: Vector2(pieceSize, pieceSize),
    );
  }

  @override
  FutureOr<void> onLoad() {
    pieceSlots =
        List.generate(kPieceCountWidth * kPieceCountHeight, _computeSlotAabb);
    pieces = List.generate(
        kPieceCountWidth * kPieceCountHeight, _computePieceSprite);
    add(backgroundSprite);
    addAll(pieces);
  }
}
