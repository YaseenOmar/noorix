import '../repositories/settings_repository.dart';

class CompleteOnboarding {
  const CompleteOnboarding(this.repository);

  final SettingsRepository repository;

  Future<void> call() => repository.completeOnboarding();
}
