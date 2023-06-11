// lib/presentation/screens/home_screen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mensajeriaup/features/mensajes/chat/domain/entities/message.dart';
import 'package:mensajeriaup/features/mensajes/chat/domain/usecases/get_messages.dart';
import 'package:mensajeriaup/features/mensajes/chat/domain/usecases/send_message.dart';
import 'package:mensajeriaup/features/mensajes/chat/presentation/widgets/message_list.dart';

//import 'package:flutter/material.dart';
//import 'package:file_picker/file_picker.dart';
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

  void _fetchMessages() async {
    final messages = await widget.getMessages();
    messages.sort((a, b) => a.id.compareTo(b.id));
    setState(() {
      _messages = messages;
    });
  }

  void _sendMessage(String text) async {
    final message = Message(id: DateTime.now().toString(), text: text);
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

    if (result != null) {
      final path = result.files.single.path;
      final fileName = path!.split('/').last;
      final ref = _storage.ref().child('$type/$fileName');
      final uploadTask = ref.putFile(File(path));
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
        print('Imagen URL: ${message.imageUrl}');
      } else if (type == 'gif') {
        message.gifUrl = downloadUrl;
      }

      await widget.sendMessage(message);
      _fetchMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
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

//print('Video URL: ${message.videoUrl}');
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:mensajeriaup/features/mensajes/chat/domain/entities/message.dart';
// import 'package:mensajeriaup/features/mensajes/chat/domain/usecases/get_messages.dart';
// import 'package:mensajeriaup/features/mensajes/chat/domain/usecases/send_message.dart';
// import 'package:mensajeriaup/features/mensajes/chat/presentation/widgets/message_list.dart';

// class HomeChat extends StatefulWidget {
//   final GetMessages getMessages;
//   final SendMessage sendMessage;

//   HomeChat({required this.getMessages, required this.sendMessage});

//   @override
//   _HomeChatState createState() => _HomeChatState();
// }

// class _HomeChatState extends State<HomeChat> {
//   final TextEditingController _textController = TextEditingController();
//   List<Message> _messages = [];
//   String _filePath = '';

//   @override
//   void initState() {
//     super.initState();
//     _fetchMessages();
//   }

//   void _fetchMessages() async {
//     final messages = await widget.getMessages();
//     messages.sort((a, b) => a.id.compareTo(b.id));
//     setState(() {
//       _messages = messages;
//     });
//   }

//   void _sendMessage(String text) async {
//     final message = Message(id: DateTime.now().toString(), text: text);
//     await widget.sendMessage(message);
//     _textController.clear();
//     _fetchMessages();
//   }

//   Future<void> _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();

//     if (result != null) {
//       setState(() {
//         _filePath = result.files.single.path!;
//         // Aquí puedes llamar al método de envío de mensaje con la información del archivo adjunto
//         // Por ejemplo:
//         // final message = Message(id: DateTime.now().toString(), text: _filePath, filePath: _filePath);
//         // await widget.sendMessage(message);
//         // _filePath = ''; // Limpiar la variable después de enviar el archivo
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: MessageList(messages: _messages),
//           ),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 16.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _textController,
//                     decoration: InputDecoration(
//                       hintText: 'Ingrese un mensaje...',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () => _sendMessage(_textController.text),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.attach_file),
//                   onPressed: () => _pickFile(),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
