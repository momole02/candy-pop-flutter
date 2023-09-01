import 'package:candy_pop_flutter/gameplay/action_pattern.dart';
import 'package:candy_pop_flutter/sprites/piece_spr.dart';
import 'package:flame/game.dart';

/// Action associé au déplacement des pièces
class MovePiecesAction extends Action {
  List<PieceSprite> pieces;
  Vector2? position;
  Vector2? vector;
  int durationMs;

  late final int startTime;
  late final List<Vector2> fromPositions;
  late final List<Vector2> toPositions;
  late final int endTime;

  MovePiecesAction({
    required this.pieces,
    this.position,
    this.vector,
    required this.durationMs,
  });

  @override
  void onStart(Map<String, dynamic> globals) {
    // Determiner les position initiales
    fromPositions = pieces.map((p) => p.position).toList();
    if (null != position) {
      // Position unique pour chaque pièce
      toPositions =
          List.generate(fromPositions.length, (index) => position!).toList();
    } else if (null != vector) {
      // Translation de chaque pièce
      toPositions = List.generate(
              fromPositions.length, (index) => fromPositions[index] + vector!)
          .toList();
    } else {
      throw Exception("Specifiez une position ou un vecteur de déplacement");
    }
    startTime = DateTime.now().millisecondsSinceEpoch;
    endTime = startTime + durationMs;
  }

  @override
  void perform(List<Action> actionQueue, Map<String, dynamic> globals) {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    double t = (currentTime - startTime) / durationMs;
    for (int i = 0; i < pieces.length; ++i) {
      // Interpolation bi-cubique
      Vector2 v0 = fromPositions[i];
      Vector2 v1 = toPositions[i];
      Vector2 f0 = v0 - v1;
      Vector2 f1 = (v1 - v0) * 2;
      Vector2 f2 = v0;
      Vector2 pos = f0 * t * t + f1 * t + f2;
      pieces[i].position = pos;
    }
    if (currentTime >= endTime) {
      terminate();
    }
  }
}
