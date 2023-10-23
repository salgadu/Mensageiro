import 'package:dartz/dartz.dart';
import 'package:mensageiro/core/errors/errors.dart';
import 'package:mensageiro/features/auth/login/domain/entity/logged_user.dart';
import 'package:mensageiro/features/auth/login/domain/repository/login_repository.dart';

abstract class ILoginWithEmailAndPassword {
  Future<Either<Failure, LoggedUser>> call(String email, String password);
}

class LoginWithEmailAndPassword implements ILoginWithEmailAndPassword {
  final LoginRepository repository;
  LoginWithEmailAndPassword(this.repository);
  @override
  Future<Either<Failure, LoggedUser>> call(String email, String password) {
    if (email.isEmpty) {
      return Future.value(
          Left(ParamtersEmptyError(message: "insira um email válido")));
    } else if (password.isEmpty) {
      return Future.value(
          Left(ParamtersEmptyError(message: "insira uma senha válida")));
    }
    return repository.loginWithEmailAndPassword(email, password);
  }
}
