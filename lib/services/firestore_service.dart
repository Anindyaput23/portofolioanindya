import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ============================================================
  // COLLECTION
  // ============================================================

  CollectionReference<Map<String, dynamic>> get projects =>
      _db.collection('projects');

  CollectionReference<Map<String, dynamic>> get skills =>
      _db.collection('skills');

  CollectionReference<Map<String, dynamic>> get certificates =>
      _db.collection('certificates');

  CollectionReference<Map<String, dynamic>> get profile =>
      _db.collection('profile');

  // ============================================================
  // PROFILE
  // ============================================================

  Future<Map<String, dynamic>?> getProfileOnce() async {
    final document = await profile.doc('main').get();

    if (!document.exists) {
      return null;
    }

    return document.data();
  }

  Future<void> createDefaultProfile() async {
    final document = await profile.doc('main').get();

    if (document.exists) {
      return;
    }

    await profile.doc('main').set({
      'name': 'Anindya Putri Nariswari',
      'title': 'Information Technology Graduate',
      'description':
          'Saya adalah lulusan Teknologi Informasi yang memiliki ketertarikan pada pengembangan aplikasi, UI/UX, dan teknologi digital.',
      'aboutDescription':
          'Saya merupakan lulusan Teknologi Informasi yang tertarik pada pengembangan aplikasi, UI/UX, dan teknologi digital. Saya senang mempelajari hal-hal baru, mengembangkan ide, dan menghasilkan karya yang fungsional serta memiliki tampilan yang baik.',
      'location': 'Madiun, Jawa Timur, Indonesia',
      'email': '',
      'github': '',
      'linkedin': '',
      'instagram': '',
      'profileImageUrl': '',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateProfile({
    required String name,
    required String title,
    required String description,
    required String aboutDescription,
    required String location,
    required String email,
    required String github,
    required String linkedin,
    required String instagram,
    String profileImageUrl = '',
  }) async {
    await profile.doc('main').set({
      'name': name,
      'title': title,
      'description': description,
      'aboutDescription': aboutDescription,
      'location': location,
      'email': email,
      'github': github,
      'linkedin': linkedin,
      'instagram': instagram,
      'profileImageUrl': profileImageUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // ============================================================
  // PROJECT CRUD
  // ============================================================

  Future<String> addProject({
    required String title,
    required String description,
    required String category,
    required String technology,
    String imageUrl = '',
    List<String> imageUrls = const [],
    String projectUrl = '',
  }) async {
    final document = await projects.add({
      'title': title,
      'description': description,
      'category': category,
      'technology': technology,

      // Cover utama
      'imageUrl': imageUrl,

      // Gallery
      'imageUrls': imageUrls,

      // Link project opsional
      'projectUrl': projectUrl,

      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return document.id;
  }

  Future<void> updateProject({
    required String id,
    required String title,
    required String description,
    required String category,
    required String technology,
    String imageUrl = '',
    List<String> imageUrls = const [],
    String projectUrl = '',
  }) async {
    await projects.doc(id).update({
      'title': title,
      'description': description,
      'category': category,
      'technology': technology,

      // Cover utama
      'imageUrl': imageUrl,

      // Gallery
      'imageUrls': imageUrls,

      // Link project opsional
      'projectUrl': projectUrl,

      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteProject(String id) async {
    await projects.doc(id).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getProjects() {
    return projects
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots();
  }

  Future<Map<String, dynamic>?> getProjectById(
    String id,
  ) async {
    final document = await projects.doc(id).get();

    if (!document.exists) {
      return null;
    }

    return document.data();
  }

  // ============================================================
  // SKILLS CRUD
  // ============================================================

  Future<String> addSkill({
    required String name,
    required String category,
    int level = 0,
  }) async {
    final document = await skills.add({
      'name': name,
      'category': category,
      'level': level,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return document.id;
  }

  Future<void> updateSkill({
    required String id,
    required String name,
    required String category,
    int level = 0,
  }) async {
    await skills.doc(id).update({
      'name': name,
      'category': category,
      'level': level,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteSkill(String id) async {
    await skills.doc(id).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSkills() {
    return skills
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots();
  }

  // ============================================================
  // CERTIFICATE CRUD
  // ============================================================

  Future<String> addCertificate({
    required String name,
    required String issuer,
    required String year,
    String credential = '',
    String certificateUrl = '',
  }) async {
    final document = await certificates.add({
      'name': name,
      'issuer': issuer,
      'year': year,
      'credential': credential,
      'certificateUrl': certificateUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return document.id;
  }

  Future<void> updateCertificate({
    required String id,
    required String name,
    required String issuer,
    required String year,
    String credential = '',
    String certificateUrl = '',
  }) async {
    await certificates.doc(id).update({
      'name': name,
      'issuer': issuer,
      'year': year,
      'credential': credential,
      'certificateUrl': certificateUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteCertificate(String id) async {
    await certificates.doc(id).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCertificates() {
    return certificates
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots();
  }

  // ============================================================
  // COUNT
  // ============================================================

  Future<int> getProjectCount() async {
    final result = await projects.count().get();
    return result.count ?? 0;
  }

  Future<int> getSkillCount() async {
    final result = await skills.count().get();
    return result.count ?? 0;
  }

  Future<int> getCertificateCount() async {
    final result = await certificates.count().get();
    return result.count ?? 0;
  }
}