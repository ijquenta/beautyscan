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
      cursorColor: Colors.black87,
      cursorWidth: 1,
      style: const TextStyle(
        fontFamily: 'PlayfairDisplay', // Or Inter, but Playfair gives luxury
        fontSize: 18,
        color: Colors.black87,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontFamily: 'Inter',
          color: Colors.black38,
          fontSize: 14,
          fontWeight: FontWeight.w300,
        ),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 0,
          vertical: 16,
        ),
        suffixIcon: suffixIcon,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.1), width: 1),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.1), width: 1),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black87, width: 1),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent.withValues(alpha: 0.5), width: 1),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent, width: 1),
        ),
      ),
    );
  }
}
