import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:mensageiro/app/core/errors/errors.dart';
import 'package:mensageiro/app/features/home/chat/domain/entity/chat.dart';

abstract class IChatRepository {
  Stream<List<Chat>> getMessages(String id);
  Future<Either<Failure, Unit>> sendMessage(String id, Chat chat);
  Future<Either<Failure, Unit>> sendAudio(
      String id, Chat chat, Uint8List audio);
}
