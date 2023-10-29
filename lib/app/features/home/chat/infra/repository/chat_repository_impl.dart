import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:mensageiro/app/core/errors/errors.dart';
import 'package:mensageiro/app/features/home/chat/domain/entity/chat.dart';
import 'package:mensageiro/app/features/home/chat/domain/repository/chat_repository.dart';
import 'package:mensageiro/app/features/home/chat/infra/datasource/i_chat_datasource.dart';

class ChatRepositoryImpl implements IChatRepository {
  final IChatDatasource _dataSource;

  ChatRepositoryImpl(this._dataSource);

  @override
  Stream<List<Chat>> getMessages(String id) {
    final controller = StreamController<List<Chat>>();

    _dataSource.getMessages(id).listen(
      (List<Chat> chats) {
        controller.add(chats);
      },
      onError: (error) {
        controller
            .addError(ServerException(message: "Error fetching chats: $error"));
      },
      onDone: () {
        controller.close();
      },
      cancelOnError: true,
    );
    return controller.stream;
  }

  @override
  Future<Either<Failure, Unit>> sendMessage(String id, Chat chat) async {
    try {
      await _dataSource.sendChat(id, chat);
      return const Right(unit);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
