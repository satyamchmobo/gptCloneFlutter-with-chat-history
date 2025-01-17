// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_conversation_data_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatConversationDataEntityAdapter
    extends TypeAdapter<ChatConversationDataEntity> {
  @override
  final int typeId = 2;

  @override
  ChatConversationDataEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatConversationDataEntity(
      text: fields[0] as String?,
      index: fields[1] as num?,
      finish_reason: fields[2] as String?,
      messageId: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ChatConversationDataEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.index)
      ..writeByte(2)
      ..write(obj.finish_reason)
      ..writeByte(3)
      ..write(obj.messageId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatConversationDataEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
