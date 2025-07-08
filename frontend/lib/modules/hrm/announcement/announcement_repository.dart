import 'package:flutter/foundation.dart';
import 'models/announcement.dart';

class AnnouncementRepository extends ChangeNotifier {
  final List<Announcement> _announcements = [
    Announcement(
      id: 'ANN_001',
      title: 'ประกาศวันหยุดประจำปี 2025',
      content: 'บริษัทจะหยุดทำการวันที่ 12-15 เมษายน 2025 เนื่องในวันสงกรานต์',
      createdDate: DateTime(2025, 7, 1),
      author: 'HR Department',
      priority: AnnouncementPriority.high,
    ),
    Announcement(
      id: 'ANN_002',
      title: 'การอบรมความปลอดภัย',
      content: 'กำหนดจัดการอบรมความปลอดภัยในการทำงาน วันที่ 20 กรกฎาคม 2025',
      createdDate: DateTime(2025, 7, 5),
      author: 'Safety Committee',
      priority: AnnouncementPriority.medium,
    ),
    Announcement(
      id: 'ANN_003',
      title: 'อัปเดตระบบ IT',
      content:
          'ระบบจะปรับปรุงในวันเสาร์ที่ 15 กรกฎาคม 2025 เวลา 18:00-22:00 น.',
      createdDate: DateTime(2025, 7, 8),
      author: 'IT Department',
      priority: AnnouncementPriority.low,
    ),
  ];

  List<Announcement> get announcements => List.unmodifiable(_announcements);

  List<Announcement> get activeAnnouncements =>
      _announcements.where((announcement) => announcement.isActive).toList();

  String _generateAnnouncementId() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch;
    return 'ANN_$timestamp';
  }

  void addAnnouncement(Announcement announcement) {
    // Generate unique ID if not provided
    String uniqueId = announcement.id;
    if (announcement.id.isEmpty ||
        _announcements.any((a) => a.id == announcement.id)) {
      uniqueId = _generateAnnouncementId();
    }

    final newAnnouncement = announcement.copyWith(
      id: uniqueId,
      createdDate: DateTime.now(),
    );

    _announcements.insert(
      0,
      newAnnouncement,
    ); // Insert at beginning for latest first
    notifyListeners();
  }

  void updateAnnouncement(Announcement announcement) {
    final index = _announcements.indexWhere((a) => a.id == announcement.id);
    if (index != -1) {
      _announcements[index] = announcement.copyWith(
        lastModified: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void deleteAnnouncement(String id) {
    _announcements.removeWhere((announcement) => announcement.id == id);
    notifyListeners();
  }

  void toggleAnnouncementStatus(String id) {
    final index = _announcements.indexWhere((a) => a.id == id);
    if (index != -1) {
      _announcements[index] = _announcements[index].copyWith(
        isActive: !_announcements[index].isActive,
        lastModified: DateTime.now(),
      );
      notifyListeners();
    }
  }

  List<Announcement> searchAnnouncements(String query) {
    if (query.isEmpty) return activeAnnouncements;

    final lowercaseQuery = query.toLowerCase();
    return activeAnnouncements.where((announcement) {
      return announcement.title.toLowerCase().contains(lowercaseQuery) ||
          announcement.content.toLowerCase().contains(lowercaseQuery) ||
          announcement.author.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  List<Announcement> getAnnouncementsByPriority(AnnouncementPriority priority) {
    return activeAnnouncements
        .where((announcement) => announcement.priority == priority)
        .toList();
  }

  List<Announcement> getAnnouncementsByAuthor(String author) {
    return activeAnnouncements
        .where(
          (announcement) =>
              announcement.author.toLowerCase().contains(author.toLowerCase()),
        )
        .toList();
  }

  Announcement? getAnnouncementById(String id) {
    try {
      return _announcements.firstWhere((announcement) => announcement.id == id);
    } catch (e) {
      return null;
    }
  }
}
