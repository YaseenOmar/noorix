import '../entities/customer.dart';
import '../entities/meter_reading.dart';

/// Abstract repository contract for customer and meter reading operations.
abstract class CustomerRepository {
  Future<List<Customer>> getCustomers();
  Future<void> addCustomer(Customer customer);
  Future<List<MeterReading>> getMeterReadings(int customerId);
  Future<void> addMeterReading(MeterReading reading);
}
