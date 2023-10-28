import 'package:dartz/dartz.dart';
import 'package:mensageiro/app/core/errors/errors.dart';
import 'package:mensageiro/app/features/home/chat/domain/entity/chat.dart';
import 'package:mensageiro/app/features/home/chat/infra/repository/chat_repository_impl.dart';

abstract class IGetChats {
  Future<Either<Failure, List<Chat>>> call(String id);
}

class GetChatsImpl implements IGetChats {
  final ChatRepositoryImpl repository;
  GetChatsImpl(this.repository);
  @override
  Future<Either<Failure, List<Chat>>> call(String id) {
    return repository.getChats(id);
  }
}
