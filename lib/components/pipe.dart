import 'package:flame/components.dart';
import 'package:klondike_flutter_game/components/card.dart';

abstract class Pile extends PositionComponent {
  Pile({super.position, super.size});
  bool canMoveCard(Card card);
  bool canAcceptCard(Card card);
  void addCard(Card card);
  void removeCard(Card card);
  void returnCard(Card card);
}
