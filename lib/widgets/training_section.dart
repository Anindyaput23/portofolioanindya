import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingSection extends StatelessWidget {
  const TrainingSection({
    super.key,
  });

  // ==========================================================
  // COLORS
  // ==========================================================

  static const Color burgundy =
      Color(0xFF7A1F3D);

  static const Color burgundyDark =
      Color(0xFF5C1730);

  static const Color ivory =
      Color(0xFFF4EFE6);

  static const Color taupe =
      Color(0xFF6F625D);

  static const Color border =
      Color(0xFFD8CEC2);

  static const Color softIvory =
      Color(0xFFE8DFD3);

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: ivory,
      padding: const EdgeInsets.fromLTRB(
        48,
        120,
        48,
        130,
      ),
      child: LayoutBuilder(
        builder: (
          context,
          constraints,
        ) {
          if (constraints.maxWidth < 800) {
            return _mobileLayout();
          }

          return _desktopLayout();
        },
      ),
    );
  }

  // ==========================================================
  // DESKTOP
  // ==========================================================

  Widget _desktopLayout() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _sectionLabel(),

        const SizedBox(
          height: 55,
        ),

        Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: _heading(),
            ),

            const SizedBox(
              width: 80,
            ),

            Expanded(
              flex: 6,
              child: _trainingList(),
            ),
          ],
        ),

        const SizedBox(
          height: 100,
        ),

        Container(
          width: double.infinity,
          height: 1,
          color: border,
        ),
      ],
    );
  }

  // ==========================================================
  // MOBILE
  // ==========================================================

  Widget _mobileLayout() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _sectionLabel(),

        const SizedBox(
          height: 45,
        ),

        _heading(),

        const SizedBox(
          height: 55,
        ),

        _trainingList(),

        const SizedBox(
          height: 70,
        ),

        Container(
          width: double.infinity,
          height: 1,
          color: border,
        ),
      ],
    );
  }

  // ==========================================================
  // SECTION LABEL
  // ==========================================================

  Widget _sectionLabel() {
    return Row(
      children: [
        Container(
          width: 38,
          height: 2,
          color: burgundy,
        ),

        const SizedBox(
          width: 15,
        ),

        Text(
          'TRAINING & COURSES',
          style: GoogleFonts.dmSans(
            color: burgundy,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.5,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // HEADING
  // ==========================================================

  Widget _heading() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'Pelatihan',
          style:
              GoogleFonts.cormorantGaramond(
            color: burgundyDark,
            fontSize: 76,
            height: 0.88,
            fontWeight:
                FontWeight.w400,
            letterSpacing: -2,
          ),
        ),

        Text(
          'yang saya ikuti.',
          style:
              GoogleFonts.cormorantGaramond(
            color: taupe,
            fontSize: 76,
            height: 0.88,
            fontWeight:
                FontWeight.w400,
            letterSpacing: -2,
          ),
        ),

        const SizedBox(
          height: 35,
        ),

        Text(
          'Pelatihan dan kursus yang '
          'menjadi bagian dari proses '
          'pengembangan kemampuan saya.',
          style: GoogleFonts.dmSans(
            color: taupe,
            fontSize: 15,
            height: 1.7,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // TRAINING LIST
  // ==========================================================

  Widget _trainingList() {
    return Column(
      children: [
        _trainingItem(
          number: '01',
          title:
              'Intro to Software Engineering',
          provider:
              'RevoU Coding Camp',
          date:
              '11 September 2026',
          credential:
              'Certificate of Attendance',
        ),
      ],
    );
  }

  // ==========================================================
  // TRAINING ITEM
  // ==========================================================

  Widget _trainingItem({
    required String number,
    required String title,
    required String provider,
    required String date,
    required String credential,
  }) {
    return Container(
      width: double.infinity,
      margin:
          const EdgeInsets.only(
        bottom: 18,
      ),
      padding:
          const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: softIvory,
        border: Border.all(
          color: border,
        ),
      ),
      child: LayoutBuilder(
        builder: (
          context,
          constraints,
        ) {
          if (constraints.maxWidth < 600) {
            return Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      number,
                      style: GoogleFonts
                          .cormorantGaramond(
                        color: burgundy,
                        fontSize: 27,
                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),

                    const Spacer(),

                    _trainingIcon(),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),

                _trainingContent(
                  title: title,
                  provider: provider,
                  date: date,
                  credential:
                      credential,
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 55,
                child: Text(
                  number,
                  style: GoogleFonts
                      .cormorantGaramond(
                    color: burgundy,
                    fontSize: 27,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(
                width: 20,
              ),

              Expanded(
                child: _trainingContent(
                  title: title,
                  provider: provider,
                  date: date,
                  credential:
                      credential,
                ),
              ),

              const SizedBox(
                width: 15,
              ),

              _trainingIcon(),
            ],
          );
        },
      ),
    );
  }

  // ==========================================================
  // TRAINING CONTENT
  // ==========================================================

  Widget _trainingContent({
    required String title,
    required String provider,
    required String date,
    required String credential,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              GoogleFonts.cormorantGaramond(
            color: burgundyDark,
            fontSize: 32,
            height: 1,
            fontWeight:
                FontWeight.w500,
          ),
        ),

        const SizedBox(
          height: 11,
        ),

        Text(
          provider.toUpperCase(),
          style: GoogleFonts.dmSans(
            color: burgundy,
            fontSize: 11,
            fontWeight:
                FontWeight.w700,
            letterSpacing: 1.4,
          ),
        ),

        const SizedBox(
          height: 7,
        ),

        Text(
          date,
          style: GoogleFonts.dmSans(
            color: taupe,
            fontSize: 13,
          ),
        ),

        const SizedBox(
          height: 10,
        ),

        Text(
          credential,
          style: GoogleFonts.dmSans(
            color: taupe,
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // ICON
  // ==========================================================

  Widget _trainingIcon() {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: ivory,
        border: Border.all(
          color: border,
        ),
      ),
      child: const Icon(
        Icons.school_outlined,
        color: burgundy,
        size: 19,
      ),
    );
  }
}