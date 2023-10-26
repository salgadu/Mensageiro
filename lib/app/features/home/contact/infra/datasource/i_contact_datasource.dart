import 'package:mensageiro/app/features/home/contact/domain/entity/contact.dart';

abstract class IContactDatasource {
  Future<List<Contact>> getContacts(String uid);
  Future<bool> addContact(String id, Contact contact);
  Future<bool> deleteContact(
    String id,
  );
  Future<bool> updateContact(String id, Contact contact);
}
