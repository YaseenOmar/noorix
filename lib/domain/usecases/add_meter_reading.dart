import '../entities/meter_reading.dart';
import '../repositories/customer_repository.dart';

/// Adds a new meter reading for a customer.
class AddMeterReading {
  final CustomerRepository repository;

  const AddMeterReading(this.repository);

  Future<void> call(MeterReading reading) {
    return repository.addMeterReading(reading);
  }
}
