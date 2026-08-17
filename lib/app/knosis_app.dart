import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'startup_placeholder.dart';

/// Root widget of the application.
///
/// Owns nothing but wiring: themes, and later the router. Keeping it thin
/// means feature work never has to modify the app root.
class KnosisApp extends StatelessWidget {
  const KnosisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Knosis',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const StartupPlaceholder(),
    );
  }
}
