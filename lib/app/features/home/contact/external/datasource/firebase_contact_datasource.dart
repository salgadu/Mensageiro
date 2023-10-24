import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mensageiro/app/features/home/contact/infra/datasource/i_contact_datasource.dart';
import 'package:mensageiro/app/features/home/contact/infra/model/contact_model.dart';

class FirebaseContactDatasource implements IContactDatasource {
  final FirebaseFirestore firestore;

  FirebaseContactDatasource(this.firestore);

  @override
  Future<List<ContactModel>> getContacts(String uid) async {
    final contacts = await firestore.collection(uid).doc('contacts').get();
    return contacts.data()?.map((e) => ContactModel.fromJson(e.data())).toList();
  }
}