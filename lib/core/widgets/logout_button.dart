import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hrms_mod_b/app/router/route_names.dart';
import '../storage/database_initializer.dart';
import '../storage/preference_service.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.logout),
      tooltip: 'Logout',
      onPressed: () => showLogoutConfirmation(context),
    );
  }

  static Future<void> showLogoutConfirmation(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to logout ?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () async {
                Navigator.of(context).pop();
                await performLogout(context);
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> performLogout(BuildContext context) async {
    try {
      PreferenceService.clearSession();
      DatabaseInitializer.clearAllData();
      if (context.mounted) {
        context.goNamed(RouteNames.login);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Logout failed"),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
