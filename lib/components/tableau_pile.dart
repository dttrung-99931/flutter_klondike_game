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
  final _bigFanOffset = Vector2(0, KlondikeGame.cardSize.y * 0.13);
  final _fanOffset = Vector2(0, KlondikeGame.cardSize.y * 0.05);

  @override
  void addCard(Card card) {
    card.position = _calcCardPosition(_cards.length);
    card.priority = _cards.length;
    card.pile = this;
    _cards.add(card);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(Card.cardRrect, _borderPaint);
  }

  void flipTopCard({double deplayedSecs = 0}) {
    if (_cards.isNotEmpty) {
      _cards.last.turnFaceUp(start: deplayedSecs);
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
    card.pile = null;
  }

  Vector2 _calcCardPosition(int cardIndex) {
    assert(cardIndex >= 0 && cardIndex <= _cards.length);
    if (cardIndex == 0) {
      return position;
    }
    var prevCard = _cards[cardIndex - 1];
    Vector2 fanOffset = prevCard.isFaceUp ? _bigFanOffset : _fanOffset;
    return prevCard.position + fanOffset;
  }

  @override
  void returnCard(Card card) {
    final index = _cards.indexOf(card);
    card.position = _calcCardPosition(index);
    card.priority = index;
  }

  List<Card> getDraggingCards(Card draggedCard) {
    final index = _cards.indexOf(draggedCard);
    return _cards.sublist(index);
  }
}
