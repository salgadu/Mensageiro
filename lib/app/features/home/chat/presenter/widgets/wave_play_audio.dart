import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:mensageiro/app/features/home/chat/domain/entity/chat.dart';
import 'package:path_provider/path_provider.dart';

class WavePlayAudio extends StatefulWidget {
  final Chat message;
  const WavePlayAudio({super.key, required this.message});

  @override
  State<WavePlayAudio> createState() => _WavePlayAudioState();
}

class _WavePlayAudioState extends State<WavePlayAudio> {
  late PlayerController playerController;
  bool isPlay = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playerController = PlayerController();
    checkIfFileExists(widget.message.timestamp).then((value) {
      if (!value) {
        downloadAndSaveAudio(widget.message.message).then((value) {});
      }
    });
    preparePlay(widget.message.timestamp);
    playerController.onCompletion.listen((_) {
      setState(() {
        isPlay = false;
      });
    });
  }

  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }

  Future<bool> checkIfFileExists(String fileName) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDir.path}/$fileName.aac';

    File file = File(filePath);
    return await file.exists();
  }

  Future<void> downloadAndSaveAudio(String url) async {
    Dio dio = Dio();
    try {
      // Faz a solicitação HTTP para obter o conteúdo do áudio
      Response response = await dio.get(url,
          options: Options(responseType: ResponseType.bytes));

      // Obtém o diretório de armazenamento local
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath = '${appDocDir.path}/${widget.message.timestamp}.aac';

      // Salva o conteúdo do áudio localmente
      File file = File(filePath);
      await file.writeAsBytes(response.data, flush: true);
      print('Áudio baixado e salvo em: $filePath');
    } catch (e) {
      print('Erro ao baixar o áudio: $e');
    }
  }

  Future<void> preparePlay(String fileName) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDir.path}/$fileName.aac';
    await playerController.preparePlayer(
      path: filePath,
      shouldExtractWaveform: true,
      noOfSamples: MediaQuery.of(context).size.width ~/ 6.6,
      volume: 1.0,
    );
    setState(() {});
  }

  void _playandPause() async {
    playerController.playerState == PlayerState.playing
        ? await playerController.pausePlayer()
        : await playerController.startPlayer(finishMode: FinishMode.pause);

    setState(() {
      isPlay = !isPlay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AudioFileWaveforms(
            continuousWaveform: true,
            enableSeekGesture: true,
            key: Key(widget.message.timestamp),
            size: Size(10, 70),
            playerController: playerController,
            waveformData: [],
            backgroundColor: Colors.black,
            margin: EdgeInsets.only(left: 20),
            waveformType: WaveformType.fitWidth,
            playerWaveStyle: const PlayerWaveStyle(
              fixedWaveColor: Colors.grey,
              liveWaveColor: Colors.black,
              scaleFactor: 100,
              spacing: 4,
              waveCap: StrokeCap.round,
              showSeekLine: true,
            ),
          ),
        ),
        IconButton(
          onPressed: _playandPause,
          icon: Container(
            width: 50,
            height: 50,
            constraints: const BoxConstraints(maxWidth: 150),
            child: Icon(
              isPlay ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(50)),
          ),
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }
}
