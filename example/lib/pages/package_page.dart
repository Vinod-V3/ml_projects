import 'package:flutter/material.dart';
import 'package:ml_projects/ml_projects.dart';

class PackagePage extends StatelessWidget {
  const PackagePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Configuration for the ML Projects package
    final Map<String, dynamic> config = {
      'baseUrl': 'https://api.example.com',
      'projects': [
        {
          'id': '1',
          'name': 'Image Classification Model',
          'description': 'Deep learning model for classifying images into 1000 categories using ResNet architecture',
          'status': 'Active',
          'accuracy': '94.5%',
          'modelType': 'ResNet-50',
          'datasetSize': '1.2M images',
          'lastUpdated': '2025-12-28',
        },
        {
          'id': '2',
          'name': 'Sentiment Analysis Engine',
          'description': 'NLP model for analyzing sentiment in customer reviews and social media posts',
          'status': 'Completed',
          'accuracy': '89.2%',
          'modelType': 'BERT',
          'datasetSize': '500K reviews',
          'lastUpdated': '2025-12-15',
        },
        {
          'id': '3',
          'name': 'Object Detection System',
          'description': 'Real-time object detection system for autonomous vehicles using YOLO',
          'status': 'In Progress',
          'accuracy': '91.8%',
          'modelType': 'YOLOv8',
          'datasetSize': '800K images',
          'lastUpdated': '2025-12-30',
        },
        {
          'id': '4',
          'name': 'Speech Recognition',
          'description': 'Voice-to-text conversion system with multi-language support',
          'status': 'Active',
          'accuracy': '96.3%',
          'modelType': 'Wav2Vec 2.0',
          'datasetSize': '10K hours',
          'lastUpdated': '2025-12-25',
        },
      ],
    };

    return MLProjects(
      config: config,
      title: 'ML Projects',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 43, 123, 208),
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
    );
  }
}
