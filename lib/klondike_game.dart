import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:klondike_flutter_game/components/card.dart';
import 'package:klondike_flutter_game/components/foundation_pile.dart';
import 'package:klondike_flutter_game/components/stock_pile.dart';
import 'package:klondike_flutter_game/components/tableau_pile.dart';
import 'package:klondike_flutter_game/components/waste_pile.dart';
import 'package:klondike_flutter_game/constants/constants.dart';

class KlondikeGame extends FlameGame {
  static const double cardWdith = 1000;
  static const double cardHeight = 1400;
  static const double cardGap = 200;
  static const double cardRadius = 100;
  static final Vector2 cardSize = Vector2(cardWdith, cardHeight);
  // Number of cards facing up at the waste pile
  static const int drawCards = 1;

  // Called when flutter game instance attached to the widget tree for loading data
  @override
  Future<void> onLoad() async {
    // Load sprites image into cache to reuse globally
    // Alternative: Gmaes.images
    await Flame.images.load(Assets.klondikeSprintes);

    final stock = StockPile()
      ..size = cardSize
      ..position = Vector2(cardGap, cardGap * 2);

    final waste = WastePile()
      ..size = cardSize
      ..position = Vector2(cardWdith + cardGap * 2, cardGap * 2);

    final foundations = List.generate(4, (index) {
      return FoundationPile(index)
        ..size = cardSize
        ..position = Vector2(
          (cardWdith + cardGap) * (3 + index),
          cardGap * 2,
        );
    });

    final piles = List.generate(7, (index) {
      return TableauPile()
        ..size = cardSize
        ..position = Vector2(
          cardGap / 2 + (cardGap + cardWdith) * index,
          cardHeight * 2,
        );
    });

    // reutrn futurre. Add await if need to wait for the compoennt to be loaded completely
    world.add;
    world.add(stock);
    world.add(waste);
    world.addAll(foundations);
    world.addAll(piles);

    // Create cards
    final cards = List.generate(52, (index) {
      final rank = index % 13 + 1;
      final suit = index ~/ 13;
      final card = Card(rankValue: rank, suitValue: suit);
      return card;
    });
    cards.shuffle();
    world.addAll(cards);

    // Add cards to 7 piles
    int cardToAdd = cards.length - 1;
    for (int i = 0; i < 7; i++) {
      for (int j = i; j < 7; j++) {
        piles[j].addCard(cards[cardToAdd--]);
      }
      piles[i].flipTopCard();
    }

    // Add remaning cards to stock pile
    for (int i = cardToAdd; i >= 0; i--) {
      stock.addCard(cards[i]);
    }

    camera.viewfinder.visibleGameSize = Vector2(
      cardWdith * 7 + cardGap * 8,
      cardHeight * 4 + cardGap * 3,
    );
    camera.viewfinder.position = Vector2(
      camera.viewfinder.visibleGameSize!.x / 2,
      0,
    );
    camera.viewfinder.anchor = Anchor.topCenter;
  }
}
