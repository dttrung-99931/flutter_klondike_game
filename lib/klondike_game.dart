import 'dart:math';

import 'package:flame/game.dart';
import 'package:klondike_flutter_game/klondike_world.dart';

class KlondikeGame extends FlameGame {
  KlondikeGame() : super(world: KlondikeWorld());

  static const double cardWdith = 1000;
  static const double cardHeight = 1400;
  static const double cardGap = 200;
  static const double cardRadius = 100;
  static final Vector2 cardSize = Vector2(cardWdith, cardHeight);

  int _cardNumTakeFromStock = 1;
  int get cardNumTakeFromStock => _cardNumTakeFromStock;

  Random _random = Random();
  Random get radom => _random;

  void restart({
    int cardNumTakeFromStock = 1,
    bool changeRandom = false,
  }) {
    _cardNumTakeFromStock = cardNumTakeFromStock;
    if (changeRandom) {
      _random = _createRandom();
    }
    world = KlondikeWorld();
  }

  Random _createRandom() {
    return Random(Random().nextInt(1000));
  }
}
