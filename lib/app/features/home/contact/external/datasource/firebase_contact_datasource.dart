import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mensageiro/app/core/errors/errors.dart';
import 'package:mensageiro/app/features/home/contact/infra/datasource/i_contact_datasource.dart';
import 'package:mensageiro/app/features/home/contact/infra/model/contact_model.dart';

class FirebaseContactDatasource implements IContactDatasource {
  final FirebaseFirestore firestore;

  FirebaseContactDatasource(this.firestore);

  @override
  Future<List<ContactModel>> getContacts(String uid) async {
    try {
      final contacts = await firestore.collection('user').doc(uid).get();
      final contatcList = (contacts.data()?['contacts'] as List?) ?? [];
      return contatcList.map((e) => ContactModel.fromJson(e.data())).toList();
    } catch (e) {
      throw ServerException(message: 'Falha ao buscar contatos');
    }
  }
}
