import '../entities/user.dart';
import '../repositories/customer_repository.dart';

class AddCustomer {
  final CustomerRepository repository;

  AddCustomer(this.repository);

  Future<void> call(UserEntity customer) {
    return repository.addCustomer(customer);
  }
}
