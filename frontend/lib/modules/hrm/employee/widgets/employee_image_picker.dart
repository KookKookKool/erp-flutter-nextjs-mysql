import 'dart:io';
import 'package:flutter/material.dart';
import '/theme/sun_theme.dart';

class EmployeeImagePicker extends StatelessWidget {
  final File? image;
  final VoidCallback onPick;
  final String? tooltip;
  const EmployeeImagePicker({
    super.key,
    required this.image,
    required this.onPick,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPick,
      child: Tooltip(
        message: tooltip ?? '',
        child: image != null
            ? CircleAvatar(
                radius: 40,
                backgroundImage: FileImage(image!),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: SunTheme.cardColor,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: SunTheme.onPrimary,
                    ),
                  ),
                ),
              )
            : CircleAvatar(
                radius: 40,
                backgroundColor: SunTheme.primary,
                child: const Icon(
                  Icons.camera_alt,
                  size: 40,
                  color: SunTheme.onPrimary,
                ),
              ),
      ),
    );
  }
}
