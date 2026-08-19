import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract final class ReceiptStorage {
  static Future<String> save(File source, {required String claimId}) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = '$claimId.jpg';

    await source.copy('${directory.path}/$fileName');
    return fileName;
  }

  static Future<String?> resolve(String? fileName) async {
    if (fileName == null || fileName.isEmpty) return null;

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');

    return file.existsSync() ? file.path : null;
  }
}
