import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({
    super.key,
  });

  static const Color bg = Color(0xFF0B0A11);
  static const Color card = Color(0xFF171321);
  static const Color card2 = Color(0xFF1D172B);
  static const Color white = Color(0xFFF7F2FF);
  static const Color muted = Color(0xFFAAA2B7);
  static const Color lime = Color(0xFFB8F44A);
  static const Color pink = Color(0xFFFF4FA3);
  static const Color purple = Color(0xFF815CFF);
  static const Color line = Color(0xFF2D2638);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool mobile = constraints.maxWidth < 850;

          return Padding(
            padding: EdgeInsets.fromLTRB(
              mobile ? 22 : 52,
              mobile ? 80 : 110,
              mobile ? 22 : 52,
              mobile ? 80 : 110,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1380,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(mobile),
                    SizedBox(
                      height: mobile ? 38 : 52,
                    ),
                    StreamBuilder<
                        QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('projects')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                            height: 250,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: lime,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return _errorBox(
                            snapshot.error.toString(),
                          );
                        }

                        final docs =
                            snapshot.data?.docs ?? [];

                        if (docs.isEmpty) {
                          return _emptyBox();
                        }

                        return LayoutBuilder(
                          builder: (context, inner) {
                            final bool twoColumns =
                                inner.maxWidth >= 1050;

                            final double gap =
                                twoColumns ? 22 : 16;

                            final double width =
                                twoColumns
                                    ? (inner.maxWidth - gap) / 2
                                    : inner.maxWidth;

                            return Wrap(
                              spacing: gap,
                              runSpacing: gap,
                              children: docs.map(
                                (doc) {
                                  return SizedBox(
                                    width: width,
                                    child: _ProjectCard(
                                      index: docs.indexOf(doc),
                                      data: doc.data(),
                                      mobile: !twoColumns,
                                    ),
                                  );
                                },
                              ).toList(),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _header(bool mobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 34,
              height: 3,
              decoration: BoxDecoration(
                color: lime,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 11),
            Text(
              'SELECTED WORK',
              style: GoogleFonts.dmSans(
                color: lime,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Project yang ',
                style: GoogleFonts.dmSans(
                  color: white,
                  fontSize: mobile ? 34 : 52,
                  fontWeight: FontWeight.w800,
                  height: 1,
                  letterSpacing: -2,
                ),
              ),
              TextSpan(
                text: 'pernah',
                style: GoogleFonts.dmSans(
                  color: pink,
                  fontSize: mobile ? 34 : 52,
                  fontWeight: FontWeight.w800,
                  height: 1,
                  letterSpacing: -2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 700,
          ),
          child: Text(
            'Beberapa karya yang saya kerjakan selama kuliah, '
            'magang, dan mengembangkan kemampuan di bidang teknologi.',
            style: GoogleFonts.dmSans(
              color: muted,
              fontSize: mobile ? 13 : 15,
              height: 1.7,
            ),
          ),
        ),
      ],
    );
  }

  Widget _errorBox(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: pink.withValues(alpha: .25),
        ),
      ),
      child: Text(
        'Gagal memuat project.\n$message',
        style: GoogleFonts.dmSans(
          color: muted,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _emptyBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 60,
      ),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: line,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.work_outline_rounded,
            color: muted,
            size: 42,
          ),
          const SizedBox(height: 14),
          Text(
            'Belum ada project.',
            style: GoogleFonts.dmSans(
              color: muted,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final int index;
  final Map<String, dynamic> data;
  final bool mobile;

  const _ProjectCard({
    required this.index,
    required this.data,
    required this.mobile,
  });

  @override
  State<_ProjectCard> createState() =>
      _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard>
    with SingleTickerProviderStateMixin {
  static const Color card = Color(0xFF171321);
  static const Color card2 = Color(0xFF1D172B);
  static const Color white = Color(0xFFF7F2FF);
  static const Color muted = Color(0xFFAAA2B7);
  static const Color lime = Color(0xFFB8F44A);
  static const Color pink = Color(0xFFFF4FA3);
  static const Color purple = Color(0xFF815CFF);
  static const Color line = Color(0xFF2D2638);

  bool hovering = false;
  Offset pointer = Offset.zero;
  int currentImage = 0;

  late final AnimationController floatController;

  @override
  void initState() {
    super.initState();

    floatController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 4,
      ),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    floatController.dispose();
    super.dispose();
  }

  List<String> _images() {
    final List<String> result = [];

    final String cover =
        widget.data['imageUrl']?.toString().trim() ?? '';

    final dynamic rawGallery =
        widget.data['imageUrls'];

    if (cover.isNotEmpty) {
      result.add(cover);
    }

    if (rawGallery is List) {
      for (final item in rawGallery) {
        final String url =
            item.toString().trim();

        if (url.isNotEmpty &&
            !result.contains(url)) {
          result.add(url);
        }
      }
    }

    return result;
  }

  void _hover(PointerHoverEvent event) {
    if (widget.mobile) return;

    final RenderBox? renderBox =
        context.findRenderObject() as RenderBox?;

    if (renderBox == null) return;

    final Size size = renderBox.size;

    if (size.width <= 0 || size.height <= 0) {
      return;
    }

    final double x =
        ((event.localPosition.dx / size.width) * 2) - 1;

    final double y =
        ((event.localPosition.dy / size.height) * 2) - 1;

    setState(() {
      pointer = Offset(
        x.clamp(-1.0, 1.0),
        y.clamp(-1.0, 1.0),
      );
    });
  }

  void _openGallery(
    List<String> images,
    String title,
  ) {
    if (images.isEmpty) return;

    int index = currentImage;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: .90),
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding:
                  const EdgeInsets.all(18),
              child: Container(
                constraints:
                    const BoxConstraints(
                  maxWidth: 1150,
                  maxHeight: 800,
                ),
                padding:
                    const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius:
                      BorderRadius.circular(22),
                  border: Border.all(
                    color: Colors.white
                        .withValues(alpha: .10),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style:
                                GoogleFonts.dmSans(
                              color: white,
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          '${index + 1}/${images.length}',
                          style:
                              GoogleFonts.dmSans(
                            color: muted,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(
                              dialogContext,
                            );
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                            color: white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          InteractiveViewer(
                            minScale: .7,
                            maxScale: 4,
                            child: Image.network(
                              images[index],
                              fit: BoxFit.contain,
                              errorBuilder: (
                                context,
                                error,
                                stackTrace,
                              ) {
                                return const Icon(
                                  Icons
                                      .broken_image_outlined,
                                  color: muted,
                                  size: 55,
                                );
                              },
                            ),
                          ),
                          if (images.length > 1)
                            Positioned(
                              left: 8,
                              child:
                                  _viewerArrow(
                                enabled: index > 0,
                                icon:
                                    Icons.arrow_back_ios_new_rounded,
                                onTap: () {
                                  if (index > 0) {
                                    setDialogState(() {
                                      index--;
                                    });
                                  }
                                },
                              ),
                            ),
                          if (images.length > 1)
                            Positioned(
                              right: 8,
                              child:
                                  _viewerArrow(
                                enabled:
                                    index <
                                        images.length -
                                            1,
                                icon:
                                    Icons.arrow_forward_ios_rounded,
                                onTap: () {
                                  if (index <
                                      images.length -
                                          1) {
                                    setDialogState(() {
                                      index++;
                                    });
                                  }
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (images.length > 1) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 60,
                        child: ListView.separated(
                          scrollDirection:
                              Axis.horizontal,
                          itemCount: images.length,
                          separatorBuilder:
                              (context, i) =>
                                  const SizedBox(
                            width: 8,
                          ),
                          itemBuilder:
                              (context, i) {
                            final bool active =
                                i == index;

                            return GestureDetector(
                              onTap: () {
                                setDialogState(() {
                                  index = i;
                                });
                              },
                              child:
                                  AnimatedContainer(
                                duration:
                                    const Duration(
                                  milliseconds: 180,
                                ),
                                width: 82,
                                decoration:
                                    BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(
                                    10,
                                  ),
                                  border:
                                      Border.all(
                                    color: active
                                        ? lime
                                        : line,
                                    width:
                                        active ? 2 : 1,
                                  ),
                                ),
                                clipBehavior:
                                    Clip.antiAlias,
                                child: Image.network(
                                  images[i],
                                  fit:
                                      BoxFit.cover,
                                  errorBuilder:
                                      (
                                    context,
                                    error,
                                    stackTrace,
                                  ) {
                                    return Container(
                                      color:
                                          card2,
                                      child:
                                          const Icon(
                                        Icons
                                            .broken_image_outlined,
                                        color:
                                            muted,
                                        size:
                                            18,
                                      ),
                                    );
                                  },
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
            );
          },
        );
      },
    );
  }

  Widget _viewerArrow({
    required bool enabled,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: card2.withValues(
            alpha: .92,
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: line,
          ),
        ),
        child: Icon(
          icon,
          color:
              enabled ? white : muted.withValues(
                alpha: .3,
              ),
          size: 14,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String title =
        widget.data['title']?.toString().trim() ??
            'Untitled Project';

    final String category =
        widget.data['category']?.toString().trim() ??
            '';

    final String technology =
        widget.data['technology']?.toString().trim() ??
            '';

    final String description =
        widget.data['description']?.toString().trim() ??
            '';

    final String projectUrl =
        widget.data['projectUrl']?.toString().trim() ??
            '';

    final List<String> images = _images();

    if (images.isEmpty) {
      currentImage = 0;
    } else if (currentImage >= images.length) {
      currentImage = images.length - 1;
    }

    final double rx =
        widget.mobile
            ? 0
            : -pointer.dy * .026;

    final double ry =
        widget.mobile
            ? 0
            : pointer.dx * .026;

    return MouseRegion(
      onEnter: (_) {
        if (!widget.mobile) {
          setState(() {
            hovering = true;
          });
        }
      },
      onHover: _hover,
      onExit: (_) {
        if (!widget.mobile) {
          setState(() {
            hovering = false;
            pointer = Offset.zero;
          });
        }
      },
      child: AnimatedBuilder(
        animation: floatController,
        builder: (context, child) {
          final double y =
              -math.sin(
                    floatController.value *
                        math.pi,
                  ) *
                  2.8;

          return Transform.translate(
            offset: Offset(0, y),
            child: AnimatedScale(
              scale: hovering ? 1.012 : 1,
              duration:
                  const Duration(milliseconds: 180),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, .0013)
                  ..rotateX(rx)
                  ..rotateY(ry),
                child: child,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: card,
            borderRadius:
                BorderRadius.circular(22),
            border: Border.all(
              color: hovering
                  ? pink.withValues(
                      alpha: .35,
                    )
                  : line,
            ),
            boxShadow: [
              BoxShadow(
                color: hovering
                    ? purple.withValues(
                        alpha: .12,
                      )
                    : Colors.black
                        .withValues(alpha: .28),
                blurRadius:
                    hovering ? 34 : 22,
                offset:
                    const Offset(0, 16),
              ),
            ],
          ),
          clipBehavior:
              Clip.antiAlias,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // ==================================================
              // MAIN IMAGE
              // ==================================================

              GestureDetector(
                onTap: () {
                  _openGallery(
                    images,
                    title,
                  );
                },
                child: SizedBox(
                  height:
                      widget.mobile ? 260 : 310,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (images.isEmpty)
                        Container(
                          color: card2,
                          child:
                              const Center(
                            child: Icon(
                              Icons
                                  .image_outlined,
                              color: muted,
                              size: 44,
                            ),
                          ),
                        )
                      else
                        AnimatedSwitcher(
                          duration:
                              const Duration(
                            milliseconds: 280,
                          ),
                          child: Image.network(
                            images[currentImage],
                            key: ValueKey(
                              images[currentImage],
                            ),
                            fit: BoxFit.cover,
                            errorBuilder: (
                              context,
                              error,
                              stackTrace,
                            ) {
                              return Container(
                                color: card2,
                                child:
                                    const Center(
                                  child: Icon(
                                    Icons
                                        .broken_image_outlined,
                                    color: muted,
                                    size: 40,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                      // dark bottom gradient
                      IgnorePointer(
                        child: DecoratedBox(
                          decoration:
                              BoxDecoration(
                            gradient:
                                LinearGradient(
                              begin:
                                  Alignment.topCenter,
                              end:
                                  Alignment
                                      .bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black
                                    .withValues(
                                  alpha: .72,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        top: 15,
                        left: 15,
                        child: Container(
                          width: 43,
                          height: 43,
                          alignment:
                              Alignment.center,
                          decoration:
                              BoxDecoration(
                            color: Colors
                                .black
                                .withValues(
                              alpha: .55,
                            ),
                            shape:
                                BoxShape.circle,
                            border:
                                Border.all(
                              color: Colors
                                  .white
                                  .withValues(
                                alpha: .12,
                              ),
                            ),
                          ),
                          child:
                              Text(
                            '${widget.index + 1}'
                                .padLeft(
                              2,
                              '0',
                            ),
                            style:
                                GoogleFonts.dmSans(
                              color: white,
                              fontSize: 11,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),
                        ),
                      ),

                      if (images.length > 1)
                        Positioned(
                          right: 15,
                          top: 15,
                          child: Container(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal:
                                  10,
                              vertical: 7,
                            ),
                            decoration:
                                BoxDecoration(
                              color:
                                  Colors.black
                                      .withValues(
                                alpha: .60,
                              ),
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                100,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons
                                      .collections_outlined,
                                  color: lime,
                                  size: 13,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${currentImage + 1}/${images.length}',
                                  style:
                                      GoogleFonts.dmSans(
                                    color: white,
                                    fontSize: 9,
                                    fontWeight:
                                        FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      if (images.length > 1) ...[
                        Positioned(
                          left: 15,
                          bottom: 15,
                          child: _imageArrow(
                            icon: Icons
                                .arrow_back_ios_new_rounded,
                            enabled:
                                currentImage > 0,
                            onTap: () {
                              if (currentImage >
                                  0) {
                                setState(() {
                                  currentImage--;
                                });
                              }
                            },
                          ),
                        ),
                        Positioned(
                          right: 15,
                          bottom: 15,
                          child: _imageArrow(
                            icon: Icons
                                .arrow_forward_ios_rounded,
                            enabled:
                                currentImage <
                                    images.length -
                                        1,
                            onTap: () {
                              if (currentImage <
                                  images.length -
                                      1) {
                                setState(() {
                                  currentImage++;
                                });
                              }
                            },
                          ),
                        ),
                      ],

                      Positioned(
                        left: 65,
                        right: 65,
                        bottom: 17,
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Text(
                              images.length > 1
                                  ? 'CLICK TO VIEW GALLERY'
                                  : 'CLICK TO VIEW',
                              style:
                                  GoogleFonts.dmSans(
                                color: white
                                    .withValues(
                                  alpha: .9,
                                ),
                                fontSize: 8,
                                fontWeight:
                                    FontWeight.w800,
                                letterSpacing:
                                    1.7,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const Icon(
                              Icons
                                  .zoom_out_map_rounded,
                              color: lime,
                              size: 13,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ==================================================
              // THUMBNAILS
              // ==================================================

              if (images.length > 1)
                SizedBox(
                  height: 72,
                  child: Padding(
                    padding:
                        const EdgeInsets.fromLTRB(
                      14,
                      10,
                      14,
                      8,
                    ),
                    child: ListView.separated(
                      scrollDirection:
                          Axis.horizontal,
                      itemCount:
                          images.length,
                      separatorBuilder:
                          (context, i) =>
                              const SizedBox(
                        width: 8,
                      ),
                      itemBuilder:
                          (context, i) {
                        final bool active =
                            i == currentImage;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              currentImage =
                                  i;
                            });
                          },
                          child:
                              AnimatedContainer(
                            duration:
                                const Duration(
                              milliseconds: 160,
                            ),
                            width: 82,
                            decoration:
                                BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(
                                10,
                              ),
                              border:
                                  Border.all(
                                color: active
                                    ? lime
                                    : line,
                                width:
                                    active ? 2 : 1,
                              ),
                            ),
                            clipBehavior:
                                Clip.antiAlias,
                            child:
                                Image.network(
                              images[i],
                              fit:
                                  BoxFit.cover,
                              errorBuilder:
                                  (
                                context,
                                error,
                                stackTrace,
                              ) {
                                return Container(
                                  color: card2,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              // ==================================================
              // TEXT
              // ==================================================

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  22,
                  20,
                  22,
                  22,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    if (category.isNotEmpty)
                      Text(
                        category.toUpperCase(),
                        style:
                            GoogleFonts.dmSans(
                          color: lime,
                          fontSize: 9,
                          fontWeight:
                              FontWeight.w800,
                          letterSpacing: 2,
                        ),
                      ),
                    const SizedBox(height: 9),
                    Text(
                      title,
                      style:
                          GoogleFonts.dmSans(
                        color: white,
                        fontSize:
                            widget.mobile
                                ? 22
                                : 27,
                        fontWeight:
                            FontWeight.w800,
                        height: 1.08,
                        letterSpacing:
                            -1.1,
                      ),
                    ),
                    if (description.isNotEmpty)
                      Padding(
                        padding:
                            const EdgeInsets.only(
                          top: 13,
                        ),
                        child: Text(
                          description,
                          maxLines:
                              widget.mobile
                                  ? 5
                                  : 4,
                          overflow:
                              TextOverflow.ellipsis,
                          style:
                              GoogleFonts.dmSans(
                            color: muted,
                            fontSize: 13,
                            height: 1.65,
                          ),
                        ),
                      ),
                    if (technology.isNotEmpty)
                      Padding(
                        padding:
                            const EdgeInsets.only(
                          top: 15,
                        ),
                        child:
                            _technologyTags(
                          technology,
                        ),
                      ),
                    if (projectUrl.isNotEmpty)
                      Padding(
                        padding:
                            const EdgeInsets.only(
                          top: 20,
                        ),
                        child: InkWell(
                          onTap: () async {
                            Uri? uri =
                                Uri.tryParse(
                              projectUrl,
                            );

                            if (uri == null) {
                              return;
                            }

                            if (!uri.hasScheme) {
                              uri =
                                  Uri.tryParse(
                                'https://$projectUrl',
                              );
                            }

                            if (uri == null) {
                              return;
                            }

                            await launchUrl(
                              uri,
                              mode:
                                  LaunchMode
                                      .externalApplication,
                            );
                          },
                          borderRadius:
                              BorderRadius.circular(
                            100,
                          ),
                          child:
                              Container(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 16,
                              vertical: 11,
                            ),
                            decoration:
                                BoxDecoration(
                              color: lime,
                              borderRadius:
                                  BorderRadius.circular(
                                100,
                              ),
                            ),
                            child: Row(
                              mainAxisSize:
                                  MainAxisSize.min,
                              children: [
                                Text(
                                  'LIHAT PROJECT',
                                  style:
                                      GoogleFonts.dmSans(
                                    color:
                                        Colors.black,
                                    fontSize: 9,
                                    fontWeight:
                                        FontWeight.w900,
                                    letterSpacing:
                                        1.25,
                                  ),
                                ),
                                const SizedBox(
                                  width: 7,
                                ),
                                const Icon(
                                  Icons
                                      .arrow_outward_rounded,
                                  color:
                                      Colors.black,
                                  size: 14,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageArrow({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black
              .withValues(alpha: .58),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white
                .withValues(alpha: .10),
          ),
        ),
        child: Icon(
          icon,
          color: enabled
              ? white
              : muted.withValues(alpha: .3),
          size: 12,
        ),
      ),
    );
  }

  Widget _technologyTags(
    String technology,
  ) {
    final items = technology
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .take(6)
        .toList();

    return Wrap(
      spacing: 7,
      runSpacing: 7,
      children: items.map(
        (item) {
          return Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: Colors.white
                  .withValues(alpha: .035),
              border: Border.all(
                color: line,
              ),
              borderRadius:
                  BorderRadius.circular(
                100,
              ),
            ),
            child:
                Text(
              item,
              style: GoogleFonts.dmSans(
                color: muted,
                fontSize: 9,
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}