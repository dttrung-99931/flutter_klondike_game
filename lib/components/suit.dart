// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:klondike_flutter_game/utils/utils.dart';

@immutable
class Suit {
  final int value;
  final Sprite sprite; // For drawing suit on canvas
  final String label;

  static final _singletons = [
    Suit._(value: 0, label: '♥', x: 1176, y: 17, width: 172, height: 183),
    Suit._(value: 1, label: '♦', x: 973, y: 14, width: 177, height: 182),
    Suit._(value: 2, label: '♣', x: 974, y: 226, width: 184, height: 172),
    Suit._(value: 3, label: '♠', x: 1178, y: 220, width: 176, height: 182),
  ];

  factory Suit.fromInt(int value) {
    assert(value >= 0 && value <= 3);
    return _singletons[value];
  }

  Suit._({
    required this.value,
    required this.label,
    required double x,
    required double y,
    required double width,
    required double height,
  }) : sprite = klondikeSprite(x, y, width, height);

  bool get isBlack => value >= 2;
  bool get isRed => value <= 1;
}
