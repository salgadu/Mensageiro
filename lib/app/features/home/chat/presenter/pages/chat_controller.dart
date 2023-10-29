import 'dart:ffi';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:mensageiro/app/core/store/auth/auth_store.dart';
import 'package:mensageiro/app/features/home/chat/domain/entity/chat.dart';
import 'package:mensageiro/app/features/home/chat/domain/usecases/get_message.dart';
import 'package:mensageiro/app/features/home/chat/domain/usecases/send_chat.dart';
import 'package:mobx/mobx.dart';

part 'chat_controller.g.dart';

class ChatController = ChatControllerBase with _$ChatController;

abstract class ChatControllerBase with Store {
  final IGetMessage getMessage;
  final ISendChat sendMessages;
  final AuthStore _authStore = Modular.get<AuthStore>();

  ChatControllerBase(this.sendMessages, this.getMessage);

  Future sendMessage(String id, Chat message) async {
    //TODO Tratar esse parametro de envio de mensagens
    message.userId = _authStore.user!.phoneNumber;
    final idChat = '$id${_authStore.user!.phoneNumber}';
    var result = await sendMessages(idChat, message);
    result.fold((l) {}, (r) {});
  }

  Stream<List<Chat>> messages(String id) {
    final idChat = '$id${_authStore.user!.phoneNumber}';
    return getMessage(idChat);
  }
}
