import 'dart:io';
import 'package:flutter/material.dart';

class EmployeeImagePicker extends StatelessWidget {
  final File? image;
  final VoidCallback onPick;
  const EmployeeImagePicker({
    super.key,
    required this.image,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPick,
      child: image != null
          ? CircleAvatar(
              radius: 40,
              backgroundImage: FileImage(image!),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          : CircleAvatar(
              radius: 40,
              child: const Icon(Icons.camera_alt, size: 40, color: Colors.grey),
            ),
    );
  }
}
