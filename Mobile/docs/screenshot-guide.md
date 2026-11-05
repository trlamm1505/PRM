# 📸 Hướng dẫn chụp ảnh minh họa - Lab 3 Friggy

## Lưu tất cả ảnh vào: `e:\PRM\Mobile\docs\screenshots\`

> ⚠️ **QUAN TRỌNG**: Đặt tên file CHÍNH XÁC như bên dưới (copy paste tên file).
> Sau khi chụp xong tất cả, gửi yêu cầu làm slide — ảnh sẽ được tự động gắn vào slide.

---

## 🔐 1. Firebase Authentication (3 ảnh)

### `01_login_screen.png`
- **Chụp gì**: Màn hình đăng nhập của app (TRƯỚC khi login)
- **Cách làm**: Mở app → ở màn hình Login → chụp
- **Lưu ý**: Thấy nút "Đăng nhập bằng Google" là OK

### `02_google_signin_dialog.png`
- **Chụp gì**: Dialog chọn tài khoản Google
- **Cách làm**: Bấm nút "Đăng nhập bằng Google" → dialog Google hiện lên → chụp NGAY
- **Lưu ý**: Chụp trước khi chọn tài khoản

### `03_console_auth_users.png`
- **Chụp gì**: Firebase Console hiển thị user đã đăng nhập
- **Cách làm**:
  1. Mở browser → vào https://console.firebase.google.com
  2. Chọn project **friggy-61bee**
  3. Menu trái → **Authentication** → tab **Users**
  4. Chụp toàn bộ trang (thấy email Google của bạn trong danh sách)

---

## ☁️ 2. Cloudinary - Cloud Storage (3 ảnh)

### `04_profile_avatar.png`
- **Chụp gì**: Màn hình Hồ sơ với avatar
- **Cách làm**: Mở app → tab **Tài khoản** (tab cuối cùng) → chụp phần avatar + tên
- **Lưu ý**: Phải thấy avatar, tên, email

### `05_avatar_picker_dialog.png`
- **Chụp gì**: Bottom sheet chọn ảnh (thư viện/camera)
- **Cách làm**: Bấm icon camera 📷 trên avatar → bottom sheet hiện lên → chụp
- **Lưu ý**: Thấy 2 option "Chọn từ thư viện ảnh" và "Chụp ảnh mới"

### `06_cloudinary_dashboard.png`
- **Chụp gì**: Cloudinary Dashboard folder avatars có ảnh
- **Cách làm**:
  1. Mở browser → vào https://console.cloudinary.com
  2. Menu trái → **Media Library** → **Folders**
  3. Vào **friggy** → **avatars**
  4. Chụp toàn bộ (thấy ảnh avatar đã upload)
- **Lưu ý**: Nếu chưa thấy ảnh → upload avatar trên app trước rồi refresh trang

---

## 🔔 3. Firebase Cloud Messaging - FCM (2 ảnh)

### `07_fcm_send_campaign.png`
- **Chụp gì**: Form gửi notification trên Firebase Console
- **Cách làm**:
  1. Firebase Console → **Messaging** (menu trái, mục Engage)
  2. Bấm **Create your first campaign** (hoặc **New campaign**)
  3. Chọn **Firebase Notification messages**
  4. Điền:
     - Notification title: `Test Lab 3`
     - Notification text: `Day la thong bao test tu Firebase Console`
  5. Chụp form này TRƯỚC khi bấm gửi

### `08_notification_received.png`
- **Chụp gì**: Notification hiện trên điện thoại
- **Cách làm**:
  1. Trong form trên → bấm **Review** → bấm **Publish**
  2. Target: chọn app **com.tqlam.friggy**
  3. Đợi notification hiện trên điện thoại → chụp
- **Lưu ý**: Nếu app đang foreground thì chụp popup notification. Nếu app background thì kéo thanh notification xuống chụp.

---

## 📊 4. Firebase Analytics (3 ảnh)

### CHUẨN BỊ TRƯỚC:
Chạy lệnh này trong PowerShell để bật DebugView:
```powershell
& "C:\Users\Admin\AppData\Local\Android\Sdk\platform-tools\adb.exe" shell setprop debug.firebase.analytics.app com.tqlam.friggy
```

### `09_debugview_events.png`
- **Chụp gì**: DebugView hiển thị nhiều sự kiện
- **Cách làm**:
  1. Chạy lệnh adb ở trên
  2. Mở app → thao tác: login, scan ảnh, xem recipe, vào thống kê, chat AI...
  3. Mở Firebase Console → **Analytics** → **DebugView** (menu trái)
  4. Đợi 30 giây → các sự kiện sẽ hiện lên (cột giữa)
  5. Chụp khi thấy ≥ 5 sự kiện khác nhau

### `10_debugview_event_detail.png`
- **Chụp gì**: Chi tiết 1 sự kiện với params
- **Cách làm**: Trong DebugView → bấm vào 1 sự kiện (VD: `scan_ingredient` hoặc `login`) → panel bên phải hiện params → chụp
- **Lưu ý**: Phải thấy tên params (VD: `scan_type=photo` hoặc `method=google`)

### `11_analytics_dashboard.png`
- **Chụp gì**: Trang Analytics Dashboard tổng quan
- **Cách làm**: Firebase Console → **Analytics** → **Dashboard** → chụp phần Users in last 30 minutes / Events
- **Lưu ý**: Có thể cần đợi 1 ngày mới có data. Nếu chưa có, chụp trang trống cũng OK.

---

## 🔥 5. Firebase Crashlytics (3 ảnh)

### CHUẨN BỊ TRƯỚC:
Trên app → Cài đặt → kéo xuống section **🔥 Firebase Debug (Lab 3)**:
1. Bấm **"Gửi lỗi Non-Fatal"** → thấy SnackBar xanh
2. Bấm **"⚠️ Test Crash"** → bấm xác nhận → app tắt → mở lại app
3. **Đợi 10-15 phút** rồi mới vào Console chụp!

### `12_app_firebase_debug.png`
- **Chụp gì**: Section Firebase Debug trên app
- **Cách làm**: Mở app → tab Tài khoản → **Cài đặt** → kéo xuống cuối → chụp section "🔥 Firebase Debug"
- **Lưu ý**: Thấy Remote Config info + nút Non-Fatal + nút Test Crash

### `13_console_crashlytics_issues.png`
- **Chụp gì**: Danh sách Issues trên Crashlytics Console
- **Cách làm**:
  1. Firebase Console → **Crashlytics** (menu trái, mục Release & Monitor)
  2. Chụp tab **Issues** — phải thấy **2 issues**:
     - `CrashlyticsService.initialize.<fn>` (non-fatal)
     - `FlutterFirebaseCrashlyticsPlugin.lambda$crash$1` (fatal crash)

### `14_console_crashlytics_detail.png`
- **Chụp gì**: Chi tiết 1 issue — thấy User ID + Custom Keys
- **Cách làm**: Bấm vào 1 issue → kéo xuống phần **Keys** → chụp
- **Lưu ý**: Phải thấy `user_name`, `login_method` trong Keys

---

## ⚙️ 6. Firebase Remote Config (3 ảnh)

### `15_console_remote_config.png`
- **Chụp gì**: 2 params trên Remote Config Console
- **Cách làm**:
  1. Firebase Console → **Remote Config** (menu trái, mục Engage)
  2. Chụp bảng params — thấy:
     - `ai_chat_enabled` = false (hoặc true)
     - `max_scan_per_day` = 10

### `16_app_remote_config_off.png`
- **Chụp gì**: App hiển thị "AI Chat: TẮT" sau khi đổi config
- **Cách làm**:
  1. Trên Console: đổi `ai_chat_enabled` = **false** → bấm **Publish changes**
  2. Trên app: Cài đặt → section Firebase Debug → bấm nút 🔄 refresh
  3. Chụp khi thấy **"AI Chat: TẮT"**

### `17_app_ai_chat_maintenance.png`
- **Chụp gì**: Tab AI Chat hiển thị "under maintenance"
- **Cách làm**: Bấm tab **Đầu bếp AI** (tab giữa bottom nav) → chụp thông báo maintenance
- **Lưu ý**: Nếu vẫn hiện chat bình thường → tắt app mở lại rồi thử lại

---

## 🏗️ 7. Kiến trúc & Code (2 ảnh)

### `18_project_structure.png`
- **Chụp gì**: Cấu trúc folder services trong IDE
- **Cách làm**: Mở VS Code → expand folder `lib/data/services/` → chụp
- **Lưu ý**: Phải thấy 6 file: analytics_service, cloudinary_service, crashlytics_service, firebase_auth_service, notification_service, remote_config_service

### `19_main_dart_init.png`
- **Chụp gì**: Code khởi tạo Firebase trong main.dart
- **Cách làm**: Mở `lib/main.dart` → chụp dòng 22-37 (phần import + init Firebase)

---

## ✅ Checklist — Tổng 19 ảnh

| # | Tên file | Chụp xong? |
|---|----------|:----------:|
| 1 | `01_login_screen.png` | ☐ |
| 2 | `02_google_signin_dialog.png` | ☐ |
| 3 | `03_console_auth_users.png` | ☐ |
| 4 | `04_profile_avatar.png` | ☐ |
| 5 | `05_avatar_picker_dialog.png` | ☐ |
| 6 | `06_cloudinary_dashboard.png` | ☐ |
| 7 | `07_fcm_send_campaign.png` | ☐ |
| 8 | `08_notification_received.png` | ☐ |
| 9 | `09_debugview_events.png` | ☐ |
| 10 | `10_debugview_event_detail.png` | ☐ |
| 11 | `11_analytics_dashboard.png` | ☐ |
| 12 | `12_app_firebase_debug.png` | ☐ |
| 13 | `13_console_crashlytics_issues.png` | ☐ |
| 14 | `14_console_crashlytics_detail.png` | ☐ |
| 15 | `15_console_remote_config.png` | ☐ |
| 16 | `16_app_remote_config_off.png` | ☐ |
| 17 | `17_app_ai_chat_maintenance.png` | ☐ |
| 18 | `18_project_structure.png` | ☐ |
| 19 | `19_main_dart_init.png` | ☐ |

---

## ⚡ Thứ tự chụp nhanh nhất (tiết kiệm thời gian)

### Bước 1: Trên điện thoại/emulator
1. Mở app (chưa login) → chụp `01` 
2. Bấm Google login → chụp dialog `02` → login xong
3. Tab Tài khoản → chụp avatar `04`
4. Bấm camera avatar → chụp dialog `05` → upload ảnh mới
5. Vào Cài đặt → chụp Firebase Debug `12`
6. Bấm "Non-Fatal" → bấm "Test Crash" → app tắt → mở lại
7. Tab Đầu bếp AI → chụp maintenance `17`

### Bước 2: Bật Analytics DebugView
```powershell
& "C:\Users\Admin\AppData\Local\Android\Sdk\platform-tools\adb.exe" shell setprop debug.firebase.analytics.app com.tqlam.friggy
```
8. Thao tác trên app: scan, xem recipe, chat AI, xem thống kê...

### Bước 3: Trên browser (Firebase Console)
9. Authentication → Users → chụp `03`
10. Crashlytics → Issues → chụp `13` → detail → chụp `14`
11. Remote Config → chụp `15` → đổi false → Publish
12. App: refresh → chụp `16`
13. Analytics → DebugView → chụp `09`, `10`
14. Analytics → Dashboard → chụp `11`
15. Messaging → tạo campaign → chụp `07` → gửi → chụp notification `08`

### Bước 4: Trên browser (Cloudinary)
16. Cloudinary Dashboard → friggy/avatars → chụp `06`

### Bước 5: Trên IDE (VS Code)
17. Chụp folder structure `18`
18. Chụp main.dart `19`

---

## 📁 Sau khi chụp xong

Kiểm tra folder `e:\PRM\Mobile\docs\screenshots\` có đủ 19 file:
```
screenshots/
├── 01_login_screen.png
├── 02_google_signin_dialog.png
├── 03_console_auth_users.png
├── 04_profile_avatar.png
├── 05_avatar_picker_dialog.png
├── 06_cloudinary_dashboard.png
├── 07_fcm_send_campaign.png
├── 08_notification_received.png
├── 09_debugview_events.png
├── 10_debugview_event_detail.png
├── 11_analytics_dashboard.png
├── 12_app_firebase_debug.png
├── 13_console_crashlytics_issues.png
├── 14_console_crashlytics_detail.png
├── 15_console_remote_config.png
├── 16_app_remote_config_off.png
├── 17_app_ai_chat_maintenance.png
├── 18_project_structure.png
└── 19_main_dart_init.png
```

**Xong → gửi tin nhắn yêu cầu làm slide thuyết trình!** 🎯
