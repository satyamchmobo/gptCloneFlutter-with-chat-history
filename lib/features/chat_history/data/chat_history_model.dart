import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_converstaion_entity.dart';
import 'package:hive/hive.dart';

part 'chat_history_model.g.dart';

@HiveType(typeId: 0) // Adjust typeId as needed
class ChatHistory {
  ChatHistory({required this.chatHistoryList});

  @HiveField(0)
  final List<ChatConversationEntity> chatHistoryList;
}
