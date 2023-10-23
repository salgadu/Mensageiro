import 'package:dartz/dartz.dart';
import 'package:mensageiro/core/errors/errors.dart';
import 'package:mensageiro/features/auth/login/domain/entity/logged_user.dart';
import 'package:mensageiro/features/auth/register/domain/entity/register_auth.dart';

abstract class IRegisterRepository {
  Future<Either<Failure, LoggedUser>> registerWithEmailAndPassword(
      RegisterAuth regoister);
}
