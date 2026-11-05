# 🧪 Hướng dẫn Test 6 Dịch vụ Firebase — Lab 3 (Friggy)

> **Luôn chạy app bằng lệnh:**
> ```powershell
> cd e:\PRM\Mobile
> flutter run --dart-define-from-file=.env
> ```
> Nếu bị lỗi Kotlin cache → chạy `flutter clean` rồi `flutter pub get` trước.

---

## 🔄 Thứ tự test (từ dễ → khó)

```
1. Remote Config       → Dễ nhất, test trước
        ↓
2. Analytics           → Bật DebugView rồi test
        ↓
3. Authentication      → Đăng nhập Google
        ↓
4. Crashlytics (Non-fatal) → Gửi lỗi test
        ↓
5. FCM                 → Gửi notification
        ↓
6. Cloudinary          → Upload ảnh
        ↓
7. Crashlytics (Crash) → Test cuối cùng vì app sẽ tắt!
```

---

## 1️⃣ Remote Config (Dễ nhất — test trước)

### Chuẩn bị trên Firebase Console
- Firebase Console → **Remote Config** → tạo 2 params → **Publish changes**:
  - `ai_chat_enabled` = `true` (Boolean)
  - `max_scan_per_day` = `10` (Number)

### Test A: Xem giá trị hiện tại
1. Mở app → **Cài đặt** → kéo xuống section **"🔥 Firebase Debug (Lab 3)"**
2. Dòng Remote Config hiện: `"AI Chat: BẬT • Max Scan: 10/ngày"`
3. Bấm nút **🔄 refresh** → SnackBar: `"Remote Config đã cập nhật!"`

### Test B: Tắt AI Chat từ xa
1. **Firebase Console** → Remote Config
2. Sửa `ai_chat_enabled` = **`false`** → **Publish changes**
3. App → Cài đặt → bấm **🔄 refresh**
4. Chuyển sang tab AI Chat → thấy **"AI Chat is under maintenance"**
5. 📸 **Chụp screenshot**

### Test C: Đổi max scan
1. Console → `max_scan_per_day` = **`3`** → Publish
2. App refresh → giá trị đổi thành `"Max Scan: 3/ngày"`

> ⚠️ Sau khi test xong, nhớ set lại `ai_chat_enabled = true` trên Console.

---

## 2️⃣ Analytics (Bật DebugView rồi test)

### Bước 1: Bật Debug Mode
Mở terminal **mới**, chạy:
```powershell
& "C:\Users\Admin\AppData\Local\Android\Sdk\platform-tools\adb.exe" shell setprop debug.firebase.analytics.app com.tqlam.friggy
```

### Bước 2: Mở DebugView
Firebase Console → **Analytics** → **DebugView** (menu trái)

### Bước 3: Trigger events trên app
Làm lần lượt, mỗi lần xong nhìn DebugView thấy event hiện **realtime**:

| # | Thao tác trên app | Event sẽ thấy |
|---|-------------------|---------------|
| 1 | Đăng xuất → Đăng nhập lại Google | `login` |
| 2 | Mở tab AI Chat → gửi 1 tin nhắn | `ai_chat_message` |
| 3 | Mở xem 1 công thức nấu ăn | `view_recipe` |
| 4 | Bấm Scan → chọn Photo → scan | `scan_ingredient` |
| 5 | Thêm nguyên liệu thủ công | `add_ingredient` |
| 6 | Mở màn hình thống kê | `view_statistics` |
| 7 | Tạo thực đơn tuần (AI) | `generate_meal_plan` |

📸 **Chụp screenshot DebugView khi events đang hiện**

### Bước 4: Tắt Debug Mode sau khi test xong
```powershell
& "C:\Users\Admin\AppData\Local\Android\Sdk\platform-tools\adb.exe" shell setprop debug.firebase.analytics.app .none.
```

---

## 3️⃣ Authentication (Đăng nhập Google)

### Chuẩn bị
- Firebase Console → Authentication → **Google provider Enabled** ✅
- SHA-1 đã thêm ✅

### Cách test
1. Mở app → màn hình Đăng nhập
2. Bấm **"Đăng nhập bằng Google"**
3. Chọn tài khoản Google → vào được Home

### Xác nhận
- **Firebase Console** → Authentication → tab **Users** → thấy tài khoản
- 📸 **Chụp screenshot Users list**

### Lỗi thường gặp
| Lỗi | Fix |
|-----|-----|
| `DEVELOPER_ERROR` (ApiException: 10) | Thêm SHA-1 vào Firebase Console |
| `Google ID Token is null` | Kiểm tra `GOOGLE_CLIENT_ID` trong `.env` |

---

## 4️⃣ Crashlytics — Non-fatal Error

### Cách test
1. Mở app → **Cài đặt** → kéo xuống cuối → section **"🔥 Firebase Debug (Lab 3)"**
2. Bấm **"Gửi lỗi Non-Fatal"**
3. Thấy SnackBar: `"✅ Non-fatal error đã gửi lên Crashlytics!"`

### Xác nhận
- Đợi 3-15 phút → Firebase Console → **Crashlytics** → thấy issue non-fatal
- 📸 **Chụp screenshot Crashlytics Issues**

---

## 5️⃣ FCM — Push Notification

### Cách test
1. **Firebase Console** → **Messaging** (Cloud Messaging)
2. Bấm **"Create your first campaign"** hoặc **"New campaign"**
3. Chọn **"Firebase Notification messages"**
4. Điền:
   - **Title**: `Test Notification Lab 3`
   - **Body**: `Đây là push notification thử nghiệm`
5. **Target**: Chọn app `com.tqlam.friggy`
6. Bấm **"Review"** → **"Publish"**

### Xác nhận
- App foreground → thấy notification banner
- App background → thấy notification trên system tray
- 📸 **Chụp screenshot notification trên thiết bị**

---

## 6️⃣ Cloudinary (Upload Avatar)

### Chuẩn bị
File `.env` đã có:
```
CLOUDINARY_CLOUD_NAME=tqlam150504
CLOUDINARY_UPLOAD_PRESET=friggy_unsigned
```

### Cách test
CloudinaryService đã tạo nhưng chưa kết nối vào UI upload avatar.
Để test, cần thêm code vào 1 nút hoặc tích hợp vào màn hình profile.

### Xác nhận
- Logcat: `[CloudinaryService] ✅ Upload successful!`
- **Cloudinary Dashboard** → Media Library → folder `avatars/`
- 📸 **Chụp screenshot Cloudinary Media Library**

---

## 7️⃣ Crashlytics — Test Crash (TEST CUỐI CÙNG!)

> ⚠️ **App sẽ tắt ngay lập tức!** Đây là test cuối cùng.

### Cách test
1. Mở app → **Cài đặt** → section **"🔥 Firebase Debug (Lab 3)"**
2. Bấm **"⚠️ Test Crash (Sẽ tắt app!)"**
3. Dialog xác nhận hiện lên → bấm **"Crash ngay"**
4. App tắt → **mở lại app** (report gửi khi app restart)

### Xác nhận
- Đợi 3-15 phút → Firebase Console → **Crashlytics**
- Thấy fatal crash: `FlutterFirebaseCrashlyticsPlugin.lambda$crash$1`
- Bấm vào issue → xem **User ID**, **Custom Keys** (login_method, user_name)
- 📸 **Chụp screenshot Crashlytics với cả non-fatal và fatal**

---

## 📸 Tổng hợp screenshot cần chụp cho báo cáo

| # | Cần chụp | Nơi chụp |
|---|----------|----------|
| 1 | Remote Config → 2 params trên Console | Firebase Console |
| 2 | Remote Config → App hiện "AI Chat: TẮT" | App |
| 3 | Analytics → DebugView hiện events | Firebase Console |
| 4 | Authentication → Users list | Firebase Console |
| 5 | Crashlytics → Issues (non-fatal + fatal) | Firebase Console |
| 6 | FCM → Notification trên thiết bị | App |
| 7 | Cloudinary → Media Library có ảnh | Cloudinary Dashboard |
| 8 | App Settings → section Firebase Debug | App |

---

## 🛠️ Lệnh hữu ích

```powershell
# Chạy app
cd e:\PRM\Mobile
flutter run --dart-define-from-file=.env

# Clean build (khi bị lỗi Kotlin cache)
flutter clean
flutter pub get

# Bật Analytics Debug Mode
& "C:\Users\Admin\AppData\Local\Android\Sdk\platform-tools\adb.exe" shell setprop debug.firebase.analytics.app com.tqlam.friggy

# Tắt Analytics Debug Mode
& "C:\Users\Admin\AppData\Local\Android\Sdk\platform-tools\adb.exe" shell setprop debug.firebase.analytics.app .none.

# Lấy SHA-1
cd e:\PRM\Mobile\android
.\gradlew.bat signingReport
```
