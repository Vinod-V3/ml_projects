import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ml_projects/config/app_config.dart';
import 'package:ml_projects/routing/app_router.dart';

class ProjectsListingPage extends StatefulWidget {
  const ProjectsListingPage({super.key});

  @override
  State<ProjectsListingPage> createState() => _ProjectsListingPageState();
}

class _ProjectsListingPageState extends State<ProjectsListingPage> {
  List<Map<String, dynamic>> _projects = [];

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  void _loadProjects() {
    // Load projects from AppConfig or use sample data
    final configProjects = AppConfig.instance.get('projects');
    if (configProjects != null && configProjects is List) {
      _projects = List<Map<String, dynamic>>.from(
        configProjects.map((p) => Map<String, dynamic>.from(p)),
      );
    } else {
      // Sample data for demonstration
      _projects = [
        {
          'id': '1',
          'name': 'Image Classification',
          'description': 'Deep learning model for image classification',
          'status': 'Active',
          'accuracy': '94.5%',
        },
        {
          'id': '2',
          'name': 'Sentiment Analysis',
          'description': 'NLP model for sentiment analysis',
          'status': 'Completed',
          'accuracy': '89.2%',
        },
        {
          'id': '3',
          'name': 'Object Detection',
          'description': 'Real-time object detection system',
          'status': 'In Progress',
          'accuracy': '91.8%',
        },
      ];
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
        title: Text('ml_projects'.tr()),
        elevation: 2,
      ),
      body: _projects.isEmpty
          ? Center(
              child: Text('no_projects_found'.tr()),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _projects.length,
              itemBuilder: (context, index) {
                final project = _projects[index];
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
                        Text(project['description'] ?? ''),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildStatusChip(project['status'] ?? 'Unknown'),
                            const SizedBox(width: 8),
                            Text(
                              'Accuracy: ${project['accuracy'] ?? 'N/A'}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _navigateToDetails(project),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'active':
        color = Colors.green;
        break;
      case 'completed':
        color = Colors.blue;
        break;
      case 'in progress':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
