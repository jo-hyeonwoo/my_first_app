import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  await dotenv.load(fileName: ".env");

  // Initialize Sentry for error monitoring
  final sentryDsn = dotenv.env['SENTRY_DSN'];
  
  await SentryFlutter.init(
    (options) {
      options.dsn = sentryDsn;
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring
      // In production, use a lower value (e.g., 0.1) to reduce overhead
      options.tracesSampleRate = 1.0;
      // Enable debug mode in development (set to false in production)
      options.debug = false;
    },
    appRunner: () async {
      // Initialize Supabase
      await Supabase.initialize(
        url: dotenv.env['SUPABASE_URL'] ?? '',
        anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
      );

      // Initialize locale data used by DateFormat
      await initializeDateFormatting('ko_KR');

      runApp(const ProviderScope(child: MyApp()));
    },
  );
}
