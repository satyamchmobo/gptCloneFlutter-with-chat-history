import 'package:hive/hive.dart';

part 'chat_conversation_data_entity.g.dart';

@HiveType(typeId: 2) // Adjust typeId as needed
class ChatConversationDataEntity extends HiveObject {
  @HiveField(0)
  final String? text;

  @HiveField(1)
  final num? index;

  @HiveField(2)
  final String? finish_reason;

  @HiveField(3)
  final String? messageId;

  ChatConversationDataEntity(
      {this.text, this.index, this.finish_reason, this.messageId});
}
