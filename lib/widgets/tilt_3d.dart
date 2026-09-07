import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Tilt3D extends StatefulWidget {
  final Widget child;

  /// Sudut kemiringan maksimum dalam derajat.
  final double maxTiltDegrees;

  /// Pembesaran saat cursor berada di atas widget.
  final double scaleOnHover;

  /// Aktifkan efek glare/kilau.
  final bool enableGlare;

  /// Radius untuk area glare.
  final BorderRadius borderRadius;

  const Tilt3D({
    super.key,
    required this.child,
    this.maxTiltDegrees = 10,
    this.scaleOnHover = 1.03,
    this.enableGlare = true,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  State<Tilt3D> createState() =>
      _Tilt3DState();
}

class _Tilt3DState extends State<Tilt3D> {
  Offset _pointer = Offset.zero;
  bool _hovering = false;
  Size _size = Size.zero;

  // ==========================================================
  // POINTER HOVER
  // ==========================================================

  void _handleHover(
    PointerHoverEvent event,
  ) {
    if (_size == Size.zero) {
      return;
    }

    final double dx =
        (event.localPosition.dx /
                    _size.width) *
                2 -
            1;

    final double dy =
        (event.localPosition.dy /
                    _size.height) *
                2 -
            1;

    setState(() {
      _pointer = Offset(
        dx.clamp(-1.0, 1.0),
        dy.clamp(-1.0, 1.0),
      );
    });
  }

  // ==========================================================
  // RESET
  // ==========================================================

  void _reset() {
    setState(() {
      _hovering = false;
      _pointer = Offset.zero;
    });
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    final double maxTiltRad =
        widget.maxTiltDegrees *
            math.pi /
            180;

    return LayoutBuilder(
      builder: (
        context,
        constraints,
      ) {
        _size = Size(
          constraints.maxWidth,
          constraints.maxHeight,
        );

        final double scale =
            _hovering
                ? widget.scaleOnHover
                : 1.0;

        // ======================================================
        // 3D TRANSFORM
        // ======================================================

        final Matrix4 transform =
            Matrix4.identity()
              ..setEntry(
                3,
                2,
                0.0018,
              )
              ..rotateX(
                -_pointer.dy *
                    maxTiltRad,
              )
              ..rotateY(
                _pointer.dx *
                    maxTiltRad,
              )
              ..scaleByDouble(
                scale,
                scale,
                scale,
                1.0,
              );

        return MouseRegion(
          onEnter: (_) {
            setState(() {
              _hovering = true;
            });
          },

          onHover:
              _handleHover,

          onExit: (_) {
            _reset();
          },

          child:
              AnimatedContainer(
            duration:
                const Duration(
              milliseconds: 180,
            ),
            curve:
                Curves.easeOutCubic,
            transform:
                transform,
            transformAlignment:
                Alignment.center,
            child:
                Stack(
              children: [
                // ==================================================
                // MAIN CONTENT
                // ==================================================

                widget.child,

                // ==================================================
                // GLARE
                // ==================================================

                if (widget.enableGlare)
                  Positioned.fill(
                    child:
                        IgnorePointer(
                      child:
                          AnimatedOpacity(
                        duration:
                            const Duration(
                          milliseconds: 180,
                        ),
                        opacity:
                            _hovering
                                ? 1.0
                                : 0.0,
                        child:
                            ClipRRect(
                          borderRadius:
                              widget
                                  .borderRadius,
                          child:
                              DecoratedBox(
                            decoration:
                                BoxDecoration(
                              gradient:
                                  LinearGradient(
                                begin:
                                    Alignment(
                                  (_pointer.dx -
                                          0.45)
                                      .clamp(
                                    -1.0,
                                    1.0,
                                  ),
                                  (_pointer.dy -
                                          0.45)
                                      .clamp(
                                    -1.0,
                                    1.0,
                                  ),
                                ),
                                end:
                                    Alignment(
                                  (_pointer.dx +
                                          0.45)
                                      .clamp(
                                    -1.0,
                                    1.0,
                                  ),
                                  (_pointer.dy +
                                          0.45)
                                      .clamp(
                                    -1.0,
                                    1.0,
                                  ),
                                ),
                                colors: [
                                  Colors.white
                                      .withValues(
                                    alpha:
                                        0.20,
                                  ),
                                  Colors.white
                                      .withValues(
                                    alpha:
                                        0.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}