import 'package:flutter/material.dart';

import 'client.dart';
import 'screens/case_dashboard_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeClient();
  runApp(const MaatruPathApp());
}

class MaatruPathApp extends StatelessWidget {
  const MaatruPathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MaatruPath — Application Blocker Companion',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      home: const CaseDashboardScreen(),
    );
  }
}
