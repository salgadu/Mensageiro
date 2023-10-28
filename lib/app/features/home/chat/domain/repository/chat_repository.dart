import 'package:dartz/dartz.dart';
import 'package:mensageiro/app/core/errors/errors.dart';
import 'package:mensageiro/app/features/home/chat/domain/entity/chat.dart';

abstract class IChatRepository {
  Future<Either<Failure, List<Chat>>> getChats(String id);
  Future<Either<Failure, List<Chat>>> sendChat(String id, Chat chat);
  // Future<Either<Failure, bool>> deleteChat(String id);
}
