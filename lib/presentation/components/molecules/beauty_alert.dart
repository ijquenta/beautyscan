import 'package:flutter/material.dart';
import '../../../core/constants.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: AppConstants.defaultCardRadius,
        border: Border.all(
          color: Colors.redAccent.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1, right: 12),
            child: Icon(
              Icons.info_outline,
              size: 16,
              color: Colors.redAccent.withValues(alpha: 0.7),
            ),
          ),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
                letterSpacing: 0.3,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
