import 'package:flutter/material.dart';

class ProjectModuleScreen extends StatelessWidget {
  const ProjectModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Project Module',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
