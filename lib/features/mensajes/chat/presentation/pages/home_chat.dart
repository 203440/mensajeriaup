import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mensajeriaup/features/mensajes/chat/domain/entities/message.dart';
import 'package:mensajeriaup/features/mensajes/chat/domain/usecases/get_messages.dart';
import 'package:mensajeriaup/features/mensajes/chat/domain/usecases/send_message.dart';
import 'package:mensajeriaup/features/mensajes/chat/presentation/widgets/message_list.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HomeScreen extends StatefulWidget {
  final GetMessages getMessages;
  final SendMessage sendMessage;

  HomeScreen({required this.getMessages, required this.sendMessage});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textController = TextEditingController();
  List<Message> _messages = [];
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _fetchMessages() async {
    final messages = await widget.getMessages();
    messages.sort((a, b) => a.id.compareTo(b.id));
    setState(() {
      _messages = messages;
    });
  }

  void _sendMessage(String text) async {
    final message = Message(
      id: DateTime.now().toString(),
      text: text,
      /*imageUrl: text,
      videoUrl: text,
      gifUrl: text,*/
    );
    await widget.sendMessage(message);
    _textController.clear();
    _fetchMessages();
  }

  Future<void> _pickFile(String type) async {
    FilePickerResult? result;
    if (type == 'video') {
      result = await FilePicker.platform.pickFiles(type: FileType.video);
    } else if (type == 'audio') {
      result = await FilePicker.platform.pickFiles(type: FileType.audio);
    } else if (type == 'image') {
      result = await FilePicker.platform.pickFiles(type: FileType.image);
    } else if (type == 'gif') {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['gif'],
      );
    }

    if (result != null && result.files.isNotEmpty) {
      final file = File(result.files.single.path!);
      if (file.existsSync()) {
        final fileName = file.path.split('/').last;
        final ref = _storage.ref().child('$type/$fileName');
        final uploadTask = ref.putFile(file);
        final snapshot = await uploadTask.whenComplete(() => null);
        final downloadUrl = await snapshot.ref.getDownloadURL();

        final message = Message(
          id: DateTime.now().toString(),
          text: '',
          videoUrl: '',
          audioUrl: '',
          imageUrl: '',
          gifUrl: '',
        );

        if (type == 'video') {
          message.videoUrl = downloadUrl;
          print('Video URL: ${message.videoUrl}');
        } else if (type == 'audio') {
          message.audioUrl = downloadUrl;
        } else if (type == 'image') {
          message.imageUrl = downloadUrl;
        } else if (type == 'gif') {
          message.gifUrl = downloadUrl;
        }

        await widget.sendMessage(message);
        _fetchMessages();
      } else {
        print('El archivo no existe: ${file.path}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(71, 134, 250, 1),
        title: Text(
          'Chat',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: MessageList(messages: _messages),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Ingrese un mensaje...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: () => _pickFile('audio'),
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () => _pickFile('image'),
                ),
                IconButton(
                  icon: Icon(Icons.video_library),
                  onPressed: () => _pickFile('video'),
                ),
                IconButton(
                  icon: Icon(Icons.gif),
                  onPressed: () => _pickFile('gif'),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(_textController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
