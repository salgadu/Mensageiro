import 'package:mensageiro/features/auth/login/domain/entity/logged_user.dart';
import 'package:mensageiro/features/auth/register/domain/entity/register_auth.dart';

abstract class IAuthRegisterDatasource {
  Future<LoggedUser> registerWithEmailAndPassword(
      {required RegisterAuth regoister});
}