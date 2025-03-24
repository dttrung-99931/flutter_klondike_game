import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:klondike_flutter_game/components/card.dart';
import 'package:klondike_flutter_game/components/flat_button.dart';
import 'package:klondike_flutter_game/components/foundation_pile.dart';
import 'package:klondike_flutter_game/components/stock_pile.dart';
import 'package:klondike_flutter_game/components/tableau_pile.dart';
import 'package:klondike_flutter_game/components/waste_pile.dart';
import 'package:klondike_flutter_game/constants/constants.dart';
import 'package:klondike_flutter_game/klondike_game.dart';

enum Action {
  newDeal,
  sameDeal,
  changeDraw,
  haveFun;

  String get text {
    switch (this) {
      case Action.newDeal:
        return 'New deal';
      case Action.sameDeal:
        return 'Same deal';
      case Action.changeDraw:
        return 'Change draw';
      case Action.haveFun:
        return 'Have fun';
    }
  }
}

class KlondikeWorld extends World with HasGameReference<KlondikeGame> {
  final stock = StockPile(
    position: Vector2.zero(),
  );
  final waste = WastePile(
    position: Vector2.zero(),
  );
  final List<FoundationPile> foundations = [];
  final List<TableauPile> tableaus = [];
  final List<Card> cards = [];
  Action? _action;

  @override
  Future<void> onLoad() async {
    // Load sprites image into cache to reuse globally
    // Alternative: Gmaes.images
    await Flame.images.load(Assets.klondikeSprintes);

    _addGameComponents();

    _setupCamera();

    _addActionButtons();
  }

  void _addActionButtons() {
    final space = 1200;
    final right = game.camera.viewfinder.visibleGameSize!.x;
    addActionButton(
      action: Action.haveFun,
      x: right,
      onPressed: () {},
    );
    addActionButton(
      action: Action.changeDraw,
      x: right - space,
      onPressed: () {},
    );
    addActionButton(
      action: Action.sameDeal,
      x: right - 2 * space,
      onPressed: () {
        dealCards();
      },
    );
    addActionButton(
      action: Action.newDeal,
      x: right - 3 * space,
      onPressed: () {},
    );
  }

  void dealCards() {
    assert(cards.length == 52, 'There must be 52 cands');

    cards.shuffle();

    for (int i = 0; i < cards.length; i++) {
      cards[i].priority = i;
    }

    int cardToDeal = cards.length - 1;
    int movingCards = 0;
    double delayedUnitSec = 0.15;
    for (int i = 0; i < 7; i++) {
      for (int j = i; j < 7; j++) {
        final card = cards[cardToDeal--];
        card.doMove(
          to: tableaus[j].position,
          speed: 8,
          startDelaySecs: delayedUnitSec * movingCards,
          onComplete: () {
            movingCards--;
            tableaus[j].addCard(card);
            if (movingCards > 0) {
              return;
            }
            for (int tableauIdx = 0; tableauIdx < 7; tableauIdx++) {
              tableaus[tableauIdx]
                  .flipTopCard(deplayedSecs: delayedUnitSec * tableauIdx);
            }
          },
        );
        movingCards++;
      }
    }

    // Add remaning KlondikeGame.cards to stock pile
    for (int i = cardToDeal; i >= 0; i--) {
      stock.addCard(cards[i]);
    }
  }

  void _addGameComponents() {
    // Setup compnent positions
    final paddingTop = KlondikeGame.cardGap * 3.5;
    stock.position = Vector2(KlondikeGame.cardGap, paddingTop);
    waste.position = Vector2(
      KlondikeGame.cardWdith + KlondikeGame.cardGap * 2,
      paddingTop,
    );
    foundations.addAll(
      List.generate(4, (index) {
        return FoundationPile(
          index,
          position: Vector2(
            (KlondikeGame.cardWdith + KlondikeGame.cardGap) * (3 + index),
            paddingTop,
          ),
        );
      }),
    );

    tableaus.addAll(
      List.generate(7, (index) {
        return TableauPile()
          ..size = KlondikeGame.cardSize
          ..position = Vector2(
            KlondikeGame.cardGap / 2 +
                (KlondikeGame.cardGap + KlondikeGame.cardWdith) * index,
            KlondikeGame.cardHeight * 2,
          );
      }),
    );

    // reutrn futurre. Add await if need to wait for the compoennt to be loaded completely
    add(stock);
    add(waste);
    addAll(foundations);
    addAll(tableaus);

    // Create KlondikeGame.cards
    cards.addAll(
      List.generate(52, (index) {
        final rank = index % 13 + 1;
        final suit = index ~/ 13;
        final card = Card(
          rankValue: rank,
          suitValue: suit,
          position: stock.position,
        );
        return card;
      }),
    );
    addAll(cards);

    dealCards();
  }

  void _setupCamera() {
    final camera = game.camera;
    camera.viewfinder.visibleGameSize = Vector2(
      KlondikeGame.cardWdith * 7 + KlondikeGame.cardGap * 8,
      KlondikeGame.cardHeight * 4 + KlondikeGame.cardGap * 3,
    );
    camera.viewfinder.position = Vector2(
      camera.viewfinder.visibleGameSize!.x / 2,
      0,
    );
    camera.viewfinder.anchor = Anchor.topCenter;
  }

  void addActionButton({
    required Action action,
    required double x,
    required Function() onPressed,
  }) {
    add(
      FlatButton(
        action.text,
        onReleased: onPressed,
        position: Vector2(x, KlondikeGame.cardGap * 1.5),
        size: Vector2(1000, 300),
      ),
    );
  }
}
