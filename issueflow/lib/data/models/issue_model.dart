// ignore_for_file: constant_identifier_names
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'issue_model.g.dart';

@HiveType(typeId: 0)
enum IssueStatus {
  @HiveField(0)
  @JsonValue('Open')
  Open,
  @HiveField(1)
  @JsonValue('In Progress')
  InProgress,
  @HiveField(2)
  @JsonValue('Resolved')
  Resolved,
  @HiveField(3)
  @JsonValue('Closed')
  Closed,
}

@HiveType(typeId: 1)
enum IssuePriority {
  @HiveField(0)
  @JsonValue('Low')
  Low,
  @HiveField(1)
  @JsonValue('Medium')
  Medium,
  @HiveField(2)
  @JsonValue('High')
  High,
}

@HiveType(typeId: 2)
enum SyncStatus {
  @HiveField(0)
  @JsonValue('Synced')
  Synced,
  @HiveField(1)
  @JsonValue('Pending Create')
  PendingCreate,
  @HiveField(2)
  @JsonValue('Pending Update')
  PendingUpdate,
  @HiveField(3)
  @JsonValue('Pending Delete')
  PendingDelete,
}

@HiveType(typeId: 3)
@JsonSerializable()
class Issue {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final IssueStatus status;

  @HiveField(4)
  final IssuePriority priority;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final String? assignee;

  @HiveField(7)
  SyncStatus syncStatus;

  Issue({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.createdAt,
    this.assignee,
    this.syncStatus = SyncStatus.Synced,
  });

  Issue copyWith({
    String? id,
    String? title,
    String? description,
    IssueStatus? status,
    IssuePriority? priority,
    DateTime? createdAt,
    String? assignee,
    SyncStatus? syncStatus,
  }) {
    return Issue(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      assignee: assignee ?? this.assignee,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  factory Issue.fromJson(Map<String, dynamic> json) => _$IssueFromJson(json);
  Map<String, dynamic> toJson() => _$IssueToJson(this);
}
