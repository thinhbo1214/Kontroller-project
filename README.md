# 🚀 Dự Án Kontroller

Chào mừng bạn đến với **Kontroller** - một dự án dự án được phát triển bởi đội ngũ đam mê công nghệ, với mục tiêu mang lại sự hiệu quả, tiện lợi và tối ưu hóa quy trình làm việc cho người dùng.

<p align="center">
  <img src="https://drive.google.com/uc?export=view&id=1vqINurv3bx5mZOfC4zsQyHoIwM0SC_nj" alt="Kontroller Logo" width="400"/>
</p>

---

## 👥 Đội Ngũ Phát Triển

Dự án Kontroller được xây dựng bởi các thành viên sau. Vui lòng điền thông tin vào bảng dưới đây:

| Tên Thành Viên | Vai Trò | Liên Kết GitHub | Liên Hệ |
|----------------|---------|-----------------|---------|
| Nguyễn Minh Thuận | Backend Dev | https://github.com/thuangf45 | [kingnemacc@gmail.com] |
| [Dương Đức Thịnh] | Backend Dev | https://github.com/thinhbo1214 | None |
| Nguyễn Gia Nghi | Project Manager | https://github.com/Nghi-creator | None |
| Nguyễn Thành Đạt | Database Dev | https://github.com/ntdat28305 | None |
| Hoàng Ngọc Tùng | Frontend Dev | https://github.com/Tung-creator | None |

<!-- > 💡 **Hướng dẫn**: Thay thế `[Tên]`, `[Vai trò]`, `[Link GitHub]`, `[Email/Social]` bằng thông tin cụ thể của từng thành viên. -->

---

## 📚 Hướng Dẫn Sử Dụng

### Cấu Trúc Thư Mục

Dự án Kontroller được tổ chức theo cấu trúc thư mục sau để đảm bảo dễ dàng quản lý và phát triển:

```plaintext
Kontroller-project/
│
├── src/
│   ├── Server/           # [Mô tả: Chứa mã nguồn toàn bộ project]
│   └── Test/             # [Mô tả: Chứa các unit test]
│       ├── TokenHelperTests.cs
│       ├── AnotherTests.cs
│       ├──...
│       └── README.md     # Hướng dẫn chi tiết về unit test
│
├── docs/                 # [Mô tả: Tài liệu dự án, hướng dẫn, API docs]
├── .github/              # [Mô tả: Cấu hình GitHub Actions]
│   └── workflows/
│       └──winforms-ci.yml    # Workflow tự động build
└── README.md             # File này
```

<!-- > 💡 **Hướng dẫn**: Điền mô tả cụ thể vào `[Mô tả]` cho từng thư mục để giải thích chức năng của nó. -->

### Cách Sử Dụng

1. **Clone repository**:
   ```bash
   git clone https://github.com/[your-username]/Kontroller-project.git
   cd Kontroller-project
   ```

2. **Cài đặt phụ thuộc**:
   ```bash
   dotnet restore
   ```

3. **Chạy dự án**:
   ```bash
   dotnet run --project src/Server
   ```

4. **Chạy unit test**:
   ```bash
   dotnet test src/Test
   ```

---

## 🛠️ Cơ Chế Tự Động Build (GitHub Actions)

Dự án sử dụng **GitHub Actions** để tự động build mỗi khi có thay đổi được push lên repository. Cấu hình workflow nằm tại:

```
.github/workflows/winforms-ci.yml
```

### Cách Hoạt Động
- **Trigger**: Workflow được kích hoạt khi có sự kiện `push` hoặc `pull request` trên các branch chính (ví dụ: `main`, `develop`).
- **Quy trình**:
  1. Kiểm tra mã nguồn.
  2. Chạy lệnh `dotnet build` để biên dịch.
  3. Chạy unit test với `dotnet test`.
  4. Lưu trữ bản build dưới dạng artifact.

### Tải Bản Build
1. Vào tab **Actions** trên GitHub repository.
2. Chọn workflow run mới nhất.
3. Tải artifact (bản build) từ phần **Artifacts** ở cuối trang.

> 💡 **Lưu ý**: Đảm bảo kiểm tra trạng thái workflow để xác nhận build thành công.

---

## 🔗 Tổng Hợp Liên Kết Không Gian Làm Việc

Dưới đây là các liên kết đến các công cụ và không gian làm việc của dự án Kontroller:

- 📂 **Google Drive (Tài liệu)**: [Link 1](https://drive.google.com/drive/u/0/folders/1Y41gS032Flr2ND7HhFPC0aJnIh4QmVMt), [Link 2](https://drive.google.com/drive/folders/18bmKYSihVVwWoHVmZzj2F0dnmUuyPx8G?usp=drive_link)
- 🎨 **Figma (Thiết kế)**: [Workspace](https://www.figma.com/board/DTFyj2Cr7LGiNofxQox6dn/Workspace?node-id=0-1&t=BxCHTWpvEL3JhcVv-1)
- 📋 **Trello (Quản lý công việc)**: [My Trello Board](https://trello.com/b/0FKVPGrS/my-trello-board)
- 💬 **Slack (Giao tiếp)**: [Kontroller Channel](https://app.slack.com/client/T0MAPCD1U/C08UMQVFD3J)
- 📅 **Instagantt (Lịch biểu)**: [Projects](https://app.instagantt.com/r/#projects/rTtM3emC16dOLAPfQ1nw/rTtM3emC16dOLAPfQ1nw)

---

## 🙏 Lời Cảm Ơn

Cảm ơn tất cả các thành viên đội ngũ đã đóng góp vào dự án Kontroller, cũng như cộng đồng đã ủng hộ và sử dụng sản phẩm của chúng tôi. Nếu bạn có ý tưởng, đề xuất hoặc muốn đóng góp, hãy liên hệ qua [Slack](https://app.slack.com/client/T0MAPCD1U/C08UMQVFD3J) hoặc mở issue/pull request trên GitHub. Chúng tôi rất mong nhận được phản hồi từ bạn! ❤️
