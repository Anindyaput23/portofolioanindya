import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({
    super.key,
  });

  // ==========================================================
  // COLORS
  // ==========================================================

  static const Color background = Color(0xFF0D0B12);
  static const Color surface = Color(0xFF17131F);
  static const Color surfaceHover = Color(0xFF211A2D);
  static const Color white = Color(0xFFF5F0FF);
  static const Color muted = Color(0xFFAAA2B3);
  static const Color pink = Color(0xFFE58BA8);
  static const Color lime = Color(0xFFB8E06A);
  static const Color purple = Color(0xFF7D5CFF);
  static const Color blue = Color(0xFF7D8CFF);

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: background,
      child: LayoutBuilder(
        builder: (
          context,
          constraints,
        ) {
          final bool mobile = constraints.maxWidth < 750;

          final double horizontalPadding = mobile ? 22 : 60;

          return Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              mobile ? 75 : 105,
              horizontalPadding,
              mobile ? 80 : 110,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1350,
                ),
                child: _content(mobile),
              ),
            ),
          );
        },
      ),
    );
  }

  // ==========================================================
  // CONTENT
  // ==========================================================

  Widget _content(bool mobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(mobile),

        SizedBox(
          height: mobile ? 38 : 52,
        ),

        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('skills')
              .orderBy(
                'createdAt',
                descending: true,
              )
              .snapshots(),
          builder: (
            context,
            snapshot,
          ) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return _loading();
            }

            if (snapshot.hasError) {
              return _error(
                snapshot.error.toString(),
              );
            }

            final skills = snapshot.data?.docs ?? [];

            if (skills.isEmpty) {
              return _empty();
            }

            return _skillWall(
              skills,
              mobile,
            );
          },
        ),
      ],
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================

  Widget _header(bool mobile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 3,
                    color: lime,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'TECH STACK',
                    style: GoogleFonts.spaceGrotesk(
                      color: lime,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.6,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 16,
              ),

              Text(
                'Yang saya',
                style: GoogleFonts.unbounded(
                  color: white,
                  fontSize: mobile ? 30 : 47,
                  fontWeight: FontWeight.w700,
                  height: 1.05,
                  letterSpacing: mobile ? -1 : -2,
                ),
              ),

              Text(
                'gunakan.',
                style: GoogleFonts.unbounded(
                  color: pink,
                  fontSize: mobile ? 30 : 47,
                  fontWeight: FontWeight.w500,
                  height: 1.05,
                  letterSpacing: mobile ? -1 : -2,
                ),
              ),
            ],
          ),
        ),

        if (!mobile)
          Padding(
            padding: const EdgeInsets.only(
              bottom: 5,
            ),
            child: Text(
              'LANGUAGES · FRAMEWORKS · TOOLS',
              style: GoogleFonts.spaceGrotesk(
                color: muted,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.7,
              ),
            ),
          ),
      ],
    );
  }

  // ==========================================================
  // SKILL WALL
  // ==========================================================

  Widget _skillWall(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> skills,
    bool mobile,
  ) {
    return LayoutBuilder(
      builder: (
        context,
        constraints,
      ) {
        final double width = constraints.maxWidth;

        final int columns;

        if (mobile) {
          columns = 1;
        } else if (width < 1050) {
          columns = 2;
        } else {
          columns = 3;
        }

        const double gap = 13;

        final double cardWidth = mobile
            ? width
            : (width - ((columns - 1) * gap)) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: List.generate(
            skills.length,
            (index) {
              final Map<String, dynamic> data =
                  skills[index].data();

              return SizedBox(
                width: cardWidth,
                child: _SkillCard(
                  index: index,
                  data: data,
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ==========================================================
  // LOADING
  // ==========================================================

  Widget _loading() {
    return const SizedBox(
      height: 220,
      child: Center(
        child: CircularProgressIndicator(
          color: lime,
          strokeWidth: 2,
        ),
      ),
    );
  }

  // ==========================================================
  // EMPTY
  // ==========================================================

  Widget _empty() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: white.withValues(
            alpha: 0.08,
          ),
        ),
      ),
      child: Text(
        'Belum ada skill yang ditambahkan.',
        style: GoogleFonts.spaceGrotesk(
          color: muted,
          fontSize: 13,
        ),
      ),
    );
  }

  // ==========================================================
  // ERROR
  // ==========================================================

  Widget _error(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: pink.withValues(
            alpha: 0.20,
          ),
        ),
      ),
      child: Text(
        'Gagal memuat skill.\n$message',
        style: GoogleFonts.spaceGrotesk(
          color: muted,
          fontSize: 12,
          height: 1.5,
        ),
      ),
    );
  }
}

// ============================================================
// SKILL CARD
// ============================================================

class _SkillCard extends StatefulWidget {
  final int index;
  final Map<String, dynamic> data;

  const _SkillCard({
    required this.index,
    required this.data,
  });

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
  bool hovering = false;

  static const Color surface = Color(0xFF17131F);
  static const Color surfaceHover = Color(0xFF211A2D);
  static const Color white = Color(0xFFF5F0FF);
  static const Color muted = Color(0xFFAAA2B3);
  static const Color pink = Color(0xFFE58BA8);
  static const Color lime = Color(0xFFB8E06A);
  static const Color purple = Color(0xFF7D5CFF);
  static const Color blue = Color(0xFF7D8CFF);

  @override
  Widget build(BuildContext context) {
    final String name =
        widget.data['name']?.toString().trim() ?? 'Skill';

    final String category =
        widget.data['category']?.toString().trim() ?? '';

    int level = 0;

    final dynamic rawLevel = widget.data['level'];

    if (rawLevel is int) {
      level = rawLevel;
    } else if (rawLevel is double) {
      level = rawLevel.round();
    } else {
      level = int.tryParse(
            rawLevel?.toString() ?? '',
          ) ??
          0;
    }

    level = level.clamp(0, 100);

    final Color accent = _accentColor();

    return MouseRegion(
      cursor: SystemMouseCursors.click,

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

      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 190,
        ),
        curve: Curves.easeOutCubic,

        transform: Matrix4.translationValues(
          0,
          hovering ? -6 : 0,
          0,
        ),

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: hovering
              ? surfaceHover
              : surface,

          borderRadius: BorderRadius.circular(19),

          border: Border.all(
            color: hovering
                ? accent.withValues(
                    alpha: 0.45,
                  )
                : white.withValues(
                    alpha: 0.075,
                  ),
          ),

          boxShadow: hovering
              ? [
                  BoxShadow(
                    color: accent.withValues(
                      alpha: 0.08,
                    ),
                    blurRadius: 28,
                    offset: const Offset(
                      0,
                      12,
                    ),
                  ),
                ]
              : [],
        ),

        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.center,

          children: [
            // ==================================================
            // TECHNOLOGY LOGO
            // ==================================================

            AnimatedContainer(
              duration: const Duration(
                milliseconds: 190,
              ),

              width: 48,
              height: 48,

              decoration: BoxDecoration(
                color: accent.withValues(
                  alpha: hovering
                      ? 0.20
                      : 0.11,
                ),

                borderRadius:
                    BorderRadius.circular(14),
              ),

              child: Center(
                child: _SkillLogo(
                  name: name,
                  accent: accent,
                ),
              ),
            ),

            const SizedBox(
              width: 14,
            ),

            // ==================================================
            // TEXT
            // ==================================================

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,

                    style:
                        GoogleFonts.spaceGrotesk(
                      color: white,
                      fontSize: 14,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  if (category.isNotEmpty)
                    Text(
                      _cleanCategory(
                        category,
                      ),

                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,

                      style:
                          GoogleFonts.spaceGrotesk(
                        color: muted,
                        fontSize: 9,
                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),

                  if (level > 0) ...[
                    const SizedBox(
                      height: 9,
                    ),

                    Row(
                      children:
                          List.generate(
                        5,
                        (dotIndex) {
                          final int
                              threshold =
                              (dotIndex + 1) *
                                  20;

                          return Container(
                            width: 18,
                            height: 3,

                            margin:
                                const EdgeInsets
                                    .only(
                              right: 3,
                            ),

                            decoration:
                                BoxDecoration(
                              color: level >=
                                      threshold
                                  ? accent
                                  : white
                                      .withValues(
                                      alpha: 0.08,
                                    ),

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                100,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // ==================================================
            // ARROW
            // ==================================================

            AnimatedOpacity(
              duration: const Duration(
                milliseconds: 150,
              ),

              opacity:
                  hovering ? 1 : 0.25,

              child: Icon(
                Icons.arrow_outward_rounded,
                color: accent,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // CATEGORY CLEANUP
  // ==========================================================

  String _cleanCategory(String value) {
    final String normalized =
        value.trim().toLowerCase();

    if (normalized == 'programmer language' ||
        normalized == 'programming language') {
      return 'Programming Language';
    }

    if (normalized == 'development tools') {
      return 'Development Tools';
    }

    if (normalized == 'backend & database') {
      return 'Backend & Database';
    }

    if (normalized == 'framework') {
      return 'Framework';
    }

    if (normalized == 'styling language') {
      return 'Styling Language';
    }

    if (normalized == 'markup language') {
      return 'Markup Language';
    }

    return value.trim();
  }

  // ==========================================================
  // ACCENT
  // ==========================================================

  Color _accentColor() {
    switch (widget.index % 4) {
      case 0:
        return lime;

      case 1:
        return pink;

      case 2:
        return purple;

      default:
        return blue;
    }
  }
}

// ============================================================
// SKILL LOGO
// ============================================================

class _SkillLogo extends StatelessWidget {
  final String name;
  final Color accent;

  const _SkillLogo({
    required this.name,
    required this.accent,
  });

  // ==========================================================
  // NORMALIZE NAME
  // ==========================================================

  String _normalize(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(
          '.',
          '',
        )
        .replaceAll(
          '-',
          ' ',
        )
        .replaceAll(
          '_',
          ' ',
        )
        .replaceAll(
          RegExp(r'\s+'),
          ' ',
        );
  }

  // ==========================================================
  // DEVICON
  // ==========================================================

  String? _devIcon(String skill) {
    const Map<String, String> logos = {
      // ------------------------------------------------------
      // HTML
      // ------------------------------------------------------

      'html':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/html5/html5-original.svg',

      'html5':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/html5/html5-original.svg',

      // ------------------------------------------------------
      // CSS
      // ------------------------------------------------------

      'css':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/css3/css3-original.svg',

      'css3':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/css3/css3-original.svg',

      // ------------------------------------------------------
      // PHP
      // ------------------------------------------------------

      'php':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/php/php-original.svg',

      // ------------------------------------------------------
      // LARAVEL
      // ------------------------------------------------------

      'laravel':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/laravel/laravel-original.svg',

      // ------------------------------------------------------
      // VISUAL STUDIO CODE
      // ------------------------------------------------------

      'visual studio code':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/vscode/vscode-original.svg',

      'vs code':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/vscode/vscode-original.svg',

      'vscode':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/vscode/vscode-original.svg',

      // ------------------------------------------------------
      // FLUTTER
      // ------------------------------------------------------

      'flutter':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/flutter/flutter-original.svg',

      // ------------------------------------------------------
      // DART
      // ------------------------------------------------------

      'dart':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/dart/dart-original.svg',

      // ------------------------------------------------------
      // FIREBASE
      // ------------------------------------------------------

      'firebase':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/firebase/firebase-plain.svg',

      // ------------------------------------------------------
      // JAVASCRIPT
      // ------------------------------------------------------

      'javascript':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/javascript/javascript-original.svg',

      'js':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/javascript/javascript-original.svg',

      // ------------------------------------------------------
      // TYPESCRIPT
      // ------------------------------------------------------

      'typescript':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/typescript/typescript-original.svg',

      'ts':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/typescript/typescript-original.svg',

      // ------------------------------------------------------
      // REACT
      // ------------------------------------------------------

      'react':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/react/react-original.svg',

      'reactjs':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/react/react-original.svg',

      // ------------------------------------------------------
      // NEXT JS
      // ------------------------------------------------------

      'nextjs':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/nextjs/nextjs-original.svg',

      'next js':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/nextjs/nextjs-original.svg',

      'next':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/nextjs/nextjs-original.svg',

      // ------------------------------------------------------
      // VUE
      // ------------------------------------------------------

      'vue':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/vuejs/vuejs-original.svg',

      'vuejs':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/vuejs/vuejs-original.svg',

      // ------------------------------------------------------
      // ANGULAR
      // ------------------------------------------------------

      'angular':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/angular/angular-original.svg',

      // ------------------------------------------------------
      // BOOTSTRAP
      // ------------------------------------------------------

      'bootstrap':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/bootstrap/bootstrap-original.svg',

      // ------------------------------------------------------
      // TAILWIND
      // ------------------------------------------------------

      'tailwind':
          'https://cdn.simpleicons.org/tailwindcss',

      'tailwind css':
          'https://cdn.simpleicons.org/tailwindcss',

      // ------------------------------------------------------
      // NODE JS
      // ------------------------------------------------------

      'node':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/nodejs/nodejs-original.svg',

      'nodejs':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/nodejs/nodejs-original.svg',

      'node js':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/nodejs/nodejs-original.svg',

      // ------------------------------------------------------
      // EXPRESS
      // ------------------------------------------------------

      'express':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/express/express-original.svg',

      // ------------------------------------------------------
      // MYSQL
      // ------------------------------------------------------

      'mysql':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/mysql/mysql-original.svg',

      // ------------------------------------------------------
      // MONGODB
      // ------------------------------------------------------

      'mongodb':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/mongodb/mongodb-original.svg',

      // ------------------------------------------------------
      // POSTGRESQL
      // ------------------------------------------------------

      'postgresql':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/postgresql/postgresql-original.svg',

      'postgres':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/postgresql/postgresql-original.svg',

      // ------------------------------------------------------
      // SQLITE
      // ------------------------------------------------------

      'sqlite':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/sqlite/sqlite-original.svg',

      // ------------------------------------------------------
      // PYTHON
      // ------------------------------------------------------

      'python':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/python/python-original.svg',

      // ------------------------------------------------------
      // JAVA
      // ------------------------------------------------------

      'java':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/java/java-original.svg',

      // ------------------------------------------------------
      // KOTLIN
      // ------------------------------------------------------

      'kotlin':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/kotlin/kotlin-original.svg',

      // ------------------------------------------------------
      // C++
      // ------------------------------------------------------

      'c++':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/cplusplus/cplusplus-original.svg',

      'cpp':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/cplusplus/cplusplus-original.svg',

      // ------------------------------------------------------
      // C#
      // ------------------------------------------------------

      'c#':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/csharp/csharp-original.svg',

      'csharp':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/csharp/csharp-original.svg',

      // ------------------------------------------------------
      // GIT
      // ------------------------------------------------------

      'git':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/git/git-original.svg',

      // ------------------------------------------------------
      // GITHUB
      // ------------------------------------------------------

      'github':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/github/github-original.svg',

      // ------------------------------------------------------
      // FIGMA
      // ------------------------------------------------------

      'figma':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/figma/figma-original.svg',

      // ------------------------------------------------------
      // ANDROID STUDIO
      // ------------------------------------------------------

      'android studio':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/androidstudio/androidstudio-original.svg',

      // ------------------------------------------------------
      // BLENDER
      // ------------------------------------------------------

      'blender':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/blender/blender-original.svg',

      // ------------------------------------------------------
      // UNITY
      // ------------------------------------------------------

      'unity':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/unity/unity-original.svg',

      // ------------------------------------------------------
      // UNREAL ENGINE
      // ------------------------------------------------------

      'unreal engine':
          'https://cdn.simpleicons.org/unrealengine',

      'unreal':
          'https://cdn.simpleicons.org/unrealengine',

      // ------------------------------------------------------
      // CANVA
      // ------------------------------------------------------

      'canva':
          'https://cdn.simpleicons.org/canva',

      // ------------------------------------------------------
      // POSTMAN
      // ------------------------------------------------------

      'postman':
          'https://cdn.simpleicons.org/postman',

      // ------------------------------------------------------
      // GITLAB
      // ------------------------------------------------------

      'gitlab':
          'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/gitlab/gitlab-original.svg',
    };

    return logos[skill];
  }

  // ==========================================================
  // BUILD LOGO
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final String skill = _normalize(name);

    final String? logoUrl = _devIcon(skill);

    if (logoUrl != null) {
      return SvgPicture.network(
        logoUrl,

        width: 29,
        height: 29,

        fit: BoxFit.contain,

        placeholderBuilder: (_) {
          return _fallbackLetter();
        },

        errorBuilder: (
          context,
          error,
          stackTrace,
        ) {
          return _fallbackLetter();
        },
      );
    }

    return _fallbackLetter();
  }

  // ==========================================================
  // FALLBACK
  // ==========================================================

  Widget _fallbackLetter() {
    final String first =
        name.trim().isEmpty
            ? '?'
            : name
                .trim()
                .substring(0, 1)
                .toUpperCase();

    return Text(
      first,

      style: GoogleFonts.unbounded(
        color: accent,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}