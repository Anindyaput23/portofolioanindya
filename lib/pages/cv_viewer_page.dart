import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web/web.dart' as web;

class CvViewerPage extends StatefulWidget {
  const CvViewerPage({
    super.key,
  });

  @override
  State<CvViewerPage> createState() => _CvViewerPageState();
}

class _CvViewerPageState extends State<CvViewerPage> {
  static const Color background = Color(0xFF09080F);
  static const Color surface = Color(0xFF15111D);
  static const Color pink = Color(0xFFFF4FA3);
  static const Color white = Color(0xFFF7F2FF);
  static const Color muted = Color(0xAAAFA7BA);

  static const String cvPath =
      'assets/assets/CV_Anindya_Putri_Nariswari.docx.pdf';

  static const String viewerType = 'cv-pdf-viewer';

  @override
  void initState() {
    super.initState();

    ui_web.platformViewRegistry.registerViewFactory(
      viewerType,
      (int viewId) {
        final iframe = web.HTMLIFrameElement();

        final pdfUrl =
            '${web.window.location.origin}/$cvPath#toolbar=1&navpanes=0&scrollbar=1';

        iframe.src = pdfUrl;

        iframe.style.border = 'none';
        iframe.style.width = '100%';
        iframe.style.height = '100%';
        iframe.style.backgroundColor = '#050509';

        return iframe;
      },
    );
  }

  void _downloadCv() {
    final anchor = web.HTMLAnchorElement();

    anchor.href = cvPath;
    anchor.download = 'CV_Anindya_Putri_Nariswari.pdf';
    anchor.target = '_blank';

    web.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: surface,
                border: const Border(
                  bottom: BorderSide(
                    color: Color(0xFF30263A),
                  ),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Kembali',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'CURRICULUM VITAE',
                      style: GoogleFonts.spaceMono(
                        color: white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: _downloadCv,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: pink.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: pink,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.download_rounded,
                              color: pink,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'UNDUH CV',
                              style: GoogleFonts.spaceMono(
                                color: white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFF050509),
                padding: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: const HtmlElementView(
                    viewType: viewerType,
                  ),
                ),
              ),
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              color: surface,
              child: Text(
                'CV • Anindya Putri Nariswari',
                style: GoogleFonts.spaceMono(
                  color: muted,
                  fontSize: 9,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}