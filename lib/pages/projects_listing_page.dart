import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ml_projects/config/api_endpoints.dart';
import 'package:ml_projects/config/app_config.dart';
import 'package:ml_projects/routing/app_router.dart';
import 'package:ml_projects/services/api_service.dart';
import 'package:ml_projects/services/toast_service.dart';

class ProjectsListingPage extends StatefulWidget {
  const ProjectsListingPage({super.key});

  @override
  State<ProjectsListingPage> createState() => _ProjectsListingPageState();
}

class _ProjectsListingPageState extends State<ProjectsListingPage> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _projectsList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchProjects();
  }

  Future<void> _fetchProjects() async {
    setState(() {
      _isLoading = true;
    });

    try {
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
      
      ToastService.showError(
        e.toString().replaceFirst('Exception: ', ''),
      );

      setState(() {
        _isLoading = false;
      });
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
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _navigateToDetails(project),
            ),
          );
      },
    );
  }
}
