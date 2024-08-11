import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_conversation_data_entity.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_converstaion_entity.dart';
import 'package:flutter_chatgpt_clone/features/chat_history/data/chat_history_model.dart';
import 'package:flutter_chatgpt_clone/features/chat_history/data/local_data_source/chat_history_hive_service.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path;

class ChatHistoryHiveServiceImpl implements ChatHistoryHiveService {
  static const String chatHistoryBoxName = 'chatHistoryBox';
  static const String chatConversatoionEntityBoxNme =
      'chatConversatoionEntityBox';
  static const String chatConversatoionDataEntityBoxNme =
      'chatConversatoionDataEntityBox';

  Future<void> initHiveLocalStorage() async {
    final dir = await path.getApplicationSupportDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(ChatHistoryAdapter());
    Hive.registerAdapter(ChatConversationEntityAdapter());
    Hive.registerAdapter(ChatConversationDataEntityAdapter());

    final box = await Hive.openBox<ChatHistory>(chatHistoryBoxName);
    await Hive.openBox<ChatHistory>(chatConversatoionEntityBoxNme);
    await Hive.openBox<ChatHistory>(chatConversatoionDataEntityBoxNme);

    final chatHistory = await box.get('chatHistory');

    if (chatHistory == null) {
      // Chat history is empty, save an empty list on first run
      print('ChatHistoryWasNull');
      await saveChatHistory(ChatHistory(chatHistoryList: []));
    } else {
      print(chatHistory.chatHistoryList.first.chatConversationName);
      print('ChatHistory is not null');
    }
  }

  @override
  Future<void> saveChatHistory(ChatHistory chatHistory) async {
    final box = await Hive.openBox<ChatHistory>(chatHistoryBoxName);
    await box.put('chatHistory', chatHistory);
  }

  @override
  Future<ChatHistory?> getChatHistory() async {
    final box = await Hive.openBox<ChatHistory>(chatHistoryBoxName);
    return box.get('chatHistory');
  }

  @override
  Future<void> clearChatHistory() async {
    final box = await Hive.openBox<ChatHistory>(chatHistoryBoxName);
    await box.delete('chatHistory');
  }

  @override
  Future<void> editChat(String chatId, String updatedChatName) async {
    final box = await Hive.openBox<ChatHistory>(chatHistoryBoxName);
    final chatHistory = box.get('chatHistory') as ChatHistory;
    final index =
        chatHistory.chatHistoryList.indexWhere((chat) => chat.id == chatId);

    if (index != -1) {
      chatHistory.chatHistoryList[index] = chatHistory.chatHistoryList[index]
          .copyWith(chatConversationName: updatedChatName);
      await box.put('chatHistory', chatHistory);
    }
  }

  @override
  Future<void> deleteChat(String chatId) async {
    final box = await Hive.openBox<ChatHistory>(chatHistoryBoxName);
    final chatHistory = box.get('chatHistory') as ChatHistory;
    chatHistory.chatHistoryList.removeWhere((chat) => chat.id == chatId);
    await box.put('chatHistory', chatHistory);
  }

  @override
  Future<void> addChat(ChatConversationEntity newChat) async {
    final box = await Hive.openBox<ChatHistory>(chatHistoryBoxName);
    final chatHistory = box.get('chatHistory') as ChatHistory;
    chatHistory.chatHistoryList.add(newChat);
    await box.put('chatHistory', chatHistory);
  }

  @override
  Future<void> addMessageToChat(
      String chatId, ChatConversationDataEntity message) async {
    print('adding message to chat');
    final box = await Hive.openBox<ChatHistory>(chatHistoryBoxName);
    final chatHistory = box.get('chatHistory') as ChatHistory;
    final chatIndex =
        chatHistory.chatHistoryList.indexWhere((chat) => chat.id == chatId);

    if (chatIndex != -1) {
      chatHistory.chatHistoryList[chatIndex].choices?.add(message);
      await box.put('chatHistory', chatHistory);
    }
  }
}
