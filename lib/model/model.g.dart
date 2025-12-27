// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContentModelAdapter extends TypeAdapter<ContentModel> {
  @override
  final int typeId = 1;

  @override
  ContentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContentModel(
      title: fields[1] as String,
      content: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ContentModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ContentSaveModelAdapter extends TypeAdapter<ContentSaveModel> {
  @override
  final int typeId = 2;

  @override
  ContentSaveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContentSaveModel(
      allContent: (fields[1] as List).cast<ContentModel>(),
      imagePath: fields[2] as String,
      Id: fields[3] as String,
      isSave: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ContentSaveModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.allContent)
      ..writeByte(2)
      ..write(obj.imagePath)
      ..writeByte(3)
      ..write(obj.Id)
      ..writeByte(4)
      ..write(obj.isSave);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContentSaveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
