import 'package:flutter/material.dart';
import '../../../core/constants.dart';

class BeautyButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const BeautyButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null && !isLoading;
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: isDisabled ? const Color(0xFFF0F0F0) : AppColors.negroCarbon,
        borderRadius: AppConstants.pillBorderRadius,
        boxShadow: isDisabled
            ? null
            : [
                BoxShadow(
                  color: AppColors.shadowGlow,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppConstants.pillBorderRadius,
          onTap: isLoading ? null : onPressed,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 1.5,
                    ),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.5,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
