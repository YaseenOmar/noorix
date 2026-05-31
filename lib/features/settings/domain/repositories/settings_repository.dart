abstract class SettingsRepository {
  Future<double> getPricePerKwh();
  Future<void> setPricePerKwh(double price);
}
