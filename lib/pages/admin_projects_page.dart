import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/cloudinary_services.dart';
import '../services/firestore_service.dart';

class AdminProjectsPage extends StatefulWidget {
  const AdminProjectsPage({
    super.key,
  });

  @override
  State<AdminProjectsPage> createState() =>
      _AdminProjectsPageState();
}

class _AdminProjectsPageState
    extends State<AdminProjectsPage> {
  final FirestoreService _firestore =
      FirestoreService();

  final CloudinaryService _cloudinary =
      CloudinaryService();

  final ImagePicker _imagePicker =
      ImagePicker();

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
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: ivory,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (
            context,
            constraints,
          ) {
            final bool mobile =
                constraints.maxWidth < 700;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal:
                    mobile ? 20 : 60,
                vertical: 55,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  _buildHeader(
                    constraints.maxWidth,
                  ),
                  const SizedBox(
                    height: 55,
                  ),
                  _buildProjectList(),
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
    final bool mobile =
        width < 850;

    if (mobile) {
      return Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'PROJECTS',
            style: TextStyle(
              color: burgundy,
              fontSize: 11,
              fontWeight:
                  FontWeight.bold,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          const Text(
            'Kelola project\nportofolio kamu.',
            style: TextStyle(
              color:
                  burgundyDark,
              fontSize: 30,
              fontWeight:
                  FontWeight.w600,
              height: 1.15,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          _addButton(),
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
                'PROJECTS',
                style: TextStyle(
                  color: burgundy,
                  fontSize: 11,
                  fontWeight:
                      FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Kelola project portofolio kamu.',
                style: TextStyle(
                  color:
                      burgundyDark,
                  fontSize: 30,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 25,
        ),
        _addButton(),
      ],
    );
  }

  Widget _addButton() {
    return ElevatedButton.icon(
      onPressed: () {
        _showProjectForm();
      },
      icon: const Icon(
        Icons.add,
        size: 19,
      ),
      label: const Text(
        'TAMBAH PROJECT',
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
          horizontal: 22,
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
  // PROJECT LIST
  // ==========================================================

  Widget _buildProjectList() {
    return StreamBuilder<
        QuerySnapshot<
            Map<String, dynamic>>>(
      stream:
          _firestore.getProjects(),
      builder: (
        context,
        snapshot,
      ) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Padding(
            padding:
                EdgeInsets.all(70),
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
            snapshot.error
                .toString(),
          );
        }

        final docs =
            snapshot.data?.docs ??
                [];

        if (docs.isEmpty) {
          return _emptyProjects();
        }

        return Column(
          children:
              docs.map((doc) {
            return _projectCard(
              id: doc.id,
              data: doc.data(),
            );
          }).toList(),
        );
      },
    );
  }

  // ==========================================================
  // PROJECT CARD
  // ==========================================================

  Widget _projectCard({
    required String id,
    required Map<String, dynamic>
        data,
  }) {
    final String title =
        data['title']
                ?.toString() ??
            '';

    final String category =
        data['category']
                ?.toString() ??
            '';

    final String technology =
        data['technology']
                ?.toString() ??
            '';

    final String description =
        data['description']
                ?.toString() ??
            '';

    final String imageUrl =
        data['imageUrl']
                ?.toString() ??
            '';

    final List<String> imageUrls =
        _readImageUrls(
      data['imageUrls'],
    );

    return LayoutBuilder(
      builder: (
        context,
        constraints,
      ) {
        final bool mobile =
            constraints.maxWidth <
                650;

        return Container(
          width:
              double.infinity,
          margin:
              const EdgeInsets.only(
            bottom: 22,
          ),
          padding:
              const EdgeInsets.all(
            28,
          ),
          decoration:
              _cardDecoration(),
          child: mobile
              ? _mobileProjectCard(
                  id: id,
                  title: title,
                  category:
                      category,
                  technology:
                      technology,
                  description:
                      description,
                  imageUrl:
                      imageUrl,
                  imageUrls:
                      imageUrls,
                )
              : _desktopProjectCard(
                  id: id,
                  title: title,
                  category:
                      category,
                  technology:
                      technology,
                  description:
                      description,
                  imageUrl:
                      imageUrl,
                  imageUrls:
                      imageUrls,
                ),
        );
      },
    );
  }

  // ==========================================================
  // DESKTOP CARD
  // ==========================================================

  Widget _desktopProjectCard({
    required String id,
    required String title,
    required String category,
    required String technology,
    required String description,
    required String imageUrl,
    required List<String> imageUrls,
  }) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _projectImage(
          imageUrl,
        ),
        const SizedBox(
          width: 30,
        ),
        Expanded(
          child: _projectContent(
            title: title,
            category: category,
            technology: technology,
            description: description,
            galleryCount:
                imageUrls.length,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        _projectActions(
          id,
        ),
      ],
    );
  }

  // ==========================================================
  // MOBILE CARD
  // ==========================================================

  Widget _mobileProjectCard({
    required String id,
    required String title,
    required String category,
    required String technology,
    required String description,
    required String imageUrl,
    required List<String> imageUrls,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            _projectImage(
              imageUrl,
            ),
            const SizedBox(
              width: 18,
            ),
            Expanded(
              child: _projectContent(
                title: title,
                category: category,
                technology: technology,
                description: description,
                galleryCount:
                    imageUrls.length,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 18,
        ),
        Align(
          alignment:
              Alignment.centerRight,
          child: _projectActions(
            id,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // PROJECT IMAGE
  // ==========================================================

  Widget _projectImage(
    String imageUrl,
  ) {
    return Container(
      width: 95,
      height: 95,
      decoration:
          BoxDecoration(
        color:
            burgundy.withValues(
          alpha: 0.08,
        ),
        border:
            Border.all(
          color: border,
        ),
      ),
      child:
          imageUrl.isEmpty
              ? const Icon(
                  Icons
                      .work_outline,
                  color:
                      burgundy,
                  size: 35,
                )
              : Image.network(
                  imageUrl,
                  fit:
                      BoxFit.contain,
                  errorBuilder:
                      (
                    context,
                    error,
                    stackTrace,
                  ) {
                    return const Icon(
                      Icons
                          .broken_image_outlined,
                      color:
                          taupe,
                      size: 35,
                    );
                  },
                ),
    );
  }

  // ==========================================================
  // PROJECT CONTENT
  // ==========================================================

  Widget _projectContent({
    required String title,
    required String category,
    required String technology,
    required String description,
    required int galleryCount,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          title.isEmpty
              ? 'Untitled Project'
              : title,
          style:
              const TextStyle(
            color:
                burgundyDark,
            fontSize:
                20,
            fontWeight:
                FontWeight.w600,
          ),
        ),

        if (category.isNotEmpty) ...[
          const SizedBox(
            height: 8,
          ),
          Text(
            category,
            style:
                const TextStyle(
              color:
                  burgundy,
              fontSize:
                  12,
              fontWeight:
                  FontWeight.bold,
              letterSpacing:
                  1,
            ),
          ),
        ],

        if (technology.isNotEmpty) ...[
          const SizedBox(
            height: 8,
          ),
          Text(
            technology,
            style:
                const TextStyle(
              color:
                  taupe,
              fontSize:
                  14,
            ),
          ),
        ],

        if (description.isNotEmpty) ...[
          const SizedBox(
            height: 12,
          ),
          Text(
            description,
            maxLines:
                3,
            overflow:
                TextOverflow
                    .ellipsis,
            style:
                const TextStyle(
              color:
                  taupe,
              fontSize:
                  14,
              height:
                  1.5,
            ),
          ),
        ],

        if (galleryCount > 0) ...[
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              const Icon(
                Icons
                    .collections_outlined,
                color:
                    burgundy,
                size:
                    15,
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                '$galleryCount gambar gallery',
                style:
                    const TextStyle(
                  color:
                      burgundy,
                  fontSize:
                      11,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  // ==========================================================
  // ACTIONS
  // ==========================================================

  Widget _projectActions(
    String id,
  ) {
    return Row(
      mainAxisSize:
          MainAxisSize.min,
      children: [
        IconButton(
          tooltip:
              'Edit project',
          onPressed: () {
            _editProject(
              id,
            );
          },
          icon:
              const Icon(
            Icons
                .edit_outlined,
            color:
                taupe,
          ),
        ),
        IconButton(
          tooltip:
              'Hapus project',
          onPressed: () {
            _confirmDelete(
              id,
            );
          },
          icon:
              const Icon(
            Icons
                .delete_outline,
            color:
                Colors.redAccent,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // EDIT PROJECT
  // ==========================================================

  Future<void> _editProject(
    String id,
  ) async {
    try {
      final document =
          await FirebaseFirestore
              .instance
              .collection(
                'projects',
              )
              .doc(id)
              .get();

      if (!document.exists) {
        _showSnack(
          'Project tidak ditemukan.',
        );
        return;
      }

      final data =
          document.data();

      if (data == null) {
        _showSnack(
          'Data project kosong.',
        );
        return;
      }

      _showProjectForm(
        id:
            id,
        data:
            data,
      );
    } catch (e) {
      _showSnack(
        'Gagal mengambil data project: $e',
      );
    }
  }

  // ==========================================================
  // FORM
  // ==========================================================

  void _showProjectForm({
    String? id,
    Map<String, dynamic>? data,
  }) {
    final bool editing =
        id != null;

    final TextEditingController
        titleController =
        TextEditingController(
      text:
          data?['title']
                  ?.toString() ??
              '',
    );

    final TextEditingController
        categoryController =
        TextEditingController(
      text:
          data?['category']
                  ?.toString() ??
              '',
    );

    final TextEditingController
        technologyController =
        TextEditingController(
      text:
          data?['technology']
                  ?.toString() ??
              '',
    );

    final TextEditingController
        descriptionController =
        TextEditingController(
      text:
          data?['description']
                  ?.toString() ??
              '',
    );

    final TextEditingController
        projectUrlController =
        TextEditingController(
      text:
          data?['projectUrl']
                  ?.toString() ??
              '',
    );

    String currentImageUrl =
        data?['imageUrl']
                ?.toString() ??
            '';

    XFile? selectedCover;

    List<String> galleryUrls =
        _readImageUrls(
      data?['imageUrls'],
    );

    final List<XFile>
        selectedGallery =
        [];

    bool saving = false;

    showDialog(
      context:
          context,
      barrierDismissible:
          false,
      builder:
          (
        dialogContext,
      ) {
        return StatefulBuilder(
          builder:
              (
            context,
            setDialogState,
          ) {
            return Dialog(
              backgroundColor:
                  ivory,
              insetPadding:
                  const EdgeInsets
                      .all(
                20,
              ),
              shape:
                  const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.zero,
              ),
              child:
                  ConstrainedBox(
                constraints:
                    const BoxConstraints(
                  maxWidth:
                      700,
                  maxHeight:
                      900,
                ),
                child:
                    SingleChildScrollView(
                  padding:
                      const EdgeInsets
                          .all(
                    30,
                  ),
                  child:
                      Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child:
                                Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  editing
                                      ? 'EDIT PROJECT'
                                      : 'TAMBAH PROJECT',
                                  style:
                                      const TextStyle(
                                    color:
                                        burgundy,
                                    fontSize:
                                        11,
                                    fontWeight:
                                        FontWeight.bold,
                                    letterSpacing:
                                        3,
                                  ),
                                ),
                                const SizedBox(
                                  height:
                                      10,
                                ),
                                Text(
                                  editing
                                      ? 'Perbarui project kamu.'
                                      : 'Tambahkan project baru.',
                                  style:
                                      const TextStyle(
                                    color:
                                        burgundyDark,
                                    fontSize:
                                        25,
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed:
                                saving
                                    ? null
                                    : () {
                                        Navigator
                                            .pop(
                                          dialogContext,
                                        );
                                      },
                            icon:
                                const Icon(
                              Icons.close,
                              color:
                                  burgundyDark,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height:
                            30,
                      ),

                      _formField(
                        controller:
                            titleController,
                        label:
                            'JUDUL PROJECT',
                        hint:
                            'Contoh: Aplikasi Fast Road',
                      ),

                      const SizedBox(
                        height:
                            18,
                      ),

                      _formField(
                        controller:
                            categoryController,
                        label:
                            'KATEGORI',
                        hint:
                            'Contoh: Mobile Development',
                      ),

                      const SizedBox(
                        height:
                            18,
                      ),

                      _formField(
                        controller:
                            technologyController,
                        label:
                            'TECHNOLOGY',
                        hint:
                            'Contoh: Flutter, Firebase',
                      ),

                      const SizedBox(
                        height:
                            18,
                      ),

                      _formField(
                        controller:
                            descriptionController,
                        label:
                            'DESKRIPSI',
                        hint:
                            'Deskripsi project...',
                        maxLines:
                            5,
                      ),

                      const SizedBox(
                        height:
                            25,
                      ),

                      // ==================================================
                      // COVER
                      // ==================================================

                      _buildCoverPicker(
                        currentImageUrl:
                            currentImageUrl,
                        selectedCover:
                            selectedCover,
                        onPick:
                            () async {
                          try {
                            final XFile?
                                image =
                                await _imagePicker
                                    .pickImage(
                              source:
                                  ImageSource
                                      .gallery,
                              imageQuality:
                                  90,
                            );

                            if (image ==
                                null) {
                              return;
                            }

                            setDialogState(
                              () {
                                selectedCover =
                                    image;
                              },
                            );
                          } catch (e) {
                            _showSnack(
                              'Gagal memilih cover: $e',
                            );
                          }
                        },
                        onRemove:
                            () {
                          setDialogState(
                            () {
                              currentImageUrl =
                                  '';
                              selectedCover =
                                  null;
                            },
                          );
                        },
                      ),

                      const SizedBox(
                        height:
                            28,
                      ),

                      // ==================================================
                      // GALLERY
                      // ==================================================

                      _buildGalleryPicker(
                        galleryUrls:
                            galleryUrls,
                        selectedGallery:
                            selectedGallery,
                        onPick:
                            () async {
                          try {
                            final List<
                                    XFile>
                                images =
                                await _imagePicker
                                    .pickMultiImage(
                              imageQuality:
                                  90,
                            );

                            if (images
                                .isEmpty) {
                              return;
                            }

                            setDialogState(
                              () {
                                selectedGallery
                                    .addAll(
                                  images,
                                );
                              },
                            );
                          } catch (e) {
                            _showSnack(
                              'Gagal memilih gambar gallery: $e',
                            );
                          }
                        },
                        onRemoveExisting:
                            (
                          int index,
                        ) {
                          setDialogState(
                            () {
                              galleryUrls
                                  .removeAt(
                                index,
                              );
                            },
                          );
                        },
                        onRemoveSelected:
                            (
                          int index,
                        ) {
                          setDialogState(
                            () {
                              selectedGallery
                                  .removeAt(
                                index,
                              );
                            },
                          );
                        },
                      ),

                      const SizedBox(
                        height:
                            25,
                      ),

                      _formField(
                        controller:
                            projectUrlController,
                        label:
                            'PROJECT URL (OPSIONAL)',
                        hint:
                            'https://github.com/...',
                      ),

                      const SizedBox(
                        height:
                            30,
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
                            width:
                                10,
                          ),

                          ElevatedButton(
                            onPressed:
                                saving
                                    ? null
                                    : () async {
                                        final String
                                            title =
                                            titleController
                                                .text
                                                .trim();

                                        final String
                                            category =
                                            categoryController
                                                .text
                                                .trim();

                                        final String
                                            technology =
                                            technologyController
                                                .text
                                                .trim();

                                        final String
                                            description =
                                            descriptionController
                                                .text
                                                .trim();

                                        final String
                                            projectUrl =
                                            projectUrlController
                                                .text
                                                .trim();

                                        if (title
                                            .isEmpty) {
                                          _showSnack(
                                            'Judul project wajib diisi.',
                                          );
                                          return;
                                        }

                                        if (category
                                            .isEmpty) {
                                          _showSnack(
                                            'Kategori project wajib diisi.',
                                          );
                                          return;
                                        }

                                        if (technology
                                            .isEmpty) {
                                          _showSnack(
                                            'Technology wajib diisi.',
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
                                          // ============================================
                                          // UPLOAD COVER
                                          // ============================================

                                          String
                                              imageUrl =
                                              currentImageUrl;

                                          if (selectedCover !=
                                              null) {
                                            imageUrl =
                                                await _cloudinary
                                                    .uploadImage(
                                              selectedCover!,
                                            );
                                          }

                                          // ============================================
                                          // UPLOAD GALLERY
                                          // ============================================

                                          final List<
                                                  String>
                                              finalGallery =
                                              List<String>.from(
                                            galleryUrls,
                                          );

                                          for (
                                            final XFile
                                                image
                                                in selectedGallery
                                          ) {
                                            final String
                                                uploadedUrl =
                                                await _cloudinary
                                                    .uploadImage(
                                              image,
                                            );

                                            if (uploadedUrl
                                                .trim()
                                                .isNotEmpty) {
                                              finalGallery
                                                  .add(
                                                uploadedUrl,
                                              );
                                            }
                                          }

                                          // ============================================
                                          // FIRESTORE
                                          // ============================================

                                          if (editing) {
                                            await _firestore
                                                .updateProject(
                                              id:
                                                  id,
                                              title:
                                                  title,
                                              description:
                                                  description,
                                              category:
                                                  category,
                                              technology:
                                                  technology,
                                              imageUrl:
                                                  imageUrl,
                                              imageUrls:
                                                  finalGallery,
                                              projectUrl:
                                                  projectUrl,
                                            );
                                          } else {
                                            await _firestore
                                                .addProject(
                                              title:
                                                  title,
                                              description:
                                                  description,
                                              category:
                                                  category,
                                              technology:
                                                  technology,
                                              imageUrl:
                                                  imageUrl,
                                              imageUrls:
                                                  finalGallery,
                                              projectUrl:
                                                  projectUrl,
                                            );
                                          }

                                          if (!dialogContext
                                              .mounted) {
                                            return;
                                          }

                                          Navigator
                                              .pop(
                                            dialogContext,
                                          );

                                          _showSnack(
                                            editing
                                                ? 'Project berhasil diperbarui.'
                                                : 'Project berhasil ditambahkan.',
                                          );
                                        } catch (e) {
                                          setDialogState(
                                            () {
                                              saving =
                                                  false;
                                            },
                                          );

                                          _showSnack(
                                            'Gagal menyimpan project: $e',
                                          );
                                        }
                                      },
                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor:
                                  burgundy,
                              foregroundColor:
                                  ivory,
                              elevation:
                                  0,
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal:
                                    22,
                                vertical:
                                    16,
                              ),
                              shape:
                                  const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius
                                        .zero,
                              ),
                            ),
                            child:
                                saving
                                    ? const SizedBox(
                                        width:
                                            18,
                                        height:
                                            18,
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
                                            : 'SIMPAN PROJECT',
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
  // COVER PICKER
  // ==========================================================

  Widget _buildCoverPicker({
    required String currentImageUrl,
    required XFile? selectedCover,
    required VoidCallback onPick,
    required VoidCallback onRemove,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'COVER PROJECT',
          style:
              TextStyle(
            color: burgundyDark,
            fontSize: 10,
            fontWeight:
                FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),

        const SizedBox(
          height: 9,
        ),

        Container(
          width:
              double.infinity,
          height:
              230,
          decoration:
              BoxDecoration(
            color:
                softIvory,
            border:
                Border.all(
              color:
                  border,
            ),
          ),
          child:
              selectedCover != null
                  ? FutureBuilder<
                      Uint8List>(
                      future:
                          selectedCover
                              .readAsBytes(),
                      builder:
                          (
                        context,
                        snapshot,
                      ) {
                        if (snapshot
                                .connectionState ==
                            ConnectionState
                                .waiting) {
                          return const Center(
                            child:
                                CircularProgressIndicator(
                              color:
                                  burgundy,
                            ),
                          );
                        }

                        if (snapshot
                                .hasError ||
                            !snapshot
                                .hasData) {
                          return const Center(
                            child:
                                Icon(
                              Icons
                                  .broken_image_outlined,
                              color:
                                  taupe,
                              size:
                                  45,
                            ),
                          );
                        }

                        return Image.memory(
                          snapshot.data!,
                          fit:
                              BoxFit.contain,
                        );
                      },
                    )
                  : currentImageUrl
                          .isNotEmpty
                      ? Image.network(
                          currentImageUrl,
                          fit:
                              BoxFit.contain,
                          errorBuilder:
                              (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return const Center(
                              child:
                                  Icon(
                                Icons
                                    .broken_image_outlined,
                                color:
                                    taupe,
                                size:
                                    45,
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,
                            children: [
                              Icon(
                                Icons
                                    .image_outlined,
                                color:
                                    taupe,
                                size:
                                    50,
                              ),
                              SizedBox(
                                height:
                                    10,
                              ),
                              Text(
                                'Belum ada cover',
                                style:
                                    TextStyle(
                                  color:
                                      taupe,
                                  fontSize:
                                      13,
                                ),
                              ),
                            ],
                          ),
                        ),
        ),

        const SizedBox(
          height: 12,
        ),

        Row(
          children: [
            Expanded(
              child:
                  OutlinedButton.icon(
                onPressed:
                    onPick,
                icon:
                    const Icon(
                  Icons
                      .upload_outlined,
                  size:
                      18,
                ),
                label:
                    Text(
                  selectedCover != null ||
                          currentImageUrl
                              .isNotEmpty
                      ? 'GANTI COVER'
                      : 'PILIH COVER',
                ),
                style:
                    OutlinedButton.styleFrom(
                  foregroundColor:
                      burgundy,
                  side:
                      const BorderSide(
                    color:
                        burgundy,
                  ),
                  padding:
                      const EdgeInsets
                          .symmetric(
                    vertical:
                        15,
                  ),
                  shape:
                      const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius
                            .zero,
                  ),
                ),
              ),
            ),

            if (selectedCover != null ||
                currentImageUrl
                    .isNotEmpty) ...[
              const SizedBox(
                width: 10,
              ),
              IconButton(
                tooltip:
                    'Hapus cover',
                onPressed:
                    onRemove,
                icon:
                    const Icon(
                  Icons
                      .delete_outline,
                  color:
                      Colors.redAccent,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  // ==========================================================
  // GALLERY PICKER
  // ==========================================================

  Widget _buildGalleryPicker({
    required List<String> galleryUrls,
    required List<XFile>
        selectedGallery,
    required VoidCallback onPick,
    required void Function(
      int index,
    ) onRemoveExisting,
    required void Function(
      int index,
    ) onRemoveSelected,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'GALLERY PROJECT',
          style:
              TextStyle(
            color: burgundyDark,
            fontSize: 10,
            fontWeight:
                FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),

        const SizedBox(
          height: 7,
        ),

        const Text(
          'Tambahkan screenshot atau gambar pendukung project. Bisa lebih dari satu.',
          style:
              TextStyle(
            color: taupe,
            fontSize: 12,
            height: 1.4,
          ),
        ),

        const SizedBox(
          height: 14,
        ),

        if (galleryUrls.isEmpty &&
            selectedGallery.isEmpty)
          Container(
            width:
                double.infinity,
            padding:
                const EdgeInsets
                    .symmetric(
              vertical: 35,
            ),
            decoration:
                BoxDecoration(
              color:
                  softIvory,
              border:
                  Border.all(
                color:
                    border,
              ),
            ),
            child:
                const Column(
              children: [
                Icon(
                  Icons
                      .collections_outlined,
                  color:
                      taupe,
                  size:
                      40,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Belum ada gambar gallery',
                  style:
                      TextStyle(
                    color:
                        taupe,
                    fontSize:
                        13,
                  ),
                ),
              ],
            ),
          )
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ...List.generate(
                galleryUrls.length,
                (
                  index,
                ) {
                  return _existingGalleryItem(
                    url:
                        galleryUrls[
                            index],
                    onRemove:
                        () {
                      onRemoveExisting(
                        index,
                      );
                    },
                  );
                },
              ),

              ...List.generate(
                selectedGallery.length,
                (
                  index,
                ) {
                  return _selectedGalleryItem(
                    image:
                        selectedGallery[
                            index],
                    onRemove:
                        () {
                      onRemoveSelected(
                        index,
                      );
                    },
                  );
                },
              ),
            ],
          ),

        const SizedBox(
          height: 14,
        ),

        SizedBox(
          width:
              double.infinity,
          child:
              OutlinedButton.icon(
            onPressed:
                onPick,
            icon:
                const Icon(
              Icons
                  .add_photo_alternate_outlined,
              size:
                  19,
            ),
            label:
                const Text(
              'TAMBAH GAMBAR GALLERY',
            ),
            style:
                OutlinedButton.styleFrom(
              foregroundColor:
                  burgundy,
              side:
                  const BorderSide(
                color:
                    burgundy,
              ),
              padding:
                  const EdgeInsets
                      .symmetric(
                vertical:
                    15,
              ),
              shape:
                  const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius
                        .zero,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // EXISTING GALLERY ITEM
  // ==========================================================

  Widget _existingGalleryItem({
    required String url,
    required VoidCallback
        onRemove,
  }) {
    return Stack(
      children: [
        Container(
          width:
              145,
          height:
              145,
          decoration:
              BoxDecoration(
            color:
                softIvory,
            border:
                Border.all(
              color:
                  border,
            ),
          ),
          child:
              Image.network(
            url,
            fit:
                BoxFit.contain,
            errorBuilder:
                (
              context,
              error,
              stackTrace,
            ) {
              return const Icon(
                Icons
                    .broken_image_outlined,
                color:
                    taupe,
                size:
                    35,
              );
            },
          ),
        ),

        Positioned(
          top:
              5,
          right:
              5,
          child:
              Material(
            color:
                Colors.white,
            child:
                InkWell(
              onTap:
                  onRemove,
              child:
                  const Padding(
                padding:
                    EdgeInsets.all(
                  5,
                ),
                child:
                    Icon(
                  Icons.close,
                  size:
                      18,
                  color:
                      Colors.redAccent,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // SELECTED GALLERY ITEM
  // ==========================================================

  Widget _selectedGalleryItem({
    required XFile image,
    required VoidCallback
        onRemove,
  }) {
    return Stack(
      children: [
        Container(
          width:
              145,
          height:
              145,
          decoration:
              BoxDecoration(
            color:
                softIvory,
            border:
                Border.all(
              color:
                  burgundy,
              width:
                  1.5,
            ),
          ),
          child:
              FutureBuilder<
                  Uint8List>(
            future:
                image.readAsBytes(),
            builder:
                (
              context,
              snapshot,
            ) {
              if (snapshot
                      .connectionState ==
                  ConnectionState
                      .waiting) {
                return const Center(
                  child:
                      CircularProgressIndicator(
                    color:
                        burgundy,
                  ),
                );
              }

              if (snapshot.hasError ||
                  !snapshot.hasData) {
                return const Icon(
                  Icons
                      .broken_image_outlined,
                  color:
                      taupe,
                  size:
                      35,
                );
              }

              return Image.memory(
                snapshot.data!,
                fit:
                    BoxFit.contain,
              );
            },
          ),
        ),

        Positioned(
          top:
              5,
          right:
              5,
          child:
              Material(
            color:
                Colors.white,
            child:
                InkWell(
              onTap:
                  onRemove,
              child:
                  const Padding(
                padding:
                    EdgeInsets.all(
                  5,
                ),
                child:
                    Icon(
                  Icons.close,
                  size:
                      18,
                  color:
                      Colors.redAccent,
                ),
              ),
            ),
          ),
        ),

        Positioned(
          left:
              5,
          bottom:
              5,
          child:
              Container(
            padding:
                const EdgeInsets
                    .symmetric(
              horizontal:
                  6,
              vertical:
                  3,
            ),
            color:
                burgundy,
            child:
                const Text(
              'BARU',
              style:
                  TextStyle(
                color:
                    ivory,
                fontSize:
                    9,
                fontWeight:
                    FontWeight.bold,
                letterSpacing:
                    1,
              ),
            ),
          ),
        ),
      ],
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
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              const TextStyle(
            color:
                burgundyDark,
            fontSize:
                10,
            fontWeight:
                FontWeight.bold,
            letterSpacing:
                1.5,
          ),
        ),

        const SizedBox(
          height: 8,
        ),

        TextField(
          controller:
              controller,
          maxLines:
              maxLines,
          style:
              const TextStyle(
            color:
                burgundyDark,
            fontSize:
                14,
          ),
          decoration:
              InputDecoration(
            hintText:
                hint,
            hintStyle:
                const TextStyle(
              color:
                  taupe,
            ),
            filled:
                true,
            fillColor:
                Colors.white
                    .withValues(
              alpha:
                  0.45,
            ),
            contentPadding:
                const EdgeInsets
                    .symmetric(
              horizontal:
                  15,
              vertical:
                  15,
            ),
            enabledBorder:
                const OutlineInputBorder(
              borderRadius:
                  BorderRadius
                      .zero,
              borderSide:
                  BorderSide(
                color:
                    border,
              ),
            ),
            focusedBorder:
                const OutlineInputBorder(
              borderRadius:
                  BorderRadius
                      .zero,
              borderSide:
                  BorderSide(
                color:
                    burgundy,
                width:
                    1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // READ IMAGE URLS
  // ==========================================================

  List<String> _readImageUrls(
    dynamic value,
  ) {
    if (value == null) {
      return [];
    }

    if (value is List) {
      return value
          .map(
            (item) =>
                item
                    .toString()
                    .trim(),
          )
          .where(
            (url) =>
                url.isNotEmpty,
          )
          .toList();
    }

    return [];
  }

  // ==========================================================
  // DELETE
  // ==========================================================

  void _confirmDelete(
    String id,
  ) {
    showDialog(
      context:
          context,
      builder:
          (
        dialogContext,
      ) {
        return AlertDialog(
          backgroundColor:
              ivory,
          shape:
              const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.zero,
          ),
          title:
              const Text(
            'Hapus Project?',
            style:
                TextStyle(
              color:
                  burgundyDark,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
          content:
              const Text(
            'Project yang dihapus tidak dapat dikembalikan.',
            style:
                TextStyle(
              color:
                  taupe,
            ),
          ),
          actions: [
            TextButton(
              onPressed:
                  () {
                Navigator.pop(
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
            ElevatedButton(
              onPressed:
                  () async {
                Navigator.pop(
                  dialogContext,
                );

                try {
                  await _firestore
                      .deleteProject(
                    id,
                  );

                  _showSnack(
                    'Project berhasil dihapus.',
                  );
                } catch (e) {
                  _showSnack(
                    'Gagal menghapus: $e',
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
                elevation:
                    0,
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
  // EMPTY
  // ==========================================================

  Widget _emptyProjects() {
    return Container(
      width:
          double.infinity,
      padding:
          const EdgeInsets
              .symmetric(
        vertical:
            70,
      ),
      decoration:
          _cardDecoration(),
      child:
          Column(
        children: [
          const Icon(
            Icons
                .work_outline,
            size:
                50,
            color:
                taupe,
          ),
          const SizedBox(
            height:
                18,
          ),
          const Text(
            'Belum ada project.',
            style:
                TextStyle(
              color:
                  burgundyDark,
              fontSize:
                  17,
            ),
          ),
          const SizedBox(
            height:
                25,
          ),
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
      width:
          double.infinity,
      padding:
          const EdgeInsets.all(
        25,
      ),
      decoration:
          BoxDecoration(
        color:
            Colors.redAccent
                .withValues(
          alpha:
              0.05,
        ),
        border:
            Border.all(
          color:
              Colors.redAccent
                  .withValues(
            alpha:
                0.25,
          ),
        ),
      ),
      child:
          Text(
        error,
        style:
            const TextStyle(
          color:
              Colors.redAccent,
        ),
      ),
    );
  }

  // ==========================================================
  // DECORATION
  // ==========================================================

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color:
          softIvory,
      border:
          Border.all(
        color:
            border,
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
        content:
            Text(
          message,
        ),
        backgroundColor:
            burgundyDark,
      ),
    );
  }
}