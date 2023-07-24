// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_item_object.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoItemObjectAdapter extends TypeAdapter<TodoItemObject> {
  @override
  final int typeId = 1;

  @override
  TodoItemObject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoItemObject(
      title: fields[0] as String,
      dueDate: fields[1] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, TodoItemObject obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.dueDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoItemObjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
