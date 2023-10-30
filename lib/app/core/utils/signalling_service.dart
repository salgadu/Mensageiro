import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart';

class ServicoSinalizacao {
  Socket? socket;

  ServicoSinalizacao._();
  static final instance = ServicoSinalizacao._();

  void inicializar({required String urlWebSocket, required String idDoChamador}) {
    socket = io(urlWebSocket, {
      "transports": ['websocket'],
      "query": {"idChamador": idDoChamador}
    });

    socket!.onConnect(_aoConectarSocket);
    socket!.onConnectError(_aoErroConexaoSocket);

    socket!.connect();
  }

  void _aoConectarSocket(data) {
    log("Socket conectado!!");
  }

  void _aoErroConexaoSocket(data) {
    log("Erro de Conexão: $data");
  }
}
