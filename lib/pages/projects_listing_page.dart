import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ml_projects/config/api_endpoints.dart';
import 'package:ml_projects/config/app_config.dart';
import 'package:ml_projects/routing/app_router.dart';
import 'package:ml_projects/services/api_service.dart';
import 'package:ml_projects/services/toast_service.dart';
import 'package:ml_projects/services/database_service.dart';
import 'package:ml_projects/services/connectivity_service.dart';

class ProjectsListingPage extends StatefulWidget {
  const ProjectsListingPage({super.key});

  @override
  State<ProjectsListingPage> createState() => _ProjectsListingPageState();
}

class _ProjectsListingPageState extends State<ProjectsListingPage> {
  static const String _tableName = 'projects';
  
  final ApiService _apiService = ApiService();
  final DatabaseService _databaseService = DatabaseService.instance;
  final ConnectivityService _connectivityService = ConnectivityService.instance;
  
  List<Map<String, dynamic>> _projectsList = [];
  Map<String, bool> _downloadedProjects = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDownloadedStatus();
    _fetchProjects();
  }

  Future<void> _loadDownloadedStatus() async {
    try {
      final downloadedData = await _databaseService.getAllData(_tableName);
      setState(() {
        _downloadedProjects = {
          for (var project in downloadedData)
            project['id']?.toString() ?? project['_id']?.toString() ?? '': true
        };
      });
    } catch (e) {
      debugPrint('Error loading downloaded status: $e');
    }
  }

  Future<void> _fetchProjects() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (!_connectivityService.isOnline) {
        final offlineProjects = await _databaseService.getAllData(_tableName);
        setState(() {
          _projectsList = offlineProjects;
          _isLoading = false;
        });
        return;
      }

      final profileData = AppConfig.instance.profileData;
      if (profileData == null) {
        throw Exception('Profile data not configured');
      }

      final response = await _apiService.post(
        ApiEndpoints.targetedSolutionsList,
        data: profileData,
        queryParameters: {
          'type': 'improvementProject',
          'page': 1,
          'limit': 10,
          'search': '',
        },
      );

      if (response != null && response is Map<String, dynamic>) {
        final result = response['result'];
        if (result != null && result is Map<String, dynamic>) {
          final data = result['data'];
          if (data != null && data is List) {
            setState(() {
              _projectsList = data.map((item) => item as Map<String, dynamic>).toList();
              _isLoading = false;
            });
            return;
          }
        }
      }

      throw Exception('Invalid response format');
    } catch (e) {
      debugPrint('Error fetching projects: $e');
      try {
        final offlineProjects = await _databaseService.getAllData(_tableName);
        if (offlineProjects.isNotEmpty) {
          setState(() {
            _projectsList = offlineProjects;
            _isLoading = false;
          });
          ToastService.showError('Failed to fetch latest data. Showing offline data.');
          return;
        }
      } catch (dbError) {
        debugPrint('Error loading from database: $dbError');
      }
      
      ToastService.showError(
        e.toString().replaceFirst('Exception: ', ''),
      );

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _downloadProject(Map<String, dynamic> project) async {
    try {
      final id = project['id']?.toString() ?? project['_id']?.toString();
      
      if (id == null || id.isEmpty) {
        ToastService.showError('Project ID not found');
        return;
      }

      if (_downloadedProjects[id] == true) {
        ToastService.showInfo('Project already downloaded');
        return;
      }

      final jsonString = json.encode(project);

      await _databaseService.saveData(_tableName, id, jsonString);

      setState(() {
        _downloadedProjects[id] = true;
      });

      ToastService.showSuccess('Project downloaded successfully');
    } catch (e) {
      debugPrint('Error downloading project: $e');
      ToastService.showError('Failed to download project');
    }
  }

  void _navigateToDetails(Map<String, dynamic> project) {
    Navigator.pushNamed(
      context,
      AppRouter.projectDetails,
      arguments: project,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        title: Text('projects'.tr()),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.fileUpload);
            },
            tooltip: 'File Upload',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_projectsList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'no_projects_found'.tr(),
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
        itemCount: _projectsList.length,
        itemBuilder: (context, index) {
          final project = _projectsList[index];
          final projectId = project['id']?.toString() ?? project['_id']?.toString() ?? '';
          final isDownloaded = _downloadedProjects[projectId] == true;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                project['name'] ?? 'Untitled Project',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(project['description'] ?? '')
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      isDownloaded ? Icons.download_done : Icons.download,
                      color: isDownloaded ? Colors.green : null,
                    ),
                    onPressed: () => _downloadProject(project),
                    tooltip: isDownloaded ? 'Downloaded' : 'Download',
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              onTap: () => _navigateToDetails(project),
            ),
          );
      },
    );
  }
}
