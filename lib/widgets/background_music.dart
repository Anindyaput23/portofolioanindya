import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

/// ============================================================
/// BACKGROUND MUSIC CONTROLLER
/// ============================================================
///
/// Satu AudioPlayer digunakan untuk seluruh halaman publik.
///
/// - Splash dan Portfolio menggunakan player yang sama
/// - Tidak membuat audio double
/// - Admin tidak menggunakan BackgroundMusic
///
/// ============================================================

class BackgroundMusicController {
  BackgroundMusicController._();

  static final BackgroundMusicController instance =
      BackgroundMusicController._();

  // ==========================================================
  // AUDIO PLAYER
  // ==========================================================

  final AudioPlayer _audioPlayer = AudioPlayer();

  // ==========================================================
  // STATE
  // ==========================================================

  bool _isPlaying = false;

  bool _isInitialized = false;

  // ==========================================================
  // GETTER
  // ==========================================================

  bool get isPlaying => _isPlaying;

  // ==========================================================
  // INITIALIZE
  // ==========================================================

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    try {
      await _audioPlayer.setReleaseMode(
        ReleaseMode.loop,
      );

      await _audioPlayer.setVolume(
        0.28,
      );

      _isInitialized = true;
    } catch (e) {
      debugPrint(
        'Gagal menyiapkan background music: $e',
      );
    }
  }

  // ==========================================================
  // AUTOPLAY
  // ==========================================================

  Future<void> prepareAndAutoplay() async {
    if (!_isInitialized) {
      await initialize();
    }

    if (_isPlaying) {
      return;
    }

    try {
      await _audioPlayer.play(
        AssetSource(
          'audio/background_music.mp3',
        ),
        volume: 0.28,
      );

      _isPlaying = true;
    } catch (e) {
      debugPrint(
        'Autoplay background music diblokir browser: $e',
      );
    }
  }

  // ==========================================================
  // START AFTER USER INTERACTION
  // ==========================================================

  Future<void> startFromUserInteraction() async {
    if (_isPlaying) {
      return;
    }

    if (!_isInitialized) {
      await initialize();
    }

    try {
      await _audioPlayer.play(
        AssetSource(
          'audio/background_music.mp3',
        ),
        volume: 0.28,
      );

      _isPlaying = true;
    } catch (e) {
      debugPrint(
        'Background music belum bisa diputar: $e',
      );
    }
  }

  // ==========================================================
  // STOP
  // ==========================================================

  Future<void> stop() async {
    if (!_isPlaying) {
      return;
    }

    try {
      await _audioPlayer.stop();

      _isPlaying = false;
    } catch (e) {
      debugPrint(
        'Gagal menghentikan background music: $e',
      );

      _isPlaying = false;
    }
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  Future<void> dispose() async {
    await _audioPlayer.stop();
    await _audioPlayer.dispose();

    _isPlaying = false;
    _isInitialized = false;
  }
}

/// ============================================================
/// BACKGROUND MUSIC WIDGET
/// ============================================================

class BackgroundMusic extends StatefulWidget {
  final Widget child;

  const BackgroundMusic({
    super.key,
    required this.child,
  });

  @override
  State<BackgroundMusic> createState() =>
      _BackgroundMusicState();
}

class _BackgroundMusicState
    extends State<BackgroundMusic> {

  // ==========================================================
  // CONTROLLER
  // ==========================================================

  final BackgroundMusicController _music =
      BackgroundMusicController.instance;

  // ==========================================================
  // INIT
  // ==========================================================

  @override
  void initState() {
    super.initState();

    _startMusic();
  }

  // ==========================================================
  // START MUSIC
  // ==========================================================

  Future<void> _startMusic() async {
    await _music.initialize();

    await _music.prepareAndAutoplay();
  }

  // ==========================================================
  // USER INTERACTION
  // ==========================================================

  Future<void> _handleUserInteraction() async {
    await _music.startFromUserInteraction();
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,

      onPointerDown: (_) {
        _handleUserInteraction();
      },

      child: widget.child,
    );
  }
}