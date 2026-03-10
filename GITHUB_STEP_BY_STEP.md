# Загрузка на GitHub - Пошаговая инструкция

## 📋 ТРЕБОВАНИЯ:

✓ Git установлен (проверено)
✓ У вас есть аккаунт на https://github.com
✓ Генерирован Personal Access Token ИЛИ настроен SSH ключ

---

## ✅ СПОСОБ 1: Автоматизированный скрипт (ПРОЩЕ)

Откройте PowerShell в папке `c:\Testers Panel\backend` и выполните:

```powershell
.\upload-to-github.ps1
```

Скрипт попросит:
1. GitHub username (напр: `john-doe`)
2. Personal Access Token (сгенерируйте или нажмите Enter)

Скрипт автоматически всё загрузит!

---

## ⚙️ СПОСОБ 2: Ручные команды (ПОЛНЫЙ КОНТРОЛЬ)

### Шаг 1: Создать репозиторий на GitHub

> За это вы отвечаете вручную!

1. Откройте https://github.com/new
2. Введите имя: `tester-panel-backend`
3. Выберите Public или Private
4. **НЕ** выбирайте "Initialize with README"
5. Нажмите **Create repository**

### Шаг 2: Генерировать токен доступа

> Если используете HTTPS (проще на Windows)

1. Откройте https://github.com/settings/tokens
2. **Нажмите "Generate new token" → "Generate new token (classic)"**
3. Название: `github-push-token`
4. Выберите галочки:
   - `repo` (для приватных репозиториев)
   - `workflow` (для GitHub Actions)
5. **Нажмите "Generate token"**
6. **СКОПИРУЙТЕ токен** (больше не будет виден!)

### Шаг 3: Выполнить команды

Откройте PowerShell и выполните ПО ОЧЕРЕДИ:

```powershell
# Зайти в папку проекта
cd "c:\Testers Panel\backend"

# Команда 1: Добавить remote (замените USERNAME и TOKEN)
git remote add origin "https://YOUR_TOKEN@github.com/YOUR_USERNAME/tester-panel-backend.git"

# Команда 2: Проверить
git remote -v

# Команда 3: Убедиться на main ветке
git branch -M main

# Команда 4: Загрузить
git push -u origin main
```

**Пример:**
```powershell
# Реальный пример (с вымышленными данными)
git remote add origin "https://ghp_xY7k9mZ5aBcD3eF1gH2@github.com/john-dev/tester-panel-backend.git"
git branch -M main
git push -u origin main
```

---

## 🔑 СПОСОБ 3: SSH (БЕЗОПАСНЕЕ, но сложнее)

### Если у вас нет SSH ключа:

```powershell
# Создать SSH ключ
ssh-keygen -t ed25519 -C "your-email@example.com"

# Нажать Enter 3 раза (без пароля)

# Показать публичный ключ
cat $env:USERPROFILE\.ssh\id_ed25519.pub
```

### Добавить публичный ключ на GitHub:

1. Откройте https://github.com/settings/keys
2. Нажмите **New SSH key**
3. **Вставьте ВСЕ содержимое файла id_ed25519.pub**
4. Нажмите **Add SSH key**

### Загрузить по SSH:

```powershell
# Добавить SSH remote (замените USERNAME)
git remote add origin git@github.com:YOUR_USERNAME/tester-panel-backend.git

# Проверить
git remote -v

# Убедиться на main ветке
git branch -M main

# Загрузить
git push -u origin main
```

---

## ✓ РЕЗУЛЬТАТ

Если всё успешно, вы должны увидеть:

```
Enumerating objects: 36, done.
Counting objects: 100% (36/36), done.
...
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.
```

### Проверить что залилось:

Откройте в браузере:
```
https://github.com/ВАШ_USERNAME/tester-panel-backend
```

Вы должны видеть все файлы!

---

## 🆘 ЧАСТЫЕ ОШИБКИ

| Ошибка | Решение |
|--------|---------|
| `error: fatal: not a git repository` | Выполните команды в той же папке `c:\Testers Panel\backend` |
| `fatal: 'origin' already exists` | Выполните: `git remote remove origin` и снова добавьте |
| `fatal: Authentication failed` | Проверьте token/пароль, может истечь или неверный |
| `Permission denied (publickey)` | SSH ключ не добавлен на GitHub или неправильно настроен |
| `branch master/main` вместо `main` | Выполните: `git branch -M main` перед push |

---

## 🚀 КАК ИСПОЛЬЗОВАТЬ ПОСЛЕ ЗАГРУЗКИ

### Клонировать на другой компьютер:

```powershell
git clone https://github.com/YOUR_USERNAME/tester-panel-backend.git
cd tester-panel-backend
npm install
npm run dev
```

### Обновить репозиторий:

```powershell
# После изменений:
git add .
git commit -m "Описание изменений"
git push
```

### Создать ветку для новой функции:

```powershell
git checkout -b feature/new-feature
# ... делаем изменения ...
git add .
git commit -m "Add new feature"
git push -u origin feature/new-feature
```

---

## ℹ️ ВАЖНО

✅ **Локальный репозиторий уже создан** (в папке `.git`)  
✅ **Первый коммит уже сделан** (36 файлов)  
✅ **Нужно только залить на GitHub**  

**Выбери способ и выполни команды! 🚀**
