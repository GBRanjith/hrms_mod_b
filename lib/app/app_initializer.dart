import 'package:flutter/material.dart';
import '../core/storage/database_initializer.dart';
import '../core/storage/preference_service.dart';

abstract final class AppInitializer {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await PreferenceService.initialize();
    await DatabaseInitializer.initialize();
  }
}
