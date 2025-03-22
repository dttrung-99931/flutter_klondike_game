import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:klondike_flutter_game/components/card.dart';
import 'package:klondike_flutter_game/components/foundation.dart';
import 'package:klondike_flutter_game/components/pile.dart';
import 'package:klondike_flutter_game/components/stock.dart';
import 'package:klondike_flutter_game/components/waste.dart';
import 'package:klondike_flutter_game/constants/constants.dart';

class KlondikeGame extends FlameGame {
  static const double cardWdith = 1000;
  static const double cardHeight = 1400;
  static const double cardGap = 175;
  static const double cardRadius = 100;
  static final Vector2 cardSize = Vector2(cardWdith, cardHeight);

  // Called when flutter game instance attached to the widget tree for loading data
  @override
  Future<void> onLoad() async {
    // Load sprites image into cache to reuse globally
    // Alternative: Gmaes.images
    await Flame.images.load(Assets.klondikeSprintes);

    final stock = Stock()
      ..size = cardSize
      ..position = Vector2(cardGap, cardGap)
      ..debugColor = Colors.green;

    final waste = Waste()
      ..size = cardSize
      ..position = Vector2(cardWdith + cardGap * 2, cardGap)
      ..debugColor = Colors.red;

    final foundations = List.generate(4, (index) {
      return Foundation()
        ..size = cardSize
        ..position = Vector2(
          (cardWdith + cardGap) * (3 + index),
          cardGap,
        );
    });

    final piles = List.generate(7, (index) {
      return Pile()
        ..size = cardSize
        ..position = Vector2(
          cardGap / 2 + (cardGap + cardWdith) * index,
          cardHeight * 3,
        );
    });

    // world.add reutrn futurre. Add await if need to wait for the compoennt to be loaded completely
    // world.add(stock);
    // world.add(waste);
    // world.addAll(foundations);
    // world.addAll(piles);

    final random = Random();

    for (int i = 0; i < 7; i++) {
      for (int j = 0; j < 4; j++) {
        final suit = random.nextInt(4);
        final level = (i * 7 + j) % 13 + 1;
        final faceUp = random.nextBool();
        final card = Card(
          rankValue: level,
          suitValue: suit,
        )..position =
            Vector2(i * (cardWdith + cardGap), (cardHeight + cardGap) * j);
        // if (faceUp) {
        card.flip();
        // }
        world.add(card);
      }
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
