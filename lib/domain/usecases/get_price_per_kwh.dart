import '../repositories/settings_repository.dart';

class GetPricePerKwh {
  const GetPricePerKwh(this.repository);

  final SettingsRepository repository;

  Future<double> call() => repository.getPricePerKwh();
}
