import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:klondike_flutter_game/components/card.dart';
import 'package:klondike_flutter_game/components/pipe.dart';
import 'package:klondike_flutter_game/components/waste_pile.dart';
import 'package:klondike_flutter_game/klondike_game.dart';

class StockPile extends Pile with TapCallbacks, HasGameReference<KlondikeGame> {
  StockPile({super.position}) : super(size: KlondikeGame.cardSize);

  final List<Card> _cards = [];
  final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..color = const Color(0xFF3F5B5D);
  final _circlePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 100
    ..color = const Color(0x883F5B5D);

  @override
  void addCard(Card card) {
    assert(card.isFaceDown);
    card.position = position;
    card.priority = _cards.length;
    card.pile = this;
    _cards.add(card);
  }

  @override
  void onTapUp(TapUpEvent event) {
    final wastePile = parent!.firstChild<WastePile>()!;

    // If stock empty then move all cards from waste pile back to stock pile
    if (_cards.isEmpty) {
      wastePile.removeAllCards().reversed.forEach(
        (card) {
          card.flip();
          addCard(card);
        },
      );
      return;
    }

    // Move cards from stock pile to waste pile
    for (int i = 0; i < game.cardNumTakeFromStock; i++) {
      final wasteCard = _cards.removeLast();
      wasteCard.moveToAndTurnFaceUp(
        to: wastePile.position,
        onComplete: () {
          wastePile.addCard(wasteCard);
        },
      );
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(Card.cardRrect, _borderPaint);
    canvas.drawCircle(Offset(width / 2, height / 2), 100, _circlePaint);
  }

  @override
  bool canMoveCard(Card card) {
    return false;
  }

  @override
  bool canAcceptCard(Card card) {
    return false;
  }

  @override
  void removeCard(Card card) {
    throw StateError('Cannot remove card from stock pile');
  }

  @override
  void returnCard(Card card) {
    throw StateError('Cannot return card to stock pile');
  }
}
