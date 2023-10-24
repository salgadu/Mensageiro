import 'package:dartz/dartz.dart';
import 'package:mensageiro/app/core/errors/errors.dart';
import 'package:mensageiro/app/features/home/contact/domain/entity/contact.dart';
import 'package:mensageiro/app/features/home/contact/domain/repository/contact_repository.dart';
import 'package:mensageiro/app/features/home/contact/infra/datasource/i_contact_datasource.dart';

class ContactRepositoryImpl implements IContactRepository {
  final IContactDatasource datasource;
  ContactRepositoryImpl(this.datasource);
  @override
  Future<Either<Failure, List<Contact>>> getContacts(String uid) async {
    try {
      final result = await datasource.getContacts(uid);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
  
  @override
  Future<Either<Failure, bool>> addContact(Contact contact) {
    // TODO: implement addContact
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, bool>> deleteContact(Contact contact) {
    // TODO: implement deleteContact
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, bool>> updateContact(Contact contact) {
    // TODO: implement updateContact
    throw UnimplementedError();
  }
}