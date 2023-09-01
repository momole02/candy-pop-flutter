import 'package:candy_pop_flutter/sprites/piece_spr.dart';
import 'package:candy_pop_flutter/state/constants.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

/// Types de piece
enum PieceType {
  clover,
  heart,
  moon,
  star,
  water,
}

/// Coordonnées entières
class Coords {
  int i;
  int j;
  Coords(this.i, this.j);
}

/// Implémentation de l'état du jeu
class GameState {
  /// Association entre AABBs et pieces
  /// Un indice pieces[i] = sprite à l'AABB[i]
  List<PieceSprite?> pieces;

  GameState({
    required this.pieces,
  });

  PieceSprite? pieceAt(int i, int j) {
    return pieces[i + j * kPieceCountWidth];
  }

  /// Calcul l'état du jeu en fonction des sprites
  factory GameState.computeFromSprites({
    required List<Aabb2> aabbs,
    required List<PieceSprite> sprites,
  }) {
    return GameState(
      pieces: List.generate(
        aabbs.length,
        (index) => _spriteAt(aabbs[index], sprites),
      ),
    );
  }
}

Aabb2 _spriteAaabb(PieceSprite sprite) {
  return Aabb2.minMax(sprite.position, sprite.position + sprite.size);
}

PieceSprite? _spriteAt(Aabb2 aabb, List<PieceSprite> sprites) {
  return sprites
      .where((sprite) => aabb.containsVector2(sprite.center))
      .firstOrNull;
}

/// Implémentation de l'algorithme
/// du flood fill pour le dropping des pièces
class FloodFillContext {
  GameState state;

  FloodFillContext(this.state);

  /// Retourne les points autour d'un autre
  List<Coords> _around(int i, int j) {
    return [
      //Coords(i - 1, j - 1),
      Coords(i, j - 1),
      //Coords(i + 1, j - 1),
      Coords(i - 1, j),
      Coords(i + 1, j),
      //Coords(i - 1, j + 1),
      Coords(i, j + 1),
      //Coords(i + 1, j + 1),
    ];
  }

  /// Effectue l'algorithme de Flood Fill
  ///
  List<PieceSprite> compute(int i, int j) {
    PieceSprite? selected = state.pieceAt(i, j);
    List<PieceSprite> sprites = [];
    if (selected == null) {
      return [];
    }
    List<Coords> queue = [
      Coords(i, j),
    ];
    while (queue.isNotEmpty) {
      Coords top = queue[0];
      queue.removeAt(0);
      if (top.i >= 0 &&
          top.j >= 0 &&
          top.i <= kPieceCountWidth - 1 &&
          top.j <= kPieceCountHeight - 1) {
        PieceSprite? spr = state.pieceAt(top.i, top.j);
        if (spr != null &&
            spr.pieceType == selected.pieceType &&
            !sprites.contains(spr)) {
          sprites.add(spr);
          queue.addAll(_around(top.i, top.j));
        }
      }
    }
    return sprites;
  }
}
