/// Represents a customer with an electricity meter.
class UserEntity {
  final int id;
  final String name;
  final String meterNumber;
  final String phoneNumber;
  final String address;

  const UserEntity({
    required this.id,
    required this.name,
    required this.meterNumber,
    this.phoneNumber = '',
    this.address = '',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
