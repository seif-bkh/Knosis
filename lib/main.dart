import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/knosis_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Draw behind the status and navigation bars. Screens are responsible for
  // honouring the resulting insets (AGENTS.md section 8), which is why every
  // surface wraps its content in SafeArea or reads MediaQuery padding.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(const ProviderScope(child: KnosisApp()));
}
