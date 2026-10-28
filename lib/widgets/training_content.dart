import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class TrainingContent extends StatelessWidget {
  final bool mobile;

  const TrainingContent({
    super.key,
    this.mobile = false,
  });

  static const Color card = Color(0xFF191919);
  static const Color border = Color(0xFF363636);
  static const Color muted = Color(0xFF999999);
  static const Color pink = Color(0xFFFF4FA3);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('training')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 260,
            child: Center(
              child: CircularProgressIndicator(color: pink, strokeWidth: 2),
            ),
          );
        }

        if (snapshot.hasError) {
          return _message('Gagal memuat training.');
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return _message('Belum ada training yang ditambahkan.');
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final int columns = mobile
                ? 1
                : constraints.maxWidth >= 1000
                    ? 3
                    : 2;

            const double gap = 20;

            final double width = columns == 1
                ? constraints.maxWidth
                : (constraints.maxWidth - ((columns - 1) * gap)) / columns;

            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: List.generate(docs.length, (index) {
                final data = docs[index].data();

                final issuer = data['issuer']?.toString().trim() ?? '';
                final year = data['year']?.toString().trim() ?? '';

                return SizedBox(
                  width: width,
                  child: _TrainingCard(
                    title: data['name']?.toString().trim() ?? '',
                    issuer: [
                      if (issuer.isNotEmpty) issuer,
                      if (year.isNotEmpty) year,
                    ].join(' • '),
                    trainingUrl: data['trainingUrl']?.toString().trim() ?? '',
                    imageUrl: data['imageUrl']?.toString().trim() ?? '',
                  ),
                );
              }),
            );
          },
        );
      },
    );
  }

  Widget _message(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(35),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border),
      ),
      child: Text(
        text,
        style: GoogleFonts.dmSans(color: muted, fontSize: 13),
      ),
    );
  }
}

class _TrainingCard extends StatefulWidget {
  final String title;
  final String issuer;
  final String trainingUrl;
  final String imageUrl;

  const _TrainingCard({
    required this.title,
    required this.issuer,
    required this.trainingUrl,
    required this.imageUrl,
  });

  @override
  State<_TrainingCard> createState() => _TrainingCardState();
}

class _TrainingCardState extends State<_TrainingCard> {
  bool hovering = false;

  static const Color card = Color(0xFF191919);
  static const Color hoverCard = Color(0xFF202020);
  static const Color border = Color(0xFF363636);
  static const Color white = Color(0xFFF5F5F5);
  static const Color pink = Color(0xFFFF4FA3);

  String? _driveId(String url) {
    final patterns = <RegExp>[
      RegExp(r'/file/d/([a-zA-Z0-9_-]+)'),
      RegExp(r'/d/([a-zA-Z0-9_-]+)'),
      RegExp(r'[?&]id=([a-zA-Z0-9_-]+)'),
    ];

    for (final p in patterns) {
      final m = p.firstMatch(url);
      if (m != null) return m.group(1);
    }
    return null;
  }

  // Prioritas: imageUrl (Cloudinary) -> thumbnail Drive -> link gambar langsung
  String? _previewUrl() {
    if (widget.imageUrl.isNotEmpty) return widget.imageUrl;

    final url = widget.trainingUrl;
    if (url.isEmpty) return null;

    final id = _driveId(url);
    if (id != null) {
      return 'https://drive.google.com/thumbnail?id=$id&sz=w1200';
    }

    final lower = url.toLowerCase();
    if (lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.webp')) {
      return url;
    }

    return null;
  }

  Future<void> _openUrl() async {
    String url = widget.trainingUrl;
    if (url.isEmpty) return;

    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    final uri = Uri.tryParse(url);
    if (uri == null) return;

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _showPreview() {
    final preview = _previewUrl();

    if (preview == null) {
      _openUrl();
      return;
    }

    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: .92),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              Center(
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 1100,
                    maxHeight: 800,
                  ),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF151515),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: .10),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: InteractiveViewer(
                      minScale: .5,
                      maxScale: 4,
                      child: Image.network(
                        preview,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Padding(
                          padding: EdgeInsets.all(40),
                          child: Icon(
                            Icons.broken_image_outlined,
                            color: Colors.white54,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final preview = _previewUrl();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: GestureDetector(
        onTap: _showPreview,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, hovering ? -4 : 0, 0),
          decoration: BoxDecoration(
            color: hovering ? hoverCard : card,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: hovering ? pink.withValues(alpha: .45) : border,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.48,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (preview != null)
                      Image.network(
                        preview,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _fallback(),
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            color: const Color(0xFF242424),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: pink,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                      )
                    else
                      _fallback(),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 180),
                      opacity: hovering ? 1 : 0,
                      child: Container(
                        color: Colors.black.withValues(alpha: .30),
                        child: const Center(
                          child: Icon(
                            Icons.zoom_in_rounded,
                            color: white,
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 17, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title.isEmpty
                          ? 'Training & Course'
                          : widget.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.dmSans(
                        color: white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                      ),
                    ),
                    if (widget.issuer.isNotEmpty) ...[
                      const SizedBox(height: 7),
                      Text(
                        widget.issuer,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.dmSans(
                          color: pink,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fallback() {
    return Container(
      color: const Color(0xFF242424),
      child: const Center(
        child: Icon(
          Icons.school_outlined,
          color: Colors.white54,
          size: 42,
        ),
      ),
    );
  }
}