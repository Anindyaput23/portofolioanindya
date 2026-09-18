import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Navbar extends StatelessWidget {
  final VoidCallback? onHome;
  final VoidCallback? onAbout;
  final VoidCallback? onSkills;
  final VoidCallback? onProjects;
  final VoidCallback? onCertificates;
  final VoidCallback? onTraining;
  final VoidCallback? onContact;

  const Navbar({
    super.key,
    this.onHome,
    this.onAbout,
    this.onSkills,
    this.onProjects,
    this.onCertificates,
    this.onTraining,
    this.onContact,
  });

  static const Color navBackground = Color(0xFF120F1D);
  static const Color navSurface = Color(0xFF1C1730);
  static const Color navWhite = Color(0xFFF5F0FF);
  static const Color navMuted = Color(0xFFB4A9D6);
  static const Color navPink = Color(0xFFFF3EA0);
  static const Color navLime = Color(0xFFA8FF3E);

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

  Widget _buildDesktopNavbar() {
    return Row(
      children: [
        GestureDetector(
          onTap: onHome,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ANINDYA', style: GoogleFonts.unbounded(color: navWhite, fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
              const SizedBox(width: 3),
              Text('.', style: GoogleFonts.unbounded(color: navLime, fontSize: 18, fontWeight: FontWeight.w900)),
            ],
          ),
        ),
        const Spacer(),
        _navItem(label: 'HOME', onTap: onHome),
        const SizedBox(width: 28),
        _navItem(label: 'ABOUT', onTap: onAbout),
        const SizedBox(width: 28),
        _navItem(label: 'SKILLS', onTap: onSkills),
        const SizedBox(width: 28),
        _navItem(label: 'PROJECTS', onTap: onProjects),
        const SizedBox(width: 28),
        _navItem(label: 'CERTIFICATES', onTap: onCertificates),
        const SizedBox(width: 28),
        _navItem(label: 'TRAINING', onTap: onTraining),
        const SizedBox(width: 28),
        _navItem(label: 'CONTACT', onTap: onContact),
      ],
    );
  }

  Widget _buildMobileNavbar(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onHome,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ANINDYA', style: GoogleFonts.unbounded(color: navWhite, fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
              Text('.', style: GoogleFonts.unbounded(color: navLime, fontSize: 16, fontWeight: FontWeight.w900)),
            ],
          ),
        ),
        const Spacer(),
        Material(
          color: navSurface,
          borderRadius: BorderRadius.circular(100),
          child: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () => _showMobileMenu(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: navWhite.withValues(alpha: 0.10)),
              ),
              child: const Icon(Icons.menu_rounded, color: navWhite, size: 22),
            ),
          ),
        ),
      ],
    );
  }

  Widget _navItem({required String label, required VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
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

  void _showMobileMenu(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: 'Mobile Menu',
      barrierDismissible: true,
      barrierColor: navBackground.withValues(alpha: 0.88),
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Material(
            color: navBackground,
            child: _MobileMenu(
              onHome: () { Navigator.of(context).pop(); onHome?.call(); },
              onAbout: () { Navigator.of(context).pop(); onAbout?.call(); },
              onSkills: () { Navigator.of(context).pop(); onSkills?.call(); },
              onProjects: () { Navigator.of(context).pop(); onProjects?.call(); },
              onCertificates: () { Navigator.of(context).pop(); onCertificates?.call(); },
              onTraining: () { Navigator.of(context).pop(); onTraining?.call(); },
              onContact: () { Navigator.of(context).pop(); onContact?.call(); },
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, -0.03), end: Offset.zero).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
    );
  }
}

class _MobileMenu extends StatelessWidget {
  final VoidCallback? onHome;
  final VoidCallback? onAbout;
  final VoidCallback? onSkills;
  final VoidCallback? onProjects;
  final VoidCallback? onCertificates;
  final VoidCallback? onTraining;
  final VoidCallback? onContact;

  const _MobileMenu({
    this.onHome,
    this.onAbout,
    this.onSkills,
    this.onProjects,
    this.onCertificates,
    this.onTraining,
    this.onContact,
  });

  static const Color menuSurface = Color(0xFF1C1730);
  static const Color menuWhite = Color(0xFFF5F0FF);
  static const Color menuMuted = Color(0xFFB4A9D6);
  static const Color menuPink = Color(0xFFFF3EA0);
  static const Color menuLime = Color(0xFFA8FF3E);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
          child: Row(
            children: [
              Text('ANINDYA', style: GoogleFonts.unbounded(color: menuWhite, fontSize: 14, fontWeight: FontWeight.w800)),
              Text('.', style: GoogleFonts.unbounded(color: menuLime, fontSize: 17, fontWeight: FontWeight.w900)),
              const Spacer(),
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: menuSurface,
                    border: Border.all(color: menuWhite.withValues(alpha: 0.10)),
                  ),
                  child: const Icon(Icons.close_rounded, color: menuWhite, size: 22),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _menuLabel('MENU'),
                const SizedBox(height: 10),
                _menuItem(number: '01', label: 'HOME', onTap: onHome),
                _menuItem(number: '02', label: 'ABOUT', onTap: onAbout),
                _menuItem(number: '03', label: 'SKILLS', onTap: onSkills),
                _menuItem(number: '04', label: 'PROJECTS', onTap: onProjects),
                _menuItem(number: '05', label: 'CERTIFICATES', onTap: onCertificates),
                _menuItem(number: '06', label: 'TRAINING', onTap: onTraining),
                _menuItem(number: '07', label: 'CONTACT', onTap: onContact),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
          child: Row(
            children: [
              Container(width: 7, height: 7, decoration: const BoxDecoration(color: menuLime, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text('WEB & MOBILE DEVELOPER', style: GoogleFonts.spaceGrotesk(color: menuMuted, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _menuLabel(String text) {
    return Text(text, style: GoogleFonts.spaceGrotesk(color: menuPink, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 2.2));
  }

  Widget _menuItem({required String number, required String label, required VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          children: [
            SizedBox(width: 35, child: Text(number, style: GoogleFonts.spaceGrotesk(color: menuMuted.withValues(alpha: 0.55), fontSize: 10, fontWeight: FontWeight.w600))),
            Expanded(child: Text(label, style: GoogleFonts.unbounded(color: menuWhite, fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: -0.5))),
            const Icon(Icons.arrow_outward_rounded, color: menuLime, size: 18),
          ],
        ),
      ),
    );
  }
}
