# Project Guidelines

## Overview

iOS-приложение (SwiftUI) — физический калькулятор. Пользователь выбирает раздел → подраздел → формулу, отмечает неизвестную переменную, вводит остальные, получает результат. Графики, избранное (Core Data), экспорт PDF.

## Tech Stack

- SwiftUI, iOS 18.0+, Xcode
- SwiftMath (MTMathUILabel) — рендер LaTeX
- SwiftUI Charts — графики
- Core Data — сохранение расчётов
- JavaScriptCore — вычисление формул
- PDFKit — экспорт

## Architecture (MVVM + Service Layer)

```
PhysicsCalculator/
  Models/          — PhysicsModels, AppSettings, AppConfiguration
  Services/        — CalculationService, DataService, PersistenceController
  ViewModels/      — CalculationViewModel, ContentViewModel
  Views/           — 9 SwiftUI views + MathLabel (UIViewRepresentable)
  formulas_data.json — 126 формул, 28 подразделов, 6 разделов
PhysicsCalculatorTests/ — 860+ тестов, 11 файлов
```

- Сервисы инжектируются через протоколы (`CalculationServiceProtocol`, `DataServiceProtocol`)
- ViewModels помечены `@MainActor`
- Локализация: 6 языков (ru/en/de/es/fr/zh) через `L10n.swift` + `physicsName()` для данных из JSON

## Build and Test

```bash
# Сборка
xcodebuild -workspace PhysicsCalculator.xcworkspace -scheme PhysicsCalculator -sdk iphonesimulator build

# Тесты
xcodebuild -workspace PhysicsCalculator.xcworkspace -scheme PhysicsCalculator -sdk iphonesimulator test
```

## Conventions

- Язык общения: **русский**
- Формулы хранятся в `formulas_data.json` — `calculation_rules` маппят символ → правило для вычисления
- `NSExpression` / JavaScriptCore для вычислений, **не** eval строк
- Core Data entity: `SavedCalculation` — `inputValuesData` и `variablesData` хранятся как JSON-encoded Binary
- Без force unwrap (`!`), без `fatalError` в продакшн-коде
- `loadPhysicsData()` кеширует результат — не вызывать повторно
- После изменений — **запускать и проверять приложение**
- DDMathParser удалён; единственная SPM-зависимость — SwiftMath
