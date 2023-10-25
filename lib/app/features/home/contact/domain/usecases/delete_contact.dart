import 'package:dartz/dartz.dart';
import 'package:mensageiro/app/core/errors/errors.dart';
import 'package:mensageiro/app/features/home/contact/domain/entity/contact.dart';
import 'package:mensageiro/app/features/home/contact/domain/repository/contact_repository.dart';

abstract class IDeleteContact {
  Future<Either<Failure, bool>> deleteContact(Contact contact);
}

class DeleteContactImpl implements IDeleteContact {
  final IContactRepository repository;
  DeleteContactImpl(this.repository);
  @override
  Future<Either<Failure, bool>> deleteContact(Contact contact) {
    return repository.deleteContact(contact);
  }
}