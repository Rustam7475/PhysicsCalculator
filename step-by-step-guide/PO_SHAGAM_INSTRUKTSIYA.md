# Пошаговая инструкция: публикация ссылок Privacy Policy и Support

## Цель
Опубликовать публичные страницы для App Store Connect и вставить корректные URL в карточку приложения.

## Что уже подготовлено
- Папка для GitHub Pages: `docs/`
- Страницы:
  - `docs/index.html`
  - `docs/privacy-policy.html`
  - `docs/support.html`

## Шаг 1. Замени email-заглушку
Открой и замени `your-email@example.com` на свой реальный email в файлах:
- `docs/privacy-policy.html`
- `docs/support.html`

Рекомендуемый формат:
- `support@yourdomain.com`

## Шаг 2. Закоммить и запушь изменения
Выполни команды в корне проекта:

```bash
git add docs/
git commit -m "Add public Privacy Policy and Support pages"
git push origin main
```

## Шаг 3. Включи GitHub Pages
1. Открой репозиторий: `https://github.com/Rustam7475/Swift`
2. Перейди в `Settings` -> `Pages`
3. В разделе `Build and deployment` выбери:
   - `Source`: `Deploy from a branch`
   - `Branch`: `main`
   - `Folder`: `/docs`
4. Нажми `Save`

## Шаг 4. Дождись деплоя
Обычно 1-5 минут. После этого должны открываться URL:
- Главная: `https://rustam7475.github.io/Swift/`
- Privacy Policy: `https://rustam7475.github.io/Swift/privacy-policy.html`
- Support: `https://rustam7475.github.io/Swift/support.html`

## Шаг 5. Проверь страницы
Перед App Store проверь:
- страницы открываются без 404
- email корректный
- ссылки между страницами работают
- текст без заглушек

## Шаг 6. Добавь URL в App Store Connect
В карточке приложения заполни:
- `Privacy Policy URL`:
  - `https://rustam7475.github.io/Swift/privacy-policy.html`
- `Support URL`:
  - `https://rustam7475.github.io/Swift/support.html`

## Шаг 7. Финальная проверка перед отправкой
- Ссылки в App Store Connect открываются
- Скриншоты загружены
- Версия и билд актуальные
- Политика конфиденциальности соответствует фактическому поведению приложения

## Частые проблемы
- 404 после включения Pages:
  - проверь, что выбран именно `main` + `/docs`
  - проверь, что файлы реально запушены
- Обновления не видны:
  - подожди 2-5 минут и обнови страницу без кэша
- Неверный URL в App Store Connect:
  - используй URL без лишних параметров
