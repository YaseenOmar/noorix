import '../repositories/settings_repository.dart';

class SetPricePerKwh {
  const SetPricePerKwh(this.repository);

  final SettingsRepository repository;

  Future<void> call(double price) => repository.setPricePerKwh(price);
}
