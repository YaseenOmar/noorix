import '../../domain/entities/user.dart';
import '../../domain/entities/meter_reading.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/customer_data_source.dart';

/// Concrete repository implementation that delegates to a [CustomerDataSource].
class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerDataSource dataSource;

  const CustomerRepositoryImpl(this.dataSource);

  @override
  Future<List<UserEntity>> getCustomers() {
    return dataSource.getCustomers();
  }

  @override
  Future<void> addCustomer(UserEntity customer) {
    return dataSource.addCustomer(customer);
  }

  @override
  Future<List<MeterReading>> getMeterReadings(int customerId) {
    return dataSource.getMeterReadings(customerId);
  }

  @override
  Future<List<MeterReading>> getAllMeterReadings() {
    return dataSource.getAllMeterReadings();
  }

  @override
  Future<void> addMeterReading(MeterReading reading) {
    return dataSource.addMeterReading(reading);
  }
}
