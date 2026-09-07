import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/firestore_service.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({
    super.key,
  });

  @override
  State<AdminProfilePage> createState() =>
      _AdminProfilePageState();
}

class _AdminProfilePageState
    extends State<AdminProfilePage> {
  final FirestoreService _firestore =
      FirestoreService();

  final _formKey =
      GlobalKey<FormState>();

  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController
      _nameController =
      TextEditingController();

  final TextEditingController
      _titleController =
      TextEditingController();

  final TextEditingController
      _descriptionController =
      TextEditingController();

  final TextEditingController
      _aboutDescriptionController =
      TextEditingController();

  final TextEditingController
      _statusController =
      TextEditingController();

  final TextEditingController
      _locationController =
      TextEditingController();

  final TextEditingController
      _emailController =
      TextEditingController();

  final TextEditingController
      _githubController =
      TextEditingController();

  final TextEditingController
      _linkedinController =
      TextEditingController();

  final TextEditingController
      _instagramController =
      TextEditingController();

  final TextEditingController
      _profileImageController =
      TextEditingController();

  bool _loading = true;
  bool _saving = false;

  // ============================================================
  // COLORS
  // ============================================================

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

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _loadProfile();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _aboutDescriptionController.dispose();
    _statusController.dispose();
    _locationController.dispose();
    _emailController.dispose();
    _githubController.dispose();
    _linkedinController.dispose();
    _instagramController.dispose();
    _profileImageController.dispose();

    super.dispose();
  }

  // ============================================================
  // LOAD PROFILE
  // ============================================================

  Future<void> _loadProfile() async {
    try {
      await _firestore.createDefaultProfile();

      final data =
          await _firestore.getProfileOnce();

      if (data != null) {
        _nameController.text =
            data['name']?.toString() ??
                'Anindya Putri Nariswari';

        _titleController.text =
            data['title']?.toString() ??
                'Information Technology Graduate';

        _descriptionController.text =
            data['description']?.toString() ??
                '';

        _aboutDescriptionController.text =
            data['aboutDescription']?.toString() ??
                'Saya merupakan lulusan D-III Teknologi Informasi yang tertarik pada pengembangan aplikasi dan perancangan antarmuka digital.';

        _statusController.text =
            data['status']?.toString() ??
                'Lulusan Teknologi Informasi';

        _locationController.text =
            data['location']?.toString() ??
                'Madiun, Jawa Timur, Indonesia';

        _emailController.text =
            data['email']?.toString() ??
                '';

        _githubController.text =
            data['github']?.toString() ??
                '';

        _linkedinController.text =
            data['linkedin']?.toString() ??
                '';

        _instagramController.text =
            data['instagram']?.toString() ??
                '';

        _profileImageController.text =
            data['profileImageUrl']?.toString() ??
                '';
      }
    } catch (e) {
      if (mounted) {
        _showSnack(
          'Gagal mengambil data profile: $e',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  // ============================================================
  // SAVE PROFILE
  // ============================================================

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      // Simpan data profile yang sudah tersedia
      // di FirestoreService.
      await _firestore.updateProfile(
        name:
            _nameController.text.trim(),

        title:
            _titleController.text.trim(),

        description:
            _descriptionController.text.trim(),

        aboutDescription:
            _aboutDescriptionController.text.trim(),

        location:
            _locationController.text.trim(),

        email:
            _emailController.text.trim(),

        github:
            _githubController.text.trim(),

        linkedin:
            _linkedinController.text.trim(),

        instagram:
            _instagramController.text.trim(),

        profileImageUrl:
            _profileImageController.text.trim(),
      );

      // ========================================================
      // STATUS
      // ========================================================
      //
      // Status disimpan langsung di dokumen profile
      // agar tidak perlu mengubah FirestoreService.
      //

      await FirebaseFirestore.instance
          .collection('profile')
          .doc('main')
          .set(
        {
          'status':
              _statusController.text.trim(),
        },
        SetOptions(
          merge: true,
        ),
      );

      if (!mounted) {
        return;
      }

      _showSnack(
        'Profile berhasil diperbarui.',
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showSnack(
        'Gagal menyimpan profile: $e',
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ivory,

      body: SafeArea(
        child: _loading
            ? const Center(
                child:
                    CircularProgressIndicator(
                  color: burgundy,
                ),
              )
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.all(45),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    _buildHeader(),

                    const SizedBox(
                      height: 35,
                    ),

                    _buildForm(),
                  ],
                ),
              ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        const Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Text(
              'PROFILE',

              style: TextStyle(
                color: burgundy,
                fontSize: 11,
                fontWeight:
                    FontWeight.bold,
                letterSpacing: 3,
              ),
            ),

            SizedBox(
              height: 10,
            ),

            Text(
              'Kelola profile portofolio kamu.',

              style: TextStyle(
                color: burgundyDark,
                fontSize: 30,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ],
        ),

        ElevatedButton.icon(
          onPressed:
              _saving
                  ? null
                  : _saveProfile,

          icon: _saving
              ? const SizedBox(
                  width: 17,
                  height: 17,

                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2,
                    color: ivory,
                  ),
                )
              : const Icon(
                  Icons.save_outlined,
                  size: 18,
                ),

          label: Text(
            _saving
                ? 'MENYIMPAN...'
                : 'SIMPAN PROFILE',
          ),

          style:
              ElevatedButton.styleFrom(
            backgroundColor:
                burgundy,

            foregroundColor:
                ivory,

            disabledBackgroundColor:
                burgundy.withValues(
              alpha: 0.5,
            ),

            disabledForegroundColor:
                ivory.withValues(
              alpha: 0.8,
            ),

            elevation: 0,

            padding:
                const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),

            shape:
                const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.zero,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // FORM
  // ============================================================

  Widget _buildForm() {
    return Form(
      key: _formKey,

      child: Container(
        width: double.infinity,

        padding:
            const EdgeInsets.all(30),

        decoration:
            _cardDecoration(),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            // ==================================================
            // INFORMASI UTAMA
            // ==================================================

            const Text(
              'INFORMASI UTAMA',

              style: TextStyle(
                color: burgundy,
                fontSize: 11,
                fontWeight:
                    FontWeight.bold,
                letterSpacing: 2,
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            // ==================================================
            // NAME + TITLE
            // ==================================================

            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Expanded(
                  child: _textField(
                    controller:
                        _nameController,

                    label:
                        'NAMA',

                    hint:
                        'Contoh: Anindya Putri Nariswari',

                    required: true,
                  ),
                ),

                const SizedBox(
                  width: 20,
                ),

                Expanded(
                  child: _textField(
                    controller:
                        _titleController,

                    label:
                        'PROFESI / TITLE',

                    hint:
                        'Contoh: Information Technology Graduate',

                    required: true,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            // ==================================================
            // HERO DESCRIPTION
            // ==================================================

            _textField(
              controller:
                  _descriptionController,

              label:
                  'DESKRIPSI HERO',

              hint:
                  'Deskripsi singkat yang tampil pada bagian Hero.',

              maxLines: 5,

              required: true,
            ),

            const SizedBox(
              height: 20,
            ),

            // ==================================================
            // ABOUT DESCRIPTION
            // ==================================================

            _textField(
              controller:
                  _aboutDescriptionController,

              label:
                  'DESKRIPSI TENTANG SAYA',

              hint:
                  'Deskripsi yang tampil khusus pada bagian Tentang.',

              maxLines: 7,

              required: true,
            ),

            const SizedBox(
              height: 20,
            ),

            // ==================================================
            // STATUS
            // ==================================================

            _textField(
              controller:
                  _statusController,

              label:
                  'STATUS',

              hint:
                  'Contoh: Lulusan Teknologi Informasi',

              required: true,
            ),

            const SizedBox(
              height: 35,
            ),

            // ==================================================
            // CONTACT
            // ==================================================

            const Text(
              'INFORMASI KONTAK',

              style: TextStyle(
                color: burgundy,
                fontSize: 11,
                fontWeight:
                    FontWeight.bold,
                letterSpacing: 2,
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            // ==================================================
            // LOCATION + EMAIL
            // ==================================================

            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Expanded(
                  child: _textField(
                    controller:
                        _locationController,

                    label:
                        'LOKASI',

                    hint:
                        'Contoh: Madiun, Jawa Timur, Indonesia',
                  ),
                ),

                const SizedBox(
                  width: 20,
                ),

                Expanded(
                  child: _textField(
                    controller:
                        _emailController,

                    label:
                        'EMAIL',

                    hint:
                        'email@example.com',

                    keyboardType:
                        TextInputType
                            .emailAddress,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            // ==================================================
            // GITHUB + LINKEDIN
            // ==================================================

            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Expanded(
                  child: _textField(
                    controller:
                        _githubController,

                    label:
                        'GITHUB',

                    hint:
                        'https://github.com/username',
                  ),
                ),

                const SizedBox(
                  width: 20,
                ),

                Expanded(
                  child: _textField(
                    controller:
                        _linkedinController,

                    label:
                        'LINKEDIN',

                    hint:
                        'https://linkedin.com/in/username',
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            // ==================================================
            // INSTAGRAM
            // ==================================================

            _textField(
              controller:
                  _instagramController,

              label:
                  'INSTAGRAM',

              hint:
                  'https://instagram.com/username',
            ),

            const SizedBox(
              height: 35,
            ),

            // ==================================================
            // PROFILE IMAGE
            // ==================================================

            const Text(
              'PROFILE IMAGE',

              style: TextStyle(
                color: burgundy,
                fontSize: 11,
                fontWeight:
                    FontWeight.bold,
                letterSpacing: 2,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            _textField(
              controller:
                  _profileImageController,

              label:
                  'PROFILE IMAGE URL',

              hint:
                  'Kosongkan jika menggunakan assets/images/profile.jpeg',
            ),

            const SizedBox(
              height: 12,
            ),

            const Text(
              'Foto portofolio saat ini menggunakan assets/images/profile.jpeg, jadi field ini boleh dikosongkan.',

              style: TextStyle(
                color: taupe,
                fontSize: 12,
              ),
            ),

            const SizedBox(
              height: 35,
            ),

            // ==================================================
            // SAVE
            // ==================================================

            Align(
              alignment:
                  Alignment.centerRight,

              child:
                  ElevatedButton.icon(
                onPressed:
                    _saving
                        ? null
                        : _saveProfile,

                icon: _saving
                    ? const SizedBox(
                        width: 17,
                        height: 17,

                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color: ivory,
                        ),
                      )
                    : const Icon(
                        Icons.save_outlined,
                        size: 18,
                      ),

                label: Text(
                  _saving
                      ? 'MENYIMPAN...'
                      : 'SIMPAN PERUBAHAN',
                ),

                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      burgundy,

                  foregroundColor:
                      ivory,

                  disabledBackgroundColor:
                      burgundy.withValues(
                    alpha: 0.5,
                  ),

                  disabledForegroundColor:
                      ivory.withValues(
                    alpha: 0.8,
                  ),

                  elevation: 0,

                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 24,
                    vertical: 17,
                  ),

                  shape:
                      const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.zero,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _textField({
    required TextEditingController
        controller,

    required String label,

    required String hint,

    bool required = false,

    int maxLines = 1,

    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Text(
          label,

          style: const TextStyle(
            color: burgundyDark,
            fontSize: 10,
            fontWeight:
                FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),

        const SizedBox(
          height: 8,
        ),

        TextFormField(
          controller:
              controller,

          maxLines:
              maxLines,

          keyboardType:
              keyboardType,

          style:
              const TextStyle(
            color: burgundyDark,
            fontSize: 14,
          ),

          validator:
              required
                  ? (value) {
                      if (value ==
                              null ||
                          value
                              .trim()
                              .isEmpty) {
                        return '$label wajib diisi';
                      }

                      return null;
                    }
                  : null,

          decoration:
              InputDecoration(
            hintText:
                hint,

            hintStyle:
                const TextStyle(
              color: taupe,
              fontSize: 13,
            ),

            filled: true,

            fillColor:
                softIvory,

            contentPadding:
                const EdgeInsets.all(
              16,
            ),

            border:
                const OutlineInputBorder(
              borderRadius:
                  BorderRadius.zero,

              borderSide:
                  BorderSide(
                color: border,
              ),
            ),

            enabledBorder:
                const OutlineInputBorder(
              borderRadius:
                  BorderRadius.zero,

              borderSide:
                  BorderSide(
                color: border,
              ),
            ),

            focusedBorder:
                const OutlineInputBorder(
              borderRadius:
                  BorderRadius.zero,

              borderSide:
                  BorderSide(
                color: burgundy,
                width: 1.5,
              ),
            ),

            errorBorder:
                const OutlineInputBorder(
              borderRadius:
                  BorderRadius.zero,

              borderSide:
                  BorderSide(
                color:
                    Colors.redAccent,
              ),
            ),

            focusedErrorBorder:
                const OutlineInputBorder(
              borderRadius:
                  BorderRadius.zero,

              borderSide:
                  BorderSide(
                color:
                    Colors.redAccent,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CARD
  // ============================================================

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,

      border:
          Border.all(
        color: border,
      ),
    );
  }

  // ============================================================
  // SNACKBAR
  // ============================================================

  void _showSnack(
    String message,
  ) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        backgroundColor:
            burgundyDark,

        content:
            Text(
          message,

          style:
              const TextStyle(
            color: ivory,
          ),
        ),
      ),
    );
  }
}