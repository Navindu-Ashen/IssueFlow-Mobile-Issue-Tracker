import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../data/models/issue_model.dart';
import '../providers/issue_provider.dart';
import '../core/constants/app_constants.dart';

class IssueFormScreen extends StatefulWidget {
  final Issue? issue; // If null, create. If provided, edit.

  const IssueFormScreen({super.key, this.issue});

  @override
  State<IssueFormScreen> createState() => _IssueFormScreenState();
}

class _IssueFormScreenState extends State<IssueFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  IssuePriority _selectedPriority = IssuePriority.Medium;
  IssueStatus _selectedStatus = IssueStatus.Open;
  String? _selectedAssignee;

  bool get _isEditing => widget.issue != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.issue?.title ?? '');
    _descController =
        TextEditingController(text: widget.issue?.description ?? '');
    if (_isEditing) {
      _selectedPriority = widget.issue!.priority;
      _selectedStatus = widget.issue!.status;

      // Ensure the assignee exists in the list, otherwise leave it null or map to Unassigned
      if (widget.issue!.assignee != null &&
          AppConstants.assignees.contains(widget.issue!.assignee)) {
        _selectedAssignee = widget.issue!.assignee;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<IssueProvider>();

      if (!_isEditing) {
        // Create
        final newIssue = Issue(
          id: const Uuid().v4(),
          title: _titleController.text,
          description: _descController.text,
          status: _selectedStatus,
          priority: _selectedPriority,
          assignee: _selectedAssignee,
          createdAt: DateTime.now(),
        );
        await provider.addIssue(newIssue);
      } else {
        // Update
        final updatedIssue = widget.issue!.copyWith(
          title: _titleController.text,
          description: _descController.text,
          status: _selectedStatus,
          priority: _selectedPriority,
          assignee: _selectedAssignee,
        );
        await provider.updateIssue(updatedIssue);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textColor = colorScheme.onSurface;
    final surfaceColor = colorScheme.surface;
    final primaryColor = colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;
    final borderColor =
        isDark ? const Color(0xFF27272A) : const Color(0xFFE4E4E7);
    final mutedTextColor = textColor.withValues(alpha: 0.55);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header ───────────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isEditing ? 'Edit Issue' : 'Create Issue',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: mutedTextColor,
                              fontSize: 13,
                              height: 1.4,
                            ),
                            children: _isEditing
                                ? [
                                    const TextSpan(
                                        text:
                                            'Update the issue details below.'),
                                  ]
                                : [
                                    const TextSpan(
                                        text:
                                            'Add a new issue to the tracker. New issues are created with '),
                                    TextSpan(
                                      text: 'Open',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: textColor,
                                      ),
                                    ),
                                    const TextSpan(text: ' status.'),
                                  ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, color: textColor, size: 22),
                  ),
                ],
              ),
            ),

            // ─── Form Body ────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Title ────────────────────────────────
                      _FieldLabel(text: 'Title'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          hintText: 'Issue title',
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Title is required'
                            : null,
                      ),
                      const SizedBox(height: 20),

                      // ── Description ──────────────────────────
                      _FieldLabel(text: 'Description'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          hintText: 'Describe the issue...',
                          alignLabelWithHint: true,
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Description is required'
                            : null,
                      ),
                      const SizedBox(height: 24),

                      // ── Priority Chips ───────────────────────
                      _FieldLabel(text: 'Priority'),
                      const SizedBox(height: 10),
                      Row(
                        children: IssuePriority.values.map((p) {
                          final isSelected = _selectedPriority == p;
                          final label = p.toString().split('.').last;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedPriority = p),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? primaryColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color:
                                        isSelected ? primaryColor : borderColor,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  label,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: isSelected
                                        ? Colors.white
                                        : textColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // ── Status Chips (edit mode only) ────────
                      if (_isEditing) ...[
                        _FieldLabel(text: 'Status'),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: IssueStatus.values.map((s) {
                            final isSelected = _selectedStatus == s;
                            final label = _statusLabel(s);
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedStatus = s),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? primaryColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color:
                                        isSelected ? primaryColor : borderColor,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  label,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: isSelected
                                        ? Colors.white
                                        : textColor,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // ── Assignee Cards ───────────────────────
                      _FieldLabel(text: 'Assignee'),
                      const SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 2.4,
                        ),
                        itemCount: AppConstants.assigneeDetails.length,
                        itemBuilder: (context, index) {
                          final detail = AppConstants.assigneeDetails[index];
                          final name = detail['name']!;
                          final role = detail['role']!;
                          final subtitle = detail['subtitle']!;
                          final isSelected = _selectedAssignee == name;

                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedAssignee = name),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: surfaceColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected
                                      ? primaryColor
                                      : borderColor,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          role,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: textColor,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          subtitle,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: mutedTextColor,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Radio-style indicator
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? primaryColor
                                            : borderColor,
                                        width: isSelected ? 2 : 1.5,
                                      ),
                                    ),
                                    child: isSelected
                                        ? Center(
                                            child: Container(
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: primaryColor,
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 32),

                      // ── Action Buttons ───────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: _save,
                            child:
                                Text(_isEditing ? 'Save' : 'Create'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(IssueStatus s) {
    switch (s) {
      case IssueStatus.Open:
        return 'Open';
      case IssueStatus.InProgress:
        return 'In Progress';
      case IssueStatus.Resolved:
        return 'Resolved';
      case IssueStatus.Closed:
        return 'Closed';
    }
  }
}

// ─── Reusable field label ──────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
