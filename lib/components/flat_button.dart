import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class FlatButton extends ButtonComponent {
  FlatButton(
    String text, {
    super.size,
    super.onReleased,
    super.position,
    Anchor anchor = Anchor.center,
  }) : super(
          button: ButtonBackground(const Color(0xffece8a3)),
          buttonDown: ButtonBackground(Colors.red),
          children: [
            TextComponent(
              text: text,
              textRenderer: TextPaint(
                  style: TextStyle(
                fontSize: 0.5 * size!.y,
                fontWeight: FontWeight.bold,
                color: const Color(0xffdbaf58),
              )),
              position: size / 2.0,
              anchor: Anchor.center,
            )
          ],
          anchor: anchor,
        );
}

class ButtonBackground extends PositionComponent with HasAncestor<FlatButton> {
  ButtonBackground(Color color) {
    _paint.color = color;
  }

  final _paint = Paint()..style = PaintingStyle.stroke;
  late double radius;
  late final _bg =
      RRect.fromRectAndRadius(size.toRect(), Radius.circular(radius));

  @override
  void onMount() {
    super.onMount();
    radius = size.y * 0.3;
    _paint.strokeWidth = size.y * 0.05;
    size = ancestor.size;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(_bg, _paint);
  }
}
