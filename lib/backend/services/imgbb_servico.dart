import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ImgbbUploadResultado {
  final String url;
  final String? deleteUrl;

  const ImgbbUploadResultado({required this.url, this.deleteUrl});
}

class ImgbbServico {
  static const String _apiKey = 'bdcd029681b7e79ece039f67493d115d';

  static Future<ImgbbUploadResultado?> uploadImageBytes(
    Uint8List imageBytes,
  ) async {
    try {
      final String base64Image = base64Encode(imageBytes);

      final url = Uri.parse('https://api.imgbb.com/1/upload');
      final response = await http.post(
        url,
        body: {
          'key': _apiKey,
          'image': base64Image,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final imageData = data['data'] as Map<String, dynamic>;
        return ImgbbUploadResultado(
          url: imageData['url'] as String,
          deleteUrl: imageData['delete_url'] as String?,
        );
      }

      debugPrint('Erro no ImgBB: ${response.body}');
      return null;
    } catch (e) {
      debugPrint('Erro ao fazer upload da imagem: $e');
      return null;
    }
  }

  static Future<void> deleteImage(String? deleteUrl) async {
    if (deleteUrl == null || deleteUrl.isEmpty) return;

    try {
      final response = await http.get(Uri.parse(deleteUrl));
      if (response.statusCode < 200 || response.statusCode >= 400) {
        debugPrint('Erro ao deletar imagem no ImgBB: ${response.body}');
      }
    } catch (e) {
      debugPrint('Erro ao deletar imagem no ImgBB: $e');
    }
  }
}
