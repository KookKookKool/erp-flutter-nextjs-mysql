import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppStatus { splash, language, org, login, home }

class AppState {
  final AppStatus status;
  final String? token;
  final String? language;
  final String? orgCode;
  const AppState({
    required this.status,
    this.token,
    this.language,
    this.orgCode,
  });

  AppState copyWith({
    AppStatus? status,
    String? token,
    String? language,
    String? orgCode,
  }) {
    return AppState(
      status: status ?? this.status,
      token: token ?? this.token,
      language: language ?? this.language,
      orgCode: orgCode ?? this.orgCode,
    );
  }
}

class AppStateCubit extends Cubit<AppState> {
  AppStateCubit() : super(const AppState(status: AppStatus.splash)) {
    restoreState();
  }

  Future<void> restoreState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final language = prefs.getString('language');
      final orgCode = prefs.getString('orgCode');
      print(
        '[AppStateCubit] restoreState: token=$token, language=$language, orgCode=$orgCode',
      );
      if (token != null) {
        emit(
          AppState(
            status: AppStatus.home,
            token: token,
            language: language,
            orgCode: orgCode,
          ),
        );
      } else if (language != null) {
        emit(AppState(status: AppStatus.org, language: language));
      } else {
        emit(const AppState(status: AppStatus.language));
      }
    } catch (e) {
      print('[AppStateCubit] restoreState error: $e');
      emit(const AppState(status: AppStatus.language));
    }
  }

  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    emit(state.copyWith(status: AppStatus.home, token: token));
  }

  Future<void> setLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    emit(state.copyWith(status: AppStatus.org, language: language));
  }

  Future<void> setOrgCode(String orgCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('orgCode', orgCode);
    emit(state.copyWith(orgCode: orgCode));
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    emit(state.copyWith(status: AppStatus.login, token: null));
  }
}
