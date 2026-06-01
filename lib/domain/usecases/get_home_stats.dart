import '../repositories/customer_repository.dart';

class HomeStats {
  final int totalCustomers;
  final int totalReadings;
  final double totalConsumption;
  final double totalRevenue;

  HomeStats({
    required this.totalCustomers,
    required this.totalReadings,
    required this.totalConsumption,
    required this.totalRevenue,
  });
}

class GetHomeStats {
  final CustomerRepository repository;

  GetHomeStats(this.repository);

  Future<HomeStats> call() async {
    final customers = await repository.getCustomers();
    final readings = await repository.getAllMeterReadings();

    double totalConsumption = 0;
    double totalRevenue = 0;

    for (final reading in readings) {
      totalConsumption += reading.consumption;
      totalRevenue += reading.totalBill;
    }

    return HomeStats(
      totalCustomers: customers.length,
      totalReadings: readings.length,
      totalConsumption: totalConsumption,
      totalRevenue: totalRevenue,
    );
  }
}
