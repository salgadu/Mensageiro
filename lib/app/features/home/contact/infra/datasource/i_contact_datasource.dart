import 'package:mensageiro/app/features/home/contact/domain/entity/contact.dart';

abstract class IContactDatasource {
  Future<List<Contact>> getContacts(String uid);
}
