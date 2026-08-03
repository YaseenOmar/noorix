import '../../domain/entities/user.dart';
import '../../domain/entities/meter_reading.dart';

/// Abstract data source contract.
abstract class CustomerDataSource {
  Future<List<UserEntity>> getCustomers();
  Future<void> addCustomer(UserEntity customer);
  Future<List<MeterReading>> getMeterReadings(int customerId);
  Future<List<MeterReading>> getAllMeterReadings();
  Future<void> addMeterReading(MeterReading reading);
}

/// In-memory implementation using Lists.
class CustomerDataSourceImpl implements CustomerDataSource {
  // Mock customers
  final List<UserEntity> _customers = [
    const UserEntity(
      id: 1,
      name: 'أحمد علي',
      meterNumber: 'MTR-1001',
      phoneNumber: '0599123456',
      address: 'شارع الجلاء، غزة',
    ),
    const UserEntity(
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
  Future<List<UserEntity>> getCustomers() async {
    return List.unmodifiable(_customers);
  }

  @override
  Future<void> addCustomer(UserEntity customer) async {
    final newCustomer = UserEntity(
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
    return _readings.where((r) => r.customerId == customerId).toList()
      ..sort((a, b) => b.readingDate.compareTo(a.readingDate));
  }

  @override
  Future<List<MeterReading>> getAllMeterReadings() async {
    return List.unmodifiable(_readings);
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
