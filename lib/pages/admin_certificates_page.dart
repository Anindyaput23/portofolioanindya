import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/firestore_service.dart';

class AdminCertificatesPage extends StatefulWidget {
  const AdminCertificatesPage({super.key});

  @override
  State<AdminCertificatesPage> createState() =>
      _AdminCertificatesPageState();
}

class _AdminCertificatesPageState
    extends State<AdminCertificatesPage> {
  final FirestoreService _firestore =
      FirestoreService();

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
    return Scaffold(
      backgroundColor: ivory,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobile =
                constraints.maxWidth < 700;

            return SingleChildScrollView(
              padding: EdgeInsets.all(
                isMobile ? 20 : 45,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  _buildHeader(isMobile),

                  SizedBox(
                    height: isMobile ? 25 : 35,
                  ),

                  _buildCertificateList(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================

  Widget _buildHeader(bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'SERTIFIKASI',
            style: TextStyle(
              color: burgundy,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Kelola sertifikasi portofolio kamu.',
            style: TextStyle(
              color: burgundyDark,
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,
            child: _addButton(),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.end,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'SERTIFIKASI',
                style: TextStyle(
                  color: burgundy,
                  fontSize: 11,
                  fontWeight:
                      FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),

              SizedBox(height: 10),

              Text(
                'Kelola sertifikasi portofolio kamu.',
                style: TextStyle(
                  color: burgundyDark,
                  fontSize: 30,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 25),

        _addButton(),
      ],
    );
  }

  // ==========================================================
  // ADD BUTTON
  // ==========================================================

  Widget _addButton() {
    return ElevatedButton.icon(
      onPressed: _showCertificateForm,
      icon: const Icon(
        Icons.add,
        size: 18,
      ),
      label: const Text(
        'TAMBAH SERTIFIKASI',
      ),
      style:
          ElevatedButton.styleFrom(
        backgroundColor: burgundy,
        foregroundColor: ivory,
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
    );
  }

  // ==========================================================
  // CERTIFICATE LIST
  // ==========================================================

  Widget _buildCertificateList() {
    return StreamBuilder<
        QuerySnapshot<
            Map<String, dynamic>>>(
      stream:
          _firestore.getCertificates(),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(60),
            child: Center(
              child:
                  CircularProgressIndicator(
                color: burgundy,
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return _errorBox(
            snapshot.error.toString(),
          );
        }

        final documents =
            snapshot.data?.docs ?? [];

        if (documents.isEmpty) {
          return _emptyState();
        }

        return Column(
          children: documents.map((doc) {
            return _certificateCard(
              id: doc.id,
              data: doc.data(),
            );
          }).toList(),
        );
      },
    );
  }

  // ==========================================================
  // CERTIFICATE CARD
  // ==========================================================

  Widget _certificateCard({
    required String id,
    required Map<String, dynamic> data,
  }) {
    final String name =
        data['name']?.toString() ??
            'Untitled Certificate';

    final String issuer =
        data['issuer']?.toString() ?? '';

    final String year =
        data['year']?.toString() ?? '';

    final String credential =
        data['credential']?.toString() ?? '';

    final String certificateUrl =
        data['certificateUrl']?.toString() ??
            '';

    return Container(
      width: double.infinity,
      margin:
          const EdgeInsets.only(
        bottom: 15,
      ),
      padding:
          const EdgeInsets.all(22),
      decoration:
          _cardDecoration(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMobile =
              constraints.maxWidth < 600;

          if (isMobile) {
            return _mobileCertificate(
              id: id,
              name: name,
              issuer: issuer,
              year: year,
              credential: credential,
              certificateUrl:
                  certificateUrl,
            );
          }

          return _desktopCertificate(
            id: id,
            name: name,
            issuer: issuer,
            year: year,
            credential: credential,
            certificateUrl:
                certificateUrl,
          );
        },
      ),
    );
  }

  // ==========================================================
  // DESKTOP CERTIFICATE
  // ==========================================================

  Widget _desktopCertificate({
    required String id,
    required String name,
    required String issuer,
    required String year,
    required String credential,
    required String certificateUrl,
  }) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _certificateIcon(),

        const SizedBox(width: 20),

        Expanded(
          child: _certificateInfo(
            name: name,
            issuer: issuer,
            year: year,
            credential: credential,
            certificateUrl:
                certificateUrl,
          ),
        ),

        const SizedBox(width: 15),

        _editButton(id),

        _deleteButton(id),
      ],
    );
  }

  // ==========================================================
  // MOBILE CERTIFICATE
  // ==========================================================

  Widget _mobileCertificate({
    required String id,
    required String name,
    required String issuer,
    required String year,
    required String credential,
    required String certificateUrl,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            _certificateIcon(),

            const SizedBox(width: 15),

            Expanded(
              child: _certificateInfo(
                name: name,
                issuer: issuer,
                year: year,
                credential: credential,
                certificateUrl:
                    certificateUrl,
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        Container(
          width: double.infinity,
          height: 1,
          color: border,
        ),

        const SizedBox(height: 10),

        Row(
          mainAxisAlignment:
              MainAxisAlignment.end,
          children: [
            _editButton(id),
            _deleteButton(id),
          ],
        ),
      ],
    );
  }

  // ==========================================================
  // CERTIFICATE ICON
  // ==========================================================

  Widget _certificateIcon() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: burgundy.withValues(
          alpha: 0.08,
        ),
        border: Border.all(
          color: border,
        ),
      ),
      child: const Icon(
        Icons
            .workspace_premium_outlined,
        color: burgundy,
        size: 30,
      ),
    );
  }

  // ==========================================================
  // CERTIFICATE INFO
  // ==========================================================

  Widget _certificateInfo({
    required String name,
    required String issuer,
    required String year,
    required String credential,
    required String certificateUrl,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          name,
          softWrap: true,
          style: const TextStyle(
            color: burgundyDark,
            fontSize: 19,
            fontWeight:
                FontWeight.w600,
          ),
        ),

        if (issuer.isNotEmpty) ...[
          const SizedBox(height: 7),

          Text(
            issuer,
            softWrap: true,
            style: const TextStyle(
              color: burgundy,
              fontSize: 11,
              fontWeight:
                  FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],

        if (year.isNotEmpty) ...[
          const SizedBox(height: 6),

          Text(
            year,
            style: const TextStyle(
              color: taupe,
              fontSize: 13,
            ),
          ),
        ],

        if (credential.isNotEmpty) ...[
          const SizedBox(height: 8),

          Text(
            'Credential: $credential',
            softWrap: true,
            style: const TextStyle(
              color: taupe,
              fontSize: 12,
            ),
          ),
        ],

        if (certificateUrl.isNotEmpty) ...[
          const SizedBox(height: 8),

          Text(
            certificateUrl,
            maxLines: 2,
            overflow:
                TextOverflow.ellipsis,
            style: const TextStyle(
              color: taupe,
              fontSize: 11,
            ),
          ),
        ],
      ],
    );
  }

  // ==========================================================
  // EDIT BUTTON
  // ==========================================================

  Widget _editButton(String id) {
    return IconButton(
      tooltip: 'Edit',
      onPressed: () async {
        final document =
            await _getCertificate(id);

        if (!mounted ||
            document == null) {
          return;
        }

        _showCertificateForm(
          id: id,
          data: document,
        );
      },
      icon: const Icon(
        Icons.edit_outlined,
        color: taupe,
      ),
    );
  }

  // ==========================================================
  // GET CERTIFICATE
  // ==========================================================

  Future<Map<String, dynamic>?>
      _getCertificate(
    String id,
  ) async {
    try {
      final snapshot =
          await FirebaseFirestore
              .instance
              .collection('certificates')
              .doc(id)
              .get();

      if (!snapshot.exists) {
        return null;
      }

      return snapshot.data();
    } catch (e) {
      _showSnack(
        'Gagal mengambil data sertifikasi: $e',
      );

      return null;
    }
  }

  // ==========================================================
  // DELETE BUTTON
  // ==========================================================

  Widget _deleteButton(String id) {
    return IconButton(
      tooltip: 'Hapus',
      onPressed: () {
        _confirmDelete(id);
      },
      icon: const Icon(
        Icons.delete_outline,
        color: Colors.redAccent,
      ),
    );
  }

  // ==========================================================
  // FORM
  // ==========================================================

  void _showCertificateForm({
    String? id,
    Map<String, dynamic>? data,
  }) {
    final bool editing = id != null;

    final nameController =
        TextEditingController(
      text:
          data?['name']?.toString() ??
              '',
    );

    final issuerController =
        TextEditingController(
      text:
          data?['issuer']?.toString() ??
              '',
    );

    final yearController =
        TextEditingController(
      text:
          data?['year']?.toString() ??
              '',
    );

    final credentialController =
        TextEditingController(
      text:
          data?['credential']
                  ?.toString() ??
              '',
    );

    final urlController =
        TextEditingController(
      text:
          data?['certificateUrl']
                  ?.toString() ??
              '',
    );

    // ========================================================
    // PENTING:
    // saving berada DI LUAR StatefulBuilder.
    // ========================================================

    bool saving = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
            context,
            setDialogState,
          ) {
            return Dialog(
              backgroundColor: ivory,
              insetPadding:
                  const EdgeInsets.all(18),
              shape:
                  const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.zero,
              ),
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(
                  maxWidth: 550,
                ),
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      // ==================================================
                      // TITLE
                      // ==================================================

                      Text(
                        editing
                            ? 'EDIT SERTIFIKASI'
                            : 'TAMBAH SERTIFIKASI',
                        style:
                            const TextStyle(
                          color: burgundy,
                          fontSize: 12,
                          fontWeight:
                              FontWeight.bold,
                          letterSpacing: 3,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Text(
                        editing
                            ? 'Perbarui sertifikasi'
                            : 'Tambahkan sertifikasi baru',
                        style:
                            const TextStyle(
                          color:
                              burgundyDark,
                          fontSize: 25,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      // ==================================================
                      // NAME
                      // ==================================================

                      _formField(
                        controller:
                            nameController,
                        label:
                            'NAMA SERTIFIKASI',
                        hint:
                            'Contoh: Junior Web Developer',
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      // ==================================================
                      // ISSUER
                      // ==================================================

                      _formField(
                        controller:
                            issuerController,
                        label:
                            'PENERBIT',
                        hint:
                            'Contoh: BNSP',
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      // ==================================================
                      // YEAR
                      // ==================================================

                      _formField(
                        controller:
                            yearController,
                        label: 'TAHUN',
                        hint:
                            'Contoh: 2025',
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      // ==================================================
                      // CREDENTIAL
                      // ==================================================

                      _formField(
                        controller:
                            credentialController,
                        label:
                            'CREDENTIAL',
                        hint:
                            'Nomor credential / ID sertifikat',
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      // ==================================================
                      // URL
                      // ==================================================

                      _formField(
                        controller:
                            urlController,
                        label:
                            'CERTIFICATE URL',
                        hint:
                            'https://...',
                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      // ==================================================
                      // BUTTON
                      // ==================================================

                      LayoutBuilder(
                        builder: (
                          context,
                          constraints,
                        ) {
                          final bool narrow =
                              constraints
                                      .maxWidth <
                                  430;

                          if (narrow) {
                            return Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .stretch,
                              children: [
                                _saveButton(
                                  saving:
                                      saving,
                                  editing:
                                      editing,
                                  onPressed:
                                      () async {
                                    await _saveCertificate(
                                      dialogContext:
                                          dialogContext,
                                      setDialogState:
                                          setDialogState,
                                      setSaving:
                                          (value) {
                                        saving =
                                            value;
                                      },
                                      editing:
                                          editing,
                                      id: id,
                                      nameController:
                                          nameController,
                                      issuerController:
                                          issuerController,
                                      yearController:
                                          yearController,
                                      credentialController:
                                          credentialController,
                                      urlController:
                                          urlController,
                                    );
                                  },
                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                TextButton(
                                  onPressed:
                                      saving
                                          ? null
                                          : () {
                                              Navigator
                                                  .pop(
                                                dialogContext,
                                              );
                                            },
                                  child:
                                      const Text(
                                    'BATAL',
                                    style:
                                        TextStyle(
                                      color:
                                          taupe,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }

                          return Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .end,
                            children: [
                              TextButton(
                                onPressed:
                                    saving
                                        ? null
                                        : () {
                                            Navigator
                                                .pop(
                                              dialogContext,
                                            );
                                          },
                                child:
                                    const Text(
                                  'BATAL',
                                  style:
                                      TextStyle(
                                    color:
                                        taupe,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                width: 10,
                              ),

                              _saveButton(
                                saving:
                                    saving,
                                editing:
                                    editing,
                                onPressed:
                                    () async {
                                  await _saveCertificate(
                                    dialogContext:
                                        dialogContext,
                                    setDialogState:
                                        setDialogState,
                                    setSaving:
                                        (value) {
                                      saving =
                                          value;
                                    },
                                    editing:
                                        editing,
                                    id: id,
                                    nameController:
                                        nameController,
                                    issuerController:
                                        issuerController,
                                    yearController:
                                        yearController,
                                    credentialController:
                                        credentialController,
                                    urlController:
                                        urlController,
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      nameController.dispose();
      issuerController.dispose();
      yearController.dispose();
      credentialController.dispose();
      urlController.dispose();
    });
  }

  // ==========================================================
  // SAVE BUTTON
  // ==========================================================

  Widget _saveButton({
    required bool saving,
    required bool editing,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed:
          saving ? null : onPressed,
      style:
          _saveButtonStyle(),
      child: saving
          ? const SizedBox(
              width: 18,
              height: 18,
              child:
                  CircularProgressIndicator(
                strokeWidth: 2,
                color: ivory,
              ),
            )
          : Text(
              editing
                  ? 'SIMPAN PERUBAHAN'
                  : 'SIMPAN SERTIFIKASI',
            ),
    );
  }

  // ==========================================================
  // SAVE CERTIFICATE
  // ==========================================================

  Future<void> _saveCertificate({
    required BuildContext dialogContext,
    required void Function(
      void Function(),
    ) setDialogState,
    required void Function(
      bool value,
    ) setSaving,
    required bool editing,
    required String? id,
    required TextEditingController
        nameController,
    required TextEditingController
        issuerController,
    required TextEditingController
        yearController,
    required TextEditingController
        credentialController,
    required TextEditingController
        urlController,
  }) async {
    final String name =
        nameController.text.trim();

    final String issuer =
        issuerController.text.trim();

    final String year =
        yearController.text.trim();

    final String credential =
        credentialController.text.trim();

    final String certificateUrl =
        urlController.text.trim();

    // ========================================================
    // VALIDATION
    // ========================================================

    if (name.isEmpty) {
      _showSnack(
        'Nama sertifikasi wajib diisi.',
      );
      return;
    }

    if (issuer.isEmpty) {
      _showSnack(
        'Penerbit wajib diisi.',
      );
      return;
    }

    if (year.isEmpty) {
      _showSnack(
        'Tahun wajib diisi.',
      );
      return;
    }

    // ========================================================
    // START SAVING
    // ========================================================

    setSaving(true);

    setDialogState(() {});

    try {
      if (editing) {
        await _firestore.updateCertificate(
          id: id!,
          name: name,
          issuer: issuer,
          year: year,
          credential: credential,
          certificateUrl:
              certificateUrl,
        );
      } else {
        await _firestore.addCertificate(
          name: name,
          issuer: issuer,
          year: year,
          credential: credential,
          certificateUrl:
              certificateUrl,
        );
      }

      if (!dialogContext.mounted) {
        return;
      }

      Navigator.pop(
        dialogContext,
      );

      _showSnack(
        editing
            ? 'Sertifikasi berhasil diperbarui.'
            : 'Sertifikasi berhasil ditambahkan.',
      );
    } catch (e) {
      setSaving(false);

      setDialogState(() {});

      _showSnack(
        'Gagal menyimpan sertifikasi: $e',
      );
    }
  }

  // ==========================================================
  // DELETE CONFIRMATION
  // ==========================================================

  void _confirmDelete(
    String id,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: ivory,
          shape:
              const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.zero,
          ),
          title: const Text(
            'Hapus Sertifikasi?',
            style: TextStyle(
              color: burgundyDark,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
          content: const Text(
            'Sertifikasi yang dihapus '
            'tidak dapat dikembalikan.',
            style: TextStyle(
              color: taupe,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text(
                'BATAL',
                style: TextStyle(
                  color: taupe,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                Navigator.pop(
                  dialogContext,
                );

                try {
                  await _firestore
                      .deleteCertificate(id);

                  _showSnack(
                    'Sertifikasi berhasil dihapus.',
                  );
                } catch (e) {
                  _showSnack(
                    'Gagal menghapus sertifikasi: $e',
                  );
                }
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.redAccent,
                foregroundColor:
                    Colors.white,
                elevation: 0,
                shape:
                    const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.zero,
                ),
              ),
              child: const Text(
                'HAPUS',
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // FORM FIELD
  // ==========================================================

  Widget _formField({
    required TextEditingController
        controller,
    required String label,
    required String hint,
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

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          style: const TextStyle(
            color: burgundyDark,
            fontSize: 14,
          ),
          decoration:
              InputDecoration(
            hintText: hint,
            hintStyle:
                const TextStyle(
              color: taupe,
            ),
            filled: true,
            fillColor:
                Colors.white.withValues(
              alpha: 0.45,
            ),
            contentPadding:
                const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
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
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // SAVE BUTTON STYLE
  // ==========================================================

  ButtonStyle _saveButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: burgundy,
      foregroundColor: ivory,
      elevation: 0,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 16,
      ),
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.zero,
      ),
    );
  }

  // ==========================================================
  // EMPTY STATE
  // ==========================================================

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(
        vertical: 70,
        horizontal: 20,
      ),
      decoration:
          _cardDecoration(),
      child: Column(
        children: [
          const Icon(
            Icons
                .workspace_premium_outlined,
            size: 50,
            color: taupe,
          ),

          const SizedBox(height: 20),

          const Text(
            'Belum ada sertifikasi.',
            textAlign:
                TextAlign.center,
            style: TextStyle(
              color: burgundyDark,
              fontSize: 17,
            ),
          ),

          const SizedBox(height: 25),

          _addButton(),
        ],
      ),
    );
  }

  // ==========================================================
  // ERROR
  // ==========================================================

  Widget _errorBox(
    String error,
  ) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color:
            Colors.redAccent.withValues(
          alpha: 0.05,
        ),
        border: Border.all(
          color:
              Colors.redAccent.withValues(
            alpha: 0.25,
          ),
        ),
      ),
      child: Text(
        error,
        softWrap: true,
        style: const TextStyle(
          color: Colors.redAccent,
        ),
      ),
    );
  }

  // ==========================================================
  // CARD DECORATION
  // ==========================================================

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: softIvory,
      border: Border.all(
        color: border,
      ),
    );
  }

  // ==========================================================
  // SNACKBAR
  // ==========================================================

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
        content: Text(message),
        backgroundColor:
            burgundyDark,
      ),
    );
  }
}