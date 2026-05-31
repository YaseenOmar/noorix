import '../../domain/entities/customer.dart';
import '../../domain/entities/meter_reading.dart';

/// Abstract data source contract.
/// Swap this implementation for REST API, Firebase, or local DB later.
abstract class CustomerDataSource {
  Future<List<Customer>> getCustomers();
  Future<List<MeterReading>> getMeterReadings(int customerId);
  Future<void> addMeterReading(MeterReading reading);
}

/// In-memory implementation using Lists.
class CustomerDataSourceImpl implements CustomerDataSource {
  // Mock customers
  final List<Customer> _customers = [
    const Customer(id: 1, name: 'أحمد علي', meterNumber: 'MTR-1001'),
    const Customer(id: 2, name: 'سارة خالد', meterNumber: 'MTR-1002'),
  ];

  // In-memory readings storage
  final List<MeterReading> _readings = [];

  // Auto-incrementing ID for new readings
  int _nextReadingId = 1;

  @override
  Future<List<Customer>> getCustomers() async {
    return List.unmodifiable(_customers);
  }

  @override
  Future<List<MeterReading>> getMeterReadings(int customerId) async {
    return _readings
        .where((r) => r.customerId == customerId)
        .toList()
      ..sort((a, b) => b.readingDate.compareTo(a.readingDate));
  }

  @override
  Future<void> addMeterReading(MeterReading reading) async {
    final newReading = MeterReading(
      id: _nextReadingId++,
      customerId: reading.customerId,
      value: reading.value,
      readingDate: reading.readingDate,
    );
    _readings.add(newReading);
  }
}
