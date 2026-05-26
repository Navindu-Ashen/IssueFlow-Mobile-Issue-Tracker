// ignore_for_file: constant_identifier_names
import 'package:hive/hive.dart';

part 'activity_model.g.dart';

@HiveType(typeId: 5)
enum ActivityType {
  @HiveField(0)
  Created,

  @HiveField(1)
  Updated,

  @HiveField(2)
  Deleted,

  @HiveField(3)
  StatusChanged,

  @HiveField(4)
  Resolved,

  @HiveField(5)
  Closed,
}

@HiveType(typeId: 4)
class Activity {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final ActivityType type;

  @HiveField(2)
  final String issueTitle;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final DateTime timestamp;

  Activity({
    required this.id,
    required this.type,
    required this.issueTitle,
    required this.description,
    required this.timestamp,
  });
}
