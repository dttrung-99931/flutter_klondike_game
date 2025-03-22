import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:klondike_flutter_game/components/pipe.dart';
import 'package:klondike_flutter_game/components/rank.dart';
import 'package:klondike_flutter_game/components/suit.dart';
import 'package:klondike_flutter_game/klondike_game.dart';
import 'package:klondike_flutter_game/utils/extensions/list_ext.dart';
import 'package:klondike_flutter_game/utils/utils.dart';

class Card extends PositionComponent with DragCallbacks {
  Card({
    required int rankValue,
    required int suitValue,
  })  : rank = Rank.fromInt(rankValue),
        suit = Suit.fromInt(suitValue),
        _faceUp = false,
        super(size: KlondikeGame.cardSize);

  static final RRect cardRrect = RRect.fromRectAndRadius(
    KlondikeGame.cardSize.toRect(),
    Radius.circular(KlondikeGame.cardRadius),
  );

  // Front
  static final Paint frontBackgroundPaint = Paint()
    ..color = const Color(0xff000000);
  static final Paint redBorderPaint = Paint()
    ..color = const Color(0xffece8a3)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10;
  static final Paint blackBorderPaint = Paint()
    ..color = const Color(0xff7ab2e8)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10;
  static final blueFilter = Paint()
    ..colorFilter = const ColorFilter.mode(
      Color(0x880d8bff),
      BlendMode.srcATop,
    );
  static final Sprite blackJack = klondikeSprite(81, 565, 562, 488)
    ..paint = blueFilter;
  static final Sprite blackQueen = klondikeSprite(717, 541, 486, 515)
    ..paint = blueFilter;
  static final Sprite blackKing = klondikeSprite(1305, 532, 407, 549)
    ..paint = blueFilter;
  static final Sprite redJack = klondikeSprite(81, 565, 562, 488);
  static final Sprite redQueen = klondikeSprite(717, 541, 486, 515);
  static final Sprite redKing = klondikeSprite(1305, 532, 407, 549);

  // Back
  static final Paint backBorderPaint1 = Paint()
    ..color = const Color(0xffdbaf58)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10;
  static final Paint backBorderPaint2 = Paint()
    ..color = const Color(0x5CEF971B)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 35;
  static final Paint backBackgroundPaint = Paint()
    ..color = const Color(0xff380c02);
  static final Sprite flameSprint = klondikeSprite(1370, 6, 356, 501);

  final Rank rank;
  final Suit suit;
  Pile? pipe;
  bool _faceUp;
  bool get faceUp => _faceUp;

  bool get isFaceUp => _faceUp;
  bool get isFaceDown => !_faceUp;
  void flip() => _faceUp = !_faceUp;

  Sprite get rankSprite => suit.isBlack ? rank.blackSprite : rank.redSprite;
  Sprite get suitSprite => suit.sprite;

  bool get canMoveCard => pipe != null && pipe!.canMoveCard(this);

  @override
  String toString() {
    return rank.label + suit.label;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (_faceUp) {
      _renderFront(canvas);
    } else {
      _renderBack(canvas);
    }
  }

  void _renderFront(Canvas canvas) {
    canvas.drawRRect(cardRrect, frontBackgroundPaint);
    canvas.drawRRect(
      cardRrect,
      suit.isRed ? redBorderPaint : blackBorderPaint,
    );
    _drawSprint(canvas, rankSprite, 0.11, 0.1);
    _drawSprint(canvas, suitSprite, 0.11, 0.21, scale: 0.45);
    _drawSprint(canvas, rankSprite, 0.11, 0.1, rotate: true);
    _drawSprint(canvas, suitSprite, 0.11, 0.21, rotate: true, scale: 0.45);
    _renderRank(canvas, rank.value);
  }

  void _renderRank(Canvas canvas, int rankValue) {
    switch (rankValue) {
      case 1:
        _drawSprint(canvas, suitSprite, 0.5, 0.5, scale: 1.3);
        break;
      case 2:
        _drawSprint(canvas, suitSprite, 0.5, 0.15);
        _drawSprint(canvas, suitSprite, 0.5, 0.15, rotate: true);
        break;
      case 3:
        _renderRank(canvas, 2);
        _drawSprint(canvas, suitSprite, 0.5, 0.5, scale: 1.3);
        break;
      case 4:
        _drawSprint(canvas, suitSprite, 0.3, 0.18);
        _drawSprint(canvas, suitSprite, 0.7, 0.18);
        _drawSprint(canvas, suitSprite, 0.3, 0.18, rotate: true);
        _drawSprint(canvas, suitSprite, 0.7, 0.18, rotate: true);
        break;
      case 5:
        _renderRank(canvas, 4);
        _drawSprint(canvas, suitSprite, 0.5, 0.5);
        break;
      case 6:
        _renderRank(canvas, 4);
        _drawSprint(canvas, suitSprite, 0.3, 0.5);
        _drawSprint(canvas, suitSprite, 0.7, 0.5);
        break;
      case 7:
        _renderRank(canvas, 6);
        _drawSprint(canvas, suitSprite, 0.5, 0.3);
        break;
      case 8:
        _renderRank(canvas, 7);
        _drawSprint(canvas, suitSprite, 0.5, 0.6);
        break;
      case 9:
        _renderRank(canvas, 4);
        _drawSprint(canvas, suitSprite, 0.3, 0.38);
        _drawSprint(canvas, suitSprite, 0.7, 0.38);
        _drawSprint(canvas, suitSprite, 0.5, 0.5);
        _drawSprint(canvas, suitSprite, 0.3, 0.38, rotate: true);
        _drawSprint(canvas, suitSprite, 0.7, 0.38, rotate: true);
        break;
      case 10:
        _renderRank(canvas, 4);
        _drawSprint(canvas, suitSprite, 0.3, 0.38);
        _drawSprint(canvas, suitSprite, 0.7, 0.38);
        _drawSprint(canvas, suitSprite, 0.5, 0.3);
        _drawSprint(canvas, suitSprite, 0.5, 0.7);
        _drawSprint(canvas, suitSprite, 0.3, 0.38, rotate: true);
        _drawSprint(canvas, suitSprite, 0.7, 0.38, rotate: true);
      case 11:
        _drawSprint(canvas, suit.isBlack ? blackJack : redJack, 0.5, 0.5);
        break;
      case 12:
        _drawSprint(canvas, suit.isBlack ? blackQueen : redQueen, 0.5, 0.5);
        break;
      case 13:
        _drawSprint(canvas, suit.isBlack ? blackKing : redKing, 0.5, 0.5);
        break;
    }
  }

  void _drawSprint(
    Canvas canvas,
    Sprite sprite,
    double relativeX,
    double relativeY, {
    bool rotate = false,
    double scale = 1,
  }) {
    if (rotate) {
      canvas.save();
      canvas.translate(size.x / 2, size.y / 2);
      canvas.rotate(pi);
      canvas.translate(-size.x / 2, -size.y / 2);
    }

    sprite.render(
      canvas,
      position: Vector2(
        size.x * relativeX,
        size.y * relativeY,
      ),
      size: sprite.srcSize.scaled(scale),
      anchor: Anchor.center,
    );

    if (rotate) {
      canvas.restore();
    }
  }

  void _renderBack(Canvas canvas) {
    canvas.drawRRect(cardRrect, backBackgroundPaint);
    canvas.drawRRect(cardRrect, backBorderPaint1);
    canvas.drawRRect(cardRrect, backBorderPaint2);
    flameSprint.render(canvas, position: size / 2, anchor: Anchor.center);
  }

  bool isNextRankAndOppositeSuitOf(Card card) {
    return rank.value == card.rank.value + 1 &&
        suit.isBlack != card.suit.isBlack;
  }

  bool isNextRankAndMatchSuitOf(Card card) {
    return rank.value == card.rank.value + 1 && suit.value == card.suit.value;
  }

  @override
  void onDragStart(DragStartEvent event) {
    if (canMoveCard) {
      priority = 100;
      super.onDragStart(event);
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (isDragged) {
      position += event.localDelta;
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (isDragged) {
      super.onDragEnd(event);
      final dropPiles = parent!
          .componentsAtPoint(position + size / 2)
          .whereType<Pile>()
          .toList();
      final Pile? destPile =
          dropPiles.firstWhereOrNull((pile) => pile.canAcceptCard(this));
      if (destPile != null) {
        pipe?.removeCard(this);
        destPile.addCard(this);
      } else {
        pipe?.returnCard(this);
      }
    }
  }
}
