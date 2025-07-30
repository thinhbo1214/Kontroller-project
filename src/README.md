# 💻 Thư Mục Mã Nguồn Dự Án Kontroller

Thư mục `src/` là nơi lưu trữ toàn bộ mã nguồn của dự án Kontroller, được tổ chức rõ ràng để hỗ trợ phát triển và kiểm thử. Dưới đây là mô tả chi tiết về cấu trúc và nội dung:

## 📂 Cấu Trúc Thư Mục `src/`

- **🖥️ Server**  
  Đây là project chính của Kontroller, chứa toàn bộ mã nguồn backend của ứng dụng.  
  - Bao gồm các thành phần chính như:  
    - Logic nghiệp vụ (business logic) ⚙️  
    - API endpoints 🌐  
    - Cấu hình và kết nối cơ sở dữ liệu 🗄️  
  - Ví dụ: Các file như `Controllers/`, `Services/`, `Models/` được đặt trong thư mục này.

- **🧪 Test**  
  Đây là project dành riêng cho unit test, đảm bảo chất lượng mã nguồn thông qua các bài kiểm tra tự động.  
  - Chứa các file kiểm thử như:  
    - `TokenHelperTests.cs` ✅  
    - `AnotherTests.cs` ✅  
  - Sử dụng MSTest để thực hiện kiểm thử đơn vị (unit testing) 🕵️‍♂️  
  - Xem thêm chi tiết cách thiết lập unit test trong `src/Test/README.md` 📖  

> 💡 **Lưu ý**: Đảm bảo project `Server` và `Test` được cấu hình đúng trong file `.csproj` để tham chiếu và chạy test mượt mà. Chạy `dotnet test` từ thư mục `src/Test` để kiểm tra toàn bộ unit test!
