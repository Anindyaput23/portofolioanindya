import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  static const String cloudName = 'i0bxcqe2';
  static const String uploadPreset = 'portofolio_projects';

  static const String _uploadUrl =
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

  Future<String> uploadImage(XFile image) async {
    final bytes = await image.readAsBytes();

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(_uploadUrl),
    );

    request.fields['upload_preset'] = uploadPreset;

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: image.name,
      ),
    );

    final response = await request.send();

    final responseBody =
        await response.stream.bytesToString();

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        'Upload Cloudinary gagal: '
        '${response.statusCode} $responseBody',
      );
    }

    final Map<String, dynamic> data =
        jsonDecode(responseBody);

    final String? secureUrl =
        data['secure_url']?.toString();

    if (secureUrl == null ||
        secureUrl.isEmpty) {
      throw Exception(
        'Cloudinary tidak mengembalikan secure_url.',
      );
    }

    return secureUrl;
  }
}