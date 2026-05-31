import '../entities/meter_reading.dart';
import '../repositories/customer_repository.dart';

/// Retrieves all meter readings for a specific customer.
class GetMeterReadings {
  final CustomerRepository repository;

  const GetMeterReadings(this.repository);

  Future<List<MeterReading>> call(int customerId) {
    return repository.getMeterReadings(customerId);
  }
}
