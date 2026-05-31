/// Represents a customer with an electricity meter.
class Customer {
  final int id;
  final String name;
  final String meterNumber;
  final String phoneNumber;
  final String address;

  const Customer({
    required this.id,
    required this.name,
    required this.meterNumber,
    this.phoneNumber = '',
    this.address = '',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Customer && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
