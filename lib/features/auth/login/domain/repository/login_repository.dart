import 'package:dartz/dartz.dart';
import 'package:mensageiro/core/errors/errors.dart';
import 'package:mensageiro/features/auth/login/domain/entity/logged_user.dart';

abstract class LoginRepository {
  Future<Either<Failure, LoggedUser>> loginWithEmailAndPassword(
      String email, String password);
}
