import 'package:flame/components.dart';
import 'package:klondike_flutter_game/components/card.dart';
import 'package:klondike_flutter_game/components/pipe.dart';
import 'package:klondike_flutter_game/klondike_game.dart';

class WastePile extends Pile {
  final Vector2 _fanOffset = Vector2(0, KlondikeGame.cardHeight * 0.01);
  final Vector2 _bigFanOffset = Vector2(0, KlondikeGame.cardHeight * 0.18);
  final List<Card> _cards = [];
  List<Card> get cards => _cards;

  @override
  void addCard(Card card) {
    assert(card.isFaceUp);
    card.position = position;
    card.priority = _cards.length;
    _cards.add(card);
    card.pipe = this;
    _fanOutTopCards();
  }

  void _fanOutTopCards() {
    final n = _cards.length;
    for (int i = 1; i < n; i++) {
      _cards[i].position = _cards[i - 1].position +
          (i != 0 && i >= n - 2 ? _bigFanOffset : _fanOffset);
    }
  }

  List<Card> removeAllCards() {
    final cards = _cards.toList();
    _cards.clear();
    return cards;
  }

  @override
  bool canMoveCard(Card card) {
    return _cards.isNotEmpty && _cards.last == card;
  }

  @override
  bool canAcceptCard(Card card) {
    return false;
  }

  @override
  void removeCard(Card card) {
    assert(canMoveCard(card));
    card.pipe = null;
    _cards.removeLast();
    _fanOutTopCards();
  }

  @override
  void returnCard(Card card) {
    final index = _cards.indexOf(card);
    card.priority = index;
    card.position =
        index > 0 ? _cards[index - 1].position + _bigFanOffset : position;
  }
}
