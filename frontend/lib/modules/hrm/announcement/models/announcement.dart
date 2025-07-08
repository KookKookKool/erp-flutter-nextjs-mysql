class Announcement {
  final String id;
  final String title;
  final String content;
  final DateTime createdDate;
  final DateTime? lastModified;
  final String author;
  final AnnouncementPriority priority;
  final bool isActive;

  const Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.createdDate,
    this.lastModified,
    required this.author,
    this.priority = AnnouncementPriority.medium,
    this.isActive = true,
  });

  Announcement copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdDate,
    DateTime? lastModified,
    String? author,
    AnnouncementPriority? priority,
    bool? isActive,
  }) {
    return Announcement(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdDate: createdDate ?? this.createdDate,
      lastModified: lastModified ?? this.lastModified,
      author: author ?? this.author,
      priority: priority ?? this.priority,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdDate': createdDate.toIso8601String(),
      'lastModified': lastModified?.toIso8601String(),
      'author': author,
      'priority': priority.name,
      'isActive': isActive,
    };
  }

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdDate: DateTime.parse(json['createdDate']),
      lastModified: json['lastModified'] != null
          ? DateTime.parse(json['lastModified'])
          : null,
      author: json['author'],
      priority: AnnouncementPriority.values.firstWhere(
        (p) => p.name == json['priority'],
        orElse: () => AnnouncementPriority.medium,
      ),
      isActive: json['isActive'] ?? true,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Announcement && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Announcement(id: $id, title: $title, author: $author, priority: $priority)';
  }
}

enum AnnouncementPriority {
  high,
  medium,
  low;

  String getDisplayName(String locale) {
    switch (this) {
      case AnnouncementPriority.high:
        return locale == 'th' ? 'สูง' : 'High';
      case AnnouncementPriority.medium:
        return locale == 'th' ? 'ปานกลาง' : 'Medium';
      case AnnouncementPriority.low:
        return locale == 'th' ? 'ต่ำ' : 'Low';
    }
  }
}
