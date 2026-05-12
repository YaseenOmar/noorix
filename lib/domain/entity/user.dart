import 'invoice.dart';

class UserEntity{
  final String id;
  final String phoneNumber;
  final String name;
  final String subscriptionId ;
  final List<InvoiceEntity> invoices;
  const UserEntity({required this.id,required this.phoneNumber,required this.name, required this.subscriptionId, required this.invoices});
}