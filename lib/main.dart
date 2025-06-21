import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_module.dart';
import 'app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  await SharedPreferences.getInstance();

  await Supabase.initialize(
    url: 'https://rfqoyhebyozwtqwlrhyx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJmcW95aGVieW96d3Rxd2xyaHl4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg0NDAwMjMsImV4cCI6MjA2NDAxNjAyM30.7GXf3tVYUzj1nJnUa--e0DYR5pUd__ifbilL-_vPnk4',
  );

  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}
