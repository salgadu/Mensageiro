import 'package:dartz/dartz.dart';
import 'package:mensageiro/app/core/errors/errors.dart';
import 'package:mensageiro/app/features/home/chat/domain/entity/chat.dart';
import 'package:mensageiro/app/features/home/chat/domain/repository/chat_repository.dart';
import 'package:mensageiro/app/features/home/chat/infra/datasource/i_chat_datasource.dart';

class ChatRepositoryImpl implements IChatRepository {
  final IChatDatasource dataSource;

  ChatRepositoryImpl(this.dataSource);
  
  @override
  Future<Either<Failure, List<Chat>>> getChats(String id) async {
    try {
      final chats = await dataSource.getChats(id);
      return Right(chats);
    }  on Failure catch (e) {
      return Left(e);
    }

  }
  
  @override
  Future<Either<Failure, List<Chat>>> sendChat(String id, Chat chat) async {
    try {
      final chats = await dataSource.sendChat(id, chat);
      return Right(chats);
    }  on Failure catch (e) {
      return Left(e);
    }
  }
}
