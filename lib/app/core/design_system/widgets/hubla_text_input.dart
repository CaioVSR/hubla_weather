import 'package:flutter/material.dart';
import 'package:hubla_weather/app/core/extensions/hubla_color_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_shape_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_spacing_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_text_style_extension.dart';

/// A themed text input field that uses Hubla design system tokens.
///
/// Supports label, hint, prefix/suffix icons, obscure text,
/// error text, keyboard type, and controller.
class HublaTextInput extends StatelessWidget {
  const HublaTextInput({
    required this.label,
    super.key,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.errorText,
    this.keyboardType,
    this.onChanged,
    this.controller,
    this.enabled = true,
    this.autocorrect = true,
    this.textInputAction,
  });

  final String label;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? errorText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final bool enabled;
  final bool autocorrect;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.hublaColors;
    final textStyles = context.hublaTextStyles;
    final shape = context.hublaShape;
    final spacing = context.hublaSpacing;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      enabled: enabled,
      autocorrect: autocorrect,
      textInputAction: textInputAction,
      style: textStyles.bodyLarge.copyWith(color: colors.onSurface),
      cursorColor: colors.sky,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelStyle: textStyles.bodyLarge.copyWith(color: colors.onSurfaceVariant),
        hintStyle: textStyles.bodyLarge.copyWith(color: colors.gray40),
        errorStyle: textStyles.bodySmall.copyWith(color: colors.danger),
        contentPadding: EdgeInsets.symmetric(horizontal: spacing.md, vertical: spacing.sm),
        filled: true,
        fillColor: colors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(shape.medium),
          borderSide: BorderSide(color: colors.gray20),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(shape.medium),
          borderSide: BorderSide(color: colors.gray20),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(shape.medium),
          borderSide: BorderSide(color: colors.sky, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(shape.medium),
          borderSide: BorderSide(color: colors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(shape.medium),
          borderSide: BorderSide(color: colors.danger, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(shape.medium),
          borderSide: BorderSide(color: colors.gray10),
        ),
      ),
    );
  }
}
