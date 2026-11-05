# 🧊 Friggy - Ứng dụng Quản lý Tủ lạnh Thông minh

<p align="center">
  <strong>PRM393 - Mobile Programming | FPT University</strong><br>
  Flutter + Firebase + Cloud Services
</p>

---

## 📋 Giới thiệu

**Friggy** là ứng dụng di động giúp người dùng quản lý tủ lạnh thông minh, theo dõi nguyên liệu, gợi ý công thức nấu ăn và hỗ trợ AI chat. Ứng dụng được xây dựng bằng **Flutter** với backend REST API và tích hợp **6 dịch vụ Firebase & Cloud**.

### Tính năng chính

- 🔐 **Đăng nhập** bằng Email/Password hoặc Google Sign-In
- 📷 **Quét mã vạch** sản phẩm để thêm vào tủ lạnh
- 🍳 **Gợi ý công thức** nấu ăn dựa trên nguyên liệu có sẵn
- 🤖 **AI Chat** - Đầu bếp AI hỗ trợ tư vấn nấu ăn
- 👨‍👩‍👧‍👦 **Quản lý gia đình** - Chia sẻ tủ lạnh với thành viên gia đình
- 🔔 **Thông báo đẩy** nhắc nhở hạn sử dụng sản phẩm
- 📊 **Thống kê dinh dưỡng** và lịch sử sử dụng

---

## 🏗️ Kiến trúc

```
View / Screen  →  Provider  →  Service Layer  →  Firebase SDK / API
```

Ứng dụng sử dụng kiến trúc **Provider + Service Layer**:
- **View/Screen** - Giao diện người dùng, không gọi trực tiếp Firebase SDK
- **Provider** - Quản lý trạng thái ứng dụng
- **Service Layer** - Lớp dịch vụ đóng gói logic gọi Firebase/API
- **Backend API** - REST API tại `api.friggy.io.vn`

---

## 🔥 Dịch vụ Firebase & Cloud tích hợp

| # | Dịch vụ | Mô tả |
|---|---------|-------|
| 1 | **Firebase Authentication** | Đăng nhập Google Sign-In + xác thực kép với backend |
| 2 | **Cloudinary** (thay Cloud Storage) | Upload avatar người dùng lên cloud |
| 3 | **Firebase Cloud Messaging** | Thông báo đẩy (Push Notifications) |
| 4 | **Firebase Analytics** | 10 sự kiện theo dõi hành vi người dùng |
| 5 | **Firebase Crashlytics** | Báo cáo lỗi & crash tự động |
| 6 | **Firebase Remote Config** | 2 tham số điều khiển từ xa |

---

## 📁 Cấu trúc dự án

```
PRM/
├── Mobile/                          # Flutter project
│   ├── lib/
│   │   ├── main.dart                # Entry point - khởi tạo Firebase services
│   │   ├── config/
│   │   │   └── app_constants.dart   # Cấu hình API & Cloudinary
│   │   ├── data/
│   │   │   ├── models/              # Data models
│   │   │   └── services/            # Service Layer
│   │   │       ├── auth_service.dart
│   │   │       ├── firebase_auth_service.dart
│   │   │       ├── cloudinary_service.dart
│   │   │       ├── analytics_service.dart
│   │   │       ├── crashlytics_service.dart
│   │   │       ├── remote_config_service.dart
│   │   │       ├── notification_service.dart
│   │   │       ├── ai_chat_service.dart
│   │   │       └── api_service.dart
│   │   ├── screens/                 # Các màn hình UI
│   │   ├── theme/                   # Theme & styling
│   │   ├── l10n/                    # Đa ngôn ngữ (Tiếng Việt, English)
│   │   └── utils/                   # Utilities
│   ├── android/                     # Android native config
│   ├── docs/                        # Tài liệu
│   │   ├── analytics-plan.md
│   │   ├── screenshots/             # Ảnh chụp minh họa
│   │   └── *.pdf                    # Báo cáo & Slides
│   ├── .env                         # Biến môi trường (KHÔNG push lên Git)
│   └── pubspec.yaml                 # Dependencies
├── README.md                        # File này
└── *.pdf                            # Báo cáo & Slides
```

---

## 🚀 Hướng dẫn Cài đặt & Chạy

### Yêu cầu hệ thống

- **Flutter SDK** >= 3.12.0 (stable channel)
- **Dart SDK** >= 3.12.0
- **Android Studio** hoặc **VS Code** với Flutter extension
- **Android device/emulator** API 21+
- **Git**

### Bước 1: Clone dự án

```bash
git clone https://github.com/trlamm1505/PRM.git
cd PRM/Mobile
```

### Bước 2: Tạo file `.env`

Tạo file `.env` trong thư mục `Mobile/` với nội dung:

```env
API_URL=https://api.friggy.io.vn/api/v1
API_KEY=<your_api_key>
CLOUDINARY_CLOUD_NAME=<your_cloud_name>
CLOUDINARY_UPLOAD_PRESET=<your_upload_preset>
```

> ⚠️ **Lưu ý:** File `.env` chứa thông tin cấu hình nhạy cảm, **không được push lên Git**.

### Bước 3: Cài đặt dependencies

```bash
flutter pub get
```

### Bước 4: Cấu hình Firebase

1. Tạo project Firebase tại [Firebase Console](https://console.firebase.google.com)
2. Đăng ký ứng dụng Android với package name `com.tqlam.friggy`
3. Tải `google-services.json` và đặt vào `Mobile/android/app/`
4. Bật các dịch vụ: Authentication (Google), Cloud Messaging, Analytics, Crashlytics, Remote Config

### Bước 5: Chạy ứng dụng

```bash
flutter run
```

---

## 📱 Các luồng chức năng chính

### 1. Đăng nhập & Xác thực
```
Splash Screen → Login Screen → Google Sign-In / Email Login → Home Screen
```
- Hỗ trợ đăng nhập bằng **Google Sign-In** hoặc **Email/Password**
- Xác thực kép: Firebase Auth + Backend REST API
- Tự động duy trì phiên đăng nhập

### 2. Quản lý Tủ lạnh
```
Home → Tủ lạnh → Quét mã vạch / Chụp ảnh / Nhập tay → Thêm nguyên liệu
```
- Quét mã vạch sản phẩm để nhận diện tự động
- Chụp ảnh thực phẩm để AI nhận diện
- Nhập thủ công thông tin nguyên liệu
- Theo dõi hạn sử dụng, thông báo khi sắp hết hạn

### 3. Gợi ý Công thức
```
Home → Đầu bếp AI → Xem gợi ý → Chi tiết công thức → Chia sẻ
```
- Gợi ý công thức dựa trên nguyên liệu có trong tủ lạnh
- Xem chi tiết công thức với hướng dẫn từng bước
- Chia sẻ công thức với người khác

### 4. AI Chat
```
Home → Đầu bếp AI → Chat → Nhận gợi ý / tư vấn
```
- Chat với AI để được tư vấn nấu ăn
- Tính năng có thể bật/tắt qua **Firebase Remote Config**

### 5. Quản lý Tài khoản
```
Home → Tài khoản → Thông tin cá nhân / Đổi avatar / Cài đặt
```
- Cập nhật thông tin cá nhân
- Upload avatar lên **Cloudinary**
- Quản lý nhóm gia đình
- Cài đặt ngôn ngữ, giao diện

---

## 🛠️ Công nghệ sử dụng

| Công nghệ | Mục đích |
|-----------|----------|
| Flutter 3.12+ | Framework phát triển mobile cross-platform |
| Dart 3.12+ | Ngôn ngữ lập trình |
| Firebase Core | Nền tảng cloud services |
| Firebase Auth | Xác thực người dùng |
| Cloudinary | Lưu trữ file trên cloud |
| Firebase Cloud Messaging | Thông báo đẩy |
| Firebase Analytics | Phân tích hành vi người dùng |
| Firebase Crashlytics | Theo dõi lỗi & crash |
| Firebase Remote Config | Cấu hình từ xa |
| Provider | Quản lý state |
| Dio | HTTP client |
| flutter_dotenv | Quản lý biến môi trường |

---

## 📄 Tài liệu

- [Kế hoạch Analytics](Mobile/docs/analytics-plan.md) - 10 sự kiện theo dõi
- [Hướng dẫn kiểm thử](Mobile/docs/testing-guide-lab3.md) - Cách test từng dịch vụ

---

## 👨‍💻 Tác giả

**Trần Quốc Lâm** - FPT University

---

*PRM393 - Mobile Programming - Lab 3: Firebase & Cloud Services Integration*
