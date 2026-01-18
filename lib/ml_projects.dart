export 'package:ml_projects/config/app_config.dart';
export 'package:ml_projects/routing/app_router.dart';
export 'package:ml_projects/pages/projects_listing_page.dart';
export 'package:ml_projects/pages/project_details_page.dart';
import 'package:flutter/material.dart';
import 'package:ml_projects/config/app_config.dart';
import 'package:ml_projects/routing/app_router.dart';
import 'package:ml_projects/services/database_service.dart';
import 'package:ml_projects/services/connectivity_service.dart';
import 'package:easy_localization/easy_localization.dart';

class MLProjects extends StatefulWidget {
  final Map<String, dynamic> config;
  final String? title;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeMode? themeMode;
  
  const MLProjects({
    super.key,
    required this.config,
    this.title,
    this.theme,
    this.darkTheme,
    this.themeMode,
  });

  @override
  State<MLProjects> createState() => _MLProjectsState();
}

class _MLProjectsState extends State<MLProjects> {
  @override
  void initState() {
    super.initState();
    AppConfig.instance.initialize(widget.config);
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    final databaseName = AppConfig.instance.databaseName;
    if (databaseName != null && databaseName.isNotEmpty) {
      await DatabaseService.instance.initialize(dbName: databaseName);
    }
    await ConnectivityService.instance.initialize();
  }

  @override
  void dispose() {
    ConnectivityService.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title ?? 'ML Projects',
      theme: widget.theme ?? ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      darkTheme: widget.darkTheme,
      themeMode: widget.themeMode ?? ThemeMode.system,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      initialRoute: AppRouter.projectsListing,
      onGenerateRoute: AppRouter.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}