import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'admin_dashboard_page.dart';
import 'portofolio_page.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({
    super.key,
  });

  @override
  State<AdminLoginPage> createState() =>
      _AdminLoginPageState();
}

class _AdminLoginPageState
    extends State<AdminLoginPage> {
  final TextEditingController
      _emailController =
      TextEditingController();

  final TextEditingController
      _passwordController =
      TextEditingController();

  final AuthService _authService =
      AuthService();

  bool _isLoading = false;

  bool _obscurePassword = true;

  String? _errorMessage;

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

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  // ==========================================================
  // LOGIN
  // ==========================================================

  Future<void> _login() async {
    final String email =
        _emailController.text.trim();

    final String password =
        _passwordController.text;

    if (email.isEmpty ||
        password.isEmpty) {
      setState(() {
        _errorMessage =
            'Email dan password wajib diisi.';
      });

      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.login(
        email: email,
        password: password,
      );

      if (!mounted) {
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const AdminDashboardPage(),
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e
              .toString()
              .replaceFirst(
                'Exception: ',
                '',
              );
        });
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // ==========================================================
  // INPUT DECORATION
  // ==========================================================

  InputDecoration _inputDecoration(
    String label, {
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,

      labelStyle: const TextStyle(
        color: taupe,
        fontSize: 14,
      ),

      suffixIcon: suffixIcon,

      filled: true,

      fillColor: Colors.white.withValues(
        alpha: 0.45,
      ),

      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),

      enabledBorder:
          const OutlineInputBorder(
        borderRadius:
            BorderRadius.zero,
        borderSide: BorderSide(
          color: border,
        ),
      ),

      focusedBorder:
          const OutlineInputBorder(
        borderRadius:
            BorderRadius.zero,
        borderSide: BorderSide(
          color: burgundy,
          width: 1.5,
        ),
      ),

      errorBorder:
          const OutlineInputBorder(
        borderRadius:
            BorderRadius.zero,
        borderSide: BorderSide(
          color: Colors.redAccent,
        ),
      ),

      focusedErrorBorder:
          const OutlineInputBorder(
        borderRadius:
            BorderRadius.zero,
        borderSide: BorderSide(
          color: Colors.redAccent,
        ),
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
    return Scaffold(
      backgroundColor: ivory,

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.all(20),

            child: LayoutBuilder(
              builder: (
                context,
                constraints,
              ) {
                return ConstrainedBox(
                  constraints:
                      const BoxConstraints(
                    maxWidth: 430,
                  ),
                  child: _buildLoginCard(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // LOGIN CARD
  // ==========================================================

  Widget _buildLoginCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(30),

      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.45,
        ),
        border: Border.all(
          color: border,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // ----------------------------------------------------
          // ADMIN
          // ----------------------------------------------------

          const Text(
            'ADMIN',
            style: TextStyle(
              color: burgundy,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            ),
          ),

          const SizedBox(height: 14),

          // ----------------------------------------------------
          // TITLE
          // ----------------------------------------------------

          const Text(
            'Masuk ke dashboard.',
            style: TextStyle(
              color: burgundyDark,
              fontSize: 32,
              fontWeight: FontWeight.w600,
              height: 1.15,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Kelola konten portofolio '
            'dari sini.',
            style: TextStyle(
              color: taupe,
              fontSize: 14,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 35),

          // ----------------------------------------------------
          // EMAIL
          // ----------------------------------------------------

          const Text(
            'EMAIL',
            style: TextStyle(
              color: burgundyDark,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller:
                _emailController,

            keyboardType:
                TextInputType.emailAddress,

            textInputAction:
                TextInputAction.next,

            style: const TextStyle(
              color: burgundyDark,
              fontSize: 15,
            ),

            decoration:
                _inputDecoration(
              'Masukkan email',
            ),
          ),

          const SizedBox(height: 22),

          // ----------------------------------------------------
          // PASSWORD
          // ----------------------------------------------------

          const Text(
            'PASSWORD',
            style: TextStyle(
              color: burgundyDark,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller:
                _passwordController,

            obscureText:
                _obscurePassword,

            textInputAction:
                TextInputAction.done,

            onSubmitted: (_) {
              if (!_isLoading) {
                _login();
              }
            },

            style: const TextStyle(
              color: burgundyDark,
              fontSize: 15,
            ),

            decoration:
                _inputDecoration(
              'Masukkan password',

              suffixIcon:
                  IconButton(
                onPressed: () {
                  setState(() {
                    _obscurePassword =
                        !_obscurePassword;
                  });
                },

                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: taupe,
                ),
              ),
            ),
          ),

          // ----------------------------------------------------
          // ERROR
          // ----------------------------------------------------

          if (_errorMessage != null) ...[
            const SizedBox(height: 18),

            Container(
              width: double.infinity,

              padding:
                  const EdgeInsets.all(12),

              decoration:
                  BoxDecoration(
                color: Colors.redAccent
                    .withValues(
                  alpha: 0.08,
                ),
                border:
                    Border.all(
                  color: Colors.redAccent
                      .withValues(
                    alpha: 0.30,
                  ),
                ),
              ),

              child: Text(
                _errorMessage!,

                style:
                    const TextStyle(
                  color:
                      Colors.redAccent,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          ],

          const SizedBox(height: 28),

          // ----------------------------------------------------
          // LOGIN BUTTON
          // ----------------------------------------------------

          SizedBox(
            width: double.infinity,
            height: 56,

            child: ElevatedButton(
              onPressed:
                  _isLoading
                      ? null
                      : _login,

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    burgundy,

                foregroundColor:
                    ivory,

                disabledBackgroundColor:
                    burgundy.withValues(
                  alpha: 0.50,
                ),

                disabledForegroundColor:
                    ivory.withValues(
                  alpha: 0.70,
                ),

                elevation: 0,

                shape:
                    const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.zero,
                ),
              ),

              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,

                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                        color: ivory,
                      ),
                    )
                  : const Text(
                      'MASUK',
                      style:
                          TextStyle(
                        fontSize: 13,
                        fontWeight:
                            FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 24),

          // ----------------------------------------------------
          // BACK
          // ----------------------------------------------------

          SizedBox(
            width: double.infinity,

            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const PortfolioPage(),
                  ),
                );
              },

              child: const Text(
                '← Kembali ke portofolio',

                style: TextStyle(
                  color: taupe,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}