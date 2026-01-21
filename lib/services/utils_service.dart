import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ml_projects/services/toast_service.dart';

class DialogAction {
  final String labelKey;
  final Map<String, dynamic> style;
  final dynamic action;

  const DialogAction({
    required this.labelKey,
    this.style = const {},
    required this.action,
  });
}

class UtilsService {
  static Future<dynamic> showAlert({
    required BuildContext context,
    required String titleKey,
    required dynamic content,
    required List<DialogAction> actions,
  }) async {
    return showDialog<dynamic>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titleKey.tr()),
        content: content is String ? Text(content) : content,
        actions: actions.map((action) {
          return TextButton(
            onPressed: () => Navigator.pop(context, action.action),
            style: _buildButtonStyle(action.style),
            child: Text(action.labelKey.tr()),
          );
        }).toList(),
      ),
    );
  }

  static ButtonStyle? _buildButtonStyle(Map<String, dynamic> styleMap) {
    if (styleMap.isEmpty) return null;

    return TextButton.styleFrom(
      foregroundColor: styleMap['foregroundColor'] as Color?,
      backgroundColor: styleMap['backgroundColor'] as Color?,
      padding: styleMap['padding'] as EdgeInsetsGeometry?,
      elevation: styleMap['elevation'] as double?,
      shape: styleMap['shape'] as OutlinedBorder?,
      minimumSize: styleMap['minimumSize'] as Size?,
      maximumSize: styleMap['maximumSize'] as Size?,
      side: styleMap['side'] as BorderSide?,
      textStyle: styleMap['textStyle'] as TextStyle?,
    );
  }

  static void showFilePreview({
    required BuildContext context,
    required File file,
    required String fileType,
  }) {
    if (!file.existsSync()) {
      ToastService.showError('file_not_found'.tr());
      return;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            Center(
              child: _buildPreviewWidget(file, fileType),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildPreviewWidget(File file, String fileType) {
    final lowerType = fileType.toLowerCase();

    if (['jpg', 'jpeg', 'png'].contains(lowerType)) {
      return InteractiveViewer(
        child: Image.file(file),
      );
    }

    if (lowerType == 'mp4') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.play_circle_outline, size: 100, color: Colors.white),
          const SizedBox(height: 20),
          Text(
            'video_message'.tr(),
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              ToastService.showInfo('${'video_file'.tr()}: ${file.path}');
            },
            child: Text('open_system_app'.tr()),
          ),
        ],
      );
    }

    if (lowerType == 'pdf') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.picture_as_pdf, size: 100, color: Colors.white),
          const SizedBox(height: 20),
          Text(
            'pdf_preview'.tr(),
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              ToastService.showInfo('${'pdf_file'.tr()}: ${file.path}');
            },
            child: Text('open_system_app'.tr()),
          ),
        ],
      );
    }

    return Text(
      'not_available'.tr(),
      style: const TextStyle(color: Colors.white),
    );
  }
}
