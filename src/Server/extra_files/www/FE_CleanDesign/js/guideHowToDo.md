# Hướng dẫn triển khai hệ thống Event Handler

## Tổng quan

Hệ thống này được thiết kế để tách biệt hoàn toàn logic JavaScript khỏi HTML, tạo ra một kiến trúc clean và dễ bảo trì. Hệ thống gồm 4 module chính:

- **event.js**: Quản lý tất cả các sự kiện
- **handle.js**: Xử lý logic nghiệp vụ  
- **ui.js**: Quản lý giao diện người dùng
- **api.js**: Xử lý các API calls

## Cách thức hoạt động

### 1. Event Delegation Pattern
```javascript
// Tất cả sự kiện được xử lý thông qua một listener duy nhất
document.addEventListener('click', this.handleGlobalClick);
```

### 2. Data Attributes cho Event Routing
```html
<!-- Sử dụng data-click để định tuyến sự kiện -->
<button data-click="createList">Create List</button>
<button data-click="likeList" data-list-id="123">Like</button>
```

### 3. ID-based Routing
```html
<!-- Hoặc sử dụng ID -->
<button id="createListBtn">Create List</button>
<form id="createListForm">...</form>
```

## Cấu trúc thư mục

```
project/
├── js/
│   ├── event.js      # Event handlers
│   ├── handle.js     # Business logic
│   ├── ui.js         # UI management
│   └── api.js        # API calls
├── lists.html        # Clean HTML
└── ...
```

## Hướng dẫn sử dụng

### 1. Thêm sự kiện mới

**Bước 1**: Thêm case mới trong `event.js`
```javascript
// Trong handleGlobalClick
case action.includes('newAction') || target.id === 'newActionBtn':
    Handle.handleNewAction(e);
    break;
```

**Bước 2**: Tạo handler method trong `handle.js`
```javascript
handleNewAction = async (e) => {
    e.preventDefault();
    
    try {
        UI.showLoading('Processing...');
        const result = await API.newAction(data);
        
        if (result.success) {
            UI.showSuccess('Action completed!');
        } else {
            UI.showError(result.message);
        }
    } catch (error) {
        UI.showError('An error occurred');
    } finally {
        UI.hideLoading();
    }
}
```

**Bước 3**: Thêm phương thức UI nếu cần trong `ui.js`
```javascript
handleNewActionUI() {
    // UI manipulation logic here
}
```

**Bước 4**: Thêm API method trong `api.js`
```javascript
async newAction(data) {
    return this.makeRequest('/new-action', {
        method: 'POST',
        body: JSON.stringify(data)
    });
}
```

### 2. Cách đặt tên và routing

#### Sử dụng data-click attribute (Khuyên dùng)
```html
<button data-click="createList">Create List</button>
<button data-click="deleteList" data-list-id="123">Delete</button>
<button data-click="addGameToList" data-game-id="456">Add Game</button>
```

#### Sử dụng ID
```html
<button id="createListBtn">Create List</button>
<form id="createListForm">...</form>
<select id="sortSelect">...</select>
```

#### Quy tắc đặt tên:
- **Actions**: `createList`, `deleteList`, `likeList`
- **Buttons**: `createListBtn`, `deleteListBtn`  
- **Forms**: `createListForm`, `loginForm`
- **Inputs**: `gameSearch`, `tagInput`, `listTitle`

### 3. Xử lý form

```html
<form id="createListForm">
    <input type="text" id="listTitle" required>
    <textarea id="listDescription"></textarea>
    <button type="submit">Create List</button>
</form>
```

Form sẽ tự động được xử lý bởi `handleGlobalSubmit` trong `event.js`

### 4. Xử lý input validation

```html
<input type="email" id="loginEmail" required>
<input type="password" id="loginPassword" required>
<input type="text" id="signupUsername" required>
```

Validation tự động dựa trên:
- `type="email"` → Email validation
- `type="password"` → Password strength
- ID chứa `username` → Username validation

### 5. Modal management

```html
<button data-click="modal-open" data-modal="createListModal">Open Modal</button>
<button data-click="modal-close">Close Modal</button>

<div id="createListModal" class="modal">
    <div class="modal-content">
        <!-- Modal content -->
    </div>
</div>
```

### 6. Dynamic content updates

```javascript
// Trong handle.js
this.selectedGames.push(newGame);
UI.updateSelectedGames(this.selectedGames, this.handleRemoveGame.bind(this));

// UI sẽ tự động thêm data-click attributes
UI.updateSelectedGames(games, removeCallback) {
    container.innerHTML = games.map(game => `
        <div>
            <span>${game.title}</span>
            <button data-click="removeGameFromList" data-game-id="${game.id}">
                Remove
            </button>
        </div>
    `).join('');
}
```

## Lợi ích của hệ thống

### 1. Clean Separation
- HTML chỉ chứa markup và styling
- JavaScript được tổ chức theo modules rõ ràng
- Dễ debug và maintain

### 2. Scalability
- Dễ thêm features mới
- Không cần sửa HTML khi thêm functionality
- Reusable components

### 3. Consistency
- Tất cả events đều đi qua một pipeline
- Unified error handling
- Consistent UI patterns

### 4. Performance
- Event delegation giảm số lượng listeners
- Lazy loading cho UI components
- Efficient DOM manipulation

## Best Practices

### 1. Naming Convention
```javascript
// Good
handleCreateList
handleDeleteList
handleGameSearch

// Bad  
createList
deleteList
searchGame
```

### 2. Error Handling
```javascript
// Luôn wrap async operations
try {
    UI.showLoading();
    const result = await API.someAction();
    // Handle success
} catch (error)