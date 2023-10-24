import 'package:dartz/dartz.dart';
import 'package:mensageiro/app/core/errors/errors.dart';
import 'package:mensageiro/app/features/home/contact/domain/entity/contact.dart';

abstract class IContactRepository {
  Future<Either<Failure, List<Contact>>> getContacts(String uid);
  Future<Either<Failure, bool>> addContact(Contact contact);
  Future<Either<Failure, bool>> deleteContact(Contact contact);
  Future<Either<Failure, bool>> updateContact(Contact contact);
}