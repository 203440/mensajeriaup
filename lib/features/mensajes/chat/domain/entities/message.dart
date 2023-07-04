import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? text;
  String? timestamp;
  String? videoUrl;
  String? audioUrl;
  String? imageUrl;
  String? gifUrl;

  Message({
    required this.text,
    this.videoUrl,
    this.audioUrl,
    this.imageUrl,
    this.gifUrl,
    this.timestamp,
  });

  factory Message.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Message(
      text: data['text'],
      imageUrl: data['imageUrl'],
      videoUrl: data['videoUrl'],
      audioUrl: data['audioUrl'],
      gifUrl: data['gifUrl'],
      timestamp: data['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'audioUrl': audioUrl,
      'gifUrl': gifUrl,
      'timestamp': timestamp,
    };
  }
}
