import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ml_projects/services/database_service.dart';
import 'package:ml_projects/services/toast_service.dart';
import 'package:ml_projects/services/utils_service.dart';
import 'package:ml_projects/constants/constants.dart';

class FileUploadPage extends StatefulWidget {
  const FileUploadPage({super.key});

  @override
  State<FileUploadPage> createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> {
  static const String _tableName = 'uploaded_files';
  
  final DatabaseService _databaseService = DatabaseService.instance;
  List<Map<String, dynamic>> _uploadedFiles = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUploadedFiles();
  }

  Future<void> _loadUploadedFiles() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final files = await _databaseService.getAllData(_tableName);
      setState(() {
        _uploadedFiles = files;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading uploaded files: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickFiles(List<String> allowedExtensions) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        for (var file in result.files) {
          if (file.path != null) {
            if (file.size > FileTypeConstants.maxFileSizeBytes) {
              ToastService.showError('file_limit_exceeded'.tr());
              return;
            }
            await _saveFile(file);
          }
        }
        await _loadUploadedFiles();
        ToastService.showSuccess('Files uploaded successfully');
      }
    } catch (e) {
      debugPrint('Error picking files: $e');
      ToastService.showError('Failed to pick files');
    }
  }

  Future<void> _saveFile(PlatformFile file) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final uploadDir = Directory('${directory.path}/uploads');
      
      if (!await uploadDir.exists()) {
        await uploadDir.create(recursive: true);
      }

      final extension = file.extension ?? 'file';
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '$timestamp.$extension';
      final newPath = '${uploadDir.path}/$fileName';
      final sourceFile = File(file.path!);
      await sourceFile.copy(newPath);

      final fileData = {
        'id': fileName,
        'name': file.name,
        'path': newPath,
        'type': extension,
        'size': file.size,
        'timestamp': timestamp,
      };

      await _databaseService.saveData(
        _tableName,
        fileName,
        json.encode(fileData),
      );

      debugPrint('File saved: $fileName');
    } catch (e) {
      debugPrint('Error saving file: $e');
      throw e;
    }
  }

  Future<void> _deleteFile(Map<String, dynamic> fileData) async {
    final confirmed = await UtilsService.showAlert(
      context: context,
      titleKey: 'delete_file',
      content: 'Are you sure you want to delete "${fileData['name']}"?',
      actions: [
        DialogAction(
          labelKey: 'cancel',
          action: false,
        ),
        DialogAction(
          labelKey: 'delete',
          style: {'foregroundColor': Colors.red},
          action: true,
        ),
      ],
    );

    if (confirmed == true) {
      try {
        await _databaseService.deleteData(_tableName, fileData['id']);
        final file = File(fileData['path']);
        if (await file.exists()) {
          await file.delete();
        }

        await _loadUploadedFiles();
        ToastService.showSuccess('File deleted successfully');
      } catch (e) {
        debugPrint('Error deleting file: $e');
        ToastService.showError('Failed to delete file');
      }
    }
  }

  void _previewFile(Map<String, dynamic> fileData) {
    final filePath = fileData['path'] as String;
    final fileType = fileData['type'] as String;
    final file = File(filePath);

    UtilsService.showFilePreview(
      context: context,
      file: file,
      fileType: fileType,
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _getFileIcon(String type) {
    if (['jpg', 'jpeg', 'png'].contains(type.toLowerCase())) {
      return '🖼️';
    } else if (type.toLowerCase() == 'mp4') {
      return '🎥';
    } else if (type.toLowerCase() == 'pdf') {
      return '📄';
    }
    return '📎';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Upload'),
        elevation: 2,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: FileTypeConstants.fileTypeConfigs.length,
              itemBuilder: (context, index) {
                final config = FileTypeConstants.fileTypeConfigs[index];
                return _buildFileTypeCard(config);
              },
            ),
          ),
          
          const Divider(height: 1),
          
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _uploadedFiles.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No files uploaded yet',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _uploadedFiles.length,
                        itemBuilder: (context, index) {
                          final file = _uploadedFiles[index];
                          return _buildFileItem(file);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileTypeCard(FileTypeConfig config) {
    return InkWell(
      onTap: () => _pickFiles(config.accept),
      child: Card(
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                config.color.withOpacity(0.7),
                config.color,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                config.icon,
                size: 40,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                config.labelKey.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFileItem(Map<String, dynamic> file) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Text(
          _getFileIcon(file['type']),
          style: const TextStyle(fontSize: 30),
        ),
        title: Text(
          file['name'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          _formatFileSize(file['size']),
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteFile(file),
            ),
          ],
        ),
        onTap: () => _previewFile(file),
      ),
    );
  }
}
