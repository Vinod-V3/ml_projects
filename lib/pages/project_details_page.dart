import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ProjectDetailsPage extends StatelessWidget {
  final Map<String, dynamic> project;

  const ProjectDetailsPage({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project['name'] ?? 'project_details'.tr()),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildInfoSection(
              'description'.tr(),
              project['description'] ?? 'No description available',
            ),
            const SizedBox(height: 16),
            _buildMetricsCard(),
            const SizedBox(height: 16),
            _buildAdditionalInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project['name'] ?? 'Untitled Project',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildStatusChip(project['status'] ?? 'Unknown'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildMetricsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Metrics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildMetricRow('Accuracy', project['accuracy'] ?? 'N/A'),
            const Divider(height: 24),
            _buildMetricRow('Model Type', project['modelType'] ?? 'N/A'),
            const Divider(height: 24),
            _buildMetricRow('Dataset Size', project['datasetSize'] ?? 'N/A'),
            const Divider(height: 24),
            _buildMetricRow(
              'Last Updated',
              project['lastUpdated'] ?? 'N/A',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo() {
    final additionalFields = project.entries
        .where((entry) => ![
              'id',
              'name',
              'description',
              'status',
              'accuracy',
              'modelType',
              'datasetSize',
              'lastUpdated'
            ].contains(entry.key))
        .toList();

    if (additionalFields.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Additional Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...additionalFields.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildMetricRow(
                  entry.key,
                  entry.value?.toString() ?? 'N/A',
                ),
              );
            }),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
