import 'package:flutter/material.dart';
import 'package:talk2partners/core/theme/app_colors.dart';
class PremiumButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isSecondary;
  final IconData? icon;
  final bool isExpanded;
  const PremiumButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isSecondary = false,
    this.icon,
    this.isExpanded = true,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: isExpanded ? double.infinity : null,
      height: 56,
      decoration: BoxDecoration(
        gradient: isSecondary ? null : AppColors.primaryGradient,
        color: isSecondary ? AppColors.surface : null,
        borderRadius: BorderRadius.circular(16),
        border: isSecondary
            ? Border.all(color: AppColors.primary.withOpacity(0.3))
            : null,
        boxShadow: !isSecondary
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
              children: [
                if (icon != null && !isLoading) ...[
                  Icon(
                    icon,
                    color: isSecondary ? AppColors.primary : Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                ],
                if (isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isSecondary ? AppColors.primary : Colors.white,
                      ),
                    ),
                  )
                else
                  Text(
                    text,
                    style: TextStyle(
                      color: isSecondary ? AppColors.primary : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

