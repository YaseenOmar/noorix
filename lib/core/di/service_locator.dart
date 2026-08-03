import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/customer_data_source.dart';
import '../../data/repositories/customer_repository_impl.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/repositories/customer_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/add_customer.dart';
import '../../domain/usecases/add_meter_reading.dart';
import '../../domain/usecases/get_all_meter_readings.dart';
import '../../domain/usecases/get_customers.dart';
import '../../domain/usecases/get_home_stats.dart';
import '../../domain/usecases/get_meter_readings.dart';
import '../../domain/usecases/complete_onboarding.dart';
import '../../domain/usecases/get_onboarding_status.dart';
import '../../domain/usecases/get_price_per_kwh.dart';
import '../../domain/usecases/set_price_per_kwh.dart';

/// Simple service locator for dependency injection.
/// Registers all dependencies as singletons.
class ServiceLocator {
  ServiceLocator._();

  static final ServiceLocator _instance = ServiceLocator._();
  static ServiceLocator get instance => _instance;

  final Map<Type, dynamic> _services = {};

  /// Initialize and register all dependencies.
  Future<void> init() async {
    // Shared Preferences
    final sharedPreferences = await SharedPreferences.getInstance();
    _register<SharedPreferences>(sharedPreferences);

    // Data sources
    final dataSource = CustomerDataSourceImpl();
    _register<CustomerDataSource>(dataSource);

    // Repositories
    final repository = CustomerRepositoryImpl(dataSource);
    _register<CustomerRepository>(repository);

    final settingsRepository = SettingsRepositoryImpl(sharedPreferences);
    _register<SettingsRepository>(settingsRepository);

    // Use cases
    _register<GetCustomers>(GetCustomers(repository));
    _register<GetMeterReadings>(GetMeterReadings(repository));
    _register<GetAllMeterReadings>(GetAllMeterReadings(repository));
    _register<AddMeterReading>(AddMeterReading(repository));
    _register<AddCustomer>(AddCustomer(repository));
    _register<GetHomeStats>(GetHomeStats(repository));
    _register<GetPricePerKwh>(GetPricePerKwh(settingsRepository));
    _register<SetPricePerKwh>(SetPricePerKwh(settingsRepository));
    _register<GetOnboardingStatus>(GetOnboardingStatus(settingsRepository));
    _register<CompleteOnboarding>(CompleteOnboarding(settingsRepository));
  }

  void _register<T>(T service) {
    _services[T] = service;
  }

  /// Retrieve a registered service by type.
  T get<T>() {
    final service = _services[T];
    if (service == null) {
      throw Exception(
        'Service ${T.toString()} not registered in ServiceLocator',
      );
    }
    return service as T;
  }
}
