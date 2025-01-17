import 'package:flutter_chatgpt_clone/features/chat/data/models/chat_conversation_data.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_conversation_data_entity.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_converstaion_entity.dart';

class ChatConversationModel extends ChatConversationEntity {
  ChatConversationModel(
    final String? id,
    final List<ChatConversationDataEntity>? choices,
    String? chatConversationName,
  ) : super(choices: choices, id: id);

  factory ChatConversationModel.fromJson(Map<String, dynamic> json) {
    final chatConversationMessageItem = json['choices'] as List;

    List<ChatConversationDataEntity> choices = chatConversationMessageItem
        .map((messageItem) => ChatConversationData.fromJson(messageItem))
        .toList();
    String chatName = choices.first.text.toString().substring(0, 3);
    return ChatConversationModel(json['id'], choices, chatName);
  }
}
