import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/models/issue_model.dart';

class ExportService {
  /// Export a list of issues as a JSON file and open the share sheet.
  static Future<void> exportAsJson(List<Issue> issues) async {
    final jsonList = issues.map((issue) => {
      'id': issue.id,
      'title': issue.title,
      'description': issue.description,
      'status': issue.status.name,
      'priority': issue.priority.name,
      'assignee': issue.assignee ?? 'Unassigned',
      'createdAt': issue.createdAt.toIso8601String(),
    }).toList();

    final jsonString = const JsonEncoder.withIndent('  ').convert(jsonList);
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/issueflow_export.json';
    final file = File(filePath);
    await file.writeAsString(jsonString);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(filePath, mimeType: 'application/json')],
        subject: 'IssueFlow — Issues Export (JSON)',
      ),
    );
  }

  /// Export a list of issues as a CSV file and open the share sheet.
  static Future<void> exportAsCsv(List<Issue> issues) async {
    final buffer = StringBuffer();

    // CSV header
    buffer.writeln('ID,Title,Description,Status,Priority,Assignee,Created At');

    // CSV rows
    for (final issue in issues) {
      buffer.writeln([
        _escapeCsv(issue.id),
        _escapeCsv(issue.title),
        _escapeCsv(issue.description),
        _escapeCsv(issue.status.name),
        _escapeCsv(issue.priority.name),
        _escapeCsv(issue.assignee ?? 'Unassigned'),
        _escapeCsv(issue.createdAt.toIso8601String()),
      ].join(','));
    }

    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/issueflow_export.csv';
    final file = File(filePath);
    await file.writeAsString(buffer.toString());

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(filePath, mimeType: 'text/csv')],
        subject: 'IssueFlow — Issues Export (CSV)',
      ),
    );
  }

  /// Export a single issue as JSON and open the share sheet.
  static Future<void> exportSingleIssueAsJson(Issue issue) async {
    final jsonMap = {
      'id': issue.id,
      'title': issue.title,
      'description': issue.description,
      'status': issue.status.name,
      'priority': issue.priority.name,
      'assignee': issue.assignee ?? 'Unassigned',
      'createdAt': issue.createdAt.toIso8601String(),
    };

    final jsonString = const JsonEncoder.withIndent('  ').convert(jsonMap);
    final directory = await getTemporaryDirectory();
    final idSlug = issue.id.length > 8 ? issue.id.substring(0, 8) : issue.id;
    final filePath = '${directory.path}/issue_$idSlug.json';
    final file = File(filePath);
    await file.writeAsString(jsonString);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(filePath, mimeType: 'application/json')],
        subject: 'IssueFlow — ${issue.title}',
      ),
    );
  }

  /// Escape a value for CSV (wrap in quotes if it contains commas, quotes, or newlines).
  static String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}
