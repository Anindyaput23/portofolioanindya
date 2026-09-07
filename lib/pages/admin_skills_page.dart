import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/firestore_service.dart';

class AdminSkillsPage extends StatefulWidget {
  const AdminSkillsPage({super.key});

  @override
  State<AdminSkillsPage> createState() =>
      _AdminSkillsPageState();
}

class _AdminSkillsPageState
    extends State<AdminSkillsPage> {
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
            final double horizontalPadding =
                constraints.maxWidth < 700
                    ? 20
                    : 45;

            return SingleChildScrollView(
              padding: EdgeInsets.all(
                horizontalPadding,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  _buildHeader(
                    constraints.maxWidth,
                  ),

                  const SizedBox(
                    height: 35,
                  ),

                  _buildSkillsList(),
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

  Widget _buildHeader(
    double width,
  ) {
    final bool isSmall =
        width < 850;

    if (isSmall) {
      return Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          _buildHeaderTitle(),

          const SizedBox(
            height: 20,
          ),

          _buildAddButton(),
        ],
      );
    }

    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.end,

      children: [
        Expanded(
          child: _buildHeaderTitle(),
        ),

        const SizedBox(
          width: 25,
        ),

        _buildAddButton(),
      ],
    );
  }

  Widget _buildHeaderTitle() {
    return const Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Text(
          'SKILLS',

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
          'Kelola keahlian portofolio kamu.',

          style: TextStyle(
            color: burgundyDark,
            fontSize: 30,
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton.icon(
      onPressed: _showSkillForm,

      icon: const Icon(
        Icons.add,
        size: 18,
      ),

      label: const Text(
        'TAMBAH SKILL',
      ),

      style:
          ElevatedButton.styleFrom(
        backgroundColor:
            burgundy,

        foregroundColor:
            ivory,

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
  // SKILLS LIST
  // ==========================================================

  Widget _buildSkillsList() {
    return StreamBuilder<
        QuerySnapshot<Map<String, dynamic>>>(
      stream:
          _firestore.getSkills(),

      builder: (
        context,
        snapshot,
      ) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Padding(
            padding:
                EdgeInsets.all(60),

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
          children:
              documents.map((doc) {
            return _skillCard(
              id: doc.id,
              data: doc.data(),
            );
          }).toList(),
        );
      },
    );
  }

  // ==========================================================
  // SKILL CARD
  // ==========================================================

  Widget _skillCard({
    required String id,
    required Map<String, dynamic> data,
  }) {
    final String name =
        data['name']?.toString() ??
            'Untitled Skill';

    final String category =
        data['category']?.toString() ??
            '';

    final int level =
        _parseLevel(
      data['level'],
    );

    return LayoutBuilder(
      builder: (
        context,
        constraints,
      ) {
        final bool compact =
            constraints.maxWidth < 650;

        return Container(
          width: double.infinity,

          margin:
              const EdgeInsets.only(
            bottom: 15,
          ),

          padding:
              const EdgeInsets.all(25),

          decoration:
              _cardDecoration(),

          child: compact
              ? _buildCompactSkillCard(
                  id: id,
                  name: name,
                  category: category,
                  level: level,
                )
              : _buildDesktopSkillCard(
                  id: id,
                  name: name,
                  category: category,
                  level: level,
                ),
        );
      },
    );
  }

  // ==========================================================
  // DESKTOP SKILL CARD
  // ==========================================================

  Widget _buildDesktopSkillCard({
    required String id,
    required String name,
    required String category,
    required int level,
  }) {
    return Row(
      children: [
        _buildSkillIcon(),

        const SizedBox(
          width: 20,
        ),

        Expanded(
          child: _buildSkillContent(
            name: name,
            category: category,
            level: level,
          ),
        ),

        const SizedBox(
          width: 15,
        ),

        _buildSkillActions(
          id,
        ),
      ],
    );
  }

  // ==========================================================
  // COMPACT SKILL CARD
  // ==========================================================

  Widget _buildCompactSkillCard({
    required String id,
    required String name,
    required String category,
    required int level,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            _buildSkillIcon(),

            const SizedBox(
              width: 15,
            ),

            Expanded(
              child:
                  _buildSkillContent(
                name: name,
                category: category,
                level: level,
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 15,
        ),

        Align(
          alignment:
              Alignment.centerRight,

          child:
              _buildSkillActions(id),
        ),
      ],
    );
  }

  // ==========================================================
  // SKILL ICON
  // ==========================================================

  Widget _buildSkillIcon() {
    return Container(
      width: 70,
      height: 70,

      decoration:
          BoxDecoration(
        color:
            burgundy.withValues(
          alpha: 0.08,
        ),

        border: Border.all(
          color: border,
        ),
      ),

      child: const Icon(
        Icons.code,
        color: burgundy,
        size: 30,
      ),
    );
  }

  // ==========================================================
  // SKILL CONTENT
  // ==========================================================

  Widget _buildSkillContent({
    required String name,
    required String category,
    required int level,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Text(
          name,

          style:
              const TextStyle(
            color: burgundyDark,
            fontSize: 18,
            fontWeight:
                FontWeight.w600,
          ),
        ),

        if (category.isNotEmpty) ...[
          const SizedBox(
            height: 7,
          ),

          Text(
            category,

            style:
                const TextStyle(
              color: burgundy,
              fontSize: 11,
              fontWeight:
                  FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],

        const SizedBox(
          height: 12,
        ),

        Row(
          children: [
            Expanded(
              child:
                  LinearProgressIndicator(
                value:
                    level / 100,

                minHeight: 4,

                backgroundColor:
                    border,

                valueColor:
                    const AlwaysStoppedAnimation<
                        Color>(
                  burgundy,
                ),
              ),
            ),

            const SizedBox(
              width: 15,
            ),

            Text(
              '$level%',

              style:
                  const TextStyle(
                color: burgundy,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================================
  // SKILL ACTIONS
  // ==========================================================

  Widget _buildSkillActions(
    String id,
  ) {
    return Row(
      mainAxisSize:
          MainAxisSize.min,

      children: [
        IconButton(
          tooltip: 'Edit',

          onPressed: () {
            _getSkillForEdit(id);
          },

          icon: const Icon(
            Icons.edit_outlined,
            color: taupe,
          ),
        ),

        IconButton(
          tooltip: 'Hapus',

          onPressed: () {
            _confirmDelete(id);
          },

          icon: const Icon(
            Icons.delete_outline,
            color: Colors.redAccent,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // GET SKILL FOR EDIT
  // ==========================================================

  Future<void> _getSkillForEdit(
    String id,
  ) async {
    try {
      final document =
          await FirebaseFirestore
              .instance
              .collection('skills')
              .doc(id)
              .get();

      if (!document.exists) {
        _showSnack(
          'Skill tidak ditemukan.',
        );
        return;
      }

      final data =
          document.data();

      if (data == null) {
        _showSnack(
          'Data skill kosong.',
        );
        return;
      }

      _showSkillForm(
        id: id,
        data: data,
      );
    } catch (e) {
      _showSnack(
        'Gagal mengambil skill: $e',
      );
    }
  }

  // ==========================================================
  // FORM
  // ==========================================================

  void _showSkillForm({
    String? id,
    Map<String, dynamic>? data,
  }) {
    final bool editing =
        id != null;

    final nameController =
        TextEditingController(
      text:
          data?['name']
                  ?.toString() ??
              '',
    );

    final categoryController =
        TextEditingController(
      text:
          data?['category']
                  ?.toString() ??
              '',
    );

    final levelController =
        TextEditingController(
      text:
          data?['level']
                  ?.toString() ??
              '80',
    );

    bool saving = false;

    showDialog(
      context: context,

      barrierDismissible:
          false,

      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
            context,
            setDialogState,
          ) {
            return Dialog(
              backgroundColor:
                  ivory,

              shape:
                  const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.zero,
              ),

              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(
                  maxWidth: 500,
                ),

                child:
                    SingleChildScrollView(
                  padding:
                      const EdgeInsets.all(
                    30,
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [
                      Text(
                        editing
                            ? 'EDIT SKILL'
                            : 'TAMBAH SKILL',

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
                            ? 'Perbarui skill'
                            : 'Tambahkan skill baru',

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

                      _formField(
                        controller:
                            nameController,
                        label:
                            'NAMA SKILL',
                        hint:
                            'Contoh: Flutter',
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      _formField(
                        controller:
                            categoryController,
                        label:
                            'KATEGORI',
                        hint:
                            'Contoh: Framework',
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      _formField(
                        controller:
                            levelController,
                        label:
                            'LEVEL (%)',
                        hint:
                            'Contoh: 80',
                        keyboardType:
                            TextInputType
                                .number,
                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      Row(
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

                          ElevatedButton(
                            onPressed:
                                saving
                                    ? null
                                    : () async {
                                        final name =
                                            nameController
                                                .text
                                                .trim();

                                        final category =
                                            categoryController
                                                .text
                                                .trim();

                                        int level =
                                            int.tryParse(
                                                  levelController
                                                      .text
                                                      .trim(),
                                                ) ??
                                                0;

                                        if (level <
                                            0) {
                                          level =
                                              0;
                                        }

                                        if (level >
                                            100) {
                                          level =
                                              100;
                                        }

                                        if (name
                                            .isEmpty) {
                                          _showSnack(
                                            'Nama skill wajib diisi.',
                                          );
                                          return;
                                        }

                                        if (category
                                            .isEmpty) {
                                          _showSnack(
                                            'Kategori wajib diisi.',
                                          );
                                          return;
                                        }

                                        setDialogState(
                                          () {
                                            saving =
                                                true;
                                          },
                                        );

                                        try {
                                          if (editing) {
                                            await _firestore
                                                .updateSkill(
                                              id: id,
                                              name:
                                                  name,
                                              category:
                                                  category,
                                              level:
                                                  level,
                                            );
                                          } else {
                                            await _firestore
                                                .addSkill(
                                              name:
                                                  name,
                                              category:
                                                  category,
                                              level:
                                                  level,
                                            );
                                          }

                                          if (!dialogContext
                                              .mounted) {
                                            return;
                                          }

                                          Navigator.pop(
                                            dialogContext,
                                          );

                                          _showSnack(
                                            editing
                                                ? 'Skill berhasil diperbarui.'
                                                : 'Skill berhasil ditambahkan.',
                                          );
                                        } catch (e) {
                                          setDialogState(
                                            () {
                                              saving =
                                                  false;
                                            },
                                          );

                                          _showSnack(
                                            'Gagal menyimpan skill: $e',
                                          );
                                        }
                                      },

                            style:
                                ElevatedButton
                                    .styleFrom(
                              backgroundColor:
                                  burgundy,

                              foregroundColor:
                                  ivory,

                              elevation: 0,

                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 22,
                                vertical: 16,
                              ),

                              shape:
                                  const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius
                                        .zero,
                              ),
                            ),

                            child: saving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth:
                                          2,
                                      color:
                                          ivory,
                                    ),
                                  )
                                : Text(
                                    editing
                                        ? 'SIMPAN PERUBAHAN'
                                        : 'SIMPAN SKILL',
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Text(
          label,

          style:
              const TextStyle(
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

        TextField(
          controller: controller,
          keyboardType:
              keyboardType,

          style:
              const TextStyle(
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
                const EdgeInsets
                    .symmetric(
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
  // EMPTY STATE
  // ==========================================================

  Widget _emptyState() {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.symmetric(
        vertical: 70,
      ),

      decoration:
          _cardDecoration(),

      child: Column(
        children: [
          const Icon(
            Icons.code,
            size: 50,
            color: taupe,
          ),

          const SizedBox(
            height: 20,
          ),

          const Text(
            'Belum ada skill.',

            style:
                TextStyle(
              color: burgundyDark,
              fontSize: 17,
            ),
          ),

          const SizedBox(
            height: 25,
          ),

          _buildAddButton(),
        ],
      ),
    );
  }

  // ==========================================================
  // DELETE
  // ==========================================================

  void _confirmDelete(
    String id,
  ) {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              ivory,

          shape:
              const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.zero,
          ),

          title: const Text(
            'Hapus Skill?',

            style:
                TextStyle(
              color: burgundyDark,
              fontWeight:
                  FontWeight.w600,
            ),
          ),

          content: const Text(
            'Skill yang dihapus tidak dapat dikembalikan.',

            style:
                TextStyle(
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

              child:
                  const Text(
                'BATAL',

                style:
                    TextStyle(
                  color: taupe,
                ),
              ),
            ),

            ElevatedButton(
              onPressed:
                  () async {
                Navigator.pop(
                  dialogContext,
                );

                try {
                  await _firestore
                      .deleteSkill(id);

                  _showSnack(
                    'Skill berhasil dihapus.',
                  );
                } catch (e) {
                  _showSnack(
                    'Gagal menghapus skill: $e',
                  );
                }
              },

              style:
                  ElevatedButton
                      .styleFrom(
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

              child:
                  const Text(
                'HAPUS',
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // CARD DECORATION
  // ==========================================================

  BoxDecoration
      _cardDecoration() {
    return BoxDecoration(
      color: softIvory,

      border: Border.all(
        color: border,
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

      decoration:
          BoxDecoration(
        color:
            Colors.redAccent
                .withValues(
          alpha: 0.05,
        ),

        border: Border.all(
          color:
              Colors.redAccent
                  .withValues(
            alpha: 0.25,
          ),
        ),
      ),

      child: Text(
        error,

        style:
            const TextStyle(
          color: Colors.redAccent,
        ),
      ),
    );
  }

  // ==========================================================
  // PARSE LEVEL
  // ==========================================================

  int _parseLevel(
    dynamic value,
  ) {
    if (value is int) {
      return value.clamp(
        0,
        100,
      );
    }

    if (value is double) {
      return value
          .toInt()
          .clamp(
            0,
            100,
          );
    }

    return int.tryParse(
          value?.toString() ?? '',
        )?.clamp(
          0,
          100,
        ) ??
        0;
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
        content:
            Text(message),

        backgroundColor:
            burgundyDark,
      ),
    );
  }
}