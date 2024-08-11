import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_converstaion_entity.dart';
import 'package:flutter_chatgpt_clone/features/chat_history/data/local_data_source/chat_history_hive_service.dart';

import 'chat_history_event.dart';
import 'chat_history_state.dart';

class ChatHistoryBloc extends Bloc<ChatHistoryEvent, ChatHistoryState> {
  final ChatHistoryHiveService _chatHistoryService;

  Future<void> loadChatFromDbAndEmitLoaded(
      Emitter<ChatHistoryState> emit) async {
    final chatHistory = await _chatHistoryService.getChatHistory();
    print(';fdfd ${chatHistory?.chatHistoryList.first.chatConversationName}');
    emit(chatHistory != null
        ? ChatHistoryLoaded(chatHistory.chatHistoryList)
        : ChatHistoryEmpty());
  }

  ChatHistoryBloc(this._chatHistoryService) : super(ChatHistoryInitial()) {
    on<LoadChatHistory>((event, emit) async {
      emit(ChatHistoryLoading());
      try {
        await loadChatFromDbAndEmitLoaded(emit);
      } catch (error) {
        emit(ChatHistoryError(error.toString()));
      }
    });

    on<EditChatEvent>((event, emit) async {
      //implement EditChat
      //
      emit(ChatHistoryLoading());
      try {
        await _chatHistoryService.editChat(event.chatId, event.newName);
        // Update the chat history state
        await loadChatFromDbAndEmitLoaded(emit);
      } catch (error) {
        emit(ChatHistoryError(error.toString()));
      }
      // ...
    });

    on<DeleteChatEvent>((event, emit) async {
      try {
        await _chatHistoryService.deleteChat(event.chatId);
        // Update the chat history state
        emit(ChatHistoryDeleting(event.chatId));
        await loadChatFromDbAndEmitLoaded(emit);
      } catch (error) {
        emit(ChatHistoryError(error.toString()));
      }
    });

    on<CreateChatEvent>((event, emit) async {
      print('creating chat');
      await addChatAndEmit(emit, event.chat);
      print('created chat');

      // ...
    });

    on<OpenChatDetails>((event, emit) async {
      // ...
    });
  }

  Future<void> addChatAndEmit(
      Emitter<ChatHistoryState> emit, ChatConversationEntity newChat) async {
    emit(ChatHistoryLoading());

    print('afterStartingLoader');
    await _chatHistoryService.addChat(newChat);
    print('afterSavingChat');

    await loadChatFromDbAndEmitLoaded(emit);
  }
}
