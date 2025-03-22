import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/widgets.dart';
import 'package:klondike_flutter_game/constants/constants.dart';

Sprite klondikeSprite(double x, double y, double width, double height) {
  return Sprite(
    Flame.images.fromCache(Assets.klondikeSprintes),
    srcSize: Vector2(width, height),
    srcPosition: Vector2(x, y),
  );
}
