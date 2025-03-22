import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:klondike_flutter_game/components/card.dart';
import 'package:klondike_flutter_game/components/pipe.dart';
import 'package:klondike_flutter_game/klondike_game.dart';

class TableauPile extends Pile {
  TableauPile({super.position}) : super(size: KlondikeGame.cardSize);

  final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..color = const Color(0x50ffffff);

  final List<Card> _cards = [];
  final _fanOffset = Vector2(0, KlondikeGame.cardSize.y * 0.05);

  @override
  void addCard(Card card) {
    if (_cards.isEmpty) {
      card.position = position;
    } else {
      card.position = _cards.last.position + _fanOffset;
    }
    card.priority = _cards.length;
    card.pipe = this;
    _cards.add(card);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(Card.cardRrect, _borderPaint);
  }

  void flipTopCard() {
    if (_cards.isNotEmpty) {
      _cards.last.flip();
    }
  }

  @override
  bool canMoveCard(Card card) {
    return card.isFaceUp;
  }

  @override
  bool canAcceptCard(Card card) {
    if (_cards.isEmpty) {
      return card.rank.value == 13;
    }
    return _cards.last.isNextRankAndOppositeSuitOf(card);
  }

  @override
  void removeCard(Card card) {
    assert(_cards.contains(card) && card.isFaceUp);
    final index = _cards.indexOf(card);
    _cards.removeRange(index, _cards.length);
    if (_cards.isNotEmpty && !_cards.last.isFaceUp) {
      flipTopCard();
    }
  }

  @override
  void returnCard(Card card) {
    final index = _cards.indexOf(card);
    card.priority = index;
    if (index > 0) {
      card.position = _cards[index - 1].position + _fanOffset;
    } else {
      card.position = position;
    }
  }
}
