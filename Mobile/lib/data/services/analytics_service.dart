import 'package:flutter/foundation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

/// AnalyticsService — Lớp dịch vụ bọc Firebase Analytics SDK
/// View/Screen KHÔNG gọi trực tiếp Analytics SDK, chỉ gọi qua service này.
///
/// Kế hoạch sự kiện (≥7 events theo yêu cầu Lab 3):
/// 1. login          — Đăng nhập thành công
/// 2. sign_up        — Đăng ký thành công
/// 3. logout         — Đăng xuất
/// 4. scan_ingredient — Scan ảnh/receipt/barcode
/// 5. add_ingredient  — Thêm nguyên liệu thủ công
/// 6. view_recipe     — Xem chi tiết recipe
/// 7. generate_meal_plan — Tạo thực đơn tuần
/// 8. ai_chat_message — Gửi tin nhắn AI chat
/// 9. upload_file     — Upload file lên Cloudinary
/// 10. view_statistics — Xem thống kê tuần
class AnalyticsService {
  AnalyticsService._();
  static final AnalyticsService instance = AnalyticsService._();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Lấy observer để gắn vào MaterialApp (theo dõi screen tự động)
  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  // -------------------------------------------------------
  // User Identity
  // -------------------------------------------------------

  /// Thiết lập user ID sau đăng nhập — KHÔNG đưa email/tên vào params
  Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
    debugPrint('[AnalyticsService] User ID set: $userId');
  }

  /// Xóa user ID khi đăng xuất
  Future<void> clearUserId() async {
    await _analytics.setUserId(id: null);
    debugPrint('[AnalyticsService] User ID cleared');
  }

  // -------------------------------------------------------
  // Event 1: login — Đăng nhập thành công
  // -------------------------------------------------------

  /// Params: method (google | email | phone)
  /// Câu hỏi sản phẩm: Phương thức đăng nhập nào được ưa chuộng nhất?
  Future<void> logLogin({required String method}) async {
    await _analytics.logLogin(loginMethod: method);
    debugPrint('[AnalyticsService] Event: login (method=$method)');
  }

  // -------------------------------------------------------
  // Event 2: sign_up — Đăng ký thành công
  // -------------------------------------------------------

  /// Params: method (email)
  /// Câu hỏi sản phẩm: Tỷ lệ đăng ký mới theo thời gian?
  Future<void> logSignUp({required String method}) async {
    await _analytics.logSignUp(signUpMethod: method);
    debugPrint('[AnalyticsService] Event: sign_up (method=$method)');
  }

  // -------------------------------------------------------
  // Event 3: logout — Đăng xuất
  // -------------------------------------------------------

  /// Câu hỏi sản phẩm: Tần suất đăng xuất thủ công?
  Future<void> logLogout() async {
    await _analytics.logEvent(name: 'logout');
    debugPrint('[AnalyticsService] Event: logout');
  }

  // -------------------------------------------------------
  // Event 4: scan_ingredient — Scan nguyên liệu
  // -------------------------------------------------------

  /// Params: scan_type (photo | receipt | barcode)
  /// Câu hỏi sản phẩm: Kiểu scan nào được dùng nhiều nhất?
  Future<void> logScanIngredient({required String scanType}) async {
    await _analytics.logEvent(
      name: 'scan_ingredient',
      parameters: {'scan_type': scanType},
    );
    debugPrint('[AnalyticsService] Event: scan_ingredient (scan_type=$scanType)');
  }

  // -------------------------------------------------------
  // Event 5: add_ingredient — Thêm nguyên liệu thủ công
  // -------------------------------------------------------

  /// Params: category, storage_location
  /// Câu hỏi sản phẩm: Loại nguyên liệu nào thêm thủ công nhiều nhất?
  Future<void> logAddIngredient({
    required String category,
    required String storageLocation,
  }) async {
    await _analytics.logEvent(
      name: 'add_ingredient',
      parameters: {
        'category': category,
        'storage_location': storageLocation,
      },
    );
    debugPrint('[AnalyticsService] Event: add_ingredient (category=$category, location=$storageLocation)');
  }

  // -------------------------------------------------------
  // Event 6: view_recipe — Xem chi tiết recipe
  // -------------------------------------------------------

  /// Params: recipe_id, recipe_name
  /// Câu hỏi sản phẩm: Công thức nào được xem nhiều nhất?
  Future<void> logViewRecipe({
    required String recipeId,
    required String recipeName,
  }) async {
    await _analytics.logEvent(
      name: 'view_recipe',
      parameters: {
        'recipe_id': recipeId,
        'recipe_name': recipeName,
      },
    );
    debugPrint('[AnalyticsService] Event: view_recipe (id=$recipeId, name=$recipeName)');
  }

  // -------------------------------------------------------
  // Event 7: generate_meal_plan — Tạo thực đơn tuần
  // -------------------------------------------------------

  /// Params: ingredient_count
  /// Câu hỏi sản phẩm: Bao nhiêu nguyên liệu trung bình khi tạo thực đơn?
  Future<void> logGenerateMealPlan({required int ingredientCount}) async {
    await _analytics.logEvent(
      name: 'generate_meal_plan',
      parameters: {'ingredient_count': ingredientCount},
    );
    debugPrint('[AnalyticsService] Event: generate_meal_plan (count=$ingredientCount)');
  }

  // -------------------------------------------------------
  // Event 8: ai_chat_message — Gửi tin nhắn AI chat
  // -------------------------------------------------------

  /// Params: session_id
  /// Câu hỏi sản phẩm: Trung bình bao nhiêu tin nhắn mỗi phiên chat?
  Future<void> logAiChatMessage({required String sessionId}) async {
    await _analytics.logEvent(
      name: 'ai_chat_message',
      parameters: {'session_id': sessionId},
    );
    debugPrint('[AnalyticsService] Event: ai_chat_message (session=$sessionId)');
  }

  // -------------------------------------------------------
  // Event 9: upload_file — Upload file lên Cloudinary
  // -------------------------------------------------------

  /// Params: file_type, file_size_kb
  /// Câu hỏi sản phẩm: Loại file nào được upload nhiều nhất?
  Future<void> logUploadFile({
    required String fileType,
    required int fileSizeKb,
  }) async {
    await _analytics.logEvent(
      name: 'upload_file',
      parameters: {
        'file_type': fileType,
        'file_size_kb': fileSizeKb,
      },
    );
    debugPrint('[AnalyticsService] Event: upload_file (type=$fileType, size=${fileSizeKb}KB)');
  }

  // -------------------------------------------------------
  // Event 10: view_statistics — Xem thống kê tuần
  // -------------------------------------------------------

  /// Params: stat_type (weekly_spending | weekly_waste | ingredient_stats)
  /// Câu hỏi sản phẩm: Loại thống kê nào thu hút người dùng nhất?
  Future<void> logViewStatistics({required String statType}) async {
    await _analytics.logEvent(
      name: 'view_statistics',
      parameters: {'stat_type': statType},
    );
    debugPrint('[AnalyticsService] Event: view_statistics (type=$statType)');
  }

  // -------------------------------------------------------
  // Screen tracking (tùy chọn, bổ sung cho auto-tracking)
  // -------------------------------------------------------

  Future<void> logScreenView({required String screenName}) async {
    await _analytics.logScreenView(screenName: screenName);
  }
}

