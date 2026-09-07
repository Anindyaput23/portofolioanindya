import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'three_d_scene.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback? onViewProjects;
  final VoidCallback? onContact;

  const HeroSection({
    super.key,
    this.onViewProjects,
    this.onContact,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  // ==========================================================
  // CONTROLLERS
  // ==========================================================

  late final AnimationController _entranceController;
  late final AnimationController _shimmerController;
  late final AnimationController _cursorController;

  Timer? _typingTimer;

  // ==========================================================
  // ANIMATIONS
  // ==========================================================

  late final Animation<double> _badgeOpacity;
  late final Animation<Offset> _badgeSlide;

  late final Animation<double> _helloOpacity;
  late final Animation<Offset> _helloSlide;

  late final Animation<double> _nameOpacity;
  late final Animation<Offset> _nameSlide;

  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _titleSlide;

  late final Animation<double> _descriptionOpacity;
  late final Animation<Offset> _descriptionSlide;

  late final Animation<double> _buttonsOpacity;
  late final Animation<Offset> _buttonsSlide;

  late final Animation<double> _sceneOpacity;
  late final Animation<Offset> _sceneSlide;

  // ==========================================================
  // TYPEWRITER
  // ==========================================================

  static const String _typingText =
      'SOFTWARE ENGINEER';

  String _typedTitle = '';
  int _typingIndex = 0;
  bool _typingFinished = false;

  // ==========================================================
  // COLORS
  // ==========================================================

  static const Color background =
      Color(0xFF080A10);

  static const Color white =
      Color(0xFFF5F7FF);

  static const Color muted =
      Color(0xFFA9AFBF);

  static const Color pink =
      Color(0xFFFF4FA3);

  static const Color pinkBright =
      Color(0xFFFF8BC5);

  @override
  void initState() {
    super.initState();

    // ========================================================
    // ENTRANCE CONTROLLER
    // ========================================================

    _entranceController =
        AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1250,
      ),
    );

    // ========================================================
    // SHIMMER CONTROLLER
    // ========================================================

    _shimmerController =
        AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 2300,
      ),
    )..repeat();

    // ========================================================
    // CURSOR BLINK
    // ========================================================

    _cursorController =
        AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 650,
      ),
    )..repeat(
        reverse: true,
      );

    // ========================================================
    // 3D SCENE
    // ========================================================

    _sceneOpacity = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(
        0.00,
        0.55,
        curve: Curves.easeOut,
      ),
    );

    _sceneSlide = Tween<Offset>(
      begin: const Offset(
        0,
        -0.25,
      ),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(
          0.00,
          0.58,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    // ========================================================
    // BADGE
    // ========================================================

    _badgeOpacity = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(
        0.02,
        0.20,
        curve: Curves.easeOut,
      ),
    );

    _badgeSlide = Tween<Offset>(
      begin: const Offset(
        0,
        -0.45,
      ),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(
          0.02,
          0.20,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    // ========================================================
    // HELLO
    // ========================================================

    _helloOpacity = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(
        0.12,
        0.30,
        curve: Curves.easeOut,
      ),
    );

    _helloSlide = Tween<Offset>(
      begin: const Offset(
        0,
        0.35,
      ),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(
          0.12,
          0.30,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    // ========================================================
    // NAME
    // ========================================================

    _nameOpacity = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(
        0.20,
        0.48,
        curve: Curves.easeOut,
      ),
    );

    _nameSlide = Tween<Offset>(
      begin: const Offset(
        0,
        0.30,
      ),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(
          0.20,
          0.48,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    // ========================================================
    // SOFTWARE ENGINEER
    // ========================================================

    _titleOpacity = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(
        0.40,
        0.60,
        curve: Curves.easeOut,
      ),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(
        0,
        0.28,
      ),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(
          0.40,
          0.60,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    // ========================================================
    // DESCRIPTION
    // ========================================================

    _descriptionOpacity =
        CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(
        0.50,
        0.70,
        curve: Curves.easeOut,
      ),
    );

    _descriptionSlide =
        Tween<Offset>(
      begin: const Offset(
        0,
        0.22,
      ),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(
          0.50,
          0.70,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    // ========================================================
    // BUTTONS
    // ========================================================

    _buttonsOpacity = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(
        0.62,
        0.88,
        curve: Curves.easeOut,
      ),
    );

    _buttonsSlide = Tween<Offset>(
      begin: const Offset(
        0,
        0.25,
      ),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(
          0.62,
          0.88,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    // ========================================================
    // START ENTRANCE
    // ========================================================

    // ========================================================
    // START ENTRANCE IMMEDIATELY
    // ========================================================
    //
    // Tidak ada delay sebelum hero mulai bergerak.
    // Begitu HeroSection selesai dibuat, animasi langsung
    // berjalan sehingga transisinya terasa menyambung
    // dengan splash screen.
    //

    _entranceController.forward();

    // Typewriter dimulai sedikit setelah entrance berjalan,
    // bukan setelah hero menunggu terlalu lama.
    Future<void>.delayed(
      const Duration(
        milliseconds: 420,
      ),
      () {
        if (mounted) {
          _startTyping();
        }
      },
    );
  }

  // ==========================================================
  // TYPEWRITER START
  // ==========================================================

  void _startTyping() {
    _typingTimer?.cancel();

    _typingIndex = 0;
    _typedTitle = '';
    _typingFinished = false;

    bool deleting = false;
    int pauseTicks = 0;

    _typingTimer = Timer.periodic(
      const Duration(
        milliseconds: 65,
      ),
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        // ======================================================
        // PAUSE SETELAH TEKS SELESAI
        // ======================================================

        if (!deleting &&
            _typingIndex == _typingText.length) {
          if (pauseTicks < 10) {
            pauseTicks++;
            return;
          }

          deleting = true;
          pauseTicks = 0;

          setState(() {
            _typingFinished = false;
          });

          return;
        }

        // ======================================================
        // HAPUS HURUF
        // ======================================================

        if (deleting) {
          if (_typingIndex > 0) {
            setState(() {
              _typingIndex--;

              _typedTitle =
                  _typingText.substring(
                0,
                _typingIndex,
              );
            });

            return;
          }

          // Teks sudah habis dihapus.
          // Beri jeda kecil lalu mulai mengetik lagi.
          if (pauseTicks < 4) {
            pauseTicks++;
            return;
          }

          deleting = false;
          pauseTicks = 0;

          return;
        }

        // ======================================================
        // KETIK HURUF
        // ======================================================

        if (_typingIndex <
            _typingText.length) {
          setState(() {
            _typingIndex++;

            _typedTitle =
                _typingText.substring(
              0,
              _typingIndex,
            );
          });

          // Ketika sudah selesai diketik, tampilkan state
          // finished sebentar supaya shimmer tetap muncul
          // sebelum masuk fase penghapusan.
          if (_typingIndex ==
              _typingText.length) {
            setState(() {
              _typingFinished = true;
            });
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _typingTimer?.cancel();

    _entranceController.dispose();
    _shimmerController.dispose();
    _cursorController.dispose();

    super.dispose();
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return StreamBuilder<
        DocumentSnapshot<
            Map<String, dynamic>>>(
      stream: FirebaseFirestore
          .instance
          .collection('profile')
          .doc('main')
          .snapshots(),
      builder: (
        context,
        snapshot,
      ) {
        final Map<String, dynamic>? data =
            snapshot.data?.data();

        final String name =
            data?['name']
                        ?.toString()
                        .trim()
                        .isNotEmpty ==
                    true
                ? data!['name']
                    .toString()
                    .trim()
                : 'Anindya Putri Nariswari';

        // ======================================================
        // TITLE TETAP
        // ======================================================

        const String title =
            'SOFTWARE ENGINEER';

        final String description =
            data?['description']
                        ?.toString()
                        .trim()
                        .isNotEmpty ==
                    true
                ? data!['description']
                    .toString()
                    .trim()
                : 'Saya adalah lulusan D3 Teknologi Informasi yang memiliki ketertarikan pada pengembangan aplikasi maupun web, UI/UX, dan teknologi digital.';

        return Container(
          width: double.infinity,
          color: background,
          child: LayoutBuilder(
            builder: (
              context,
              constraints,
            ) {
              final bool mobile =
                  constraints.maxWidth < 900;

              return Padding(
                padding:
                    EdgeInsets.fromLTRB(
                  mobile ? 24 : 72,
                  mobile ? 60 : 78,
                  mobile ? 24 : 72,
                  mobile ? 35 : 35,
                ),
                child: mobile
                    ? _buildMobile(
                        name: name,
                        title: title,
                        description:
                            description,
                      )
                    : _buildDesktop(
                        name: name,
                        title: title,
                        description:
                            description,
                      ),
              );
            },
          ),
        );
      },
    );
  }

  // ==========================================================
  // DESKTOP
  // ==========================================================

  Widget _buildDesktop({
    required String name,
    required String title,
    required String description,
  }) {
    return ConstrainedBox(
      constraints:
          const BoxConstraints(
        maxWidth: 1450,
        minHeight: 680,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 58,
            child: _buildContent(
              name: name,
              title: title,
              description: description,
              desktop: true,
            ),
          ),

          const SizedBox(
            width: 35,
          ),

          Expanded(
            flex: 42,
            child: FadeTransition(
              opacity: _sceneOpacity,
              child: SlideTransition(
                position: _sceneSlide,
                child: const SizedBox(
                  height: 600,
                  child: ThreeDScene(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // MOBILE
  // ==========================================================

  Widget _buildMobile({
    required String name,
    required String title,
    required String description,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _buildContent(
          name: name,
          title: title,
          description: description,
          desktop: false,
        ),

        const SizedBox(
          height: 35,
        ),

        FadeTransition(
          opacity: _sceneOpacity,
          child: SlideTransition(
            position: _sceneSlide,
            child: const SizedBox(
              width: double.infinity,
              height: 400,
              child: ThreeDScene(),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // CONTENT
  // ==========================================================

  Widget _buildContent({
    required String name,
    required String title,
    required String description,
    required bool desktop,
  }) {
    final List<String> words =
        name.trim().split(
              RegExp(r'\s+'),
            );

    final String firstName =
        words.isNotEmpty
            ? words.first.toUpperCase()
            : 'ANINDYA';

    final String lastName =
        words.length > 1
            ? words
                .sublist(1)
                .join(' ')
                .toUpperCase()
            : 'PUTRI NARISWARI';

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        // ======================================================
        // BADGE
        // ======================================================

        FadeTransition(
          opacity: _badgeOpacity,
          child: SlideTransition(
            position: _badgeSlide,
            child: _buildBadge(),
          ),
        ),

        SizedBox(
          height:
              desktop ? 34 : 28,
        ),

        // ======================================================
        // HELLO
        // ======================================================

        FadeTransition(
          opacity: _helloOpacity,
          child: SlideTransition(
            position: _helloSlide,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 3,
                  decoration:
                      BoxDecoration(
                    color: pink,
                    borderRadius:
                        BorderRadius.circular(
                      50,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            pink.withValues(
                          alpha: 0.55,
                        ),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  width: 12,
                ),

                Text(
                  'HELLO, I\'M',
                  style:
                      GoogleFonts.spaceMono(
                    color: pinkBright,
                    fontSize: 10,
                    fontWeight:
                        FontWeight.w700,
                    letterSpacing: 2.5,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(
          height: 24,
        ),

        // ======================================================
        // NAME
        // ======================================================

        FadeTransition(
          opacity: _nameOpacity,
          child: SlideTransition(
            position: _nameSlide,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  firstName,
                  style:
                      GoogleFonts.dmSans(
                    color: white,
                    fontSize:
                        desktop ? 76 : 54,
                    fontWeight:
                        FontWeight.w900,
                    height: 0.88,
                    letterSpacing:
                        desktop
                            ? -4.5
                            : -2.5,
                  ),
                ),

                Text(
                  lastName,
                  style:
                      GoogleFonts.dmSans(
                    color: pink,
                    fontSize:
                        desktop ? 48 : 34,
                    fontWeight:
                        FontWeight.w900,
                    height: 1.0,
                    letterSpacing:
                        desktop
                            ? -2.4
                            : -1.4,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(
          height:
              desktop ? 24 : 19,
        ),

        // ======================================================
        // SOFTWARE ENGINEER
        // TYPEWRITER + PINK SHIMMER
        // ======================================================

        FadeTransition(
          opacity: _titleOpacity,
          child: SlideTransition(
            position: _titleSlide,
            child: _buildTypingTitle(
              title: title,
              desktop: desktop,
            ),
          ),
        ),

        const SizedBox(
          height: 13,
        ),

        // ======================================================
        // DESCRIPTION
        // ======================================================

        FadeTransition(
          opacity:
              _descriptionOpacity,
          child: SlideTransition(
            position:
                _descriptionSlide,
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(
                maxWidth:
                    desktop ? 620 : 520,
              ),
              child: Text(
                description,
                style:
                    GoogleFonts.dmSans(
                  color: muted,
                  fontSize:
                      desktop ? 15 : 13,
                  fontWeight:
                      FontWeight.w400,
                  height: 1.75,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(
          height: 28,
        ),

        // ======================================================
        // BUTTONS
        // ======================================================

        FadeTransition(
          opacity: _buttonsOpacity,
          child: SlideTransition(
            position:
                _buttonsSlide,
            child:
                _buildButtons(
              desktop,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // TYPEWRITER TITLE
  // ==========================================================

  Widget _buildTypingTitle({
    required String title,
    required bool desktop,
  }) {
    final String visibleText =
        _typingFinished
            ? title
            : _typedTitle;

    // ========================================================
    // SEBELUM KETIK DIMULAI
    // ========================================================

    if (visibleText.isEmpty) {
      return AnimatedBuilder(
        animation: _cursorController,
        builder: (
          context,
          child,
        ) {
          return Row(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Text(
                '',
                style:
                    GoogleFonts.dmSans(
                  color: white,
                  fontSize:
                      desktop ? 17 : 14,
                  fontWeight:
                      FontWeight.w800,
                  height: 1.3,
                  letterSpacing: 0.2,
                ),
              ),

              Opacity(
                opacity:
                    _cursorController.value,
                child: Text(
                  '|',
                  style:
                      GoogleFonts.dmSans(
                    color: pink,
                    fontSize:
                        desktop ? 18 : 15,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    // ========================================================
    // SETELAH SELESAI
    // SHIMMER PINK
    // ========================================================

    if (_typingFinished) {
      return AnimatedBuilder(
        animation: _shimmerController,
        builder: (
          context,
          child,
        ) {
          final double progress =
              _shimmerController.value;

          final double center =
              -0.45 +
                  (progress * 1.9);

          return Row(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              ShaderMask(
                blendMode:
                    BlendMode.srcIn,
                shaderCallback:
                    (bounds) {
                  return LinearGradient(
                    begin: Alignment(
                      center - 0.45,
                      0,
                    ),
                    end: Alignment(
                      center + 0.45,
                      0,
                    ),
                    colors: const [
                      white,
                      white,
                      pinkBright,
                      Colors.white,
                      pink,
                      Colors.white,
                      white,
                    ],
                    stops: const [
                      0.00,
                      0.36,
                      0.45,
                      0.49,
                      0.52,
                      0.56,
                      0.70,
                    ],
                  ).createShader(
                    bounds,
                  );
                },
                child: Text(
                  visibleText,
                  style:
                      GoogleFonts.dmSans(
                    color: white,
                    fontSize:
                        desktop ? 17 : 14,
                    fontWeight:
                        FontWeight.w800,
                    height: 1.3,
                    letterSpacing: 0.2,
                  ),
                ),
              ),

              const SizedBox(
                width: 3,
              ),

              _buildBlinkingCursor(
                desktop,
              ),
            ],
          );
        },
      );
    }

    // ========================================================
    // SEDANG MENGETIK
    // ========================================================

    return Row(
      mainAxisSize:
          MainAxisSize.min,
      children: [
        Text(
          visibleText,
          style:
              GoogleFonts.dmSans(
            color: white,
            fontSize:
                desktop ? 17 : 14,
            fontWeight:
                FontWeight.w800,
            height: 1.3,
            letterSpacing: 0.2,
          ),
        ),

        const SizedBox(
          width: 3,
        ),

        _buildBlinkingCursor(
          desktop,
        ),
      ],
    );
  }

  // ==========================================================
  // BLINKING CURSOR
  // ==========================================================

  Widget _buildBlinkingCursor(
    bool desktop,
  ) {
    return AnimatedBuilder(
      animation: _cursorController,
      builder: (
        context,
        child,
      ) {
        return Opacity(
          opacity:
              _cursorController.value,
          child: Text(
            '|',
            style:
                GoogleFonts.dmSans(
              color: pink,
              fontSize:
                  desktop ? 18 : 15,
              fontWeight:
                  FontWeight.w500,
            ),
          ),
        );
      },
    );
  }

  // ==========================================================
  // BADGE
  // ==========================================================

  Widget _buildBadge() {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 9,
      ),
      decoration:
          BoxDecoration(
        color: pink.withValues(
          alpha: 0.055,
        ),
        border: Border.all(
          color: pink.withValues(
            alpha: 0.75,
          ),
          width: 1.2,
        ),
        borderRadius:
            BorderRadius.circular(
          100,
        ),
        boxShadow: [
          BoxShadow(
            color: pink.withValues(
              alpha: 0.08,
            ),
            blurRadius: 18,
          ),
        ],
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration:
                BoxDecoration(
              color: pink,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: pink.withValues(
                    alpha: 0.8,
                  ),
                  blurRadius: 8,
                ),
              ],
            ),
          ),

          const SizedBox(
            width: 9,
          ),

          Text(
            'OPEN FOR OPPORTUNITIES',
            style:
                GoogleFonts.spaceMono(
              color: white,
              fontSize: 9,
              fontWeight:
                  FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // BUTTONS
  // ==========================================================

  Widget _buildButtons(
    bool desktop,
  ) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _outlineButton(
          label: 'LIHAT KARYA',
          onTap:
              widget.onViewProjects,
          width:
              desktop ? 220 : 175,
          height:
              desktop ? 56 : 50,
        ),

        _filledButton(
          label: 'HUBUNGI SAYA',
          onTap:
              widget.onContact,
          width:
              desktop ? 220 : 175,
          height:
              desktop ? 56 : 50,
        ),
      ],
    );
  }

  // ==========================================================
  // OUTLINE BUTTON
  // ==========================================================

  Widget _outlineButton({
    required String label,
    required VoidCallback? onTap,
    required double width,
    required double height,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius:
              BorderRadius.circular(
            100,
          ),
          child: Ink(
            decoration:
                BoxDecoration(
              color:
                  Colors.transparent,
              border: Border.all(
                color: pink,
                width: 1.4,
              ),
              borderRadius:
                  BorderRadius.circular(
                100,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      pink.withValues(
                    alpha: 0.07,
                  ),
                  blurRadius: 15,
                ),
              ],
            ),
            child: Center(
              child: Row(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style:
                        GoogleFonts.dmSans(
                      color: white,
                      fontSize: 9,
                      fontWeight:
                          FontWeight.w900,
                      letterSpacing: 1.4,
                    ),
                  ),

                  const SizedBox(
                    width: 9,
                  ),

                  const Icon(
                    Icons
                        .arrow_outward_rounded,
                    color: pink,
                    size: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // FILLED BUTTON
  // ==========================================================

  Widget _filledButton({
    required String label,
    required VoidCallback? onTap,
    required double width,
    required double height,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius:
              BorderRadius.circular(
            100,
          ),
          child: Ink(
            decoration:
                BoxDecoration(
              color: pink,
              borderRadius:
                  BorderRadius.circular(
                100,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      pink.withValues(
                    alpha: 0.22,
                  ),
                  blurRadius: 25,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: Row(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style:
                        GoogleFonts.dmSans(
                      color:
                          background,
                      fontSize: 9,
                      fontWeight:
                          FontWeight.w900,
                      letterSpacing: 1.4,
                    ),
                  ),

                  const SizedBox(
                    width: 9,
                  ),

                  const Icon(
                    Icons
                        .arrow_outward_rounded,
                    color: background,
                    size: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}