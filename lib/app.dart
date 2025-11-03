import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/tasks/screens/task_list_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'routes/route_generator.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';

class StudyTrackerApp extends StatefulWidget {
  const StudyTrackerApp({super.key});

  @override
  State<StudyTrackerApp> createState() => _StudyTrackerAppState();
}

class _StudyTrackerAppState extends State<StudyTrackerApp> {
  @override
  void initState() {
    super.initState();
    // Check auth status SETELAH build selesai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      localizationsDelegates: [
        ...FlutterQuillLocalizations.localizationsDelegates,
      ],
      supportedLocales: FlutterQuillLocalizations.supportedLocales,

      // Consumer untuk subscribe provider changes
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // Show loading berdasarkan isLoading flag
          if (authProvider.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Navigasi berdasarkan status autentikasi
          if (authProvider.isAuthenticated) {
            return const TaskListScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
