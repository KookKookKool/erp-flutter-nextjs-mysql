import 'package:flutter/material.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:frontend/core/theme/sun_theme.dart';
import '../models/announcement.dart';

class AddAnnouncementDialog extends StatefulWidget {
  final Future<void> Function(Announcement announcement) onSave;
  final Announcement? initial;

  const AddAnnouncementDialog({super.key, required this.onSave, this.initial});

  @override
  State<AddAnnouncementDialog> createState() => _AddAnnouncementDialogState();
}

class _AddAnnouncementDialogState extends State<AddAnnouncementDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _authorController = TextEditingController();

  AnnouncementPriority _selectedPriority = AnnouncementPriority.medium;

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      _titleController.text = widget.initial!.title;
      _contentController.text = widget.initial!.content;
      _authorController.text = widget.initial!.author;
      _selectedPriority = widget.initial!.priority;
    } else {
      // Set default author
      _authorController.text = 'HR Department';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      backgroundColor: SunTheme.cardColor,
      title: Text(
        widget.initial == null
            ? (l10n.localeName == 'th' ? 'เพิ่มประกาศ' : 'Add Announcement')
            : (l10n.localeName == 'th' ? 'แก้ไขประกาศ' : 'Edit Announcement'),
        style: TextStyle(color: SunTheme.textPrimary),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: l10n.localeName == 'th' ? 'หัวข้อ' : 'Title',
                  labelStyle: TextStyle(color: SunTheme.textPrimary),
                  prefixIcon: Icon(Icons.title, color: SunTheme.primary),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: SunTheme.primary),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: SunTheme.cardColor),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.localeName == 'th'
                        ? 'กรุณากรอกหัวข้อ'
                        : 'Please enter title';
                  }
                  return null;
                },
                maxLength: 100,
              ),
              const SizedBox(height: 16),

              // Content field
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: l10n.localeName == 'th' ? 'เนื้อหา' : 'Content',
                  labelStyle: TextStyle(color: SunTheme.textPrimary),
                  prefixIcon: Icon(Icons.description, color: SunTheme.primary),
                  alignLabelWithHint: true,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: SunTheme.primary),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: SunTheme.cardColor),
                  ),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.localeName == 'th'
                        ? 'กรุณากรอกเนื้อหา'
                        : 'Please enter content';
                  }
                  return null;
                },
                maxLength: 500,
              ),
              const SizedBox(height: 16),

              // Author field
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(
                  labelText: l10n.localeName == 'th' ? 'ผู้ประกาศ' : 'Author',
                  labelStyle: TextStyle(color: SunTheme.textPrimary),
                  prefixIcon: Icon(Icons.person, color: SunTheme.primary),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: SunTheme.primary),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: SunTheme.cardColor),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.localeName == 'th'
                        ? 'กรุณากรอกผู้ประกาศ'
                        : 'Please enter author';
                  }
                  return null;
                },
                maxLength: 50,
              ),
              const SizedBox(height: 16),

              // Priority dropdown
              DropdownButtonFormField<AnnouncementPriority>(
                value: _selectedPriority,
                decoration: InputDecoration(
                  labelText: l10n.localeName == 'th' ? 'ความสำคัญ' : 'Priority',
                  labelStyle: TextStyle(color: SunTheme.textPrimary),
                  prefixIcon: Icon(Icons.flag, color: SunTheme.primary),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: SunTheme.primary),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: SunTheme.cardColor),
                  ),
                ),
                items: AnnouncementPriority.values.map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Row(
                      children: [
                        Icon(
                          _getPriorityIcon(priority),
                          color: _getPriorityColor(priority),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(priority.getDisplayName(l10n.localeName)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedPriority = value;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel, style: TextStyle(color: SunTheme.primary)),
        ),
        ElevatedButton(
          onPressed: _saveAnnouncement,
          style: ElevatedButton.styleFrom(
            backgroundColor: SunTheme.primary,
            foregroundColor: SunTheme.onPrimary,
          ),
          child: Text(l10n.save, style: TextStyle(color: SunTheme.onPrimary)),
        ),
      ],
    );
  }

  void _saveAnnouncement() async {
    if (_formKey.currentState!.validate()) {
      try {
        final announcement = Announcement(
          id: widget.initial?.id ?? '',
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          author: _authorController.text.trim(),
          priority: _selectedPriority,
          createdDate: widget.initial?.createdDate ?? DateTime.now(),
          lastModified: widget.initial != null ? DateTime.now() : null,
        );

        await widget.onSave(announcement);

        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.localeName == 'th'
                    ? 'เกิดข้อผิดพลาด: ${e.toString()}'
                    : 'Error: ${e.toString()}',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  IconData _getPriorityIcon(AnnouncementPriority priority) {
    switch (priority) {
      case AnnouncementPriority.high:
        return Icons.priority_high;
      case AnnouncementPriority.medium:
        return Icons.info;
      case AnnouncementPriority.low:
        return Icons.info_outline;
    }
  }

  Color _getPriorityColor(AnnouncementPriority priority) {
    switch (priority) {
      case AnnouncementPriority.high:
        return Colors.red;
      case AnnouncementPriority.medium:
        return Colors.orange;
      case AnnouncementPriority.low:
        return Colors.blue;
    }
  }
}
