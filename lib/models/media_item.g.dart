// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MediaItemAdapter extends TypeAdapter<MediaItem> {
  @override
  final int typeId = 0;

  @override
  MediaItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MediaItem()
      ..id = fields[0] as String
      ..path = fields[1] as String
      ..capturedAt = fields[2] as DateTime
      ..scheduledDeleteAt = fields[3] as DateTime?
      ..geoZoneId = fields[4] as String?
      ..inSafeVault = fields[5] as bool
      ..type = fields[6] as String
      ..permanentDeleteAt = fields[7] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, MediaItem obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.path)
      ..writeByte(2)
      ..write(obj.capturedAt)
      ..writeByte(3)
      ..write(obj.scheduledDeleteAt)
      ..writeByte(4)
      ..write(obj.geoZoneId)
      ..writeByte(5)
      ..write(obj.inSafeVault)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.permanentDeleteAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
