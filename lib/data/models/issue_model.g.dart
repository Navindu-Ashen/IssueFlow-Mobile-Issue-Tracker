// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IssueAdapter extends TypeAdapter<Issue> {
  @override
  final int typeId = 3;

  @override
  Issue read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Issue(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      status: fields[3] as IssueStatus,
      priority: fields[4] as IssuePriority,
      createdAt: fields[5] as DateTime,
      assignee: fields[6] as String?,
      syncStatus: fields[7] as SyncStatus,
    );
  }

  @override
  void write(BinaryWriter writer, Issue obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.priority)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.assignee)
      ..writeByte(7)
      ..write(obj.syncStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssueAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IssueStatusAdapter extends TypeAdapter<IssueStatus> {
  @override
  final int typeId = 0;

  @override
  IssueStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return IssueStatus.Open;
      case 1:
        return IssueStatus.InProgress;
      case 2:
        return IssueStatus.Resolved;
      case 3:
        return IssueStatus.Closed;
      default:
        return IssueStatus.Open;
    }
  }

  @override
  void write(BinaryWriter writer, IssueStatus obj) {
    switch (obj) {
      case IssueStatus.Open:
        writer.writeByte(0);
        break;
      case IssueStatus.InProgress:
        writer.writeByte(1);
        break;
      case IssueStatus.Resolved:
        writer.writeByte(2);
        break;
      case IssueStatus.Closed:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssueStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IssuePriorityAdapter extends TypeAdapter<IssuePriority> {
  @override
  final int typeId = 1;

  @override
  IssuePriority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return IssuePriority.Low;
      case 1:
        return IssuePriority.Medium;
      case 2:
        return IssuePriority.High;
      default:
        return IssuePriority.Low;
    }
  }

  @override
  void write(BinaryWriter writer, IssuePriority obj) {
    switch (obj) {
      case IssuePriority.Low:
        writer.writeByte(0);
        break;
      case IssuePriority.Medium:
        writer.writeByte(1);
        break;
      case IssuePriority.High:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssuePriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SyncStatusAdapter extends TypeAdapter<SyncStatus> {
  @override
  final int typeId = 2;

  @override
  SyncStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SyncStatus.Synced;
      case 1:
        return SyncStatus.PendingCreate;
      case 2:
        return SyncStatus.PendingUpdate;
      case 3:
        return SyncStatus.PendingDelete;
      default:
        return SyncStatus.Synced;
    }
  }

  @override
  void write(BinaryWriter writer, SyncStatus obj) {
    switch (obj) {
      case SyncStatus.Synced:
        writer.writeByte(0);
        break;
      case SyncStatus.PendingCreate:
        writer.writeByte(1);
        break;
      case SyncStatus.PendingUpdate:
        writer.writeByte(2);
        break;
      case SyncStatus.PendingDelete:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Issue _$IssueFromJson(Map<String, dynamic> json) => Issue(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: $enumDecode(_$IssueStatusEnumMap, json['status']),
      priority: $enumDecode(_$IssuePriorityEnumMap, json['priority']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      assignee: json['assignee'] as String?,
      syncStatus:
          $enumDecodeNullable(_$SyncStatusEnumMap, json['syncStatus']) ??
              SyncStatus.Synced,
    );

Map<String, dynamic> _$IssueToJson(Issue instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'status': _$IssueStatusEnumMap[instance.status]!,
      'priority': _$IssuePriorityEnumMap[instance.priority]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'assignee': instance.assignee,
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus]!,
    };

const _$IssueStatusEnumMap = {
  IssueStatus.Open: 'Open',
  IssueStatus.InProgress: 'In Progress',
  IssueStatus.Resolved: 'Resolved',
  IssueStatus.Closed: 'Closed',
};

const _$IssuePriorityEnumMap = {
  IssuePriority.Low: 'Low',
  IssuePriority.Medium: 'Medium',
  IssuePriority.High: 'High',
};

const _$SyncStatusEnumMap = {
  SyncStatus.Synced: 'Synced',
  SyncStatus.PendingCreate: 'Pending Create',
  SyncStatus.PendingUpdate: 'Pending Update',
  SyncStatus.PendingDelete: 'Pending Delete',
};
