import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({
    super.key,
  });

  // ==========================================================
  // COLORS
  // ==========================================================

  static const Color background =
      Color(0xFF0D0B12);

  static const Color surface =
      Color(0xFF17131F);

  static const Color surfaceHover =
      Color(0xFF211A2D);

  static const Color white =
      Color(0xFFF5F0FF);

  static const Color muted =
      Color(0xFFAAA2B3);

  static const Color pink =
      Color(0xFFE58BA8);

  static const Color lime =
      Color(0xFFB8E06A);

  static const Color purple =
      Color(0xFF7D5CFF);

  static const Color blue =
      Color(0xFF7D8CFF);

  static const String whatsappNumber =
      '6285731531475';

  // ==========================================================
  // WHATSAPP
  // ==========================================================

  Future<void> _openWhatsApp() async {
    final Uri uri = Uri.parse(
      'https://wa.me/$whatsappNumber',
    );

    try {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {}
  }

  // ==========================================================
  // URL
  // ==========================================================

  Future<void> _openUrl(
    String url,
  ) async {
    if (url.trim().isEmpty) {
      return;
    }

    Uri? uri = Uri.tryParse(
      url.trim(),
    );

    if (uri == null) {
      return;
    }

    if (!uri.hasScheme) {
      uri = Uri.tryParse(
        'https://${url.trim()}',
      );
    }

    if (uri == null) {
      return;
    }

    try {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {}
  }

  // ==========================================================
  // EMAIL
  // ==========================================================

  Future<void> _sendEmail(
    String email,
  ) async {
    if (email.trim().isEmpty) {
      return;
    }

    final Uri uri = Uri(
      scheme: 'mailto',
      path: email.trim(),
    );

    try {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {}
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

        final String email =
            data?['email']
                    ?.toString()
                    .trim() ??
                '';

        final String github =
            data?['github']
                    ?.toString()
                    .trim() ??
                '';

        final String linkedin =
            data?['linkedin']
                    ?.toString()
                    .trim() ??
                '';

        final String instagram =
            data?['instagram']
                    ?.toString()
                    .trim() ??
                '';

        final String location =
            data?['location']
                    ?.toString()
                    .trim() ??
                'Indonesia';

        return Container(
          width: double.infinity,
          color: background,
          child: LayoutBuilder(
            builder: (
              context,
              constraints,
            ) {
              final bool mobile =
                  constraints.maxWidth < 850;

              return Padding(
                padding: EdgeInsets.fromLTRB(
                  mobile ? 22 : 60,
                  mobile ? 75 : 105,
                  mobile ? 22 : 60,
                  mobile ? 40 : 50,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    _header(mobile),

                    SizedBox(
                      height:
                          mobile ? 40 : 55,
                    ),

                    _contactGrid(
                      mobile: mobile,
                      email: email,
                      github: github,
                      linkedin: linkedin,
                      instagram: instagram,
                    ),

                    const SizedBox(
                      height: 65,
                    ),

                    Container(
                      width: double.infinity,
                      height: 1,
                      color: white.withValues(
                        alpha: 0.08,
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Row(
                      children: [
                        Text(
                          'ANINDYA.',
                          style:
                              GoogleFonts.unbounded(
                            color: white,
                            fontSize: 10,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '© 2026 • $location',
                          style:
                              GoogleFonts.spaceGrotesk(
                            color: muted,
                            fontSize: 9,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================

  Widget _header(
    bool mobile,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 3,
              color: pink,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'GET IN TOUCH',
              style:
                  GoogleFonts.spaceGrotesk(
                color: pink,
                fontSize: 10,
                fontWeight:
                    FontWeight.w800,
                letterSpacing: 2.5,
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 18,
        ),

        Text(
          'Mari ngobrol.',
          style:
              GoogleFonts.unbounded(
            color: white,
            fontSize:
                mobile ? 30 : 47,
            fontWeight:
                FontWeight.w700,
            height: 1.05,
            letterSpacing:
                mobile ? -1 : -2,
          ),
        ),

        const SizedBox(
          height: 13,
        ),

        Text(
          'Terbuka untuk kesempatan kerja, '
          'kolaborasi, dan project baru.',
          style:
              GoogleFonts.spaceGrotesk(
            color: muted,
            fontSize:
                mobile ? 13 : 15,
            height: 1.7,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // CONTACT GRID
  // ==========================================================

  Widget _contactGrid({
    required bool mobile,
    required String email,
    required String github,
    required String linkedin,
    required String instagram,
  }) {
    final List<Widget> cards = [
      // ========================================================
      // WHATSAPP
      // ========================================================

      _ContactCard(
        accent: lime,
        logo: 'whatsapp',
        label: 'WHATSAPP',
        value: '+62 857 3153 1475',
        onTap: _openWhatsApp,
      ),

      // ========================================================
      // GMAIL
      // ========================================================

      _ContactCard(
        accent: pink,
        logo: 'gmail',
        label: 'EMAIL',
        value: email.isEmpty
            ? 'Belum tersedia'
            : email,
        enabled: email.isNotEmpty,
        onTap: () {
          _sendEmail(email);
        },
      ),

      // ========================================================
      // GITHUB
      // ========================================================

      _ContactCard(
        accent: purple,
        logo: 'github',
        label: 'GITHUB',
        value: _shortUrl(github),
        enabled: github.isNotEmpty,
        onTap: () {
          _openUrl(github);
        },
      ),

      // ========================================================
      // LINKEDIN
      // ========================================================

      _ContactCard(
        accent: blue,
        logo: 'linkedin',
        label: 'LINKEDIN',
        value: _shortUrl(linkedin),
        enabled: linkedin.isNotEmpty,
        onTap: () {
          _openUrl(linkedin);
        },
      ),

      // ========================================================
      // INSTAGRAM
      // ========================================================

      _ContactCard(
        accent: pink,
        logo: 'instagram',
        label: 'INSTAGRAM',
        value: _shortUrl(instagram),
        enabled: instagram.isNotEmpty,
        onTap: () {
          _openUrl(instagram);
        },
      ),
    ];

    // ==========================================================
    // MOBILE
    // ==========================================================

    if (mobile) {
      return Column(
        children: List.generate(
          cards.length,
          (index) {
            return Padding(
              padding:
                  const EdgeInsets.only(
                bottom: 10,
              ),
              child: cards[index],
            );
          },
        ),
      );
    }

    // ==========================================================
    // DESKTOP
    // ==========================================================

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          cards.length,
          (index) {
            return Padding(
              padding: EdgeInsets.only(
                right:
                    index ==
                            cards.length - 1
                        ? 0
                        : 12,
              ),
              child: SizedBox(
                width: 235,
                child: cards[index],
              ),
            );
          },
        ),
      ),
    );
  }

  // ==========================================================
  // SHORT URL
  // ==========================================================

  String _shortUrl(
    String value,
  ) {
    if (value.trim().isEmpty) {
      return 'Belum tersedia';
    }

    String result =
        value.trim();

    result = result.replaceFirst(
      'https://',
      '',
    );

    result = result.replaceFirst(
      'http://',
      '',
    );

    if (result.length > 30) {
      result =
          '${result.substring(0, 27)}...';
    }

    return result;
  }
}

// ============================================================
// CONTACT CARD
// ============================================================

class _ContactCard
    extends StatefulWidget {
  final Color accent;
  final String logo;
  final String label;
  final String value;
  final VoidCallback onTap;
  final bool enabled;

  const _ContactCard({
    required this.accent,
    required this.logo,
    required this.label,
    required this.value,
    required this.onTap,
    this.enabled = true,
  });

  @override
  State<_ContactCard> createState() =>
      _ContactCardState();
}

class _ContactCardState
    extends State<_ContactCard> {
  bool hovering = false;

  static const Color surface =
      Color(0xFF17131F);

  static const Color surfaceHover =
      Color(0xFF211A2D);

  static const Color white =
      Color(0xFFF5F0FF);

  static const Color muted =
      Color(0xFFAAA2B3);

  // ==========================================================
  // REAL BRAND LOGO
  // ==========================================================

  Widget _brandLogo() {
    final String url =
        'https://cdn.simpleicons.org/${widget.logo}';

    return SvgPicture.network(
      url,
      width: 23,
      height: 23,
      fit: BoxFit.contain,
      placeholderBuilder:
          (context) {
        return _fallbackLogo();
      },
      errorBuilder: (
        context,
        error,
        stackTrace,
      ) {
        return _fallbackLogo();
      },
    );
  }

  // ==========================================================
  // FALLBACK
  // ==========================================================

  Widget _fallbackLogo() {
    String letter = '?';

    switch (widget.logo) {
      case 'whatsapp':
        letter = 'W';
        break;
      case 'gmail':
        letter = 'M';
        break;
      case 'github':
        letter = 'G';
        break;
      case 'linkedin':
        letter = 'in';
        break;
      case 'instagram':
        letter = '◎';
        break;
    }

    return Text(
      letter,
      style: TextStyle(
        color: widget.accent,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return MouseRegion(
      cursor: widget.enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) {
        setState(() {
          hovering = true;
        });
      },
      onExit: (_) {
        setState(() {
          hovering = false;
        });
      },
      child: GestureDetector(
        onTap:
            widget.enabled
                ? widget.onTap
                : null,
        child: AnimatedContainer(
          duration:
              const Duration(
            milliseconds: 180,
          ),
          curve:
              Curves.easeOutCubic,
          padding:
              const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: hovering
                ? surfaceHover
                : surface,
            borderRadius:
                BorderRadius.circular(17),
            border: Border.all(
              color: hovering
                  ? widget.accent
                      .withValues(
                      alpha: 0.45,
                    )
                  : white.withValues(
                      alpha: 0.08,
                    ),
            ),
            boxShadow: hovering
                ? [
                    BoxShadow(
                      color: widget.accent
                          .withValues(
                        alpha: 0.07,
                      ),
                      blurRadius: 24,
                      offset:
                          const Offset(
                        0,
                        10,
                      ),
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // ==================================================
              // LOGO + ARROW
              // ==================================================

              Row(
                children: [
                  AnimatedContainer(
                    duration:
                        const Duration(
                      milliseconds: 180,
                    ),
                    width: 42,
                    height: 42,
                    decoration:
                        BoxDecoration(
                      color: widget.accent
                          .withValues(
                        alpha:
                            hovering
                                ? 0.17
                                : 0.11,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),
                    child: Center(
                      child:
                          _brandLogo(),
                    ),
                  ),

                  const Spacer(),

                  if (widget.enabled)
                    AnimatedOpacity(
                      duration:
                          const Duration(
                        milliseconds: 150,
                      ),
                      opacity:
                          hovering ? 1 : 0.8,
                      child: Icon(
                        Icons
                            .arrow_outward_rounded,
                        color:
                            widget.accent,
                        size: 16,
                      ),
                    ),
                ],
              ),

              const SizedBox(
                height: 22,
              ),

              // ==================================================
              // LABEL
              // ==================================================

              Text(
                widget.label,
                style: TextStyle(
                  color:
                      widget.accent,
                  fontSize: 8,
                  fontWeight:
                      FontWeight.w800,
                  letterSpacing: 1.6,
                ),
              ),

              const SizedBox(
                height: 5,
              ),

              // ==================================================
              // VALUE
              // ==================================================

              Text(
                widget.value,
                maxLines: 2,
                overflow:
                    TextOverflow.ellipsis,
                style: TextStyle(
                  color: widget.enabled
                      ? white
                      : muted,
                  fontSize: 11,
                  fontWeight:
                      FontWeight.w600,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}