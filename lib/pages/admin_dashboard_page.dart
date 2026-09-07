import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/firestore_service.dart';

import 'admin_certificates_page.dart';
import 'admin_login_page.dart';
import 'admin_profile_page.dart';
import 'admin_projects_page.dart';
import 'admin_skills_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({
    super.key,
  });

  @override
  State<AdminDashboardPage> createState() =>
      _AdminDashboardPageState();
}

class _AdminDashboardPageState
    extends State<AdminDashboardPage> {
  final FirestoreService _firestore =
      FirestoreService();

  final AuthService _authService =
      AuthService();

  final GlobalKey<ScaffoldState>
      _scaffoldKey =
      GlobalKey<ScaffoldState>();

  int _selectedMenu = 0;

  // ==========================================================
  // COLORS
  // ==========================================================

  static const Color background =
      Color(0xFF09070F);

  static const Color surface =
      Color(0xFF15111D);

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

  // ==========================================================
  // ADMIN CHECK
  // ==========================================================

  bool _isAdmin() {
    final user =
        _authService.currentUser;

    if (user == null) {
      return false;
    }

    return user.email ==
        'anindyaputri231204@gmail.com';
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    if (!_isAdmin()) {
      return const _UnauthorizedAdminPage();
    }

    return LayoutBuilder(
      builder: (
        context,
        constraints,
      ) {
        final bool mobile =
            constraints.maxWidth < 900;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor:
              background,
          drawer:
              mobile
                  ? _buildDrawer()
                  : null,
          body:
              mobile
                  ? Column(
                      children: [
                        _buildMobileHeader(),
                        Expanded(
                          child:
                              _buildContent(),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        _buildSidebar(),
                        Expanded(
                          child:
                              _buildContent(),
                        ),
                      ],
                    ),
        );
      },
    );
  }

  // ==========================================================
  // MOBILE HEADER
  // ==========================================================

  Widget _buildMobileHeader() {
    return Container(
      height: 70,
      width: double.infinity,
      decoration:
          BoxDecoration(
        color: surface,
        border:
            Border(
          bottom:
              BorderSide(
            color:
                white.withValues(
              alpha: 0.08,
            ),
          ),
        ),
      ),
      child:
          Row(
        children: [
          IconButton(
            onPressed: () {
              _scaffoldKey
                  .currentState
                  ?.openDrawer();
            },
            icon:
                const Icon(
              Icons.menu_rounded,
              color: white,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          const Text(
            'ANINDYA',
            style:
                TextStyle(
              color: lime,
              fontSize: 16,
              fontWeight:
                  FontWeight.w800,
              letterSpacing: 2.8,
            ),
          ),
          const Spacer(),
          Padding(
            padding:
                const EdgeInsets.only(
              right: 18,
            ),
            child:
                Text(
              _currentMenuTitle(),
              style:
                  const TextStyle(
                color: muted,
                fontSize: 9,
                fontWeight:
                    FontWeight.w700,
                letterSpacing:
                    1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // CURRENT TITLE
  // ==========================================================

  String _currentMenuTitle() {
    switch (_selectedMenu) {
      case 1:
        return 'PROJECTS';
      case 2:
        return 'SKILLS';
      case 3:
        return 'SERTIFIKASI';
      case 4:
        return 'PROFILE';
      default:
        return 'DASHBOARD';
    }
  }

  // ==========================================================
  // SIDEBAR
  // ==========================================================

  Widget _buildSidebar() {
    return Container(
      width: 250,
      decoration:
          BoxDecoration(
        color: surface,
        border:
            Border(
          right:
              BorderSide(
            color:
                white.withValues(
              alpha: 0.08,
            ),
          ),
        ),
      ),
      child:
          SafeArea(
        child:
            Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 35,
            ),

            const Padding(
              padding:
                  EdgeInsets.symmetric(
                horizontal: 28,
              ),
              child:
                  Text(
                'ANINDYA',
                style:
                    TextStyle(
                  color: lime,
                  fontSize: 22,
                  fontWeight:
                      FontWeight.w800,
                  letterSpacing: 3,
                ),
              ),
            ),

            const Padding(
              padding:
                  EdgeInsets.symmetric(
                horizontal: 28,
              ),
              child:
                  Text(
                'ADMIN PANEL',
                style:
                    TextStyle(
                  color: muted,
                  fontSize: 9,
                  fontWeight:
                      FontWeight.w600,
                  letterSpacing: 2.4,
                ),
              ),
            ),

            const SizedBox(
              height: 45,
            ),

            _menuItem(
              icon:
                  Icons.dashboard_outlined,
              title:
                  'Dashboard',
              index:
                  0,
            ),

            _menuItem(
              icon:
                  Icons.work_outline_rounded,
              title:
                  'Projects',
              index:
                  1,
            ),

            _menuItem(
              icon:
                  Icons.code_rounded,
              title:
                  'Skills',
              index:
                  2,
            ),

            _menuItem(
              icon:
                  Icons.workspace_premium_outlined,
              title:
                  'Sertifikasi',
              index:
                  3,
            ),

            _menuItem(
              icon:
                  Icons.person_outline_rounded,
              title:
                  'Profile',
              index:
                  4,
            ),

            const Spacer(),

            Padding(
              padding:
                  const EdgeInsets.all(
                20,
              ),
              child:
                  SizedBox(
                width:
                    double.infinity,
                child:
                    OutlinedButton.icon(
                  onPressed:
                      _logout,
                  icon:
                      const Icon(
                    Icons.logout_rounded,
                    size: 16,
                  ),
                  label:
                      const Text(
                    'LOGOUT',
                  ),
                  style:
                      OutlinedButton.styleFrom(
                    foregroundColor:
                        pink,
                    side:
                        BorderSide(
                      color:
                          pink.withValues(
                        alpha:
                            0.35,
                      ),
                    ),
                    padding:
                        const EdgeInsets
                            .symmetric(
                      vertical: 14,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // DRAWER
  // ==========================================================

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor:
          surface,
      width: 280,
      child:
          SafeArea(
        child:
            Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                28,
                30,
                25,
                25,
              ),
              child:
                  Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ANINDYA',
                    style:
                        TextStyle(
                      color: lime,
                      fontSize: 22,
                      fontWeight:
                          FontWeight.w800,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    'ADMIN PANEL',
                    style:
                        TextStyle(
                      color: muted,
                      fontSize: 9,
                      fontWeight:
                          FontWeight.w600,
                      letterSpacing: 2.4,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    width:
                        double.infinity,
                    height: 1,
                    color:
                        white.withValues(
                      alpha: 0.08,
                    ),
                  ),
                ],
              ),
            ),

            _drawerMenuItem(
              icon:
                  Icons.dashboard_outlined,
              title:
                  'Dashboard',
              index:
                  0,
            ),

            _drawerMenuItem(
              icon:
                  Icons.work_outline_rounded,
              title:
                  'Projects',
              index:
                  1,
            ),

            _drawerMenuItem(
              icon:
                  Icons.code_rounded,
              title:
                  'Skills',
              index:
                  2,
            ),

            _drawerMenuItem(
              icon:
                  Icons.workspace_premium_outlined,
              title:
                  'Sertifikasi',
              index:
                  3,
            ),

            _drawerMenuItem(
              icon:
                  Icons.person_outline_rounded,
              title:
                  'Profile',
              index:
                  4,
            ),

            const Spacer(),

            Padding(
              padding:
                  const EdgeInsets.all(
                20,
              ),
              child:
                  SizedBox(
                width:
                    double.infinity,
                child:
                    OutlinedButton.icon(
                  onPressed:
                      _logout,
                  icon:
                      const Icon(
                    Icons.logout_rounded,
                    size: 16,
                  ),
                  label:
                      const Text(
                    'LOGOUT',
                  ),
                  style:
                      OutlinedButton.styleFrom(
                    foregroundColor:
                        pink,
                    side:
                        BorderSide(
                      color:
                          pink.withValues(
                        alpha: 0.35,
                      ),
                    ),
                    padding:
                        const EdgeInsets
                            .symmetric(
                      vertical: 14,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // DESKTOP MENU ITEM
  // ==========================================================

  Widget _menuItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final bool active =
        _selectedMenu == index;

    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 3,
      ),
      child:
          InkWell(
        borderRadius:
            BorderRadius.circular(
          12,
        ),
        onTap: () {
          setState(() {
            _selectedMenu =
                index;
          });
        },
        child:
            AnimatedContainer(
          duration:
              const Duration(
            milliseconds:
                180,
          ),
          padding:
              const EdgeInsets.symmetric(
            horizontal:
                16,
            vertical:
                14,
          ),
          decoration:
              BoxDecoration(
            color:
                active
                    ? pink.withValues(
                        alpha: 0.10,
                      )
                    : Colors.transparent,
            borderRadius:
                BorderRadius.circular(
              12,
            ),
            border:
                Border.all(
              color:
                  active
                      ? pink.withValues(
                          alpha: 0.25,
                        )
                      : Colors.transparent,
            ),
          ),
          child:
              Row(
            children: [
              Icon(
                icon,
                size: 19,
                color:
                    active
                        ? pink
                        : muted,
              ),
              const SizedBox(
                width: 13,
              ),
              Text(
                title,
                style:
                    TextStyle(
                  color:
                      active
                          ? white
                          : muted,
                  fontSize: 13,
                  fontWeight:
                      active
                          ? FontWeight.w700
                          : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // DRAWER MENU ITEM
  // ==========================================================

  Widget _drawerMenuItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final bool active =
        _selectedMenu == index;

    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 3,
      ),
      child:
          InkWell(
        borderRadius:
            BorderRadius.circular(
          12,
        ),
        onTap: () {
          setState(() {
            _selectedMenu =
                index;
          });

          Navigator.of(
            context,
          ).pop();
        },
        child:
            Container(
          width:
              double.infinity,
          padding:
              const EdgeInsets.symmetric(
            horizontal:
                16,
            vertical:
                15,
          ),
          decoration:
              BoxDecoration(
            color:
                active
                    ? pink.withValues(
                        alpha: 0.10,
                      )
                    : Colors.transparent,
            borderRadius:
                BorderRadius.circular(
              12,
            ),
          ),
          child:
              Row(
            children: [
              Icon(
                icon,
                size: 19,
                color:
                    active
                        ? pink
                        : muted,
              ),
              const SizedBox(
                width: 13,
              ),
              Text(
                title,
                style:
                    TextStyle(
                  color:
                      active
                          ? white
                          : muted,
                  fontSize: 13,
                  fontWeight:
                      active
                          ? FontWeight.w700
                          : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // CONTENT SWITCH
  // ==========================================================

  Widget _buildContent() {
    switch (_selectedMenu) {
      case 1:
        return const AdminProjectsPage();

      case 2:
        return const AdminSkillsPage();

      case 3:
        return const AdminCertificatesPage();

      case 4:
        return const AdminProfilePage();

      default:
        return _buildDashboard();
    }
  }

  // ==========================================================
  // DASHBOARD
  // ==========================================================

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding:
          const EdgeInsets.all(
        38,
      ),
      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _dashboardHeader(),

          const SizedBox(
            height: 35,
          ),

          LayoutBuilder(
            builder: (
              context,
              constraints,
            ) {
              if (constraints.maxWidth <
                  700) {
                return Column(
                  children: [
                    _projectStat(),
                    const SizedBox(
                      height: 12,
                    ),
                    _skillStat(),
                    const SizedBox(
                      height: 12,
                    ),
                    _certificateStat(),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child:
                        _projectStat(),
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child:
                        _skillStat(),
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child:
                        _certificateStat(),
                  ),
                ],
              );
            },
          ),

          const SizedBox(
            height: 35,
          ),

          _quickActions(),
        ],
      ),
    );
  }

  // ==========================================================
  // DASHBOARD HEADER
  // ==========================================================

  Widget _dashboardHeader() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'DASHBOARD',
          style:
              TextStyle(
            color: lime,
            fontSize: 10,
            fontWeight:
                FontWeight.w800,
            letterSpacing: 2.7,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Selamat datang kembali.',
          style:
              TextStyle(
            color: white,
            fontSize: 28,
            fontWeight:
                FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 7,
        ),
        const Text(
          'Kelola isi portfolio kamu dari satu tempat.',
          style:
              TextStyle(
            color: muted,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // PROJECT STAT
  // ==========================================================

  Widget _projectStat() {
    return StreamBuilder<
        QuerySnapshot<
            Map<String, dynamic>>>(
      stream:
          _firestore.getProjects(),
      builder: (
        context,
        snapshot,
      ) {
        return _statCard(
          title: 'PROJECT',
          value:
              '${snapshot.data?.docs.length ?? 0}',
          icon:
              Icons.work_outline_rounded,
          accent:
              pink,
        );
      },
    );
  }

  // ==========================================================
  // SKILL STAT
  // ==========================================================

  Widget _skillStat() {
    return StreamBuilder<
        QuerySnapshot<
            Map<String, dynamic>>>(
      stream:
          _firestore.getSkills(),
      builder: (
        context,
        snapshot,
      ) {
        return _statCard(
          title: 'KEAHLIAN',
          value:
              '${snapshot.data?.docs.length ?? 0}',
          icon:
              Icons.code_rounded,
          accent:
              lime,
        );
      },
    );
  }

  // ==========================================================
  // CERTIFICATE STAT
  // ==========================================================

  Widget _certificateStat() {
    return StreamBuilder<
        QuerySnapshot<
            Map<String, dynamic>>>(
      stream:
          _firestore
              .getCertificates(),
      builder: (
        context,
        snapshot,
      ) {
        return _statCard(
          title: 'SERTIFIKASI',
          value:
              '${snapshot.data?.docs.length ?? 0}',
          icon:
              Icons
                  .workspace_premium_outlined,
          accent:
              purple,
        );
      },
    );
  }

  // ==========================================================
  // STAT CARD
  // ==========================================================

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
    required Color accent,
  }) {
    return Container(
      width:
          double.infinity,
      padding:
          const EdgeInsets.all(
        22,
      ),
      decoration:
          BoxDecoration(
        color:
            surface,
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        border:
            Border.all(
          color:
              white.withValues(
            alpha: 0.08,
          ),
        ),
      ),
      child:
          Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration:
                BoxDecoration(
              color:
                  accent.withValues(
                alpha:
                    0.12,
              ),
              borderRadius:
                  BorderRadius.circular(
                13,
              ),
            ),
            child:
                Icon(
              icon,
              color:
                  accent,
              size: 21,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(
                  color: muted,
                  fontSize: 8,
                  fontWeight:
                      FontWeight.w800,
                  letterSpacing:
                      1.6,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                value,
                style:
                    const TextStyle(
                  color: white,
                  fontSize: 28,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // QUICK ACTIONS
  // ==========================================================

  Widget _quickActions() {
    return Container(
      width:
          double.infinity,
      padding:
          const EdgeInsets.all(
        24,
      ),
      decoration:
          BoxDecoration(
        color:
            surface,
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        border:
            Border.all(
          color:
              white.withValues(
            alpha: 0.08,
          ),
        ),
      ),
      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'QUICK ACTION',
            style:
                TextStyle(
              color: pink,
              fontSize: 9,
              fontWeight:
                  FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _actionButton(
                icon:
                    Icons.add_rounded,
                title:
                    'Tambah Project',
                color:
                    pink,
                onTap: () {
                  setState(() {
                    _selectedMenu =
                        1;
                  });
                },
              ),
              _actionButton(
                icon:
                    Icons.code_rounded,
                title:
                    'Tambah Skill',
                color:
                    lime,
                onTap: () {
                  setState(() {
                    _selectedMenu =
                        2;
                  });
                },
              ),
              _actionButton(
                icon:
                    Icons
                        .workspace_premium_outlined,
                title:
                    'Tambah Sertifikasi',
                color:
                    purple,
                onTap: () {
                  setState(() {
                    _selectedMenu =
                        3;
                  });
                },
              ),
              _actionButton(
                icon:
                    Icons
                        .person_outline_rounded,
                title:
                    'Edit Profile',
                color:
                    blue,
                onTap: () {
                  setState(() {
                    _selectedMenu =
                        4;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // ACTION BUTTON
  // ==========================================================

  Widget _actionButton({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap:
          onTap,
      borderRadius:
          BorderRadius.circular(
        12,
      ),
      child:
          Container(
        padding:
            const EdgeInsets
                .symmetric(
          horizontal:
              15,
          vertical:
              13,
        ),
        decoration:
            BoxDecoration(
          color:
              color.withValues(
            alpha:
                0.08,
          ),
          border:
              Border.all(
            color:
                color.withValues(
              alpha:
                  0.25,
            ),
          ),
          borderRadius:
              BorderRadius.circular(
            12,
          ),
        ),
        child:
            Row(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Icon(
              icon,
              color:
                  color,
              size: 17,
            ),
            const SizedBox(
              width: 9,
            ),
            Text(
              title,
              style:
                  const TextStyle(
                color: white,
                fontSize: 10,
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // LOGOUT
  // ==========================================================

  Future<void> _logout() async {
    await _authService.logout();

    if (!mounted) {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                const AdminLoginPage(),
      ),
    );
  }
}

// ============================================================
// UNAUTHORIZED
// ============================================================

class _UnauthorizedAdminPage
    extends StatelessWidget {
  const _UnauthorizedAdminPage();

  static const Color background =
      Color(0xFF09070F);

  static const Color surface =
      Color(0xFF17131F);

  static const Color white =
      Color(0xFFF5F0FF);

  static const Color muted =
      Color(0xFFAAA2B3);

  static const Color pink =
      Color(0xFFE58BA8);

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          background,
      body:
          Center(
        child:
            Container(
          constraints:
              const BoxConstraints(
            maxWidth:
                430,
          ),
          margin:
              const EdgeInsets.all(
            22,
          ),
          padding:
              const EdgeInsets.all(
            32,
          ),
          decoration:
              BoxDecoration(
            color:
                surface,
            borderRadius:
                BorderRadius.circular(
              20,
            ),
            border:
                Border.all(
              color:
                  white.withValues(
                alpha:
                    0.08,
              ),
            ),
          ),
          child:
              Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Container(
                width:
                    60,
                height:
                    60,
                decoration:
                    BoxDecoration(
                  color:
                      pink.withValues(
                    alpha:
                        0.10,
                  ),
                  shape:
                      BoxShape.circle,
                ),
                child:
                    const Icon(
                  Icons
                      .lock_outline_rounded,
                  color:
                      pink,
                  size:
                      27,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'AKSES DITOLAK',
                style:
                    TextStyle(
                  color:
                      white,
                  fontSize:
                      20,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Halaman ini hanya dapat diakses oleh administrator.',
                textAlign:
                    TextAlign.center,
                style:
                    TextStyle(
                  color:
                      muted,
                  fontSize:
                      13,
                  height:
                      1.5,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator
                      .pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              const AdminLoginPage(),
                    ),
                  );
                },
                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      pink,
                  foregroundColor:
                      background,
                  elevation:
                      0,
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal:
                        22,
                    vertical:
                        14,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      100,
                    ),
                  ),
                ),
                child:
                    const Text(
                  'KE HALAMAN LOGIN',
                  style:
                      TextStyle(
                    fontWeight:
                        FontWeight.w800,
                    fontSize:
                        10,
                    letterSpacing:
                        1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}