import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/core/utils/debug_utils.dart';

enum AppStatus { splash, language, org, login, home }

class AppState {
  final AppStatus status;
  final String? token;
  final String? language;
  final String? orgCode;
  final bool isInitialized; // Add flag to track initialization

  const AppState({
    required this.status,
    this.token,
    this.language,
    this.orgCode,
    this.isInitialized = false,
  });

  AppState copyWith({
    AppStatus? status,
    String? token,
    String? language,
    String? orgCode,
    bool? isInitialized,
  }) {
    return AppState(
      status: status ?? this.status,
      token: token ?? this.token,
      language: language ?? this.language,
      orgCode: orgCode ?? this.orgCode,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

class AppStateCubit extends Cubit<AppState> {
  bool _isRestoring = false;

  AppStateCubit() : super(const AppState(status: AppStatus.splash)) {
    DebugUtils.logBlocEvent('AppStateCubit', 'initialized');
    restoreState();
  }

  Future<void> restoreState() async {
    if (_isRestoring) {
      DebugUtils.logBlocEvent(
        'AppStateCubit',
        'restoreState skipped - already restoring',
      );
      return;
    }

    _isRestoring = true;
    DebugUtils.logBlocEvent('AppStateCubit', 'restoreState started');

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final language = prefs.getString('language');
      final orgCode = prefs.getString('orgCode');

      DebugUtils.logBlocEvent(
        'AppStateCubit',
        'restoreState data',
        'token=${token != null ? "***" : "null"}, language=$language, orgCode=$orgCode',
      );

      // Add delay to prevent immediate navigation
      await Future.delayed(const Duration(milliseconds: 500));

      if (!isClosed) {
        // Check if cubit is still active
        AppStatus newStatus;
        if (token != null) {
          newStatus = AppStatus.home;
        } else if (language != null) {
          newStatus = AppStatus.org;
        } else {
          newStatus = AppStatus.language;
        }

        DebugUtils.logStateChange(
          'AppStateCubit',
          state.status.toString(),
          newStatus.toString(),
        );

        emit(
          AppState(
            status: newStatus,
            token: token,
            language: language,
            orgCode: orgCode,
            isInitialized: true,
          ),
        );
      }
    } catch (e) {
      DebugUtils.logBlocEvent(
        'AppStateCubit',
        'restoreState error',
        e.toString(),
      );
      if (!isClosed) {
        emit(const AppState(status: AppStatus.language, isInitialized: true));
      }
    } finally {
      _isRestoring = false;
      DebugUtils.logBlocEvent('AppStateCubit', 'restoreState completed');
    }
  }

  Future<void> setToken(String token) async {
    if (_isRestoring) {
      DebugUtils.logBlocEvent(
        'AppStateCubit',
        'setToken skipped - restoring in progress',
      );
      return;
    }

    DebugUtils.logBlocEvent('AppStateCubit', 'setToken called');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.remove(
      'last_visited_route',
    ); // ลบ route ล่าสุดทุกครั้งที่ login

    DebugUtils.logStateChange(
      'AppStateCubit',
      state.status.toString(),
      AppStatus.home.toString(),
    );
    emit(
      state.copyWith(status: AppStatus.home, token: token, isInitialized: true),
    );
  }

  Future<void> setLanguage(String language) async {
    if (_isRestoring) {
      DebugUtils.logBlocEvent(
        'AppStateCubit',
        'setLanguage skipped - restoring in progress',
      );
      return;
    }

    DebugUtils.logBlocEvent('AppStateCubit', 'setLanguage called', language);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);

    DebugUtils.logStateChange(
      'AppStateCubit',
      state.status.toString(),
      AppStatus.org.toString(),
    );
    emit(
      state.copyWith(
        status: AppStatus.org,
        language: language,
        isInitialized: true,
      ),
    );
  }

  Future<void> setOrgCode(String orgCode) async {
    if (_isRestoring) {
      DebugUtils.logBlocEvent(
        'AppStateCubit',
        'setOrgCode skipped - restoring in progress',
      );
      return;
    }

    DebugUtils.logBlocEvent('AppStateCubit', 'setOrgCode called', orgCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('orgCode', orgCode);

    emit(state.copyWith(orgCode: orgCode, isInitialized: true));
  }

  Future<void> logout() async {
    DebugUtils.logBlocEvent('AppStateCubit', 'logout called');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove(
      'last_visited_route',
    ); // ลบ route ล่าสุดทุกครั้งที่ logout

    DebugUtils.logStateChange(
      'AppStateCubit',
      state.status.toString(),
      AppStatus.login.toString(),
    );
    emit(
      state.copyWith(status: AppStatus.login, token: null, isInitialized: true),
    );
  }
}
