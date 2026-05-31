import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/di/service_locator.dart';
import 'features/meter_reading/presentation/screens/customers_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ServiceLocator.instance.init();
  runApp(const NoorixSupportApp());
}

class NoorixSupportApp extends StatelessWidget {
  const NoorixSupportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noorix Support',
      debugShowCheckedModeBanner: false,

      // Material 3 dark theme with teal accent
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00897B),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
      ),

      // Arabic localization
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: const CustomersScreen(),
    );
  }
}
