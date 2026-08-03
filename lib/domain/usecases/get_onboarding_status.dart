import '../repositories/settings_repository.dart';

class GetOnboardingStatus {
  const GetOnboardingStatus(this.repository);

  final SettingsRepository repository;

  Future<bool> call() => repository.hasSeenOnboarding();
}
