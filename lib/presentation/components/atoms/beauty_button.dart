import 'package:flutter/material.dart';

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
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: onPressed == null && !isLoading 
            ? const Color(0xFFF0F0F0) 
            : Colors.black87, // Solid black, sharp editorial look
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
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
                    text.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: onPressed == null && !isLoading ? Colors.black38 : Colors.white,
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
