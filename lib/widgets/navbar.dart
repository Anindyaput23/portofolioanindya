import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Navbar extends StatelessWidget {
  final VoidCallback? onHome;
  final VoidCallback? onAbout;
  final VoidCallback? onSkills;
  final VoidCallback? onProjects;
  final VoidCallback? onCertificates;
  final VoidCallback? onContact;

  const Navbar({
    super.key,
    this.onHome,
    this.onAbout,
    this.onSkills,
    this.onProjects,
    this.onCertificates,
    this.onContact,
  });

  // ==========================================================
  // COLORS
  // ==========================================================

  static const Color navBackground = Color(0xFF080B14);

  static const Color navSurface = Color(0xFF101827);

  static const Color navWhite = Color(0xFFF5F7FF);

  static const Color navMuted = Color(0xFF9AA8C7);

  static const Color navBlue = Color(0xFF3B82F6);

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Material(
      color: navBackground,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMobile = constraints.maxWidth < 850;

          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: navBackground.withValues(alpha: 0.96),
              border: Border(
                bottom: BorderSide(
                  color: navWhite.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : 45,
                  vertical: isMobile ? 16 : 18,
                ),
                child: isMobile
                    ? _buildMobileNavbar(context)
                    : _buildDesktopNavbar(),
              ),
            ),
          );
        },
      ),
    );
  }

  // ==========================================================
  // DESKTOP NAVBAR
  // ==========================================================

  Widget _buildDesktopNavbar() {
    return Row(
      children: [
        // ======================================================
        // LOGO
        // ======================================================

        GestureDetector(
          onTap: onHome,
          child: Text(
            'ANINDYA',
            style: GoogleFonts.unbounded(
              color: navWhite,
              fontSize: 15,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ),

        const Spacer(),

        // ======================================================
        // NAVIGATION
        // ======================================================

        _navItem(
          label: 'BERANDA',
          onTap: onHome,
        ),

        const SizedBox(width: 28),

        _navItem(
          label: 'TENTANG',
          onTap: onAbout,
        ),

        const SizedBox(width: 28),

        _navItem(
          label: 'KEAHLIAN',
          onTap: onSkills,
        ),

        const SizedBox(width: 28),

        _navItem(
          label: 'PROYEK',
          onTap: onProjects,
        ),

        const SizedBox(width: 28),

        _navItem(
          label: 'SERTIFIKAT',
          onTap: onCertificates,
        ),

        const SizedBox(width: 28),

        _navItem(
          label: 'KONTAK',
          onTap: onContact,
        ),
      ],
    );
  }

  // ==========================================================
  // MOBILE NAVBAR
  // ==========================================================

  Widget _buildMobileNavbar(BuildContext context) {
    return Row(
      children: [
        // ======================================================
        // LOGO
        // ======================================================

        GestureDetector(
          onTap: onHome,
          child: Text(
            'ANINDYA',
            style: GoogleFonts.unbounded(
              color: navWhite,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
        ),

        const Spacer(),

        // ======================================================
        // MENU BUTTON
        // ======================================================

        Material(
          color: navSurface,
          borderRadius: BorderRadius.circular(100),
          child: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () {
              _showMobileMenu(context);
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: navBlue.withValues(alpha: 0.35),
                ),
              ),
              child: const Icon(
                Icons.menu_rounded,
                color: navWhite,
                size: 22,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // NAV ITEM
  // ==========================================================

  Widget _navItem({
    required String label,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      hoverColor: navBlue.withValues(alpha: 0.08),
      splashColor: navBlue.withValues(alpha: 0.12),
      highlightColor: navBlue.withValues(alpha: 0.06),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 8,
        ),
        child: Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            color: navMuted,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.3,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // MOBILE MENU
  // ==========================================================

  void _showMobileMenu(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: 'Menu Navigasi',
      barrierDismissible: true,
      barrierColor: navBackground.withValues(alpha: 0.88),
      transitionDuration: const Duration(
        milliseconds: 280,
      ),
      pageBuilder: (
        context,
        animation,
        secondaryAnimation,
      ) {
        return SafeArea(
          child: Material(
            color: navBackground,
            child: _MobileMenu(
              onHome: () {
                Navigator.of(context).pop();
                onHome?.call();
              },
              onAbout: () {
                Navigator.of(context).pop();
                onAbout?.call();
              },
              onSkills: () {
                Navigator.of(context).pop();
                onSkills?.call();
              },
              onProjects: () {
                Navigator.of(context).pop();
                onProjects?.call();
              },
              onCertificates: () {
                Navigator.of(context).pop();
                onCertificates?.call();
              },
              onContact: () {
                Navigator.of(context).pop();
                onContact?.call();
              },
            ),
          ),
        );
      },
      transitionBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
      ) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(
                0,
                -0.03,
              ),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }
}

// ============================================================
// MOBILE MENU
// ============================================================

class _MobileMenu extends StatelessWidget {
  final VoidCallback? onHome;
  final VoidCallback? onAbout;
  final VoidCallback? onSkills;
  final VoidCallback? onProjects;
  final VoidCallback? onCertificates;
  final VoidCallback? onContact;

  const _MobileMenu({
    this.onHome,
    this.onAbout,
    this.onSkills,
    this.onProjects,
    this.onCertificates,
    this.onContact,
  });

  // ==========================================================
  // COLORS
  // ==========================================================

  static const Color menuSurface = Color(0xFF101827);

  static const Color menuWhite = Color(0xFFF5F7FF);

  static const Color menuMuted = Color(0xFF9AA8C7);

  static const Color menuBlue = Color(0xFF3B82F6);

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ======================================================
        // TOP BAR
        // ======================================================

        Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            16,
            20,
            10,
          ),
          child: Row(
            children: [
              Text(
                'ANINDYA',
                style: GoogleFonts.unbounded(
                  color: menuWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const Spacer(),

              // ==================================================
              // CLOSE
              // ==================================================

              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: menuSurface,
                    border: Border.all(
                      color: menuBlue.withValues(alpha: 0.35),
                    ),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: menuWhite,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // ======================================================
        // MENU CONTENT
        // ======================================================

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _menuLabel('MENU'),

                const SizedBox(height: 10),

                _menuItem(
                  number: '01',
                  label: 'BERANDA',
                  onTap: onHome,
                ),

                _menuItem(
                  number: '02',
                  label: 'TENTANG',
                  onTap: onAbout,
                ),

                _menuItem(
                  number: '03',
                  label: 'KEAHLIAN',
                  onTap: onSkills,
                ),

                _menuItem(
                  number: '04',
                  label: 'PROYEK',
                  onTap: onProjects,
                ),

                _menuItem(
                  number: '05',
                  label: 'SERTIFIKAT',
                  onTap: onCertificates,
                ),

                _menuItem(
                  number: '06',
                  label: 'KONTAK',
                  onTap: onContact,
                ),
              ],
            ),
          ),
        ),

        // ======================================================
        // FOOTER
        // ======================================================

        Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            15,
            20,
            20,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'PENGEMBANG WEB & MOBILE',
              style: GoogleFonts.spaceGrotesk(
                color: menuMuted,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // MENU LABEL
  // ==========================================================

  Widget _menuLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.spaceGrotesk(
        color: menuBlue,
        fontSize: 9,
        fontWeight: FontWeight.w800,
        letterSpacing: 2.2,
      ),
    );
  }

  // ==========================================================
  // MENU ITEM
  // ==========================================================

  Widget _menuItem({
    required String number,
    required String label,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      hoverColor: menuBlue.withValues(alpha: 0.07),
      splashColor: menuBlue.withValues(alpha: 0.12),
      highlightColor: menuBlue.withValues(alpha: 0.06),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 18,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 35,
              child: Text(
                number,
                style: GoogleFonts.spaceGrotesk(
                  color: menuMuted.withValues(alpha: 0.55),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Expanded(
              child: Text(
                label,
                style: GoogleFonts.unbounded(
                  color: menuWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
              ),
            ),

            Icon(
              Icons.arrow_outward_rounded,
              color: menuBlue,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}