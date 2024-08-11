import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_conversation_data_entity.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_converstaion_entity.dart';
import 'package:flutter_chatgpt_clone/features/chat_history/data/chat_history_model.dart';

abstract class ChatHistoryHiveService {
  Future<void> initHiveLocalStorage();
  Future<void> saveChatHistory(ChatHistory chatHistory);
  Future<ChatHistory?> getChatHistory();
  Future<void> clearChatHistory();
  Future<void> editChat(String chatId, String updatedChatName);
  Future<void> deleteChat(String chatId);
  Future<void> addChat(ChatConversationEntity newChat);
  Future<void> addMessageToChat(
      String chatId, ChatConversationDataEntity message);
}
