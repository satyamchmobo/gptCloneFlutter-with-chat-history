import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_chatgpt_clone/core/custom_exception.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_conversation_data_entity.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_converstaion_entity.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_message_entity.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/usecases/chat_converstaion_usecase.dart';
import 'package:flutter_chatgpt_clone/features/chat_history/data/chat_history_model.dart';
import 'package:flutter_chatgpt_clone/features/chat_history/data/local_data_source/chat_history_hive_service.dart';
import 'package:flutter_chatgpt_clone/features/global/const/app_const.dart';
import 'package:flutter_chatgpt_clone/injection_container.dart';

part 'chat_conversation_state.dart';

class ChatConversationCubit extends Cubit<ChatConversationState> {
  final ChatConversationUseCase chatConversationUseCase;

  ChatConversationCubit({required this.chatConversationUseCase})
      : super(ChatConversationInitial()) {
    print('HERE IN CUTBIT INTI');
    // _chatMessages.clear();
  }

  late String conversationId;

  List<ChatMessageEntity> _chatMessages = [];

  init(ChatConversationEntity chatConversationEntity) {
    this.conversationId = chatConversationEntity.id!;
    print(chatConversationEntity.choices);
    if (chatConversationEntity.choices != null &&
        chatConversationEntity.choices!.isNotEmpty) {
      print('list not empty HERE IN INIT');
      _chatMessages = chatConversationEntity.choices!
          .map((e) => ChatMessageEntity(
                queryPrompt: e.text,
                promptResponse: e.text,
                messageId: e.messageId,
              ))
          .toList();

      emit(
        ChatConversationLoaded(
          chatMessages: _chatMessages,
        ),
      );
    }
  }

  Future<void> chatConversation({
    required ChatMessageEntity chatMessage,
    required Function(bool isReqComplete) onCompleteReqProcessing,
  }) async {
    try {
      //

      _chatMessages.add(chatMessage);
      sl.get<ChatHistoryHiveService>().addMessageToChat(
          conversationId,
          ChatConversationDataEntity(
              text: chatMessage.queryPrompt!,
              messageId: chatMessage.messageId));

      emit(
        ChatConversationLoaded(
          chatMessages: _chatMessages,
        ),
      );

      final conversationData = await chatConversationUseCase
          .call(chatMessage.queryPrompt!, onCompleteReqProcessing)
          .then((value) {
        print(value.id);
      });

      // final ChatHistoryHiveService _chatHistoryService;
      // _chatHistoryService = ChatHistoryHiveService();
      sl
          .get<ChatHistoryHiveService>()
          .addMessageToChat(conversationId, conversationData.choices!.first);

      //This is for testing if new msg is added in local storage chat under history
      // ChatHistory? history =
      //     await sl.get<ChatHistoryHiveService>().getChatHistory();
      // print('a msg from last chat history ' +
      //     history!.chatHistoryList.first.choices.toString());

      final chatMessageResponse = ChatMessageEntity(
          messageId: ChatGptConst.AIBot,
          promptResponse: conversationData.choices!.first.text);
      print('reacged gere');
      _chatMessages.add(chatMessageResponse);

      emit(ChatConversationLoaded(
        chatMessages: _chatMessages,
      ));
    } on SocketException catch (e) {
      final chatMessageResponse = ChatMessageEntity(
          messageId: ChatGptConst.AIBot, promptResponse: e.message);

      _chatMessages.add(chatMessageResponse);

      emit(ChatConversationLoaded(
        chatMessages: _chatMessages,
      ));
    } on ChatGPTServerException catch (e) {
      final chatMessageResponse = ChatMessageEntity(
          messageId: ChatGptConst.AIBot, promptResponse: e.message);

      _chatMessages.add(chatMessageResponse);

      sl.get<ChatHistoryHiveService>().addMessageToChat(
          conversationId,
          ChatConversationDataEntity(
              messageId: chatMessageResponse.messageId,
              text: chatMessageResponse.promptResponse!));

      emit(ChatConversationLoaded(
        chatMessages: _chatMessages,
      ));
    }
  }

  // @override
  // Future<void> close() {
  //   _chatMessages.clear();
  //   // TODO: implement close
  //   return super.close();
  // }
}
