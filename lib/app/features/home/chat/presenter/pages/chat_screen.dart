import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:mensageiro/app/core/components/cutom_contact_card.dart';
import 'package:mensageiro/app/core/components/svg_asset.dart';
import 'package:mensageiro/app/core/components/text.dart';
import 'package:mensageiro/app/core/components/title_textfield.dart';
import 'package:mensageiro/app/core/constants/colors.dart';
import 'package:mensageiro/app/core/constants/const.dart';
import 'package:mensageiro/app/core/constants/fonts_sizes.dart';
import 'package:mensageiro/app/core/infra/call/signalling_service.dart';
import 'package:mensageiro/app/features/home/chat/domain/entity/chat.dart';
import 'package:mensageiro/app/features/home/chat/presenter/pages/chat_controller.dart';
import 'package:mensageiro/app/features/home/chat/presenter/pages/pdf_view_page.dart';
import 'package:mensageiro/app/features/home/contact/domain/entity/contact.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:video_player/video_player.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import "package:cached_network_image/cached_network_image.dart";

class ChatPage extends StatefulWidget {
  final ChatController controller;
  final Contact contact;

  const ChatPage({
    Key? key,
    required this.controller,
    required this.contact,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  late VideoPlayerController _videoPlayerController;
  AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = const Duration();
  Duration position = const Duration();
  bool isPlaying = false;
  bool isLoading = false;
  bool isPause = false;
  AudioRecorder _audioRecorder = AudioRecorder();
  bool _isPressed = false;
  bool _isTextEmpty = true;
  double _recordTime = 0.0;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network('');
    _messageController.addListener(_onTextChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeaderComposer(context),
            Expanded(
              child: StreamBuilder<List<Chat>>(
                stream: widget.controller.messages(widget.contact.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Stack(
                      children: [_buildMessagesList(snapshot.data!)],
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            _buildMessageComposer(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderComposer(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppConst.sidePadding),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Modular.to.pop();
                    },
                    child: AppSvgAsset(
                      image: 'back.svg',
                      color: AppColors.black,
                      imageH: 20,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CustomContactCard(
                      icon: 'profile.svg',
                      subtitle: 'Online',
                      subtitleColor: AppColors.grey,
                      color: AppColors.grey,
                      title: widget.contact.name,
                    ),
                  ),
                  AppSvgAsset(
                    image: 'video.svg',
                    color: AppColors.grey,
                    imageH: 16,
                  ),
                  SizedBox(width: 20),
                  AppSvgAsset(
                      image: 'phone.svg', color: AppColors.grey, imageH: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(List<Chat> messages) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppConst.sidePadding - 10, vertical: 20),
      child: ListView.builder(
        reverse: true,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          if (message.typeMessage == 'A') {
            return _buildAudioBubble(message);
          } else if (message.typeMessage == 'P') {
            return _buildImageBubble(message);
          } else if (message.typeMessage == 'V') {
            return _buildVideoMessage(message);
          } else if (message.typeMessage == 'D') {
            return _buildDocumentMessage(message);
          }
          return _buildTextBubble(message);
        },
      ),
    );
  }

  Widget _buildAudioBubble(Chat message) {
    return BubbleNormalAudio(
      color: const Color(0xFFE8E8EE),
      duration: duration.inSeconds.toDouble(),
      position: position.inSeconds.toDouble(),
      isPlaying: isPlaying,
      isLoading: isLoading,
      isPause: isPause,
      isSender: message.userId != widget.contact.id,
      onSeekChanged: _changeSeek,
      key: Key(message.timestamp),
      onPlayPauseButtonClick: () {
        _playAudio(audioLink: message.message);
      },
      sent: true,
    );
  }

  Widget _buildImageBubble(Chat message) {
    return BubbleNormalImage(
      isSender: message.userId != widget.contact.id,
      id: message.id ?? message.timestamp,
      image: _image(message.message),
      color: Colors.transparent,
      tail: true,
      sent: true,
      delivered: true,
    );
  }

  Widget _buildVideoMessage(Chat message) {
    return ListTile(
      title: AspectRatio(
        aspectRatio: 16 / 9,
        child: VideoPlayer(_videoPlayerController),
      ),
    );
  }

  Widget _buildDocumentMessage(Chat message) {
    return FractionallySizedBox(
      widthFactor: 0.6,
      alignment: message.userId != widget.contact.id
          ? Alignment.bottomRight
          : Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(5)),
        child: ListTile(
          onTap: () => Modular.to.push(
            MaterialPageRoute(
                builder: (context) => PdfViewPage(
                      pdf: message.message,
                    )),
          ),
          title: const Text("Document"),
          leading: const Icon(Icons.file_copy),
        ),
      ),
    );
  }

  Widget _buildTextBubble(Chat message) {
    return BubbleNormal(
      text: message.message,
      isSender: message.userId != widget.contact.id,
      color: Colors.black,
      sent: true,
      tail: true,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.white,
      ),
    );
  }

  Widget _buildMessageComposer(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppConst.sidePadding),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () async {
                      await _showAttachmentOptions(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.0),
                        color: AppColors.black,
                      ),
                      padding: EdgeInsets.all(10),
                      child: AppSvgAsset(
                        image: 'add.svg',
                        imageH: 16,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TitleTextField(
                      controller: _messageController,
                      hintText: 'Digite uma mensagem...',
                      borderColor: Colors.transparent,
                    ),
                  ),
                  _isTextEmpty
                      ? _buildMicButton()
                      : SizedBox(), // Empty SizedBox when text is not empty
                  _isTextEmpty
                      ? InkWell(
                          child: const SizedBox(
                            width: 20,
                            height: 20,
                            child: AppSvgAsset(
                              image: 'emotion.svg',
                              color: AppColors.grey,
                            ),
                          ),
                        )
                      : InkWell(
                          child: const SizedBox(
                            width: 20,
                            height: 20,
                            child: AppSvgAsset(
                              image:
                                  'send.svg', // assuming 'send.svg' is your send button icon
                              color: AppColors.grey,
                            ),
                          ),
                          onTap: () {
                            _sendMessage(_messageController.text);
                          },
                        ),
                  const SizedBox(width: 15),
                  InkWell(
                    onTap: () async {
                      await widget.controller
                          .sendImage(widget.contact.id, input: true);
                    },
                    child: const SizedBox(
                      width: 20,
                      height: 20,
                      child: AppSvgAsset(
                        image: 'camera.svg',
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onTextChanged() {
    setState(() {
      _isTextEmpty = _messageController.text.isEmpty;
    });
  }

  Widget _buildAttachmentButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.black,
      ),
      child: IconButton(
        icon: Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await _showAttachmentOptions(context);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildSendButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.grey,
      ),
      child: IconButton(
        icon: Icon(Icons.send, color: Colors.white),
        onPressed: () {
          _sendMessage(_messageController.text);
        },
      ),
    );
  }

  Widget _buildMicButton() {
    return GestureDetector(
      child: AnimatedContainer(
        transformAlignment: Alignment.centerLeft,
        duration: Duration(milliseconds: 100),
        width: _isPressed ? null : 40,
        child: Row(
          children: [
            //format the time
            if (_isPressed)
              AppText(
                  text: _recordTime
                      .toStringAsFixed(2)
                      .toString()
                      .replaceAll('.', ':'),
                  color: AppColors.grey,
                  fontSize: AppFontSize.fz06),
            if (_isPressed) SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isPressed ? Colors.red : Colors.transparent,
              ),
              padding: const EdgeInsets.all(12.0),
              child: _isPressed
                  ? AppSvgAsset(
                      image: 'record.svg',
                      color: AppColors.white,
                      imageH: 20, // Adjusted to 24px
                    )
                  : AppSvgAsset(
                      image: 'record.svg',
                      color: AppColors.grey,
                      imageH: 20, // Adjusted to 24px
                    ),
            ),
          ],
        ),
      ),
      onLongPress: () {
        setState(() {
          _isPressed = true;
          _recordTime = 0.0;
          _recordAudio();
          _recordAudioTime();
        });
      },
      onLongPressUp: () {
        setState(() {
          _isPressed = false;
          _recordAudioStop();
        });
      },
    );
  }

  void _startVideoCall() {
    final signallingService = SignallingService.instance;
    signallingService.socket?.emit('startVideosCall', {
      'callerId': widget.contact.id,
      'calleeId': widget.contact.id,
    });
  }

  void _sendMessage(String message) {
    widget.controller.sendMessage(
      widget.contact.id,
      Chat(
        message: message,
        timestamp: DateTime.now().toString(),
        typeMessage: 'M',
      ),
    );
    _messageController.clear();
  }

  Future<void> _recordAudioStop() async {
    final recording = await _audioRecorder.stop();
    if (recording == null) {
      return;
    }
    await widget.controller.sendAudio(widget.contact.id, recording);
  }

  Future<void> _recordAudio() async {
    if (await _audioRecorder.hasPermission()) {
      String directoryPath = (await getApplicationDocumentsDirectory()).path;
      Directory('$directoryPath/audio/').createSync(recursive: true);
      String filePath =
          '$directoryPath${DateTime.now().millisecondsSinceEpoch}.wav';
      try {
        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.wav, bitRate: 128000),
          path: filePath,
        );
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> _recordAudioTime() async {
    await Future.delayed(const Duration(seconds: 1), () {
      if (_isPressed) {
        setState(() {
          _recordTime = _recordTime + 0.01;

          if (_recordTime > 0.60) {
            _isPressed = false;
            _recordAudioStop();
          }
        });
        _recordAudioTime();
      }
    });
  }

  Future<void> _showAttachmentOptions(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildAttachmentOption(
                Icon(Icons.photo_camera),
                'Fotos',
                () {
                  _sendPhoto();
                  Navigator.of(context).pop();
                },
              ),
              // _buildAttachmentOption(
              //   Icon(Icons.videocam),
              //   'Vídeos',
              //   () {
              //     // _sendVideo();
              //   },
              // ),
              _buildAttachmentOption(
                Icon(Icons.insert_drive_file),
                'Documentos',
                () {
                  _sendDocuments();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  ListTile _buildAttachmentOption(
    Icon icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: icon,
      title: Text(title),
      onTap: onTap,
    );
  }

  Future<void> _sendPhoto() async {
    await widget.controller.sendImage(widget.contact.id);
  }

  Future<void> _sendDocuments() async {
    await widget.controller.sendDocument(widget.contact.id);
  }

  Widget _image(String image) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 20.0,
        minWidth: 20.0,
      ),
      child: CachedNetworkImage(
        imageUrl: image,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  void _playAudio({required String audioLink}) async {
    final url = audioLink;
    if (isPause) {
      await audioPlayer.resume();
      setState(() {
        isPlaying = true;
        isPause = false;
      });
    } else if (isPlaying) {
      await audioPlayer.pause();
      setState(() {
        isPlaying = false;
        isPause = true;
      });
    } else {
      setState(() {
        isLoading = true;
      });
      await audioPlayer.setSourceDeviceFile(url);
      audioPlayer.resume();

      setState(() {
        audioPlayer.getDuration.call().then((value) => duration = value!);
        isPlaying = true;
      });
    }

    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        duration = d;
        isLoading = false;
      });
    });
    audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        position = p;
      });
    });
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
        duration = const Duration();
        position = const Duration();
      });
    });
  }

  void _changeSeek(double value) {
    setState(() {
      audioPlayer.seek(Duration(seconds: value.toInt()));
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    audioPlayer.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }
}
