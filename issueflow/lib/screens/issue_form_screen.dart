import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../data/models/issue_model.dart';
import '../providers/issue_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
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

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.issue?.title ?? '');
    _descController = TextEditingController(text: widget.issue?.description ?? '');
    if (widget.issue != null) {
      _selectedPriority = widget.issue!.priority;
      _selectedStatus = widget.issue!.status;
      
      // Ensure the assignee exists in the list, otherwise leave it null or map to Unassigned
      if (widget.issue!.assignee != null && AppConstants.assignees.contains(widget.issue!.assignee)) {
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
      
      if (widget.issue == null) {
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
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: textColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.issue == null ? 'Create Issue' : 'Edit Issue',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomTextField(
                        controller: _titleController,
                        labelText: 'Title',
                        validator: (value) => value == null || value.isEmpty ? 'Title is required' : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _descController,
                        labelText: 'Description',
                        maxLines: 4,
                        validator: (value) => value == null || value.isEmpty ? 'Description is required' : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<IssuePriority>(
                        initialValue: _selectedPriority,
                        decoration: const InputDecoration(labelText: 'Priority'),
                        dropdownColor: Theme.of(context).colorScheme.surface,
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                        items: IssuePriority.values.map((priority) {
                          return DropdownMenuItem(
                            value: priority,
                            child: Text(priority.toString().split('.').last),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedPriority = val);
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedAssignee,
                        decoration: const InputDecoration(labelText: 'Assignee'),
                        dropdownColor: Theme.of(context).colorScheme.surface,
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                        items: AppConstants.assignees.map((assignee) {
                          return DropdownMenuItem(
                            value: assignee,
                            child: Text(assignee),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedAssignee = val);
                        },
                        validator: (value) => value == null || value.isEmpty ? 'Assignee is required' : null,
                      ),
                      const SizedBox(height: 16),
                      if (widget.issue != null) // Only show status if editing
                        DropdownButtonFormField<IssueStatus>(
                          initialValue: _selectedStatus,
                          decoration: const InputDecoration(labelText: 'Status'),
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                          items: IssueStatus.values.map((status) {
                            return DropdownMenuItem(
                              value: status,
                              child: Text(status.toString().split('.').last.replaceAll('In', 'In ')),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedStatus = val);
                          },
                        ),
                      const SizedBox(height: 48),
                      PrimaryButton(
                        text: 'Save Issue',
                        onPressed: _save,
                      ),
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
}
