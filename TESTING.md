# Полное тестирование Tester Panel Backend

## 1️⃣ Быстрое тестирование (Docker Compose) - РЕКОМЕНДУЕТСЯ

Самый простой способ - всё поднимется автоматически с MySQL:

```bash
cd "c:\Testers Panel\backend"
docker-compose up
```

После запуска сервер будет на `http://localhost:3000`

Откройте другой терминал и запустите тесты:

```bash
# Проверить здоровье сервера
curl http://localhost:3000/api/health
```

---

## 2️⃣ Локальное тестирование (без Docker)

### Требования:
- MySQL должен быть установлен и запущен локально
- Настроить `.env` файл

### Шаги:

```bash
# 1. Убедиться что Node.js зависимости установлены
cd "c:\Testers Panel\backend"
npm install

# 2. Обновить .env с вашими MySQL данными
# Отредактировать .env файл

# 3. Запустить сервер
npm run dev

# 4. В другом терминале - запустить unit тесты
npm test
```

---

## 3️⃣ Полное ручное тестирование с curl

Открыть PowerShell/CMD терминал и запустить последовательно:

```bash
# 1. Проверить что сервер работает
curl http://localhost:3000/api/health

# 2. Зарегистрировать нового пользователя
$registerBody = @{
    email = "testuser@example.com"
    password = "password123"
    name = "Test User"
} | ConvertTo-Json

$response = Invoke-WebRequest -Uri "http://localhost:3000/api/auth/register" `
    -Method POST `
    -Headers @{"Content-Type"="application/json"} `
    -Body $registerBody

$token = ($response.Content | ConvertFrom-Json).token
Write-Host "Token: $token"

# 3. Получить текущего пользователя
$headers = @{"Authorization"="Bearer $token"}
Invoke-WebRequest -Uri "http://localhost:3000/api/users/profile/me" `
    -Method GET `
    -Headers $headers | ConvertFrom-Json

# 4. Создать item
$itemBody = @{
    title = "Test Item"
    description = "This is a test item"
    status = "pending"
} | ConvertTo-Json

Invoke-WebRequest -Uri "http://localhost:3000/api/items" `
    -Method POST `
    -Headers (@{"Authorization"="Bearer $token"; "Content-Type"="application/json"}) `
    -Body $itemBody | ConvertFrom-Json

# 5. Получить все items
Invoke-WebRequest -Uri "http://localhost:3000/api/items" `
    -Method GET `
    -Headers $headers | ConvertFrom-Json
```

---

## 4️⃣ Автоматизированное тестирование (Bash скрипт)

На системах с bash (Git Bash, WSL, Linux, Mac):

```bash
cd "c:\Testers Panel\backend"
bash test-api.sh
```

Скрипт автоматически:
- ✓ Проверит здоровье сервера
- ✓ Зарегистрирует пользователя
- ✓ Залогинится
- ✓ Создаст элемент
- ✓ Обновит элемент
- ✓ Удалит элемент

---

## 5️⃣ Postman тестирование

### Способ 1: Импортировать коллекцию

1. Откроется Postman
2. Click **Import** → выбрать `Postman_Collection.json`
3. Все API запросы будут доступны
4. Обновить `{{base_url}}` и `{{token}}` переменные
5. Нажать **Send** на каждый запрос

### Способ 2: Через командную строку

```bash
npm install -g newman

newman run Postman_Collection.json \
  --environment postman_env.json \
  --globals postman_globals.json
```

---

## 6️⃣ Unit тесты (Jest)

```bash
# Запустить все тесты
npm test

# Запустить с живым reload
npm test -- --watch

# Запустить с coverage отчётом
npm test -- --coverage
```

---

## 📋 Чек-лист полного тестирования

- [ ] **Health Check** - `GET /api/health`
- [ ] **Register** - `POST /api/auth/register` (новый пользователь)
- [ ] **Login** - `POST /api/auth/login` (получить токен)
- [ ] **Get Profile** - `GET /api/users/profile/me`
- [ ] **Get All Users** - `GET /api/users`
- [ ] **Get User by ID** - `GET /api/users/1`
- [ ] **Update User** - `PUT /api/users/1`
- [ ] **Create Item** - `POST /api/items`
- [ ] **Get All Items** - `GET /api/items`
- [ ] **Get Item by ID** - `GET /api/items/1`
- [ ] **Update Item** - `PUT /api/items/1`
- [ ] **Delete Item** - `DELETE /api/items/1`
- [ ] **Delete User** - `DELETE /api/users/1`
- [ ] **Invalid Token** - запрос без токена должен вернуть 401
- [ ] **Forbidden Access** - попытка обновить чужой item должна вернуть 403

---

## 🐛 Лог-файлы для отладки

```bash
# Просмотреть логи Docker
docker-compose logs -f backend

# Просмотреть логи MySQL
docker-compose logs -f mysql

# Получить все логи
docker-compose logs
```

---

## ⚠️ Типичные проблемы и решения

| Проблема | Решение |
|----------|---------|
| `ECONNREFUSED` | MySQL не запущена, запустить `docker-compose up` |
| `401 Unauthorized` | Отсутствует токен или он неверный; перелогиниться |
| `403 Forbidden` | Пытаетесь изменить чужой ресурс |
| `400 Bad Request` | Проверить данные в теле запроса (JSON формат) |
| Port 3000 уже занят | Изменить PORT в .env или остановить другое приложение |

---

## 📊 Performance тестирование (Load testing)

```bash
# Установить Apache Bench
npm install -g apache-benchmark

# Запустить 100 запросов, 10 одновременно
ab -n 100 -c 10 http://localhost:3000/api/health
```

---

## 🔍 Отладка в VS Code

1. Создать `.vscode/launch.json`:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node",
      "request": "launch",
      "name": "Launch Backend",
      "program": "${workspaceFolder}/server.js",
      "restart": true,
      "console": "integratedTerminal"
    }
  ]
}
```

2. Нажать **F5** для запуска с отладкой
3. Установить breakpoints кликом на номер строки

---

## ✅ Что проверяют тесты

✓ Регистрация с валидацией e-mail и пароля  
✓ Логин с правильными credentials  
✓ JWT токен работает  
✓ Защита эндпойнтов требует аутентификации  
✓ CRUD операции для пользователей  
✓ CRUD операции для элементов  
✓ Ownership проверка (нельзя изменить чужой item)  
✓ Обработка ошибок (400, 401, 403, 404, 500)  

