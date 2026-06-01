import '../entities/user.dart';
import '../entities/meter_reading.dart';

/// Abstract repository contract for customer and meter reading operations.
abstract class CustomerRepository {
  Future<List<UserEntity>> getCustomers();
  Future<void> addCustomer(UserEntity customer);
  Future<List<MeterReading>> getMeterReadings(int customerId);
  Future<List<MeterReading>> getAllMeterReadings();
  Future<void> addMeterReading(MeterReading reading);
}
