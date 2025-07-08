import 'package:flutter/material.dart';

/// Utility class for safe navigation that prevents common navigation issues
class NavigationUtils {
  /// Safely navigate to a route, preventing multiple navigation calls
  static Future<T?> safeNavigate<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    bool replacement = false,
  }) async {
    if (!context.mounted) return null;

    // Check if we're already navigating
    final route = ModalRoute.of(context);
    if (route?.isActive != true) return null;

    try {
      if (replacement) {
        return await Navigator.of(
          context,
        ).pushReplacementNamed<T, Object?>(routeName, arguments: arguments);
      } else {
        return await Navigator.of(
          context,
        ).pushNamed<T>(routeName, arguments: arguments);
      }
    } catch (e) {
      debugPrint('[NavigationUtils] Navigation error: $e');
      return null;
    }
  }

  /// Safely pop the current route
  static bool safePop(BuildContext context, [Object? result]) {
    if (!context.mounted) return false;

    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop(result);
      return true;
    }
    return false;
  }

  /// Check if current route is the one specified
  static bool isCurrentRoute(BuildContext context, String routeName) {
    if (!context.mounted) return false;

    final route = ModalRoute.of(context);
    return route?.settings.name == routeName;
  }

  /// Close drawer safely without causing state issues
  static void safeCloseDrawer(BuildContext context) {
    if (!context.mounted) return;

    final scaffoldState = Scaffold.maybeOf(context);
    if (scaffoldState?.isDrawerOpen == true) {
      Navigator.of(context).maybePop();
    }
  }
}
