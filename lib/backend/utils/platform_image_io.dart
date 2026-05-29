import 'dart:io';

import 'package:flutter/material.dart';

ImageProvider localFileImageProvider(String path) => FileImage(File(path));

Widget localFileImage(
  String path, {
  required BoxFit fit,
  required Alignment alignment,
}) {
  return Image.file(File(path), fit: fit, alignment: alignment);
}

Future<void> deleteLocalFileIfExists(String path) async {
  final file = File(path);
  if (await file.exists()) {
    await file.delete();
  }
}
