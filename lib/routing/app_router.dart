import 'package:flutter/material.dart';
import 'package:ml_projects/pages/projects_listing_page.dart';
import 'package:ml_projects/pages/project_details_page.dart';

class AppRouter {
  // Route names
  static const String projectsListing = '/';
  static const String projectDetails = '/project-details';

  // Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case projectsListing:
        return MaterialPageRoute(
          builder: (_) => const ProjectsListingPage(),
          settings: settings,
        );

      case projectDetails:
        final args = settings.arguments;
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => ProjectDetailsPage(project: args),
            settings: settings,
          );
        }
        // If arguments are invalid, navigate to error page or listing
        return MaterialPageRoute(
          builder: (_) => const ProjectsListingPage(),
          settings: settings,
        );

      default:
        // Unknown route, return to listing page
        return MaterialPageRoute(
          builder: (_) => const ProjectsListingPage(),
          settings: settings,
        );
    }
  }

  // Helper method for programmatic navigation
  static Future<T?> navigateTo<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed<T>(
      context,
      routeName,
      arguments: arguments,
    );
  }

  // Helper method for replacing current route
  static Future<T?> navigateAndReplace<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushReplacementNamed<T, void>(
      context,
      routeName,
      arguments: arguments,
    );
  }

  // Helper method for popping until a specific route
  static void popUntil(BuildContext context, String routeName) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }
}
