import 'dart:io';
import 'package:mensajeriaup/features/mensajes/chat/domain/entities/message.dart';

class MessageModel extends Message {
  MessageModel({
    String? text,
    String? imageUrl,
    String? videoUrl,
    String? audioUrl,
    String? timestamp,
  }) : super(
          text: text,
          imageUrl: imageUrl,
          videoUrl: videoUrl,
          audioUrl: audioUrl,
          timestamp: timestamp,
        );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      text: json['text'],
      timestamp: json['timestamp'],
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      audioUrl: json['audioUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'timestamp': timestamp,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'audioUrl': audioUrl,
    };
  }

  Message toEntity() {
    return Message(
      text: text,
      imageUrl: imageUrl,
      videoUrl: videoUrl,
      audioUrl: audioUrl,
      timestamp: timestamp,
    );
  }

  MessageModel copyWith({
    String? text,
    String? timestamp,
    String? imageUrl,
    String? videoUrl,
    String? audioUrl,
  }) {
    return MessageModel(
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      audioUrl: audioUrl ?? this.audioUrl,
    );
  }

  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      timestamp: message.timestamp,
      text: message.text,
      imageUrl: message.imageUrl,
      videoUrl: message.videoUrl,
      audioUrl: message.audioUrl,
    );
  }
}
