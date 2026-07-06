// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_zone.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GeoZoneAdapter extends TypeAdapter<GeoZone> {
  @override
  final int typeId = 1;

  @override
  GeoZone read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GeoZone()
      ..id = fields[0] as String
      ..name = fields[1] as String
      ..lat = fields[2] as double
      ..lng = fields[3] as double
      ..radiusMeters = fields[4] as double
      ..expiryDays = fields[5] as int
      ..isActive = fields[6] as bool;
  }

  @override
  void write(BinaryWriter writer, GeoZone obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.lat)
      ..writeByte(3)
      ..write(obj.lng)
      ..writeByte(4)
      ..write(obj.radiusMeters)
      ..writeByte(5)
      ..write(obj.expiryDays)
      ..writeByte(6)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeoZoneAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
