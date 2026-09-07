import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class CertificatesSection
    extends StatelessWidget {
  const CertificatesSection({
    super.key,
  });

  static const Color background =
      Color(0xFF0D0B12);

  static const Color surface =
      Color(0xFF17131F);

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

  Future<void> _openCertificate(
    String url,
  ) async {
    if (url.trim().isEmpty) {
      return;
    }

    Uri? uri =
        Uri.tryParse(
      url.trim(),
    );

    if (uri == null) {
      return;
    }

    if (!uri.hasScheme) {
      uri =
          Uri.tryParse(
        'https://${url.trim()}',
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
  }

  @override
  Widget build(
    BuildContext context,
  ) {
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
            padding:
                EdgeInsets.fromLTRB(
              mobile ? 22 : 60,
              mobile ? 80 : 110,
              mobile ? 22 : 60,
              mobile ? 85 : 115,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                _header(
                  mobile,
                ),

                SizedBox(
                  height:
                      mobile ? 45 : 60,
                ),

                StreamBuilder<
                    QuerySnapshot<
                        Map<String, dynamic>>>(
                  stream:
                      FirebaseFirestore
                          .instance
                          .collection(
                        'certificates',
                      )
                          .orderBy(
                        'createdAt',
                        descending:
                            true,
                      )
                          .snapshots(),
                  builder: (
                    context,
                    snapshot,
                  ) {
                    if (snapshot
                            .connectionState ==
                        ConnectionState
                            .waiting) {
                      return _loading();
                    }

                    if (snapshot.hasError) {
                      return _error(
                        snapshot.error
                            .toString(),
                      );
                    }

                    final certificates =
                        snapshot.data?.docs ??
                            [];

                    if (certificates.isEmpty) {
                      return _empty();
                    }

                    return Column(
                      children:
                          List.generate(
                        certificates.length,
                        (index) {
                          return _CertificateItem(
                            index:
                                index,
                            data:
                                certificates[
                                        index]
                                    .data(),
                            onOpen:
                                _openCertificate,
                            mobile:
                                mobile,
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

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
              width: 34,
              height: 3,
              color: purple,
            ),
            const SizedBox(
              width: 11,
            ),
            Text(
              'CREDENTIALS',
              style:
                  GoogleFonts.spaceGrotesk(
                color: purple,
                fontSize: 10,
                fontWeight:
                    FontWeight.w800,
                letterSpacing:
                    2.5,
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 18,
        ),

        Text(
          'Sertifikasi',
          style:
              GoogleFonts.unbounded(
            color: white,
            fontSize:
                mobile ? 29 : 47,
            fontWeight:
                FontWeight.w700,
            height: 1.05,
            letterSpacing:
                mobile ? -1 : -2,
          ),
        ),

        Text(
          'yang saya raih.',
          style:
              GoogleFonts.unbounded(
            color: pink,
            fontSize:
                mobile ? 29 : 47,
            fontWeight:
                FontWeight.w500,
            height: 1.05,
            letterSpacing:
                mobile ? -1 : -2,
          ),
        ),

        const SizedBox(
          height: 13,
        ),

        Text(
          'Sertifikasi yang mendukung '
          'perjalanan saya di bidang teknologi.',
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

  Widget _loading() {
    return const SizedBox(
      height: 220,
      child: Center(
        child:
            CircularProgressIndicator(
          color: purple,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _error(
    String error,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(
        25,
      ),
      decoration:
          BoxDecoration(
        color: surface,
        borderRadius:
            BorderRadius.circular(
          18,
        ),
      ),
      child: Text(
        'Gagal memuat sertifikasi.\n$error',
        style:
            GoogleFonts.spaceGrotesk(
          color: muted,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _empty() {
    return Container(
      padding:
          const EdgeInsets.all(
        30,
      ),
      decoration:
          BoxDecoration(
        color: surface,
        borderRadius:
            BorderRadius.circular(
          18,
        ),
      ),
      child: Text(
        'Belum ada sertifikasi yang ditambahkan.',
        style:
            GoogleFonts.spaceGrotesk(
          color: muted,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _CertificateItem
    extends StatefulWidget {
  final int index;
  final Map<String, dynamic> data;
  final Future<void> Function(
    String,
  ) onOpen;
  final bool mobile;

  const _CertificateItem({
    required this.index,
    required this.data,
    required this.onOpen,
    required this.mobile,
  });

  @override
  State<_CertificateItem> createState() =>
      _CertificateItemState();
}

class _CertificateItemState
    extends State<_CertificateItem> {
  bool hovering = false;

  static const Color surface =
      Color(0xFF17131F);

  static const Color surface2 =
      Color(0xFF1E1829);

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

  @override
  Widget build(
    BuildContext context,
  ) {
    final String name =
        widget.data['name']
                ?.toString()
                .trim() ??
            'Sertifikat';

    final String issuer =
        widget.data['issuer']
                ?.toString()
                .trim() ??
            '';

    final String year =
        widget.data['year']
                ?.toString()
                .trim() ??
            '';

    final String credential =
        widget.data['credential']
                ?.toString()
                .trim() ??
            '';

    final String url =
        widget.data['certificateUrl']
                ?.toString()
                .trim() ??
            '';

    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 13,
      ),
      child: MouseRegion(
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
          duration:
              const Duration(
            milliseconds: 180,
          ),
          curve:
              Curves.easeOutCubic,
          transform:
              Matrix4.translationValues(
            hovering ? 6 : 0,
            hovering ? -2 : 0,
            0,
          ),
          padding:
              EdgeInsets.all(
            widget.mobile ? 20 : 24,
          ),
          decoration:
              BoxDecoration(
            color:
                hovering
                    ? surface2
                    : surface,
            borderRadius:
                BorderRadius.circular(
              20,
            ),
            border:
                Border.all(
              color:
                  hovering
                      ? purple.withValues(
                          alpha:
                              0.55,
                        )
                      : white.withValues(
                          alpha:
                              0.08,
                        ),
            ),
          ),
          child:
              widget.mobile
                  ? _mobile(
                      name:
                          name,
                      issuer:
                          issuer,
                      year:
                          year,
                      credential:
                          credential,
                      url:
                          url,
                    )
                  : _desktop(
                      name:
                          name,
                      issuer:
                          issuer,
                      year:
                          year,
                      credential:
                          credential,
                      url:
                          url,
                    ),
        ),
      ),
    );
  }

  Widget _desktop({
    required String name,
    required String issuer,
    required String year,
    required String credential,
    required String url,
  }) {
    return Row(
      children: [
        _index(),

        const SizedBox(
          width: 20,
        ),

        Container(
          width: 48,
          height: 48,
          decoration:
              BoxDecoration(
            color:
                _accent(),
            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),
          child:
              const Icon(
            Icons.workspace_premium_outlined,
            color:
                Color(0xFF120F1D),
            size:
                22,
          ),
        ),

        const SizedBox(
          width: 18,
        ),

        Expanded(
          child:
              _details(
            name:
                name,
            issuer:
                issuer,
            year:
                year,
            credential:
                credential,
          ),
        ),

        if (url.isNotEmpty)
          _button(
            url,
          ),
      ],
    );
  }

  Widget _mobile({
    required String name,
    required String issuer,
    required String year,
    required String credential,
    required String url,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _index(),
            const Spacer(),
            Container(
              width: 42,
              height: 42,
              decoration:
                  BoxDecoration(
                color:
                    _accent(),
                borderRadius:
                    BorderRadius.circular(
                  13,
                ),
              ),
              child:
                  const Icon(
                Icons.workspace_premium_outlined,
                color:
                    Color(0xFF120F1D),
                size:
                    19,
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 18,
        ),

        _details(
          name:
              name,
          issuer:
              issuer,
          year:
              year,
          credential:
              credential,
        ),

        if (url.isNotEmpty) ...[
          const SizedBox(
            height: 16,
          ),
          _button(
            url,
          ),
        ],
      ],
    );
  }

  Widget _index() {
    return Text(
      (widget.index + 1)
          .toString()
          .padLeft(
            2,
            '0',
          ),
      style:
          GoogleFonts.unbounded(
        color: purple,
        fontSize: 10,
        fontWeight:
            FontWeight.w700,
      ),
    );
  }

  Widget _details({
    required String name,
    required String issuer,
    required String year,
    required String credential,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style:
              GoogleFonts.spaceGrotesk(
            color: white,
            fontSize:
                widget.mobile
                    ? 17
                    : 21,
            fontWeight:
                FontWeight.w700,
            height: 1.2,
          ),
        ),

        if (issuer.isNotEmpty) ...[
          const SizedBox(
            height: 7,
          ),
          Text(
            issuer,
            style:
                GoogleFonts.spaceGrotesk(
              color: pink,
              fontSize: 10,
              fontWeight:
                  FontWeight.w800,
              letterSpacing:
                  1.1,
            ),
          ),
        ],

        if (year.isNotEmpty) ...[
          const SizedBox(
            height: 4,
          ),
          Text(
            year,
            style:
                GoogleFonts.spaceGrotesk(
              color: muted,
              fontSize: 10,
            ),
          ),
        ],

        if (credential.isNotEmpty) ...[
          const SizedBox(
            height: 7,
          ),
          Text(
            credential,
            style:
                GoogleFonts.spaceGrotesk(
              color: muted,
              fontSize: 11,
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }

  Widget _button(
    String url,
  ) {
    return InkWell(
      onTap: () {
        widget.onOpen(
          url,
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
          horizontal: 14,
          vertical: 10,
        ),
        decoration:
            BoxDecoration(
          color:
              lime,
          borderRadius:
              BorderRadius.circular(
            100,
          ),
        ),
        child:
            Row(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Text(
              'LIHAT',
              style:
                  GoogleFonts
                      .spaceGrotesk(
                color:
                    const Color(
                  0xFF120F1D,
                ),
                fontSize:
                    9,
                fontWeight:
                    FontWeight.w800,
                letterSpacing:
                    1.2,
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            const Icon(
              Icons
                  .arrow_outward_rounded,
              color:
                  Color(
                0xFF120F1D,
              ),
              size:
                  14,
            ),
          ],
        ),
      ),
    );
  }

  Color _accent() {
    switch (widget.index %
        3) {
      case 0:
        return lime;
      case 1:
        return pink;
      default:
        return purple;
    }
  }
}