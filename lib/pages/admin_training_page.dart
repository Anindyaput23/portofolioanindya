import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/cloudinary_services.dart';
import '../services/firestore_service.dart';

class AdminTrainingPage extends StatefulWidget {
  const AdminTrainingPage({super.key});

  @override
  State<AdminTrainingPage> createState() => _AdminTrainingPageState();
}

class _AdminTrainingPageState extends State<AdminTrainingPage> {
  final FirestoreService _firestore = FirestoreService();
  final CloudinaryService _cloudinary = CloudinaryService();
  final ImagePicker _picker = ImagePicker();

  static const Color burgundy = Color(0xFF7A1F3D);
  static const Color burgundyDark = Color(0xFF5C1730);
  static const Color ivory = Color(0xFFF4EFE6);
  static const Color taupe = Color(0xFF6F625D);
  static const Color border = Color(0xFFD8CEC2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ivory,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final mobile = constraints.maxWidth < 700;
            return SingleChildScrollView(
              padding: EdgeInsets.all(mobile ? 20 : 45),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(mobile),
                  SizedBox(height: mobile ? 25 : 35),
                  _list(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _header(bool mobile) {
    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('TRAINING & COURSES', style: TextStyle(color: burgundy, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 3)),
        SizedBox(height: 10),
        Text('Kelola training & courses portfolio kamu.', style: TextStyle(color: burgundyDark, fontSize: 30, fontWeight: FontWeight.w600)),
      ],
    );
    if (mobile) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [title, const SizedBox(height: 22), SizedBox(width: double.infinity, child: _addButton())]);
    }
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [Expanded(child: title), const SizedBox(width: 25), _addButton()]);
  }

  Widget _addButton() {
    return ElevatedButton.icon(
      onPressed: () => _showForm(),
      icon: const Icon(Icons.add, size: 18),
      label: const Text('TAMBAH TRAINING & COURSES'),
      style: ElevatedButton.styleFrom(
        backgroundColor: burgundy,
        foregroundColor: ivory,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
    );
  }

  Widget _list() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _firestore.getTrainings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(padding: EdgeInsets.all(60), child: Center(child: CircularProgressIndicator(color: burgundy)));
        }
        if (snapshot.hasError) return _errorBox(snapshot.error.toString());
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) return _empty();
        return Column(children: docs.map((doc) => _card(doc.id, doc.data())).toList());
      },
    );
  }

  Widget _card(String id, Map<String, dynamic> data) {
    final name = data['name']?.toString() ?? 'Untitled Training';
    final issuer = data['issuer']?.toString() ?? '';
    final year = data['year']?.toString() ?? '';
    final credential = data['credential']?.toString() ?? '';
    final url = data['trainingUrl']?.toString() ?? '';
    final image = data['imageUrl']?.toString() ?? '';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: .42), border: Border.all(color: border)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final mobile = constraints.maxWidth < 650;
          final info = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: const TextStyle(color: burgundyDark, fontSize: 19, fontWeight: FontWeight.w600)),
            if (issuer.isNotEmpty) ...[const SizedBox(height: 7), Text(issuer, style: const TextStyle(color: burgundy, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1))],
            if (year.isNotEmpty) ...[const SizedBox(height: 6), Text(year, style: const TextStyle(color: taupe, fontSize: 13))],
            if (credential.isNotEmpty) ...[const SizedBox(height: 8), Text('Credential: $credential', style: const TextStyle(color: taupe, fontSize: 12))],
            if (url.isNotEmpty) ...[const SizedBox(height: 8), Text(url, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: taupe, fontSize: 11))],
            if (image.isNotEmpty) ...[const SizedBox(height: 8), Text('Gambar tersimpan di Cloudinary', style: const TextStyle(color: taupe, fontSize: 11))],
          ]);
          final actions = Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(tooltip: 'Edit', onPressed: () => _getAndEdit(id), icon: const Icon(Icons.edit_outlined, color: taupe)),
            IconButton(tooltip: 'Hapus', onPressed: () => _confirmDelete(id), icon: const Icon(Icons.delete_outline, color: Colors.redAccent)),
          ]);
          if (mobile) return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [info, const SizedBox(height: 14), Align(alignment: Alignment.centerRight, child: actions)]);
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _thumb(image), const SizedBox(width: 20), Expanded(child: info), const SizedBox(width: 15), actions,
          ]);
        },
      ),
    );
  }

  Widget _thumb(String url) {
    return Container(
      width: 90, height: 65,
      decoration: BoxDecoration(border: Border.all(color: border), color: burgundy.withValues(alpha: .06)),
      clipBehavior: Clip.antiAlias,
      child: url.isEmpty ? const Icon(Icons.school_outlined, color: burgundy, size: 28) : Image.network(url, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined, color: taupe)),
    );
  }

  Future<Map<String, dynamic>?> _get(String id) async {
    final snap = await FirebaseFirestore.instance.collection('training').doc(id).get();
    return snap.exists ? snap.data() : null;
  }

  Future<void> _getAndEdit(String id) async {
    try {
      final data = await _get(id);
      if (!mounted || data == null) return;
      _showForm(id: id, data: data);
    } catch (e) {
      _snack('Gagal mengambil data training: $e');
    }
  }

  void _showForm({String? id, Map<String, dynamic>? data}) {
    final name = TextEditingController(text: data?['name']?.toString() ?? '');
    final issuer = TextEditingController(text: data?['issuer']?.toString() ?? '');
    final year = TextEditingController(text: data?['year']?.toString() ?? '');
    final credential = TextEditingController(text: data?['credential']?.toString() ?? '');
    final url = TextEditingController(text: data?['trainingUrl']?.toString() ?? '');
    String imageUrl = data?['imageUrl']?.toString() ?? '';
    XFile? pickedImage;
    bool saving = false;
    bool uploading = false;

    showDialog(
      context: context,
      barrierDismissible: !saving && !uploading,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> pick() async {
              final file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
              if (file != null) setDialogState(() { pickedImage = file; });
            }

            Future<void> upload() async {
              if (pickedImage == null) return;
              setDialogState(() => uploading = true);
              try {
                final uploaded = await _cloudinary.uploadImage(pickedImage!);
                setDialogState(() { imageUrl = uploaded; uploading = false; });
              } catch (e) {
                setDialogState(() => uploading = false);
                _snack('Upload gambar gagal: $e');
              }
            }

            Future<void> save() async {
              if (name.text.trim().isEmpty || issuer.text.trim().isEmpty || year.text.trim().isEmpty) {
                _snack('Nama, penerbit, dan tahun wajib diisi.');
                return;
              }
              if (pickedImage != null && imageUrl.isEmpty) {
                await upload();
                if (imageUrl.isEmpty) return;
              }
              setDialogState(() => saving = true);
              try {
                if (id == null) {
                  await _firestore.addTraining(name: name.text.trim(), issuer: issuer.text.trim(), year: year.text.trim(), credential: credential.text.trim(), trainingUrl: url.text.trim(), imageUrl: imageUrl);
                } else {
                  await _firestore.updateTraining(id: id, name: name.text.trim(), issuer: issuer.text.trim(), year: year.text.trim(), credential: credential.text.trim(), trainingUrl: url.text.trim(), imageUrl: imageUrl);
                }
                if (dialogContext.mounted) Navigator.pop(dialogContext);
                _snack(id == null ? 'Training berhasil ditambahkan.' : 'Training berhasil diperbarui.');
              } catch (e) {
                setDialogState(() => saving = false);
                _snack('Gagal menyimpan training: $e');
              }
            }

            return AlertDialog(
              backgroundColor: ivory,
              surfaceTintColor: ivory,
              title: Text(id == null ? 'Tambahkan training baru' : 'Edit training', style: const TextStyle(color: burgundyDark, fontWeight: FontWeight.w700)),
              content: SizedBox(
                width: 680,
                child: SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _field(name, 'NAMA TRAINING & COURSES', 'Contoh: Intro to Software Engineering'),
                    _field(issuer, 'PENERBIT', 'Contoh: RevoU Coding Camp'),
                    _field(year, 'TAHUN', 'Contoh: 2026'),
                    _field(credential, 'CREDENTIAL', 'Nomor credential / ID jika ada'),
                    _field(url, 'TRAINING URL', 'Link Google Drive / website course'),
                    const SizedBox(height: 14),
                    const Text('GAMBAR TRAINING / SERTIFIKAT', style: TextStyle(color: burgundyDark, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.4)),
                    const SizedBox(height: 10),
                    if (imageUrl.isNotEmpty) ...[
                      Container(height: 180, width: double.infinity, decoration: BoxDecoration(border: Border.all(color: border)), clipBehavior: Clip.antiAlias, child: Image.network(imageUrl, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image_outlined, color: taupe)))),
                      const SizedBox(height: 10),
                    ],
                    if (pickedImage != null) Text('File dipilih: ${pickedImage!.name}', style: const TextStyle(color: taupe, fontSize: 12)),
                    Row(children: [
                      OutlinedButton.icon(onPressed: saving || uploading ? null : pick, icon: const Icon(Icons.image_outlined), label: const Text('PILIH GAMBAR')),
                      const SizedBox(width: 10),
                      if (pickedImage != null) ElevatedButton.icon(onPressed: saving || uploading ? null : upload, icon: uploading ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: ivory)) : const Icon(Icons.cloud_upload_outlined), label: const Text('UPLOAD')),
                    ]),
                  ]),
                ),
              ),
              actions: [
                TextButton(onPressed: saving || uploading ? null : () => Navigator.pop(dialogContext), child: const Text('BATAL', style: TextStyle(color: taupe))),
                ElevatedButton(onPressed: saving || uploading ? null : save, style: ElevatedButton.styleFrom(backgroundColor: burgundy, foregroundColor: ivory), child: Text(saving ? 'MENYIMPAN...' : (id == null ? 'SIMPAN TRAINING & COURSES' : 'SIMPAN PERUBAHAN'))),
              ],
            );
          },
        );
      },
    ).then((_) { name.dispose(); issuer.dispose(); year.dispose(); credential.dispose(); url.dispose(); });
  }

  Widget _field(TextEditingController controller, String label, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: burgundyDark, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.4)),
        const SizedBox(height: 7),
        TextField(controller: controller, decoration: InputDecoration(hintText: hint, filled: true, fillColor: Colors.white.withValues(alpha: .45), border: OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: border)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: border)), focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: burgundy, width: 1.5)), contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15))),
      ]),
    );
  }

  Future<void> _confirmDelete(String id) async {
    final ok = await showDialog<bool>(context: context, builder: (context) => AlertDialog(backgroundColor: ivory, title: const Text('Hapus training?'), content: const Text('Data training ini akan dihapus dari portfolio.'), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('BATAL')), ElevatedButton(onPressed: () => Navigator.pop(context, true), style: ElevatedButton.styleFrom(backgroundColor: burgundy, foregroundColor: ivory), child: const Text('HAPUS'))])) ?? false;
    if (!ok) return;
    try { await _firestore.deleteTraining(id); _snack('Training berhasil dihapus.'); } catch (e) { _snack('Gagal menghapus training: $e'); }
  }

  Widget _errorBox(String text) => Container(width: double.infinity, padding: const EdgeInsets.all(22), decoration: BoxDecoration(color: const Color(0xFFFFE9E5), border: Border.all(color: const Color(0xFFFFB9AD))), child: Text(text, style: const TextStyle(color: Colors.redAccent)));
  Widget _empty() => Container(width: double.infinity, padding: const EdgeInsets.all(50), alignment: Alignment.center, decoration: BoxDecoration(border: Border.all(color: border)), child: const Text('Belum ada training & courses.', style: TextStyle(color: taupe)));
  void _snack(String text) { if (!mounted) return; ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text))); }
}
