import 'dart:ui';

import 'package:flame/components.dart';
import 'package:klondike_flutter_game/components/card.dart';
import 'package:klondike_flutter_game/components/pipe.dart';
import 'package:klondike_flutter_game/components/suit.dart';
import 'package:klondike_flutter_game/klondike_game.dart';

class FoundationPile extends Pile {
  FoundationPile(int suitValue)
      : suit = Suit.fromInt(suitValue),
        super(size: KlondikeGame.cardSize);

  final List<Card> _cards = [];
  final Suit suit;
  final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..color = const Color(0x50ffffff);
  late final _suitPaint = Paint()
    ..color = suit.isRed ? const Color(0x3a000000) : const Color(0x64000000)
    ..blendMode = BlendMode.luminosity;

  @override
  void addCard(Card card) {
    assert(card.isFaceUp);
    card.position = position;
    card.priority = _cards.length;
    card.pile = this;
    _cards.add(card);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(Card.cardRrect, _borderPaint);
    suit.sprite.render(
      canvas,
      position: size / 2,
      anchor: Anchor.center,
      size: Vector2.all(KlondikeGame.cardWdith * 0.5),
      overridePaint: _suitPaint,
    );
  }

  @override
  bool canMoveCard(Card card) {
    return false;
  }

  @override
  bool canAcceptCard(Card card) {
    if (_cards.isEmpty) {
      return card.suit == suit && card.rank.value == 1;
    }
    return card.isNextRankAndMatchSuitOf(_cards.last);
  }

  @override
  void removeCard(Card card) {
    assert(canMoveCard(card));
    _cards.removeLast();
  }

  @override
  void returnCard(Card card) {
    final index = _cards.indexOf(card);
    card.priority = index;
    card.position = position;
  }
}
