import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mensageiro/app/features/home/contact/presenter/pages/contacts_controller.dart';

class ChatPage extends StatefulWidget {
  final ContactsController controller;

  const ChatPage({Key? key, required this.controller}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Column(children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return _buildContactItem(index);
                },
              ),
            ),
            _buildMessageComposer(context),
          ]),
        ),
        body: Column(),
      ),
    );
  }

  Widget _buildContactItem(int index) {
    final contact = widget.controller.listContacts![index];
    return ListTile(
      title: Text(contact.name),
      subtitle: Text(contact.phone),
      leading: CircleAvatar(
        backgroundImage:
            contact.photo != null ? NetworkImage(contact.photo!) : null,
      ),
    );
  }

  Widget _buildMessageComposer(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.attach_file),
            onPressed: () {
              _showAttachmentOptions(context);
            },
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(hintText: 'Digite uma mensagem...'),
              onSubmitted: (text) {},
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.keyboard_voice),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Fotos e Videos'),
                onTap: () {
                  _pickMedia(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.insert_drive_file),
                title: Text('Documento'),
                onTap: () {
                  _pickDocument(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.contacts),
                title: Text('Contato'),
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickMedia(BuildContext context) async {
    // Lógica para escolher fotos e vídeos aqui
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.media,
      allowMultiple: false,
    );
    if (result != null) {}
    Navigator.pop(context);
  }

  Future<void> _pickDocument(BuildContext context) async {
    // Lógica para escolher documentos aqui
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      allowMultiple: false,
    );
    if (result != null) {}
    Navigator.pop(context);
  }
}
