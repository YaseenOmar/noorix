import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/service_locator.dart';
import 'domain/usecases/add_customer.dart';
import 'domain/usecases/add_meter_reading.dart';
import 'domain/usecases/complete_onboarding.dart';
import 'domain/usecases/get_all_meter_readings.dart';
import 'domain/usecases/get_customers.dart';
import 'domain/usecases/get_home_stats.dart';
import 'domain/usecases/get_meter_readings.dart';
import 'domain/usecases/get_onboarding_status.dart';
import 'domain/usecases/get_price_per_kwh.dart';
import 'domain/usecases/set_price_per_kwh.dart';
import 'presentation/cubit/app_cubit.dart';
import 'presentation/cubit/app_state.dart';
import 'presentation/screens/main_screen.dart';
import 'presentation/screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator.instance.init();
  runApp(const NoorixSupportApp());
}

class NoorixSupportApp extends StatelessWidget {
  const NoorixSupportApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locator = ServiceLocator.instance;
    return BlocProvider(
      create: (_) => AppCubit(
        getCustomers: locator.get<GetCustomers>(),
        getAllMeterReadings: locator.get<GetAllMeterReadings>(),
        getMeterReadings: locator.get<GetMeterReadings>(),
        getHomeStats: locator.get<GetHomeStats>(),
        addCustomer: locator.get<AddCustomer>(),
        addMeterReading: locator.get<AddMeterReading>(),
        getPricePerKwh: locator.get<GetPricePerKwh>(),
        setPricePerKwh: locator.get<SetPricePerKwh>(),
        getOnboardingStatus: locator.get<GetOnboardingStatus>(),
        completeOnboarding: locator.get<CompleteOnboarding>(),
      )..initialize(),
      child: MaterialApp(
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

        home: const AppEntry(),
      ),
    );
  }
}

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.hasSeenOnboarding != current.hasSeenOnboarding,
      builder: (context, state) {
        if (state.status == AppStatus.initial ||
            state.status == AppStatus.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state.status == AppStatus.failure) {
          return Scaffold(
            body: Center(
              child: FilledButton(
                onPressed: context.read<AppCubit>().initialize,
                child: const Text('إعادة المحاولة'),
              ),
            ),
          );
        }
        return state.hasSeenOnboarding
            ? const MainScreen()
            : const OnboardingScreen();
      },
    );
  }
}
