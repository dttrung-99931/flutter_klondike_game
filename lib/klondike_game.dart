import 'package:flame/game.dart';
import 'package:klondike_flutter_game/klondike_world.dart';

class KlondikeGame extends FlameGame {
  KlondikeGame() : super(world: KlondikeWorld());

  static const double cardWdith = 1000;
  static const double cardHeight = 1400;
  static const double cardGap = 200;
  static const double cardRadius = 100;
  static final Vector2 cardSize = Vector2(cardWdith, cardHeight);
  // Number of cards facing up at the waste pile
  static const int drawCards = 1;
}
