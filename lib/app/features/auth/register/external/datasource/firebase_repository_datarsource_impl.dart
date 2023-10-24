import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mensageiro/app/features/auth/login/domain/entity/logged_user.dart';
import 'package:mensageiro/app/features/auth/register/domain/entity/register_auth.dart';
import 'package:mensageiro/app/features/auth/register/infra/datasource/i_auth_register_datasource.dart';

class FireBaseRepositoryDataSource implements IAuthRegisterDatasource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  FireBaseRepositoryDataSource(this.auth, this.firestore);

  @override
  Future<LoggedUser> registerWithEmailAndPassword(
      {required RegisterAuth regoister}) async {
    final credentials = await auth.createUserWithEmailAndPassword(
        email: regoister.email, password: regoister.password);
    await credentials.user!.updateDisplayName(regoister.name);
    await credentials.user!.linkWithPhoneNumber(regoister.phone);
    final user = {
      "name": regoister.name,
      "email": regoister.email,
      "phone": regoister.phone,
      "contacts": [],
    };
    await firestore.collection('users').doc(regoister.phone).set(user);
    return LoggedUser(
      email: credentials.user!.email!,
      name: credentials.user!.displayName!,
      uid: credentials.user!.uid,
      phoneNumber: credentials.user!.phoneNumber!,
    );
  }
}
