import 'package:flutter/material.dart';

class BeautyAlert extends StatelessWidget {
  final String message;

  const BeautyAlert({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        border: Border(
          left: BorderSide(color: Colors.black87, width: 2),
        ),
      ),
      child: Text(
        message,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
          letterSpacing: 0.3,
          height: 1.5,
        ),
      ),
    );
  }
}
