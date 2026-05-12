class InvoiceEntity{
  final String id;
  final double previousReading;
  final double currentReading;
  final bool isPaid;
  final String  userId;
  const InvoiceEntity(

  {
    required this.id,
    required this.previousReading,
    required this.currentReading,
    required this.isPaid,
    required this.userId,

}
      );
}