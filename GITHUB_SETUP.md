# GitHub Upload Instructions (Инструкция по загрузке на GitHub)

## 🚀 Шаг 1: Создать репозиторий на GitHub

1. Откройте https://github.com/new
2. Заполните форму:
   - **Repository name:** `tester-panel-backend`
   - **Description:** `Full-stack API backend with Node.js, Express, SQLite and JWT authentication`
   - **Visibility:** Public (или Private)
   - НЕ выбирайте "Initialize this repository with..."
3. Нажмите **Create repository**

---

## 🔑 Шаг 2: Генерировать Personal Access Token

1. Откройте GitHub Settings → Developer settings → Personal access tokens
   - Ссылка: https://github.com/settings/tokens
2. Нажмите "Generate new token"
3. Дайте имя: `github-cli-token`
4. Выберите scopes: `repo`, `workflow`
5. Нажмите **Generate token**
6. **Скопируйте токен** (больше не покажется!)

---

## 🔗 Шаг 3: Добавить удаленный репозиторий и залить код

Откройте PowerShell в папке `c:\Testers Panel\backend` и выполните:

```powershell
# Замените USERNAME на ваш GitHub логин
$GITHUB_USERNAME = "your-github-username"
$GITHUB_TOKEN = "ghp_xxxxxxxxxxxxxxxxxxxxxx"  # Ваш token

# Добавить remote
git remote add origin "https://$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/tester-panel-backend.git"

# Проверить
git remote -v

# Залить на GitHub
git branch -M main
git push -u origin main
```

---

## ✅ Если используете SSH (рекомендуется)

1. Откройте https://github.com/settings/keys
2. Нажмите "New SSH key"
3. В PowerShell выполните:

```powershell
# Сгенерировать SSH ключ (если его нет)
ssh-keygen -t ed25519 -C "your-email@example.com"
# Нажмите Enter когда спросит где сохранить

# Показать публичный ключ
Get-Content $env:USERPROFILE\.ssh\id_ed25519.pub
```

4. Скопируйте весь текст и вставьте в GitHub
5. Затем выполните:

```powershell
# Добавить SSH remote
git remote add origin git@github.com:your-github-username/tester-panel-backend.git

# Залить на GitHub
git branch -M main
git push -u origin main
```

---

## 🎉 Быстрая версия (одна команда)

Если у вас уже есть GitHub CLI (`gh`):

```powershell
cd "c:\Testers Panel\backend"
gh repo create tester-panel-backend --source=. --remote=origin --push --public
```

---

## 🔍 Проверить что залилось

После успешной загрузки:

```powershell
# Проверить что всё на сервере
git remote -v
git log --oneline

# Смотреть код на GitHub
start "https://github.com/your-github-username/tester-panel-backend"
```

---

## 📝 После первой загрузки

### Добавить README бейдж в README.md:

```markdown
# Tester Panel Backend

[![Node.js](https://img.shields.io/badge/Node.js-18+-green?logo=node.js)](https://nodejs.org/)
[![Express](https://img.shields.io/badge/Express-4.18+-blue?logo=express)](https://expressjs.com/)
[![SQLite](https://img.shields.io/badge/SQLite-3-blue?logo=sqlite)](https://www.sqlite.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Full-stack API backend with Node.js, Express, SQLite and JWT authentication
```

### Добавить GitHub Actions секреты (для деплоя):

Если хотите автоматический деплой:

1. Откройте Settings → Secrets and variables → Actions
2. Добавьте:
   - `RAILWAY_TOKEN` - возьмите с railway.app
   - `HEROKU_API_KEY` - возьмите с heroku.com

---

## 🐛 Если ошибка при push

### Ошибка: fatal: repository already exists

```powershell
# Удалить старый remote
git remote remove origin

# Добавить новый
git remote add origin https://github.com/YOUR_USERNAME/tester-panel-backend.git
```

### Ошибка: refusing to merge unrelated histories

```powershell
git pull origin main --allow-unrelated-histories
```

### Ошибка: 403 Forbidden

Используйте SSH вместо HTTPS или проверьте токен.

---

## 📦 Дополнительные команды

```powershell
# Просмотреть статус
git status

# Просмотреть коммиты
git log --oneline -n 10

# Добавить новые файлы в следующий коммит
git add .
git commit -m "Add new features"
git push

# Создать новую ветку
git checkout -b feature/new-feature
git push -u origin feature/new-feature

# Вернуться на main
git checkout main
```

---

## 🎯 Результат:

После выполнения вы получите:
✅ Проект на GitHub
✅ Все файлы залиты
✅ История коммитов
✅ Готово для CI/CD
✅ Готово для других разработчиков

**Всё готово! 🚀**
