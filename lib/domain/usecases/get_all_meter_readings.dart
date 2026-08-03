import '../entities/meter_reading.dart';
import '../repositories/customer_repository.dart';

/// Retrieves every meter reading in the system for admin-wide views.
class GetAllMeterReadings {
  final CustomerRepository repository;

  const GetAllMeterReadings(this.repository);

  Future<List<MeterReading>> call() {
    return repository.getAllMeterReadings();
  }
}
