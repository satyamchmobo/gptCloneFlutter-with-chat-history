// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_converstaion_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatConversationEntityAdapter
    extends TypeAdapter<ChatConversationEntity> {
  @override
  final int typeId = 1;

  @override
  ChatConversationEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatConversationEntity(
      id: fields[1] as String?,
      chatConversationName: fields[0] as String?,
      choices: (fields[2] as List?)?.cast<ChatConversationDataEntity>(),
    );
  }

  @override
  void write(BinaryWriter writer, ChatConversationEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.chatConversationName)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.choices);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatConversationEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
