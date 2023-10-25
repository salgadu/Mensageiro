import 'package:dartz/dartz.dart';
import 'package:mensageiro/app/core/errors/errors.dart';
import 'package:mensageiro/app/features/home/contact/domain/entity/contact.dart';
import 'package:mensageiro/app/features/home/contact/domain/repository/contact_repository.dart';

abstract class IAddContact {
  Future<Either<Failure, bool>> addContact(Contact contact);
}

class AddContactImpl implements IAddContact {
  final IContactRepository repository;
  AddContactImpl(this.repository);
  @override
  Future<Either<Failure, bool>> addContact(Contact contact) {
    return repository.addContact(contact);
  }
}