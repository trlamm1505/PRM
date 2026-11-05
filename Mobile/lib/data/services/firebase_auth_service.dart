import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// FirebaseAuthService — Lớp dịch vụ bọc Firebase Authentication SDK
/// Chiến lược: DUAL AUTH — đăng nhập Firebase Auth song song với backend API
/// View/Screen KHÔNG gọi trực tiếp Firebase Auth SDK, chỉ gọi qua service này.
class FirebaseAuthService {
  FirebaseAuthService._();
  static final FirebaseAuthService instance = FirebaseAuthService._();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Lấy trạng thái đăng nhập hiện tại
  User? get currentUser => _firebaseAuth.currentUser;

  /// Stream theo dõi thay đổi trạng thái đăng nhập (authStateChanges)
  /// Dùng để chuyển giữa Đăng nhập ↔ Trang chủ
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Đăng nhập Firebase Auth bằng Google credential
  /// Gọi SAU khi GoogleSignIn thành công, TRƯỚC khi gọi backend API
  ///
  /// Flow: GoogleSignIn SDK → Google credential → Firebase Auth → rồi gửi idToken cho backend
  Future<UserCredential?> signInWithGoogle(GoogleSignInAccount googleUser) async {
    try {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      if (idToken == null) {
        debugPrint('[FirebaseAuthService] Google ID Token is null');
        return null;
      }

      // Tạo credential từ Google tokens
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      );

      // Đăng nhập Firebase Auth
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      debugPrint('[FirebaseAuthService] Firebase Auth sign-in successful: ${userCredential.user?.uid}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('[FirebaseAuthService] FirebaseAuthException: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      debugPrint('[FirebaseAuthService] Error during Google sign-in: $e');
      return null;
    }
  }

  /// Kiểm tra xem user đã đăng nhập Firebase Auth chưa (bảo vệ màn hình)
  bool isAuthenticated() {
    return _firebaseAuth.currentUser != null;
  }

  /// Đăng xuất khỏi Firebase Auth
  /// Gọi cùng lúc với backend logout
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      debugPrint('[FirebaseAuthService] Firebase Auth signed out');
    } catch (e) {
      debugPrint('[FirebaseAuthService] Error signing out: $e');
    }
  }

  /// Lấy Firebase User ID (UID)
  String? get uid => _firebaseAuth.currentUser?.uid;

  /// Lấy display name
  String? get displayName => _firebaseAuth.currentUser?.displayName;

  /// Lấy email
  String? get email => _firebaseAuth.currentUser?.email;

  /// Lấy photo URL
  String? get photoURL => _firebaseAuth.currentUser?.photoURL;
}

