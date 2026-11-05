import 'package:flutter/foundation.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

/// RemoteConfigService — Lớp dịch vụ bọc Firebase Remote Config SDK
/// View/Screen KHÔNG gọi trực tiếp Remote Config SDK, chỉ gọi qua service này.
///
/// 2 tham số cấu hình từ xa (yêu cầu Lab 3):
/// 1. ai_chat_enabled (bool)   — Bật/tắt tính năng AI Chat
/// 2. max_scan_per_day (int)   — Giới hạn số lần scan nguyên liệu mỗi ngày
class RemoteConfigService {
  RemoteConfigService._();
  static final RemoteConfigService instance = RemoteConfigService._();

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  /// Khởi tạo Remote Config với giá trị mặc định + fetch từ server
  Future<void> initialize() async {
    try {
      // Cấu hình: fetch tối thiểu mỗi 60 giây (dev), production nên 12 giờ
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 60),
      ));

      // Giá trị mặc định khi offline hoặc chưa fetch được
      await _remoteConfig.setDefaults({
        'ai_chat_enabled': true,
        'max_scan_per_day': 10,
      });

      // Tải và kích hoạt cấu hình từ Firebase Console
      await _remoteConfig.fetchAndActivate();

      debugPrint('[RemoteConfigService] Initialized successfully');
      debugPrint('[RemoteConfigService] ai_chat_enabled = $isAiChatEnabled');
      debugPrint('[RemoteConfigService] max_scan_per_day = $maxScanPerDay');
    } catch (e) {
      debugPrint('[RemoteConfigService] Error initializing: $e');
      // Khi lỗi, dùng giá trị mặc định đã set ở trên
    }
  }

  /// Tải lại cấu hình từ server (gọi khi cần refresh)
  Future<void> refresh() async {
    try {
      final updated = await _remoteConfig.fetchAndActivate();
      debugPrint('[RemoteConfigService] Config refreshed, activated=$updated');
    } catch (e) {
      debugPrint('[RemoteConfigService] Error refreshing: $e');
    }
  }

  // -------------------------------------------------------
  // Param 1: ai_chat_enabled — Bật/tắt AI Chat
  // -------------------------------------------------------

  /// Khi false: ẩn tab AI Chat trên bottom nav, hiện thông báo "Tính năng đang bảo trì"
  /// Thay đổi trên Console mà không cần build lại ứng dụng
  bool get isAiChatEnabled => _remoteConfig.getBool('ai_chat_enabled');

  // -------------------------------------------------------
  // Param 2: max_scan_per_day — Giới hạn scan/ngày
  // -------------------------------------------------------

  /// Giới hạn số lần scan nguyên liệu (ảnh/receipt/barcode) mỗi ngày
  /// Khi đạt giới hạn: hiện dialog thông báo
  int get maxScanPerDay => _remoteConfig.getInt('max_scan_per_day');
}

