import 'package:flutter/material.dart';
import '../../../core/constants.dart';

class BeautyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  const BeautyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      cursorColor: AppColors.negroCarbon,
      cursorWidth: 1.5,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        color: Colors.black87,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontFamily: 'Poppins',
          color: Colors.black38,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.85),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: AppConstants.pillBorderRadius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppConstants.pillBorderRadius,
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.9),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppConstants.pillBorderRadius,
          borderSide: const BorderSide(
            color: AppColors.negroCarbon,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppConstants.pillBorderRadius,
          borderSide: BorderSide(
            color: Colors.redAccent.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppConstants.pillBorderRadius,
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
