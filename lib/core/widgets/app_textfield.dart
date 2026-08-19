import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_radius.dart';
import '../theme/app_scaling.dart';

enum FieldType { text, number, email, phone, password, multiline }

class AppTextField extends StatelessWidget {
  final String? title;
  final String? hintText;
  final TextEditingController? controller;
  final FieldType fieldType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final bool readOnly;
  final bool? obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLength;
  final int? maxLines;
  final bool isRequired;
  final void Function()? onTap;

  const AppTextField({
    super.key,
    this.title,
    this.hintText,
    this.controller,
    this.fieldType = FieldType.text,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLength,
    this.maxLines,
    this.isRequired = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title!, style: const TextStyle(fontWeight: FontWeight.w500)),
              if (isRequired)
                Text(
                  ' *',
                  style: TextStyle(
                    color: colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppScaling.space4),
        ],

        TextFormField(
          controller: controller,
          validator: validator,
          onChanged: onChanged,
          enabled: enabled,
          readOnly: readOnly,
          keyboardType: _keyboardType,
          obscureText: obscureText ?? fieldType == FieldType.password,
          inputFormatters: _inputFormatters,
          maxLength: maxLength,
          maxLines: fieldType == FieldType.multiline ? (maxLines ?? 5) : 1,
          onTapOutside: (_) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: colorScheme.onPrimaryContainer.withValues(alpha: .3),
            ),
            filled: true,
            isDense: true,
            fillColor: colorScheme.surfaceContainer,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.radius8),
              borderSide: BorderSide(color: colorScheme.surfaceContainer),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.radius8),
              borderSide: BorderSide(
                color: colorScheme.onPrimaryContainer.withValues(alpha: .3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.radius8),
              borderSide: BorderSide(
                color: colorScheme.onPrimaryContainer.withValues(alpha: .3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  TextInputType get _keyboardType {
    switch (fieldType) {
      case FieldType.text:
        return TextInputType.text;

      case FieldType.number:
        return const TextInputType.numberWithOptions(decimal: true);

      case FieldType.email:
        return TextInputType.emailAddress;

      case FieldType.phone:
        return TextInputType.phone;

      case FieldType.password:
        return TextInputType.visiblePassword;

      case FieldType.multiline:
        return TextInputType.multiline;
    }
  }

  List<TextInputFormatter>? get _inputFormatters {
    switch (fieldType) {
      case FieldType.number:
        return [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))];

      case FieldType.phone:
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ];

      case FieldType.email:
        return [FilteringTextInputFormatter.deny(RegExp(r'\s'))];

      default:
        return null;
    }
  }
}
