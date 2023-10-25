import 'package:mensageiro/app/features/home/contact/domain/entity/contact.dart';

abstract class IContactDatasource {
  Future<List<Contact>> getContacts(String uid);
  Future<bool> addContact(Contact contact); 
  Future<bool> deleteContact(Contact contact);
  Future<bool> updateContact(Contact contact);
}
