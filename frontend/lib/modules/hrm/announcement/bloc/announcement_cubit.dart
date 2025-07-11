import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/modules/hrm/announcement/announcement_repository.dart';
import 'package:frontend/modules/hrm/announcement/models/announcement.dart';

class AnnouncementState {
  final List<Announcement> announcements;
  final bool isLoading;
  final String? error;
  final String searchQuery;

  const AnnouncementState({
    this.announcements = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
  });

  AnnouncementState copyWith({
    List<Announcement>? announcements,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return AnnouncementState(
      announcements: announcements ?? this.announcements,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  List<Announcement> get filteredAnnouncements {
    if (searchQuery.isEmpty) return announcements;

    final lowercaseQuery = searchQuery.toLowerCase();
    return announcements.where((announcement) {
      return announcement.title.toLowerCase().contains(lowercaseQuery) ||
          announcement.content.toLowerCase().contains(lowercaseQuery) ||
          announcement.author.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}

class AnnouncementCubit extends Cubit<AnnouncementState> {
  final AnnouncementRepository repository;

  AnnouncementCubit(this.repository) : super(const AnnouncementState()) {
    loadAnnouncements();
  }

  void loadAnnouncements() {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final announcements = repository.activeAnnouncements;
      emit(state.copyWith(announcements: announcements, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void searchAnnouncements(String query) {
    emit(state.copyWith(searchQuery: query.trim()));
  }

  void addAnnouncement(Announcement announcement) {
    try {
      repository.addAnnouncement(announcement);
      loadAnnouncements();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void updateAnnouncement(Announcement announcement) {
    try {
      repository.updateAnnouncement(announcement);
      loadAnnouncements();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void deleteAnnouncement(String id) {
    try {
      repository.deleteAnnouncement(id);
      loadAnnouncements();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void toggleAnnouncementStatus(String id) {
    try {
      repository.toggleAnnouncementStatus(id);
      loadAnnouncements();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }
}
