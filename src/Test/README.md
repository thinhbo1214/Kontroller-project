# 🧪 Hướng Dẫn Thiết Lập Unit Testing với MSTest

Hướng dẫn chi tiết từ A đến Z để thiết lập và chạy unit test bằng MSTest cho dự án .NET.

## 1. 📁 Tạo Project Test

Bạn có thể tạo project test bằng một trong hai cách sau:

### Cách 1: Sử dụng lệnh `dotnet`
1. Điều hướng đến thư mục chứa project chính (ví dụ: `src/`).
2. Tạo project test mới bằng lệnh:

   ```bash
   dotnet new mstest -n Test
   ```

### Cách 2: Sử dụng Visual Studio
1. Mở Visual Studio và chọn **File > New > Project**.
2. Trong cửa sổ **Create a new project**, tìm và chọn **MSTest Test Project (.NET Core)** hoặc **MSTest Test Project (.NET Framework)** tùy thuộc vào framework của project chính.
3. Đặt tên project (ví dụ: `Test`) và chọn thư mục phù hợp (ví dụ: trong `src/`).
4. Nhấn **Create** để tạo project.

   > 💡 **Lưu ý**: Đảm bảo chọn đúng **Target Framework** khớp với project chính (ví dụ: `net9.0-windows`).

> 💡 **Gợi ý**: Đặt tên project như `Test` để ngắn gọn, hoặc `UnitTests` để rõ ràng hơn.

## 2. 🧾 Cấu Hình File `Test.csproj`

Đảm bảo file `Test.csproj` có nội dung sau, với các tham chiếu và cấu hình phù hợp:

```xml
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>net9.0-windows</TargetFramework> <!-- Phải khớp với project chính -->
    <ImplicitUsings>enable</ImplicitUsings>
    <Nullable>enable</Nullable>
    <IsTestProject>true</IsTestProject> <!-- Xác định là project test -->
  </PropertyGroup>

  <ItemGroup>
    <PackageReference Include="Microsoft.NET.Test.Sdk" Version="17.8.0" />
    <PackageReference Include="MSTest.TestAdapter" Version="3.10.0" />
    <PackageReference Include="MSTest.TestFramework" Version="3.10.0" />
  </ItemGroup>

  <ItemGroup>
    <ProjectReference Include="..\Server\Server.csproj" />
  </ItemGroup>
</Project>
```

## 3. 📥 Tải Thư Viện

Chạy các lệnh sau để tải thư viện và biên dịch project:

```bash
dotnet restore
dotnet build
dotnet test
```

## 4. ✍️ Viết Unit Test

Tạo file `.cs` trong thư mục `Test`, ví dụ: `TokenHelperTests.cs`. Nội dung mẫu:

```csharp
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Server.Source.Helper; // Điều chỉnh namespace theo dự án

namespace UnitTests
{
    [TestClass]
    public class TokenHelperTests
    {
        [TestMethod]
        public void CreateToken_ShouldNotBeEmpty()
        {
            var token = TokenHelper.CreateToken("abc", 5);
            Assert.IsFalse(string.IsNullOrEmpty(token));
        }

        [TestMethod]
        public void GetToken_ShouldReturnCorrectToken()
        {
            TokenHelper.SetToken("sample-token-123");
            var token = TokenHelper.GetToken();
            Assert.AreEqual("sample-token-123", token);
        }
    }
}
```

## 5. ▶️ Chạy Test

Chạy toàn bộ test từ thư mục gốc hoặc thư mục `Test` bằng lệnh:

```bash
dotnet test
```

## 6. 📂 Cấu Trúc Thư Mục Gợi Ý

```plaintext
Kontroller-project/
│
├── src/
│   ├── Server/
│   └── Test/
│       ├── TokenHelperTests.cs
│       ├── AnotherTests.cs
│       └── README.md  <!-- File này -->
│
└── ...
```

## 7. 🧠 Mẹo Sử Dụng

- **Tổ chức test**: Tạo nhiều file test riêng biệt như `AuthTests.cs`, `DatabaseTests.cs` để dễ quản lý.
- **Tự động phát hiện**: MSTest tự động nhận diện các `[TestClass]` và `[TestMethod]` mà không cần đăng ký.
- **Chạy test cụ thể**: Để chạy test cho một class cụ thể, sử dụng:

   ```bash
   dotnet test --filter FullyQualifiedName~UnitTests.TokenHelperTests
   ```

## ✅ Hoàn Tất!

Bạn đã thiết lập thành công hệ thống unit test cho dự án .NET với MSTest. Chỉ cần thêm các file `.cs` vào thư mục `Test`, lệnh `dotnet test` sẽ tự động chạy tất cả các test.