import 'dart:ui';

import 'package:flutter/material.dart';

class AnimatedSection extends StatefulWidget {
  final Widget child;

  final Duration duration;

  final Duration delay;

  final Offset beginOffset;

  final double beginScale;

  final bool blur;

  const AnimatedSection({
    super.key,
    required this.child,
    this.duration =
        const Duration(
      milliseconds: 900,
    ),
    this.delay =
        Duration.zero,
    this.beginOffset =
        const Offset(
      0,
      45,
    ),
    this.beginScale = 0.97,
    this.blur = true,
  });

  @override
  State<AnimatedSection> createState() =>
      _AnimatedSectionState();
}

class _AnimatedSectionState
    extends State<AnimatedSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController
      _controller;

  late final Animation<double>
      _opacity;

  late final Animation<double>
      _scale;

  late final Animation<Offset>
      _offset;

  late final Animation<double>
      _blur;

  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(
      vsync: this,
      duration:
          widget.duration,
    );

    final CurvedAnimation curve =
        CurvedAnimation(
      parent: _controller,
      curve:
          Curves.easeOutCubic,
    );

    _opacity =
        Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      curve,
    );

    _scale =
        Tween<double>(
      begin:
          widget.beginScale,
      end: 1,
    ).animate(
      curve,
    );

    _offset =
        Tween<Offset>(
      begin:
          widget.beginOffset,
      end: Offset.zero,
    ).animate(
      curve,
    );

    _blur =
        Tween<double>(
      begin:
          widget.blur ? 7 : 0,
      end: 0,
    ).animate(
      curve,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_hasStarted) {
      return;
    }

    _hasStarted = true;

    WidgetsBinding.instance
        .addPostFrameCallback(
      (_) {
        if (!mounted) {
          return;
        }

        if (widget.delay ==
            Duration.zero) {
          _controller.forward();
        } else {
          Future.delayed(
            widget.delay,
            () {
              if (mounted) {
                _controller.forward();
              }
            },
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (
        context,
        child,
      ) {
        return Opacity(
          opacity:
              _opacity.value,
          child: Transform.translate(
            offset:
                _offset.value,
            child: Transform.scale(
              scale:
                  _scale.value,
              alignment:
                  Alignment.center,
              child:
                  widget.blur
                      ? ImageFiltered(
                          imageFilter:
                              ImageFilter
                                  .blur(
                            sigmaX:
                                _blur.value,
                            sigmaY:
                                _blur.value,
                          ),
                          child:
                              child,
                        )
                      : child,
            ),
          ),
        );
      },
    );
  }
}