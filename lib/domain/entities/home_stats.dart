class HomeStats {
  const HomeStats({
    required this.totalCustomers,
    required this.totalReadings,
    required this.totalConsumption,
    required this.totalRevenue,
  });

  final int totalCustomers;
  final int totalReadings;
  final double totalConsumption;
  final double totalRevenue;
}
