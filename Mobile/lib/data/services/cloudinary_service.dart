import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import '../../config/app_constants.dart';

/// CloudinaryService — Lớp dịch vụ upload file lên Cloudinary
/// Thay thế Firebase Cloud Storage. Dùng cho chức năng upload avatar.
/// View/Screen KHÔNG gọi trực tiếp Cloudinary SDK, chỉ gọi qua service này.
class CloudinaryService {
  CloudinaryService._();
  static final CloudinaryService instance = CloudinaryService._();

  CloudinaryPublic? _cloudinary;

  /// Khởi tạo Cloudinary client với cloud_name và upload_preset từ env
  void initialize() {
    final cloudName = AppConstants.cloudinaryCloudName;
    final uploadPreset = AppConstants.cloudinaryUploadPreset;
    debugPrint('[CloudinaryService] cloudName=' + cloudName + ' preset=' + uploadPreset);

    if (cloudName.isEmpty || uploadPreset.isEmpty) {
      debugPrint('[CloudinaryService] ⚠️ Cloudinary credentials not configured in .env');
      return;
    }

    _cloudinary = CloudinaryPublic(cloudName, uploadPreset, cache: false);
    debugPrint('[CloudinaryService] Initialized with cloud: $cloudName');
  }

  /// Upload avatar lên Cloudinary
  /// Trả về URL ảnh đã upload, hoặc null nếu thất bại
  ///
  /// [filePath] — đường dẫn file ảnh trên thiết bị
  /// [userId] — ID người dùng (dùng làm folder và public_id)
  /// [onProgress] — callback báo tiến độ (0.0 → 1.0)
  Future<CloudinaryUploadResult?> uploadAvatar({
    required String filePath,
    required String userId,
    Function(double progress)? onProgress,
  }) async {
    if (_cloudinary == null) {
      debugPrint('[CloudinaryService] Not initialized. Call initialize() first.');
      return null;
    }

    try {
      debugPrint('[CloudinaryService] Uploading avatar for user: $userId');

      final file = File(filePath);
      if (!await file.exists()) {
        debugPrint('[CloudinaryService] File not found: $filePath');
        return null;
      }

      // Tính file size để log analytics
      final fileSizeBytes = await file.length();
      final fileSizeKb = (fileSizeBytes / 1024).round();
      debugPrint('[CloudinaryService] File size: ${fileSizeKb}KB');

      final response = await _cloudinary!.uploadFile(
        CloudinaryFile.fromFile(
          filePath,
          folder: 'friggy/avatars',
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      debugPrint('[CloudinaryService] ✅ Upload successful!');
      debugPrint('[CloudinaryService] URL: ${response.secureUrl}');
      debugPrint('[CloudinaryService] Public ID: ${response.publicId}');

      return CloudinaryUploadResult(
        secureUrl: response.secureUrl,
        publicId: response.publicId,
        fileSizeKb: fileSizeKb,
      );
    } on CloudinaryException catch (e) {
      debugPrint('[CloudinaryService] CloudinaryException: ${e.message}');
      return null;
    } catch (e) {
      debugPrint('[CloudinaryService] Error uploading: $e');
      return null;
    }
  }

  /// Upload file bất kỳ lên Cloudinary
  Future<CloudinaryUploadResult?> uploadFile({
    required String filePath,
    required String userId,
    required String folder,
    CloudinaryResourceType resourceType = CloudinaryResourceType.Auto,
  }) async {
    if (_cloudinary == null) {
      debugPrint('[CloudinaryService] Not initialized.');
      return null;
    }

    try {
      final file = File(filePath);
      if (!await file.exists()) {
        debugPrint('[CloudinaryService] File not found: $filePath');
        return null;
      }

      final fileSizeBytes = await file.length();
      final fileSizeKb = (fileSizeBytes / 1024).round();

      final response = await _cloudinary!.uploadFile(
        CloudinaryFile.fromFile(
          filePath,
          folder: '$folder/$userId',
          resourceType: resourceType,
        ),
      );

      debugPrint('[CloudinaryService] ✅ File uploaded: ${response.secureUrl}');

      return CloudinaryUploadResult(
        secureUrl: response.secureUrl,
        publicId: response.publicId,
        fileSizeKb: fileSizeKb,
      );
    } catch (e) {
      debugPrint('[CloudinaryService] Error uploading file: $e');
      return null;
    }
  }
}

/// Kết quả upload Cloudinary
class CloudinaryUploadResult {
  final String secureUrl;
  final String publicId;
  final int fileSizeKb;

  CloudinaryUploadResult({
    required this.secureUrl,
    required this.publicId,
    required this.fileSizeKb,
  });
}

