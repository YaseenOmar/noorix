import '../repositories/customer_repository.dart';
import '../entities/home_stats.dart';

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
