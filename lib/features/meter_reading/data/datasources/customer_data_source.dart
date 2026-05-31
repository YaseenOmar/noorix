import '../../domain/entities/customer.dart';
import '../../domain/entities/meter_reading.dart';

/// Abstract data source contract.
abstract class CustomerDataSource {
  Future<List<Customer>> getCustomers();
  Future<void> addCustomer(Customer customer);
  Future<List<MeterReading>> getMeterReadings(int customerId);
  Future<void> addMeterReading(MeterReading reading);
}

/// In-memory implementation using Lists.
class CustomerDataSourceImpl implements CustomerDataSource {
  // Mock customers
  final List<Customer> _customers = [
    const Customer(
      id: 1,
      name: 'أحمد علي',
      meterNumber: 'MTR-1001',
      phoneNumber: '0599123456',
      address: 'شارع الجلاء، غزة',
    ),
    const Customer(
      id: 2,
      name: 'سارة خالد',
      meterNumber: 'MTR-1002',
      phoneNumber: '0598765432',
      address: 'حي الرمال، غزة',
    ),
  ];

  // In-memory readings storage
  final List<MeterReading> _readings = [];

  // Auto-incrementing IDs
  int _nextCustomerId = 3;
  int _nextReadingId = 1;

  @override
  Future<List<Customer>> getCustomers() async {
    return List.unmodifiable(_customers);
  }

  @override
  Future<void> addCustomer(Customer customer) async {
    final newCustomer = Customer(
      id: _nextCustomerId++,
      name: customer.name,
      meterNumber: customer.meterNumber,
      phoneNumber: customer.phoneNumber,
      address: customer.address,
    );
    _customers.add(newCustomer);
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
      previousValue: reading.previousValue,
      consumption: reading.consumption,
      pricePerKwh: reading.pricePerKwh,
      totalBill: reading.totalBill,
      readingDate: reading.readingDate,
    );
    _readings.add(newReading);
  }
}
