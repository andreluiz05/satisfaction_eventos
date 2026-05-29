import 'package:flutter/material.dart';

ImageProvider? localFileImageProvider(String path) => null;

Widget localFileImage(
  String path, {
  required BoxFit fit,
  required Alignment alignment,
}) {
  return const SizedBox.shrink();
}

Future<void> deleteLocalFileIfExists(String path) async {}
