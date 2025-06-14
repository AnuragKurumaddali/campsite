import 'package:flutter/material.dart';

class FeatureIcon extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final Color activeColor;

  const FeatureIcon({
    super.key,
    required this.icon,
    required this.isActive,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6), // Slightly larger padding
      decoration: BoxDecoration(
        color: isActive ? activeColor.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? activeColor : Colors.grey,
          width: isActive ? 1.5 : 1,
        ),
      ),
      child: Icon(
        icon,
        size: 18, // Larger icon size
        color: isActive ? activeColor : Colors.grey,
      ),
    );
  }
}