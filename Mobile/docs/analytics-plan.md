# Analytics Plan — Friggy (PRM393 Lab 3)

## Tổng quan

Kế hoạch theo dõi sự kiện Firebase Analytics cho ứng dụng Friggy — quản lý tủ lạnh thông minh.  
Mục tiêu: đo lường hành vi người dùng qua các luồng chính để cải thiện trải nghiệm sản phẩm.

**Nguyên tắc:**
- Ưu tiên tên sự kiện được Google khuyến nghị (`login`, `sign_up`)
- Tên tùy chỉnh dùng `snake_case`
- **KHÔNG** đưa thông tin cá nhân (email, tên, số điện thoại) vào tham số
- Thiết lập `userId` sau đăng nhập, xóa khi đăng xuất

---

## Danh sách sự kiện (10 events)

### Event 1: `login` (Khuyến nghị)

| Thuộc tính | Giá trị |
|-----------|---------|
| **Thời điểm kích hoạt** | Khi đăng nhập thành công (Google / Email / Phone) |
| **Tham số** | `method` (String): `google`, `email`, `phone` |
| **Kiểu tham số** | String |
| **Câu hỏi sản phẩm** | Phương thức đăng nhập nào được ưa chuộng nhất? |
| **Luồng Lab 2** | Authentication Flow → Bước cuối (Login Success) |
| **Tiêu chí thành công** | Mỗi lần đăng nhập thành công đều ghi nhận event |

### Event 2: `sign_up` (Khuyến nghị)

| Thuộc tính | Giá trị |
|-----------|---------|
| **Thời điểm kích hoạt** | Khi đăng ký tài khoản mới thành công (verify OTP) |
| **Tham số** | `method` (String): `email` |
| **Kiểu tham số** | String |
| **Câu hỏi sản phẩm** | Tỷ lệ đăng ký mới theo thời gian? |
| **Luồng Lab 2** | Authentication Flow → Register → Verify OTP |
| **Tiêu chí thành công** | Event chỉ fire khi OTP verified + account created |

### Event 3: `logout` (Tùy chỉnh)

| Thuộc tính | Giá trị |
|-----------|---------|
| **Thời điểm kích hoạt** | Khi người dùng nhấn đăng xuất |
| **Tham số** | Không |
| **Câu hỏi sản phẩm** | Tần suất đăng xuất thủ công? User có xu hướng duy trì phiên lâu không? |
| **Luồng Lab 2** | Profile → Logout |
| **Tiêu chí thành công** | Event fire trước khi xóa session |

### Event 4: `scan_ingredient` (Tùy chỉnh)

| Thuộc tính | Giá trị |
|-----------|---------|
| **Thời điểm kích hoạt** | Khi scan nguyên liệu thành công (ảnh / receipt / barcode) |
| **Tham số** | `scan_type` (String): `photo`, `receipt`, `barcode` |
| **Kiểu tham số** | String |
| **Câu hỏi sản phẩm** | Kiểu scan nào được dùng nhiều nhất? |
| **Luồng Lab 2** | Fridge Management → Select Input → Scan |
| **Tiêu chí thành công** | Event fire khi scan trả về kết quả hợp lệ |

### Event 5: `add_ingredient` (Tùy chỉnh)

| Thuộc tính | Giá trị |
|-----------|---------|
| **Thời điểm kích hoạt** | Khi thêm nguyên liệu thủ công thành công |
| **Tham số** | `category` (String), `storage_location` (String) |
| **Kiểu tham số** | String, String |
| **Câu hỏi sản phẩm** | Loại nguyên liệu nào thêm thủ công nhiều nhất? |
| **Luồng Lab 2** | Fridge Management → Manual Add → Confirm |
| **Tiêu chí thành công** | Event fire sau khi API trả về success |

### Event 6: `view_recipe` (Tùy chỉnh)

| Thuộc tính | Giá trị |
|-----------|---------|
| **Thời điểm kích hoạt** | Khi xem chi tiết công thức nấu ăn |
| **Tham số** | `recipe_id` (String), `recipe_name` (String) |
| **Kiểu tham số** | String, String |
| **Câu hỏi sản phẩm** | Công thức nào được xem nhiều nhất? |
| **Luồng Lab 2** | Meal Planning → Recipe Suggestions → Recipe Detail |
| **Tiêu chí thành công** | Event fire khi màn hình chi tiết được mở |

### Event 7: `generate_meal_plan` (Tùy chỉnh)

| Thuộc tính | Giá trị |
|-----------|---------|
| **Thời điểm kích hoạt** | Khi tạo thực đơn tuần bằng AI |
| **Tham số** | `ingredient_count` (int): số nguyên liệu có sẵn |
| **Kiểu tham số** | Integer |
| **Câu hỏi sản phẩm** | Bao nhiêu nguyên liệu trung bình khi tạo thực đơn? |
| **Luồng Lab 2** | Meal Planning → Generate Weekly Plan |
| **Tiêu chí thành công** | Event fire khi AI trả về kế hoạch thành công |

### Event 8: `ai_chat_message` (Tùy chỉnh)

| Thuộc tính | Giá trị |
|-----------|---------|
| **Thời điểm kích hoạt** | Khi gửi tin nhắn trong AI Chat |
| **Tham số** | `session_id` (String): ID phiên chat |
| **Kiểu tham số** | String |
| **Câu hỏi sản phẩm** | Trung bình bao nhiêu tin nhắn mỗi phiên chat? |
| **Luồng Lab 2** | AI Chat Flow → Send Message |
| **Tiêu chí thành công** | Event fire mỗi lần gửi tin nhắn |

### Event 9: `upload_file` (Tùy chỉnh)

| Thuộc tính | Giá trị |
|-----------|---------|
| **Thời điểm kích hoạt** | Khi upload file lên Cloudinary (avatar, v.v.) |
| **Tham số** | `file_type` (String), `file_size_kb` (int) |
| **Kiểu tham số** | String, Integer |
| **Câu hỏi sản phẩm** | Loại file nào được upload nhiều nhất? Kích thước trung bình? |
| **Luồng Lab 2** | Profile → Change Avatar |
| **Tiêu chí thành công** | Event fire khi Cloudinary trả về URL thành công |

### Event 10: `view_statistics` (Tùy chỉnh)

| Thuộc tính | Giá trị |
|-----------|---------|
| **Thời điểm kích hoạt** | Khi xem thống kê nguyên liệu / chi tiêu tuần |
| **Tham số** | `stat_type` (String): `ingredient_stats`, `weekly_spending`, `weekly_waste` |
| **Kiểu tham số** | String |
| **Câu hỏi sản phẩm** | Loại thống kê nào thu hút người dùng nhất? |
| **Luồng Lab 2** | Home → Statistics Section |
| **Tiêu chí thành công** | Event fire khi màn hình thống kê mở thành công |

---

## User Identity

| Hành động | Phương thức | Thời điểm |
|-----------|------------|-----------|
| Set userId | `AnalyticsService.setUserId(uid)` | Sau login thành công |
| Clear userId | `AnalyticsService.clearUserId()` | Khi logout |

> **Lưu ý:** Chỉ dùng ID nội bộ (từ backend). KHÔNG đưa email, tên, số điện thoại vào `setUserId()` hoặc bất kỳ tham số nào.

---

## Hướng dẫn kiểm tra bằng DebugView

1. Bật debug mode trên thiết bị Android:
   ```bash
   adb shell setprop debug.firebase.analytics.app com.tqlam.friggy
   ```

2. Mở Firebase Console → Analytics → DebugView

3. Thực hiện từng hành động trong app và kiểm tra event xuất hiện trên DebugView

4. Tắt debug mode khi hoàn thành:
   ```bash
   adb shell setprop debug.firebase.analytics.app .none.
   ```

