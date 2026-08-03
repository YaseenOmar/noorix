abstract class SettingsRepository {
  Future<double> getPricePerKwh();
  Future<void> setPricePerKwh(double price);
  Future<bool> hasSeenOnboarding();
  Future<void> completeOnboarding();
}
