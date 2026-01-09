import 'package:flutter/material.dart';
import 'package:ml_projects/ml_projects.dart';

class PackagePage extends StatelessWidget {
  const PackagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> config = {
      'baseUrl': '',
      'token': '',
      'cookie': '',
      'profileData': {},
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
