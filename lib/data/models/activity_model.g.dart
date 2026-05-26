// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityAdapter extends TypeAdapter<Activity> {
  @override
  final int typeId = 4;

  @override
  Activity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Activity(
      id: fields[0] as String,
      type: fields[1] as ActivityType,
      issueTitle: fields[2] as String,
      description: fields[3] as String,
      timestamp: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Activity obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.issueTitle)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ActivityTypeAdapter extends TypeAdapter<ActivityType> {
  @override
  final int typeId = 5;

  @override
  ActivityType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ActivityType.Created;
      case 1:
        return ActivityType.Updated;
      case 2:
        return ActivityType.Deleted;
      case 3:
        return ActivityType.StatusChanged;
      case 4:
        return ActivityType.Resolved;
      case 5:
        return ActivityType.Closed;
      default:
        return ActivityType.Created;
    }
  }

  @override
  void write(BinaryWriter writer, ActivityType obj) {
    switch (obj) {
      case ActivityType.Created:
        writer.writeByte(0);
        break;
      case ActivityType.Updated:
        writer.writeByte(1);
        break;
      case ActivityType.Deleted:
        writer.writeByte(2);
        break;
      case ActivityType.StatusChanged:
        writer.writeByte(3);
        break;
      case ActivityType.Resolved:
        writer.writeByte(4);
        break;
      case ActivityType.Closed:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
