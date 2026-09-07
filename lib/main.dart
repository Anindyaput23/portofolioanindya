import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'widgets/background_music.dart';
import 'pages/admin_login_page.dart';
import 'pages/portofolio_page.dart';
import 'pages/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const PortfolioApp(),
  );
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({
    super.key,
  });

  // ==========================================================
  // COLORS
  // ==========================================================

  static const Color burgundy = Color(0xFF7A1F3D);
  static const Color burgundyDark = Color(0xFF5C1730);
  static const Color ivory = Color(0xFFF4EFE6);
  static const Color taupe = Color(0xFF6F625D);
  static const Color border = Color(0xFFD8CEC2);

  // ==========================================================
  // INITIAL ROUTE
  // ==========================================================

  String _initialRoute() {
    final String path = Uri.base.path.toLowerCase();

    // ADMIN
    if (path == '/admin' || path == '/admin/') {
      return '/admin';
    }

    // PORTFOLIO
    if (path == '/portfolio' || path == '/portfolio/') {
      return '/portfolio';
    }

    // DEFAULT
    return '/';
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Anindya Putri Nariswari — Portfolio',

      // ========================================================
      // THEME
      // ========================================================

      theme: ThemeData(
        brightness: Brightness.light,

        scaffoldBackgroundColor: ivory,

        colorScheme: const ColorScheme.light(
          primary: burgundy,
          secondary: burgundyDark,
          surface: ivory,
          onPrimary: ivory,
          onSecondary: ivory,
          onSurface: burgundyDark,
        ),

        fontFamily: 'Arial',

        appBarTheme: const AppBarTheme(
          backgroundColor: ivory,
          foregroundColor: burgundyDark,
          elevation: 0,
        ),

        inputDecorationTheme: const InputDecorationTheme(
          filled: true,

          fillColor: ivory,

          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: border,
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: border,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: burgundy,
              width: 1.5,
            ),
          ),

          labelStyle: TextStyle(
            color: taupe,
          ),

          hintStyle: TextStyle(
            color: taupe,
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: burgundy,
            foregroundColor: ivory,
            elevation: 0,
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: burgundy,
          ),
        ),
      ),

      // ========================================================
      // INITIAL ROUTE
      // ========================================================

      initialRoute: _initialRoute(),

      // ========================================================
      // ROUTES
      // ========================================================

      routes: {
        // ======================================================
        // PUBLIC LANDING
        // ======================================================
        //
        // BackgroundMusic hanya dipasang di halaman publik.
        //

        '/': (context) {
          return const BackgroundMusic(
            child: SplashPage(),
          );
        },

        // ======================================================
        // PORTFOLIO
        // ======================================================
        //
        // Tetap menggunakan controller audio yang sama.
        // Jadi tidak membuat AudioPlayer baru.
        //

        '/portfolio': (context) {
          return const BackgroundMusic(
            child: PortfolioPage(),
          );
        },

        // ======================================================
        // ADMIN
        // ======================================================
        //
        // TIDAK dibungkus BackgroundMusic.
        //

        '/admin': (context) {
          // Kalau user masuk Admin dari Portfolio,
          // hentikan musik terlebih dahulu.
          BackgroundMusicController.instance.stop();

          return const AdminLoginPage();
        },
      },
    );
  }
}