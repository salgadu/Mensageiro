import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mensageiro/app/core/errors/errors.dart';
import 'package:mensageiro/app/features/home/contact/domain/entity/contact.dart';
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

  @override
  Future<bool> addContact(Contact contact) async { // Aqui é Contact ou CotactModel?
    try {
      final contacts = await firestore.collection('user').doc(contact.id).get();
      final contactList = (contacts.data()?['contacts'] as List?) ?? [];
      contactList.add(contact); // não sei se vai funcionar
      await firestore
          .collection('user')
          .doc(contact.id)
          .update({'contacts': contactList});
      return true;
    } catch (e) {
      throw ServerException(message: 'Falha ao adicionar contato');
    }
  }

  @override
  Future<bool> deleteContact(Contact contact) async {
    try {
      final contacts = await firestore.collection('user').doc(contact.id).get();
      final contatcList = (contacts.data()?['contacts'] as List?) ?? [];
      contatcList.removeWhere((element) => element['id'] == contact.id);
      await firestore
          .collection('user')
          .doc(contact.id)
          .update({'contacts': contatcList});
      return true;
    } catch (e) {
      throw ServerException(message: 'Falha ao deletar contato');
    }
  }

  @override
  Future<bool> updateContact(Contact contact) async {
    try {
      final contacts = await firestore.collection('user').doc(contact.id).get();
      final contatcList = (contacts.data()?['contacts'] as List?) ?? [];
      contatcList.removeWhere((element) => element['id'] == contact.id);
      contatcList.add(contact);
      await firestore
          .collection('user')
          .doc(contact.id)
          .update({'contacts': contatcList});
      return true;
    } catch (e) {
      throw ServerException(message: 'Falha ao atualizar contato');
    }
  }
}
