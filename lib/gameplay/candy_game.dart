import 'dart:async';
import 'dart:math';

import 'package:candy_pop_flutter/gameplay/action_pattern.dart';
import 'package:candy_pop_flutter/gameplay/actions/move_pieces_action.dart';
import 'package:candy_pop_flutter/state/constants.dart';
import 'package:candy_pop_flutter/sprites/background_spr.dart';
import 'package:candy_pop_flutter/sprites/piece_spr.dart';
import 'package:candy_pop_flutter/state/game_state.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

/// Classe de base du jeu
///
class CandyGame extends FlameGame with TapCallbacks {
  late BackgroundSprite backgroundSprite;
  late List<Aabb2> pieceSlots;
  late List<PieceSprite> pieces;
  late ActionManager actionManager;
  late GameState state;

  CandyGame() {
    backgroundSprite = BackgroundSprite();
    actionManager = ActionManager();
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

  void _computeGameState() {
    state = GameState.computeFromSprites(
      aabbs: pieceSlots,
      sprites: pieces,
    );
  }

  void _play(double x, double y) {
    double pieceSize = size.x / kPieceCountWidth;
    int i = (x / pieceSize).floor();
    int j = (y / pieceSize).floor();
    FloodFillContext floodFillContext = FloodFillContext(state);
    List<PieceSprite> spritesToDrop = floodFillContext.compute(i, j);
    if (spritesToDrop.length >= 3) {
      actionManager.push(MovePiecesAction(
          pieces: spritesToDrop,
          durationMs: 600,
          position: Vector2(0, size.y - pieceSize)));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    actionManager.performStuff();
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!actionManager.isRunning()) {
      _play(event.localPosition.x, event.localPosition.y);
    }
  }

  @override
  FutureOr<void> onLoad() {
    pieceSlots =
        List.generate(kPieceCountWidth * kPieceCountHeight, _computeSlotAabb);
    pieces = List.generate(
        kPieceCountWidth * kPieceCountHeight, _computePieceSprite);
    add(backgroundSprite);
    addAll(pieces);
    _computeGameState();
  }
}
