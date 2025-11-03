import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_tracker/app.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/tasks/providers/task_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: const StudyTrackerApp(),
    ),
  );
}
