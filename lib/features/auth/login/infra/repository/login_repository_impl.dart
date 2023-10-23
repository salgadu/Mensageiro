import 'package:dartz/dartz.dart';
import 'package:mensageiro/core/errors/errors.dart';
import 'package:mensageiro/features/auth/login/domain/entity/logged_user.dart';
import 'package:mensageiro/features/auth/login/domain/repository/login_repository.dart';
import 'package:mensageiro/features/auth/login/infra/datasource/login_datasource.dart';

class LoginRepositoryImpl implements LoginRepository {
  final ILoginDatasource datasource;

  LoginRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, LoggedUser>> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      final user = await datasource.loginWithEmailAndPassword(
          email: email, password: password);
      return Right(user);
    } on ServerException {
      return Left(ServerException(message: "Erro no servidor"));
    }
  }
}
