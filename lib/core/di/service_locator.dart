import '../../features/meter_reading/data/datasources/customer_data_source.dart';
import '../../features/meter_reading/data/repositories/customer_repository_impl.dart';
import '../../features/meter_reading/domain/repositories/customer_repository.dart';
import '../../features/meter_reading/domain/usecases/add_meter_reading.dart';
import '../../features/meter_reading/domain/usecases/get_customers.dart';
import '../../features/meter_reading/domain/usecases/get_meter_readings.dart';

/// Simple service locator for dependency injection.
/// Registers all dependencies as singletons.
class ServiceLocator {
  ServiceLocator._();

  static final ServiceLocator _instance = ServiceLocator._();
  static ServiceLocator get instance => _instance;

  final Map<Type, dynamic> _services = {};

  /// Initialize and register all dependencies.
  void init() {
    // Data sources
    final dataSource = CustomerDataSourceImpl();
    _register<CustomerDataSource>(dataSource);

    // Repositories
    final repository = CustomerRepositoryImpl(dataSource);
    _register<CustomerRepository>(repository);

    // Use cases
    _register<GetCustomers>(GetCustomers(repository));
    _register<GetMeterReadings>(GetMeterReadings(repository));
    _register<AddMeterReading>(AddMeterReading(repository));
  }

  void _register<T>(T service) {
    _services[T] = service;
  }

  /// Retrieve a registered service by type.
  T get<T>() {
    final service = _services[T];
    if (service == null) {
      throw Exception('Service ${T.toString()} not registered in ServiceLocator');
    }
    return service as T;
  }
}
