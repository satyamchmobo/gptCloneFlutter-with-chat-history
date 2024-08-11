import 'package:equatable/equatable.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_converstaion_entity.dart';

abstract class ChatHistoryState extends Equatable {
  const ChatHistoryState();
}

class ChatHistoryInitial extends ChatHistoryState {
  const ChatHistoryInitial();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class ChatHistoryLoading extends ChatHistoryState {
  const ChatHistoryLoading();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class ChatHistoryLoaded extends ChatHistoryState {
  final List<ChatConversationEntity> chats;

  const ChatHistoryLoaded(this.chats);

  @override
  List<Object> get props => [chats];
}

class ChatHistoryEmpty extends ChatHistoryState {
  const ChatHistoryEmpty();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class ChatHistoryError extends ChatHistoryState {
  final String message;

  const ChatHistoryError(this.message);

  @override
  List<Object> get props => [message];
}

class ChatHistoryDeleting extends ChatHistoryState {
  final String chatId;

  const ChatHistoryDeleting(this.chatId);

  @override
  List<Object> get props => [chatId];
}

class ChatDetailsOpened extends ChatHistoryState {
  final String chatId;

  const ChatDetailsOpened(this.chatId);

  @override
  List<Object> get props => [chatId];
}
