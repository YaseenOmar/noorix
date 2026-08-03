import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences sharedPreferences;
  static const String _priceKey = 'electricity_price_per_kwh';
  static const String _onboardingKey = 'has_seen_onboarding';

  SettingsRepositoryImpl(this.sharedPreferences);

  @override
  Future<double> getPricePerKwh() async {
    return sharedPreferences.getDouble(_priceKey) ?? 0.0;
  }

  @override
  Future<void> setPricePerKwh(double price) async {
    await sharedPreferences.setDouble(_priceKey, price);
  }

  @override
  Future<bool> hasSeenOnboarding() async {
    return sharedPreferences.getBool(_onboardingKey) ?? false;
  }

  @override
  Future<void> completeOnboarding() async {
    await sharedPreferences.setBool(_onboardingKey, true);
  }
}
