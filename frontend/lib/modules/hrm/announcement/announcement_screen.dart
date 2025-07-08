import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:frontend/core/theme/sun_theme.dart';
import 'package:frontend/widgets/responsive_card_grid.dart';
import 'package:frontend/core/theme/widget_styles.dart';
import 'widgets/announcement_card.dart';
import 'widgets/announcement_search_bar.dart';
import 'widgets/add_announcement_dialog.dart';
import 'bloc/announcement_cubit.dart';
import 'models/announcement.dart';

class AnnouncementScreen extends StatelessWidget {
  const AnnouncementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _AnnouncementScreenView(l10n: l10n);
  }
}

class _AnnouncementScreenView extends StatefulWidget {
  final AppLocalizations l10n;
  const _AnnouncementScreenView({required this.l10n});

  @override
  State<_AnnouncementScreenView> createState() =>
      _AnnouncementScreenViewState();
}

class _AnnouncementScreenViewState extends State<_AnnouncementScreenView> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.l10n.localeName == 'th' ? 'ประกาศ' : 'Announcements',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AnnouncementSearchBar(
              value: _searchQuery,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                context.read<AnnouncementCubit>().searchAnnouncements(value);
              },
              onClear: () {
                setState(() {
                  _searchQuery = '';
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<AnnouncementCubit, AnnouncementState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.l10n.localeName == 'th'
                                ? 'เกิดข้อผิดพลาด'
                                : 'An error occurred',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.error!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<AnnouncementCubit>().clearError();
                              context
                                  .read<AnnouncementCubit>()
                                  .loadAnnouncements();
                            },
                            child: Text(
                              widget.l10n.localeName == 'th'
                                  ? 'ลองอีกครั้ง'
                                  : 'Try again',
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final announcements = state.filteredAnnouncements;

                  if (announcements.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.announcement_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isNotEmpty
                                ? (widget.l10n.localeName == 'th'
                                      ? 'ไม่พบประกาศที่ค้นหา'
                                      : 'No announcements found')
                                : (widget.l10n.localeName == 'th'
                                      ? 'ยังไม่มีประกาศ'
                                      : 'No announcements yet'),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _searchQuery.isNotEmpty
                                ? (widget.l10n.localeName == 'th'
                                      ? 'ลองค้นหาด้วยคำอื่น'
                                      : 'Try searching with different keywords')
                                : (widget.l10n.localeName == 'th'
                                      ? 'กดปุ่ม + เพื่อเพิ่มประกาศใหม่'
                                      : 'Tap + to add a new announcement'),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    );
                  }

                  return ResponsiveCardGrid(
                    cardHeight: WidgetStyles.cardHeightLarge,
                    children: announcements
                        .map(
                          (announcement) => AnnouncementCard(
                            announcement: announcement,
                            onEdit: () => _showEditDialog(announcement),
                            onDelete: () =>
                                _deleteAnnouncement(announcement.id),
                            onTap: () => _showAnnouncementDetail(announcement),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: SunTheme.sunOrange,
        tooltip: widget.l10n.localeName == 'th'
            ? 'เพิ่มประกาศ'
            : 'Add Announcement',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog() async {
    final cubit = context.read<AnnouncementCubit>();
    await showDialog(
      context: context,
      builder: (dialogContext) => AddAnnouncementDialog(
        onSave: (announcement) async {
          cubit.addAnnouncement(announcement);
          _showSuccessMessage(
            'เพิ่มประกาศสำเร็จ',
            'Announcement added successfully',
          );
        },
      ),
    );
  }

  void _showEditDialog(Announcement announcement) async {
    final cubit = context.read<AnnouncementCubit>();
    await showDialog(
      context: context,
      builder: (dialogContext) => AddAnnouncementDialog(
        initial: announcement,
        onSave: (updatedAnnouncement) async {
          cubit.updateAnnouncement(updatedAnnouncement);
          _showSuccessMessage(
            'แก้ไขประกาศสำเร็จ',
            'Announcement updated successfully',
          );
        },
      ),
    );
  }

  void _deleteAnnouncement(String id) {
    context.read<AnnouncementCubit>().deleteAnnouncement(id);
    _showSuccessMessage('ลบประกาศสำเร็จ', 'Announcement deleted successfully');
  }

  void _showAnnouncementDetail(Announcement announcement) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(announcement.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(announcement.content),
              const SizedBox(height: 16),
              Divider(color: Colors.grey[300]),
              const SizedBox(height: 8),
              _buildDetailRow(
                Icons.person,
                widget.l10n.localeName == 'th' ? 'ผู้ประกาศ:' : 'Author:',
                announcement.author,
              ),
              const SizedBox(height: 4),
              _buildDetailRow(
                Icons.access_time,
                widget.l10n.localeName == 'th' ? 'วันที่ประกาศ:' : 'Created:',
                _formatDateTime(announcement.createdDate),
              ),
              if (announcement.lastModified != null) ...[
                const SizedBox(height: 4),
                _buildDetailRow(
                  Icons.edit,
                  widget.l10n.localeName == 'th'
                      ? 'แก้ไขล่าสุด:'
                      : 'Last modified:',
                  _formatDateTime(announcement.lastModified!),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(widget.l10n.localeName == 'th' ? 'ปิด' : 'Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(value, style: TextStyle(color: Colors.grey[600])),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _showSuccessMessage(String thaiMessage, String englishMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.l10n.localeName == 'th' ? thaiMessage : englishMessage,
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
