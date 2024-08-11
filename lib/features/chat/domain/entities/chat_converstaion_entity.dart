import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_conversation_data_entity.dart';
import 'package:hive/hive.dart';
part 'chat_converstaion_entity.g.dart';

@HiveType(typeId: 1)
class ChatConversationEntity extends HiveObject {
  @HiveField(0)
  final String? chatConversationName;

  @HiveField(1)
  final String? id;

  @HiveField(2)
  final List<ChatConversationDataEntity>? choices;

  ChatConversationEntity({
    required this.id,
    this.chatConversationName,
    this.choices,
  });

  ChatConversationEntity copyWith({
    String? chatConversationName,
    String? id,
    List<ChatConversationDataEntity>? choices,
  }) {
    return ChatConversationEntity(
      id: id ?? this.id,
      chatConversationName: chatConversationName ?? this.chatConversationName,
      choices: choices ?? this.choices?.toList(),
    );
  }
}
