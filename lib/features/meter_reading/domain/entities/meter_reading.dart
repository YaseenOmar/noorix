/// Represents a single electricity meter reading for a customer.
class MeterReading {
  final int id;
  final int customerId;
  final double value;
  final DateTime readingDate;

  const MeterReading({
    required this.id,
    required this.customerId,
    required this.value,
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
