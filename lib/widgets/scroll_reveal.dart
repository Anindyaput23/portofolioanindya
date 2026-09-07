import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

enum ScrollRevealType {
  cinematic,
  floatUp,
  split,
  zoom,
  rotate,
  blurIn,
}

/// Scroll reveal yang sengaja dibuat tidak terasa seperti template "slide dari kiri".
/// Tiap section punya kombinasi opacity + scale + rotasi mikro + blur + gerakan
/// melengkung sehingga tetap halus di desktop maupun mobile.
class ScrollReveal extends StatefulWidget {
  final Widget child;
  final ScrollController controller;
  final ScrollRevealType type;
  final double triggerOffset;
  final Duration duration;
  final Duration delay;
  final bool repeat;
  final double intensity;

  const ScrollReveal({
    super.key,
    required this.child,
    required this.controller,
    this.type = ScrollRevealType.cinematic,
    this.triggerOffset = 0.16,
    this.duration = const Duration(milliseconds: 1050),
    this.delay = Duration.zero,
    this.repeat = false,
    this.intensity = 1,
  });

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation;
  bool _inside = false;
  bool _played = false;
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: const Duration(milliseconds: 500),
    );

    widget.controller.addListener(_scheduleCheck);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  void _scheduleCheck() {
    if (_checking) return;
    _checking = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checking = false;
      if (mounted) _checkVisibility();
    });
  }

  void _checkVisibility() {
    if (!mounted) return;

    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return;

    final top = renderObject.localToGlobal(Offset.zero).dy;
    final bottom = top + renderObject.size.height;
    final height = MediaQuery.sizeOf(context).height;
    final trigger = height * (1 - widget.triggerOffset);

    final visible = bottom > height * 0.04 && top < trigger;

    if (visible && !_inside) {
      _inside = true;
      if (!_played || widget.repeat) {
        _played = true;
        _play();
      }
    } else if (!visible && _inside) {
      _inside = false;
      if (widget.repeat) _animation.reverse();
    }
  }

  Future<void> _play() async {
    if (widget.delay > Duration.zero) {
      await Future.delayed(widget.delay);
      if (!mounted || !_inside) return;
    }
    if (mounted) await _animation.forward(from: 0);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_scheduleCheck);
    _animation.dispose();
    super.dispose();
  }

  double get _t => Curves.easeOutCubic.transform(_animation.value);

  Offset _offset(Size size) {
    final i = widget.intensity;
    switch (widget.type) {
      case ScrollRevealType.floatUp:
        return Offset(0, (1 - _t) * 52 * i);
      case ScrollRevealType.split:
        return Offset(math.sin(_t * math.pi) * 34 * i, (1 - _t) * 20 * i);
      case ScrollRevealType.zoom:
        return Offset(0, (1 - _t) * 18 * i);
      case ScrollRevealType.rotate:
        return Offset(math.sin(_t * math.pi) * 20 * i, (1 - _t) * 28 * i);
      case ScrollRevealType.blurIn:
        return Offset(0, (1 - _t) * 24 * i);
      case ScrollRevealType.cinematic:
        return Offset(
          math.sin(_t * math.pi) * 18 * i,
          (1 - _t) * 42 * i,
        );
    }
  }

  double _scale() {
    switch (widget.type) {
      case ScrollRevealType.zoom:
        return 0.88 + 0.12 * _t;
      case ScrollRevealType.cinematic:
        return 0.965 + 0.035 * _t;
      default:
        return 0.985 + 0.015 * _t;
    }
  }

  double _rotation() {
    final i = widget.intensity;
    switch (widget.type) {
      case ScrollRevealType.rotate:
        return (1 - _t) * -math.pi / 34 * i;
      case ScrollRevealType.cinematic:
        return math.sin((1 - _t) * math.pi) * math.pi / 90 * i;
      default:
        return 0;
    }
  }

  double _blurSigma() {
    switch (widget.type) {
      case ScrollRevealType.blurIn:
      case ScrollRevealType.cinematic:
        return (1 - _t) * 8;
      default:
        return (1 - _t) * 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, child) {
        return Opacity(
          opacity: Curves.easeOut.transform(_animation.value),
          child: Transform.translate(
            offset: _offset(MediaQuery.sizeOf(context)),
            child: Transform.scale(
              scale: _scale(),
              alignment: Alignment.center,
              child: Transform.rotate(
                angle: _rotation(),
                alignment: Alignment.center,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: _blurSigma(),
                    sigmaY: _blurSigma(),
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
