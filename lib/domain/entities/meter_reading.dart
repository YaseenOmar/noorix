/// Represents a single electricity meter reading for a customer.
class MeterReading {
  final int id;
  final int customerId;
  final double value;
  final double previousValue;
  final double consumption;
  final double pricePerKwh;
  final double totalBill;
  final DateTime readingDate;

  const MeterReading({
    required this.id,
    required this.customerId,
    required this.value,
    required this.previousValue,
    required this.consumption,
    required this.pricePerKwh,
    required this.totalBill,
    required this.readingDate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeterReading &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
