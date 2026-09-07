import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class ThreeDScene extends StatefulWidget {
  const ThreeDScene({
    super.key,
  });

  @override
  State<ThreeDScene> createState() =>
      _ThreeDSceneState();
}

class _ThreeDSceneState
    extends State<ThreeDScene>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  Offset _mouse = Offset.zero;
  bool _hovering = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 14,
      ),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(
    PointerHoverEvent event,
  ) {
    final RenderBox? box =
        context.findRenderObject()
            as RenderBox?;

    if (box == null) {
      return;
    }

    final Size size = box.size;

    if (size.width <= 0 ||
        size.height <= 0) {
      return;
    }

    final double x =
        ((event.localPosition.dx /
                    size.width) *
                2) -
            1;

    final double y =
        ((event.localPosition.dy /
                    size.height) *
                2) -
            1;

    setState(() {
      _mouse = Offset(
        x.clamp(-1.0, 1.0),
        y.clamp(-1.0, 1.0),
      );
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _hovering = true;
        });
      },
      onHover: _handleHover,
      onExit: (_) {
        setState(() {
          _hovering = false;
          _mouse = Offset.zero;
        });
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (
          context,
          child,
        ) {
          final double t =
              _controller.value *
                  math.pi *
                  2;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(
                3,
                2,
                0.0013,
              )
              ..rotateX(
                -_mouse.dy * 0.22,
              )
              ..rotateY(
                _mouse.dx * 0.22,
              ),
            child: AnimatedScale(
              scale:
                  _hovering ? 1.02 : 1.0,
              duration:
                  const Duration(
                milliseconds: 220,
              ),
              curve:
                  Curves.easeOutCubic,
              child: CustomPaint(
                painter:
                    _ThreeDScenePainter(
                  time: t,
                  mouse: _mouse,
                  hovering: _hovering,
                ),
                child:
                    const SizedBox.expand(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ThreeDScenePainter
    extends CustomPainter {
  final double time;
  final Offset mouse;
  final bool hovering;

  const _ThreeDScenePainter({
    required this.time,
    required this.mouse,
    required this.hovering,
  });

  static const Color pink =
      Color(0xFFFF4FA3);

  static const Color purple =
      Color(0xFF815CFF);

  static const Color blue =
      Color(0xFF5C7CFF);

  static const Color lime =
      Color(0xFFB8F44A);

  static const Color white =
      Color(0xFFF5F1FF);

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final Offset center = Offset(
      size.width * 0.50,
      size.height * 0.51,
    );

    _drawAtmosphere(
      canvas,
      size,
      center,
    );

    _drawOrbit(
      canvas,
      center,
      size.width * 0.29,
      size.height * 0.16,
      -0.20,
      time * 0.55,
    );

    _drawOrbit(
      canvas,
      center,
      size.width * 0.31,
      size.height * 0.12,
      0.75,
      -time * 0.42,
    );

    _drawOrbit(
      canvas,
      center,
      size.width * 0.22,
      size.height * 0.27,
      0.15,
      time * 0.34,
    );

    _drawParticles(
      canvas,
      size,
    );

    _drawCodeCube(
      canvas,
      center,
      size,
    );

    _drawGlowDot(
      canvas,
      Offset(
        size.width * 0.18,
        size.height * 0.34,
      ),
      pink,
      7,
    );

    _drawGlowDot(
      canvas,
      Offset(
        size.width * 0.82,
        size.height * 0.32,
      ),
      lime,
      6,
    );

    _drawGlowDot(
      canvas,
      Offset(
        size.width * 0.76,
        size.height * 0.77,
      ),
      blue,
      6,
    );

    _drawGlowDot(
      canvas,
      Offset(
        size.width * 0.29,
        size.height * 0.78,
      ),
      const Color(
        0xFFFFC83D,
      ),
      5,
    );
  }

  void _drawAtmosphere(
    Canvas canvas,
    Size size,
    Offset center,
  ) {
    final Paint glow = Paint()
      ..shader = RadialGradient(
        colors: [
          purple.withValues(alpha: 0.09),
          pink.withValues(alpha: 0.025),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: center,
          radius:
              size.width * 0.40,
        ),
      );

    canvas.drawCircle(
      center,
      size.width * 0.40,
      glow,
    );

    final Paint glow2 = Paint()
      ..shader = RadialGradient(
        colors: [
          blue.withValues(alpha: 0.045),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(
            size.width * 0.70,
            size.height * 0.40,
          ),
          radius:
              size.width * 0.24,
        ),
      );

    canvas.drawCircle(
      Offset(
        size.width * 0.70,
        size.height * 0.40,
      ),
      size.width * 0.24,
      glow2,
    );
  }

  void _drawOrbit(
    Canvas canvas,
    Offset center,
    double rx,
    double ry,
    double tilt,
    double rotation,
  ) {
    final Path path = Path();

    const int points = 180;

    for (int i = 0;
        i <= points;
        i++) {
      final double angle =
          (i / points) *
              math.pi *
              2;

      final double x =
          math.cos(angle) * rx;

      final double y =
          math.sin(angle) * ry;

      final double tx =
          x * math.cos(tilt) -
              y * math.sin(tilt);

      final double ty =
          x * math.sin(tilt) +
              y * math.cos(tilt);

      final double finalX =
          tx * math.cos(rotation) -
              ty * math.sin(rotation);

      final double finalY =
          tx * math.sin(rotation) +
              ty * math.cos(rotation);

      final Offset point = Offset(
        center.dx + finalX,
        center.dy + finalY,
      );

      if (i == 0) {
        path.moveTo(
          point.dx,
          point.dy,
        );
      } else {
        path.lineTo(
          point.dx,
          point.dy,
        );
      }
    }

    final Paint paint = Paint()
      ..style =
          PaintingStyle.stroke
      ..strokeWidth = 1.15
      ..color =
          white.withValues(
        alpha: 0.48,
      );

    canvas.drawPath(
      path,
      paint,
    );
  }

  void _drawParticles(
    Canvas canvas,
    Size size,
  ) {
    final math.Random random =
        math.Random(2026);

    for (int i = 0;
        i < 72;
        i++) {
      final double x =
          random.nextDouble() *
              size.width;

      final double y =
          random.nextDouble() *
              size.height;

      final double pulse =
          (math.sin(
                    time *
                            (0.7 +
                                random
                                    .nextDouble()) +
                        i,
                  ) +
                  1) /
              2;

      final double opacity =
          0.18 +
              pulse * 0.30;

      final double radius =
          0.6 +
              random.nextDouble() *
                  1.8;

      final Paint paint = Paint()
        ..color =
            white.withValues(
          alpha: opacity,
        );

      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint,
      );
    }
  }

  void _drawCodeCube(
    Canvas canvas,
    Offset center,
    Size size,
  ) {
    final double floatY =
        math.sin(time * 1.05) *
            9;

    final Offset c = Offset(
      center.dx +
          mouse.dx * 10,
      center.dy +
          floatY +
          mouse.dy * 8,
    );

    final double scale =
        size.width < 500
            ? 0.78
            : 1.0;

    final double w =
        185 * scale;

    final double h =
        185 * scale;

    final double depth =
        52 * scale;

    final Path front =
        Path()
          ..moveTo(
            c.dx - w / 2,
            c.dy - h / 2,
          )
          ..lineTo(
            c.dx + w / 2,
            c.dy - h / 2,
          )
          ..lineTo(
            c.dx + w / 2,
            c.dy + h / 2,
          )
          ..lineTo(
            c.dx - w / 2,
            c.dy + h / 2,
          )
          ..close();

    final Path side =
        Path()
          ..moveTo(
            c.dx + w / 2,
            c.dy - h / 2,
          )
          ..lineTo(
            c.dx + w / 2 + depth,
            c.dy - h / 2 + 40 * scale,
          )
          ..lineTo(
            c.dx + w / 2 + depth,
            c.dy + h / 2 + 40 * scale,
          )
          ..lineTo(
            c.dx + w / 2,
            c.dy + h / 2,
          )
          ..close();

    final Paint outerGlow = Paint()
      ..color =
          pink.withValues(
        alpha:
            hovering ? 0.24 : 0.15,
      )
      ..maskFilter =
          const MaskFilter.blur(
        BlurStyle.normal,
        35,
      );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: c,
          width: w + 18,
          height: h + 18,
        ),
        Radius.circular(
          24 * scale,
        ),
      ),
      outerGlow,
    );

    final Paint sidePaint = Paint()
      ..shader =
          const LinearGradient(
        colors: [
          Color(0xFF6C5FFF),
          Color(0xFF3E75FF),
        ],
        begin:
            Alignment.topLeft,
        end:
            Alignment.bottomRight,
      ).createShader(
        Rect.fromLTWH(
          c.dx,
          c.dy - h / 2,
          depth,
          h + 40,
        ),
      );

    canvas.drawPath(
      side,
      sidePaint,
    );

    final Paint frontPaint = Paint()
      ..shader =
          const LinearGradient(
        colors: [
          Color(0xFFE34899),
          Color(0xFF824BFF),
        ],
        begin:
            Alignment.topLeft,
        end:
            Alignment.bottomRight,
      ).createShader(
        Rect.fromLTWH(
          c.dx - w / 2,
          c.dy - h / 2,
          w,
          h,
        ),
      );

    canvas.drawPath(
      front,
      frontPaint,
    );

    final Rect screen =
        Rect.fromCenter(
      center: Offset(
        c.dx,
        c.dy + 4 * scale,
      ),
      width:
          105 * scale,
      height:
          116 * scale,
    );

    final Paint screenPaint =
        Paint()
          ..color =
              const Color(
            0xFF201735,
          );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        screen,
        Radius.circular(
          13 * scale,
        ),
      ),
      screenPaint,
    );

    final Paint linePink =
        Paint()
          ..color =
              pink.withValues(
            alpha: 0.90,
          )
          ..strokeWidth =
              3 * scale
          ..strokeCap =
              StrokeCap.round;

    final Paint lineLime =
        Paint()
          ..color =
              lime.withValues(
            alpha: 0.92,
          )
          ..strokeWidth =
              3 * scale
          ..strokeCap =
              StrokeCap.round;

    final Paint lineWhite =
        Paint()
          ..color =
              white.withValues(
            alpha: 0.72,
          )
          ..strokeWidth =
              2.5 * scale
          ..strokeCap =
              StrokeCap.round;

    final Paint linePurple =
        Paint()
          ..color =
              purple.withValues(
            alpha: 0.92,
          )
          ..strokeWidth =
              2.7 * scale
          ..strokeCap =
              StrokeCap.round;

    final double left =
        screen.left +
            18 * scale;

    final double right =
        screen.right -
            18 * scale;

    canvas.drawLine(
      Offset(
        left,
        screen.top +
            22 * scale,
      ),
      Offset(
        left +
            34 * scale,
        screen.top +
            22 * scale,
      ),
      lineLime,
    );

    canvas.drawLine(
      Offset(
        left,
        screen.top +
            40 * scale,
      ),
      Offset(
        left +
            58 * scale,
        screen.top +
            40 * scale,
      ),
      linePink,
    );

    canvas.drawLine(
      Offset(
        left,
        screen.top +
            58 * scale,
      ),
      Offset(
        left +
            43 * scale,
        screen.top +
            58 * scale,
      ),
      lineWhite,
    );

    canvas.drawLine(
      Offset(
        left,
        screen.top +
            76 * scale,
      ),
      Offset(
        left +
            62 * scale,
        screen.top +
            76 * scale,
      ),
      linePurple,
    );

    canvas.drawLine(
      Offset(
        left,
        screen.top +
            94 * scale,
      ),
      Offset(
        right,
        screen.top +
            94 * scale,
      ),
      lineWhite,
    );

    final TextPainter codePainter =
        TextPainter(
      text:
          const TextSpan(
        text:
            '</>',
        style:
            TextStyle(
          color:
              white,
          fontSize:
              42,
          fontWeight:
              FontWeight.w900,
          letterSpacing:
              -3,
        ),
      ),
      textDirection:
          TextDirection.ltr,
    )..layout();

    canvas.save();

    canvas.translate(
      c.dx -
          codePainter.width /
              2,
      c.dy -
          codePainter.height /
              2 +
          7 * scale,
    );

    canvas.scale(
      scale,
      scale,
    );

    codePainter.paint(
      canvas,
      Offset.zero,
    );

    canvas.restore();

    final Paint shine =
        Paint()
          ..shader =
              LinearGradient(
            colors: [
              Colors.white.withValues(
                alpha: 0.20,
              ),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromLTWH(
              c.dx - w / 2,
              c.dy - h / 2,
              w * 0.75,
              h * 0.45,
            ),
          );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          c.dx - w / 2,
          c.dy - h / 2,
          w,
          h * 0.35,
        ),
        Radius.circular(
          20 * scale,
        ),
      ),
      shine,
    );
  }

  void _drawGlowDot(
    Canvas canvas,
    Offset center,
    Color color,
    double radius,
  ) {
    final Paint glow = Paint()
      ..color =
          color.withValues(
        alpha: 0.18,
      )
      ..maskFilter =
          const MaskFilter.blur(
        BlurStyle.normal,
        12,
      );

    canvas.drawCircle(
      center,
      radius * 2.5,
      glow,
    );

    final Paint dot = Paint()
      ..color = color;

    canvas.drawCircle(
      center,
      radius,
      dot,
    );
  }

  @override
  bool shouldRepaint(
    covariant _ThreeDScenePainter
        oldDelegate,
  ) {
    return oldDelegate.time !=
            time ||
        oldDelegate.mouse !=
            mouse ||
        oldDelegate.hovering !=
            hovering;
  }
}