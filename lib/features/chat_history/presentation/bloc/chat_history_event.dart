import 'package:equatable/equatable.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_converstaion_entity.dart';

abstract class ChatHistoryEvent extends Equatable {
  const ChatHistoryEvent();
}

class LoadChatHistory extends ChatHistoryEvent {
  const LoadChatHistory();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class EditChatEvent extends ChatHistoryEvent {
  final String chatId;
  final String newName;

  const EditChatEvent(this.chatId, this.newName);

  @override
  List<Object> get props => [chatId, newName];
}

class DeleteChatEvent extends ChatHistoryEvent {
  final String chatId;

  const DeleteChatEvent(this.chatId);

  @override
  List<Object> get props => [chatId];
}

class CreateChatEvent extends ChatHistoryEvent {
  final ChatConversationEntity chat;

  const CreateChatEvent(this.chat);

  @override
  List<Object> get props => [chat];
}

class OpenChatDetails extends ChatHistoryEvent {
  final String chatId;

  const OpenChatDetails(this.chatId);

  @override
  List<Object> get props => [chatId];
}
