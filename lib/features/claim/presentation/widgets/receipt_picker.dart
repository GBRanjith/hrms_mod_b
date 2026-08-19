import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/receipt_storage.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_scaling.dart';

class ReceiptPicker extends StatelessWidget {
  const ReceiptPicker({
    super.key,
    required this.onChanged,
    this.file,
    this.fileName,
    this.title = 'Receipt',
    this.helperText =
        'A bill is the proof finance needs before reimbursing you.',
  });

  final File? file;
  final String? fileName;
  final ValueChanged<File?> onChanged;
  final String title;
  final String helperText;

  bool get _hasReceipt =>
      file != null || (fileName != null && fileName!.isNotEmpty);

  Future<void> _pick(BuildContext context, {required bool fromCamera}) async {
    final messenger = ScaffoldMessenger.of(context);
    final source = fromCamera ? 'camera' : 'photos';

    try {
      final picked = await ImagePicker().pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: AppConstants.receiptMaxWidth,
        imageQuality: AppConstants.receiptImageQuality,
      );

      if (picked == null) return;

      onChanged(File(picked.path));
    } on PlatformException catch (e) {
      final isDenied =
          e.code == 'camera_access_denied' || e.code == 'photo_access_denied';

      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              isDenied
                  ? 'Access to $source is off. Enable it in Settings.'
                  : 'Could not open the $source. Please try again.',
            ),
          ),
        );
    } catch (_) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Could not attach the receipt.')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.labelLarge),
        const SizedBox(height: AppScaling.space4),
        Text(
          helperText,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppScaling.space8),

        if (_hasReceipt)
          _buildPreview(context)
        else
          _buildSourceButtons(context),
      ],
    );
  }

  Widget _buildSourceButtons(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppScaling.space16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.radius12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _pick(context, fromCamera: true),
              icon: const Icon(Icons.photo_camera_outlined),
              label: const Text('Camera'),
            ),
          ),
          const SizedBox(width: AppScaling.space12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _pick(context, fromCamera: false),
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('Gallery'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview(BuildContext context) {
    final path = file != null
        ? Future.value(file!.path)
        : ReceiptStorage.resolve(fileName);

    return FutureBuilder<String?>(
      future: path,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final resolved = snapshot.data;

        if (resolved == null) {
          return const Center(child: Text('Preview unavailable'));
        }

        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.radius12),
              child: Image.file(
                File(resolved),
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: AppScaling.space8,
              right: AppScaling.space8,
              child: IconButton(
                onPressed: () => onChanged(null),
                icon: const Icon(Icons.close),
              ),
            ),
          ],
        );
      },
    );
  }
}
