import '../entities/customer.dart';
import '../repositories/customer_repository.dart';

/// Retrieves the list of all customers.
class GetCustomers {
  final CustomerRepository repository;

  const GetCustomers(this.repository);

  Future<List<Customer>> call() {
    return repository.getCustomers();
  }
}
