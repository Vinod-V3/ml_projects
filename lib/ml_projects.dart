import 'package:flutter/material.dart';
import './config/app_config.dart';

class MLProjects extends StatefulWidget {
  final Map<String, dynamic> config;
  const MLProjects({super.key, required this.config});

  @override
  State<MLProjects> createState() => _MLProjectsState();
}

class _MLProjectsState extends State<MLProjects> {
  @override
  void initState() {
    super.initState();
    AppConfig.instance.initialize(widget.config);
  }

  readConfigData(){
    debugPrint('Config Data: ${AppConfig.instance.all}');
  }
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: readConfigData, child: const Text('ML Projects'));
  }
}