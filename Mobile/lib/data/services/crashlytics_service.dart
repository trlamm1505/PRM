import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// CrashlyticsService — Lớp dịch vụ bọc Firebase Crashlytics SDK
/// View/Screen KHÔNG gọi trực tiếp Crashlytics SDK, chỉ gọi qua service này.
class CrashlyticsService {
  CrashlyticsService._();
  static final CrashlyticsService instance = CrashlyticsService._();

  FirebaseCrashlytics get _crashlytics => FirebaseCrashlytics.instance;

  /// Khởi tạo Crashlytics — gọi trong main() trước runApp
  /// Thiết lập FlutterError.onError và PlatformDispatcher.onError
  Future<void> initialize() async {
    // Bắt lỗi Flutter framework (widget build errors, etc.)
    FlutterError.onError = (errorDetails) {
      debugPrint('[CrashlyticsService] FlutterError caught: ${errorDetails.exceptionAsString()}');
      _crashlytics.recordFlutterFatalError(errorDetails);
    };

    // Bắt lỗi async không được catch (PlatformDispatcher)
    PlatformDispatcher.instance.onError = (error, stack) {
      debugPrint('[CrashlyticsService] PlatformDispatcher error: $error');
      _crashlytics.recordError(error, stack, fatal: true);
      return true;
    };

    debugPrint('[CrashlyticsService] Initialized successfully');
  }

  /// Gắn user ID vào Crashlytics (gọi sau khi đăng nhập)
  Future<void> setUserIdentifier(String userId) async {
    await _crashlytics.setUserIdentifier(userId);
    debugPrint('[CrashlyticsService] User ID set: $userId');
  }

  /// Xóa user ID khi đăng xuất
  Future<void> clearUserIdentifier() async {
    await _crashlytics.setUserIdentifier('');
    debugPrint('[CrashlyticsService] User ID cleared');
  }

  /// Gắn custom key để chẩn đoán lỗi
  Future<void> setCustomKey(String key, Object value) async {
    await _crashlytics.setCustomKey(key, value);
    debugPrint('[CrashlyticsService] Custom key set: $key = $value');
  }

  /// Ghi log message vào Crashlytics (xuất hiện trong breadcrumbs)
  Future<void> log(String message) async {
    await _crashlytics.log(message);
  }

  /// Ghi nhận lỗi không gây dừng ứng dụng (non-fatal error)
  /// Dùng khi catch được exception trong luồng thực tế (API fail, parse error, etc.)
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    String? reason,
    bool fatal = false,
  }) async {
    debugPrint('[CrashlyticsService] Recording ${fatal ? "fatal" : "non-fatal"} error: $exception');
    await _crashlytics.recordError(
      exception,
      stack,
      reason: reason ?? 'Non-fatal error',
      fatal: fatal,
    );
  }

  /// Crash thử nghiệm có chủ đích — CHỈ DÙNG TRONG KHU VỰC TRÌNH DIỄN
  /// Không kích hoạt trong quá trình sử dụng thông thường
  void triggerTestCrash() {
    debugPrint('[CrashlyticsService] ⚠️ Triggering test crash...');
    _crashlytics.crash();
  }
}

