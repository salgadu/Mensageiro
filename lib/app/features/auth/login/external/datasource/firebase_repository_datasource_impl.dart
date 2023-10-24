import 'package:firebase_auth/firebase_auth.dart';
import 'package:mensageiro/app/features/auth/login/domain/entity/logged_user.dart';
import 'package:mensageiro/app/features/auth/login/infra/datasource/login_datasource.dart';

class FireBaseRepositoryDataSourceImpl implements ILoginDatasource {
  final FirebaseAuth auth;

  FireBaseRepositoryDataSourceImpl(this.auth);

  @override
  Future<LoggedUser> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    final credentials =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    return LoggedUser(
      email: credentials.user!.email!,
      name: credentials.user!.displayName!,
      uid: credentials.user!.uid,
      phoneNumber: credentials.user!.phoneNumber!,
    );
  }
}
