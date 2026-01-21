import 'package:flutter/material.dart';

class FileTypeConfig {
  final String labelKey;
  final IconData icon;
  final List<String> accept;
  final Color color;

  const FileTypeConfig({
    required this.labelKey,
    required this.icon,
    required this.accept,
    required this.color,
  });
}

class FileTypeConstants {
  static const List<FileTypeConfig> fileTypeConfigs = [
    FileTypeConfig(
      labelKey: 'images',
      icon: Icons.image,
      accept: ['jpg', 'png', 'jpeg'],
      color: Colors.blue,
    ),
    FileTypeConfig(
      labelKey: 'videos',
      icon: Icons.video_library,
      accept: ['mp4'],
      color: Colors.purple,
    ),
    FileTypeConfig(
      labelKey: 'files',
      icon: Icons.picture_as_pdf,
      accept: ['pdf'],
      color: Colors.red,
    ),
  ];

  static const int maxFileSizeBytes = 50 * 1024 * 1024;
}
