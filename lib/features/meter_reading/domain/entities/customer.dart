/// Represents a customer with an electricity meter.
class Customer {
  final int id;
  final String name;
  final String meterNumber;

  const Customer({
    required this.id,
    required this.name,
    required this.meterNumber,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Customer && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
