| **Thư mục**     | **Mục đích**                                                                        |
| --------------- | ----------------------------------------------------------------------------------- |
| **assets/**     | Lưu static assets (images, fonts, icons).                                           |
| **components/** | Các component nhỏ, **tái sử dụng được** như Button, GameCard, RatingStars.          |
| **context/**    | Context Provider (AuthContext, ThemeContext).                                       |
| **hooks/**      | Custom hooks như `useAuth`, `useFetchGames`.                                        |
| **layouts/**    | Layout tổng (Navbar, Footer, Sidebar layout).                                       |
| **pages/**      | Các page chính theo route, mỗi file = 1 route.                                      |
| **routes/**     | Nếu dùng React Router v6, có thể define route config riêng.                         |
| **services/**   | File gọi API, ví dụ `gameService.js`, `authService.js`.                             |
| **styles/**     | Global styles nếu có thêm CSS ngoài Tailwind.                                       |
| **types/**      | Nếu TypeScript, define types game, user, review. Nếu JS, có thể lưu data shape mẫu. |
| **utils/**      | Hàm tiện ích, helper function.                                                      |
