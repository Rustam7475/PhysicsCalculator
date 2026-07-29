import Foundation

extension L10n {
    // MARK: - SectionsView
    static var allFormulas: String { t(["ru": "Все формулы", "en": "All formulas", "de": "Alle Formeln", "es": "Todas las fórmulas", "fr": "Toutes les formules", "zh": "所有公式"]) }
    static var selectSection: String { t(["ru": "Выберите раздел", "en": "Select section", "de": "Bereich wählen", "es": "Seleccionar sección", "fr": "Choisir une section", "zh": "选择分类"]) }
    static var selectSubsection: String { t(["ru": "Выберите подраздел", "en": "Select subsection", "de": "Unterbereich wählen", "es": "Seleccionar subsección", "fr": "Choisir une sous-section", "zh": "选择子分类"]) }
    static var searchResults: String { t(["ru": "Результаты поиска", "en": "Search results", "de": "Suchergebnisse", "es": "Resultados de búsqueda", "fr": "Résultats de recherche", "zh": "搜索结果"]) }
    
    // MARK: - HistoryView
    static var historyTitle: String { t(["ru": "История расчётов", "en": "Calculation history", "de": "Berechnungsverlauf", "es": "Historial de cálculos", "fr": "Historique des calculs", "zh": "计算历史"]) }
    static var clearHistory: String { t(["ru": "Очистить историю", "en": "Clear history", "de": "Verlauf löschen", "es": "Borrar historial", "fr": "Effacer l'historique", "zh": "清除历史记录"]) }
    static var historyEmpty: String { t(["ru": "История пуста", "en": "History is empty", "de": "Verlauf ist leer", "es": "El historial está vacío", "fr": "L'historique est vide", "zh": "历史记录为空"]) }
    static var historyHint: String { t(["ru": "Здесь будут появляться\nваши последние расчёты", "en": "Your recent calculations\nwill appear here", "de": "Hier erscheinen\nIhre letzten Berechnungen", "es": "Aquí aparecerán\nsus cálculos recientes", "fr": "Vos calculs récents\napparaîtront ici", "zh": "您最近的计算\n将显示在这里"]) }
    static var clearHistoryTitle: String { t(["ru": "Очистить историю?", "en": "Clear history?", "de": "Verlauf löschen?", "es": "¿Borrar historial?", "fr": "Effacer l'historique ?", "zh": "清除历史记录？"]) }
    static var clearHistoryMessage: String { t(["ru": "Все записи истории будут удалены. Избранное не затронется.", "en": "All history entries will be deleted. Favorites won't be affected.", "de": "Alle Verlaufseinträge werden gelöscht. Favoriten bleiben erhalten.", "es": "Se eliminarán todas las entradas del historial. Los favoritos no se verán afectados.", "fr": "Toutes les entrées de l'historique seront supprimées. Les favoris ne seront pas affectés.", "zh": "所有历史记录将被删除。收藏不会受到影响。"]) }
    static var historySearch: String { t(["ru": "Поиск по истории", "en": "Search history", "de": "Verlauf durchsuchen", "es": "Buscar en historial", "fr": "Rechercher dans l'historique", "zh": "搜索历史"]) }
    static var historyToday: String { t(["ru": "Сегодня", "en": "Today", "de": "Heute", "es": "Hoy", "fr": "Aujourd'hui", "zh": "今天"]) }
    static var historyYesterday: String { t(["ru": "Вчера", "en": "Yesterday", "de": "Gestern", "es": "Ayer", "fr": "Hier", "zh": "昨天"]) }
    static var historyThisWeek: String { t(["ru": "На этой неделе", "en": "This week", "de": "Diese Woche", "es": "Esta semana", "fr": "Cette semaine", "zh": "本周"]) }
    static var historyThisMonth: String { t(["ru": "В этом месяце", "en": "This month", "de": "Diesen Monat", "es": "Este mes", "fr": "Ce mois-ci", "zh": "本月"]) }
    static var historyEarlier: String { t(["ru": "Ранее", "en": "Earlier", "de": "Früher", "es": "Anterior", "fr": "Plus ancien", "zh": "更早"]) }
    
    // MARK: - FavoritesView
    static var favoritesTitle: String { t(["ru": "Избранное", "en": "Favorites", "de": "Favoriten", "es": "Favoritos", "fr": "Favoris", "zh": "收藏夹"]) }
    static var favoritesEmpty: String { t(["ru": "Здесь пока ничего нет. Сохраняйте формулы для быстрого доступа.", "en": "Nothing here yet. Save formulas for quick access.", "de": "Noch nichts hier. Speichern Sie Formeln für den schnellen Zugriff.", "es": "Todavía no hay nada aquí. Guarda fórmulas para un acceso rápido.", "fr": "Rien ici pour l'instant. Enregistrez des formules pour un accès rapide.", "zh": "这里还没有内容。保存公式以便快速访问。"]) }
    static var noFavorites: String { t(["ru": "Нет сохранённых расчётов", "en": "No saved calculations", "de": "Keine gespeicherten Berechnungen", "es": "No hay cálculos guardados", "fr": "Aucun calcul enregistré", "zh": "没有收藏的计算"]) }
    static var addToFavorites: String { t(["ru": "В избранное", "en": "Favorite", "de": "Favorit", "es": "Favorito", "fr": "Favori", "zh": "收藏"]) }
    static var addToFavoritesHint: String { t(["ru": "Добавляйте расчёты в избранное,\nчтобы быстро к ним возвращаться", "en": "Add calculations to favorites\nfor quick access", "de": "Fügen Sie Berechnungen zu Favoriten hinzu,\num schnell darauf zuzugreifen", "es": "Añada cálculos a favoritos\npara acceder rápidamente", "fr": "Ajoutez des calculs aux favoris\npour y accéder rapidement", "zh": "将计算添加到收藏夹\n以便快速访问"]) }
    
    // MARK: - SettingsView
    static var settingsTitle: String { t(["ru": "Настройки", "en": "Settings", "de": "Einstellungen", "es": "Configuración", "fr": "Paramètres", "zh": "设置"]) }
    static var settingsLanguage: String { t(["ru": "Язык", "en": "Language", "de": "Sprache", "es": "Idioma", "fr": "Langue", "zh": "语言"]) }
    static var settingsTheme: String { t(["ru": "Тема оформления", "en": "Appearance", "de": "Erscheinungsbild", "es": "Apariencia", "fr": "Apparence", "zh": "外观"]) }
    static var themeLabel: String { t(["ru": "Оформление", "en": "Appearance", "de": "Design", "es": "Diseño", "fr": "Apparence", "zh": "外观"]) }
    static var themeSystem: String { t(["ru": "Системная", "en": "System", "de": "System", "es": "Sistema", "fr": "Système", "zh": "系统"]) }
    static var themeLight: String { t(["ru": "Светлая", "en": "Light", "de": "Hell", "es": "Claro", "fr": "Clair", "zh": "浅色"]) }
    static var themeDark: String { t(["ru": "Тёмная", "en": "Dark", "de": "Dunkel", "es": "Oscuro", "fr": "Sombre", "zh": "深色"]) }
    static var themeOLED: String { t(["ru": "OLED Чёрная", "en": "OLED Black", "de": "OLED Schwarz", "es": "OLED Negro", "fr": "OLED Noir", "zh": "OLED 纯黑"]) }
    static var settingsPremium: String { t(["ru": "Премиум доступ", "en": "Premium Access", "de": "Premium-Zugang", "es": "Acceso Premium", "fr": "Accès Premium", "zh": "高级版权限"]) }
    static var settingsFeedback: String { t(["ru": "Обратная связь", "en": "Feedback", "de": "Feedback", "es": "Comentarios", "fr": "Commentaires", "zh": "反馈"]) }
    static var settingsRateUs: String { t(["ru": "Оценить приложение", "en": "Rate app", "de": "App bewerten", "es": "Calificar aplicación", "fr": "Noter l'application", "zh": "评价应用"]) }
    static var settingsPrivacy: String { t(["ru": "Политика конфиденциальности", "en": "Privacy Policy", "de": "Datenschutz", "es": "Política de privacidad", "fr": "Politique de confidentialité", "zh": "隐私政策"]) }
    static var settingsSupport: String { t(["ru": "Поддержка", "en": "Support", "de": "Support", "es": "Soporte", "fr": "Support", "zh": "支持"]) }
    static var settingsAbout: String { t(["ru": "О приложении", "en": "About app", "de": "Über die App", "es": "Acerca de la aplicación", "fr": "À propos de l'application", "zh": "关于应用"]) }
    static var settingsShare: String { t(["ru": "Порекомендовать другу", "en": "Recommend to a friend", "de": "Einem Freund empfehlen", "es": "Recomendar a un amigo", "fr": "Recommander à un ami", "zh": "向朋友推荐"]) }
    static var settingsRestore: String { t(["ru": "Восстановить покупки", "en": "Restore purchases", "de": "Käufe wiederherstellen", "es": "Restaurar compras", "fr": "Restaurer les achats", "zh": "恢复购买"]) }
    static var appearance: String { t(["ru": "Внешний вид", "en": "Appearance", "de": "Erscheinungsbild", "es": "Apariencia", "fr": "Apparence", "zh": "外观"]) }
    static var aboutApp: String { t(["ru": "О приложении", "en": "About", "de": "Über die App", "es": "Acerca de", "fr": "À propos", "zh": "关于"]) }
    static var languageLabel: String { t(["ru": "Язык", "en": "Language", "de": "Sprache", "es": "Idioma", "fr": "Langue", "zh": "语言"]) }
    static var version: String { t(["ru": "Версия", "en": "Version", "de": "Version", "es": "Versión", "fr": "Version", "zh": "版本"]) }
    static var langSystem: String { t(["ru": "Как в системе", "en": "System default", "de": "Systemstandard", "es": "Predeterminado", "fr": "Par défaut", "zh": "系统默认"]) }
    
    // MARK: - MultiCalcView
    static var multiCalcTitle: String { t(["ru": "Множественный расчет", "en": "Multi-Calculation", "de": "Mehrfachberechnung", "es": "Cálculo múltiple", "fr": "Calcul multiple", "zh": "多次计算"]) }
    static func multiCalcSubtitle(_ name: String, _ symbol: String) -> String {
        let format = t([
            "ru": "Расчет \(name) (\(symbol)) для разных значений",
            "en": "Calculate \(name) (\(symbol)) for different values",
            "de": "Berechnen Sie \(name) (\(symbol)) für verschiedene Werte",
            "es": "Calcular \(name) (\(symbol)) para diferentes valores",
            "fr": "Calculer \(name) (\(symbol)) pour différentes valeurs",
            "zh": "为不同数值计算 \(name) (\(symbol))"
        ])
        return format
    }
    static var addRow: String { t(["ru": "Добавить строку", "en": "Add row", "de": "Zeile hinzufügen", "es": "Agregar fila", "fr": "Ajouter une ligne", "zh": "添加行"]) }
    static var removeRow: String { t(["ru": "Удалить строку", "en": "Remove row", "de": "Zeile löschen", "es": "Eliminar fila", "fr": "Supprimer la ligne", "zh": "删除行"]) }
    static var calculateAll: String { t(["ru": "Рассчитать всё", "en": "Calculate all", "de": "Alles berechnen", "es": "Calcular todo", "fr": "Tout calculer", "zh": "全部计算"]) }
    static var statistics: String { t(["ru": "Статистика", "en": "Statistics", "de": "Statistiken", "es": "Estadísticas", "fr": "Statistiques", "zh": "统计数据"]) }
    static var statMin: String { t(["ru": "Мин.", "en": "Min", "de": "Min", "es": "Mín.", "fr": "Min", "zh": "最小"]) }
    static var statMax: String { t(["ru": "Макс.", "en": "Max", "de": "Max", "es": "Máx.", "fr": "Max", "zh": "最大"]) }
    static var statAvg: String { t(["ru": "Среднее", "en": "Average", "de": "Mittelwert", "es": "Promedio", "fr": "Moyenne", "zh": "平均"]) }
    static var inputValues: String { t(["ru": "Входные параметры", "en": "Input values", "de": "Eingabewerte", "es": "Valores de entrada", "fr": "Valeurs d'entrée", "zh": "输入值"]) }
    static var noRuleFound: String { t(["ru": "Правило расчета не найдено", "en": "Calculation rule not found", "de": "Berechnungsregel nicht gefunden", "es": "No se encontró regla de cálculo", "fr": "Règle de calcul introuvable", "zh": "未找到计算规则"]) }

    // MARK: - Onboarding
    static var onboardingTitle1: String { t(["ru": "Добро пожаловать!", "en": "Welcome!", "de": "Willkommen!", "es": "¡Bienvenido!", "fr": "Bienvenue !", "zh": "欢迎！"]) }
    static var onboardingDesc1: String { t(["ru": "Более 100 формул для решения любых задач по физике.", "en": "More than 100 formulas to solve any physics problem.", "de": "Über 100 Formeln zur Lösung physikalischer Aufgaben.", "es": "Más de 100 fórmulas para resolver cualquier problema de física.", "fr": "Plus de 100 formules pour résoudre tout problème de physique.", "zh": "超过100个公式，助您解决各种物理难题。"]) }
    static var onboardingTitle2: String { t(["ru": "Умный расчет", "en": "Smart Calculation", "de": "Intelligente Berechnung", "es": "Cálculo inteligente", "fr": "Calcul intelligent", "zh": "智能计算"]) }
    static var onboardingDesc2: String { t(["ru": "Просто введите известные переменные, и приложение само предложит результат.", "en": "Just enter the known variables, and the app will suggest the result.", "de": "Geben Sie die bekannten Variablen ein, und die App schlägt das Ergebnis vor.", "es": "Solo ingrese las variables conocidas y la aplicación sugerirá el resultado.", "fr": "Saisissez les variables connues et l'application suggérera le résultat.", "zh": "只需输入已知变量，应用即可自动计算结果。"]) }
    static var onboardingTitle3: String { t(["ru": "Конвертер величин", "en": "Unit Converter", "de": "Einheitenumrechner", "es": "Convertidor de unidades", "fr": "Convertisseur d'unités", "zh": "单位换算器"]) }
    static var onboardingDesc3: String { t(["ru": "Мгновенно переводите значения между любыми единицами измерения.", "en": "Instantly convert values between any measurement units.", "de": "Wandeln Sie Werte sofort in beliebige Einheiten um.", "es": "Convierte instantáneamente valores entre cualquier unidad de medida.", "fr": "Convertissez instantanément des valeurs entre toutes les unités.", "zh": "即时在各种计量单位之间转换数值。"]) }
    static var onboardingTitle4: String { t(["ru": "Графики", "en": "Graphs", "de": "Grafiken", "es": "Gráficos", "fr": "Graphiques", "zh": "图表"]) }
    static var onboardingDesc4: String { t(["ru": "Наглядная визуализация формул и объяснение физических принципов.", "en": "Clear visualization of formulas and explanation of principles.", "de": "Anschauliche Visualisierung von Formeln und Erklärungen.", "es": "Visualización clara de fórmulas y explicación de principios.", "fr": "Visualisation claire des formules et explication des principes.", "zh": "公式的可视化呈现与物理原理的详细解释。"]) }
    static var onboardingTitle5: String { t(["ru": "Множественный расчет", "en": "Multi-Calculation", "de": "Mehrfachberechnung", "es": "Cálculo múltiple", "fr": "Calcul multiple", "zh": "多次计算"]) }
    static var onboardingDesc5: String { t(["ru": "Рассчитывайте одну формулу для целого списка значений одновременно.", "en": "Calculate one formula for a whole list of values at once.", "de": "Berechnen Sie eine Formel für eine ganze Liste von Werten gleichzeitig.", "es": "Calcule una fórmula para una lista completa de valores a la vez.", "fr": "Calculez une formule pour toute une liste de valeurs à la fois.", "zh": "一次性为整组数值计算同一个公式。"]) }
    static var onboardingTitle6: String { t(["ru": "Физические константы", "en": "Physical Constants", "de": "Physikalische Konstanten", "es": "Constantes físicas", "fr": "Constantes physiques", "zh": "物理常数"]) }
    static var onboardingDesc6: String { t(["ru": "Все важные константы всегда под рукой в удобной таблице.", "en": "All important constants are always at hand in a handy table.", "de": "Alle wichtigen Konstanten immer griffbereit in einer Tabelle.", "es": "Todas las constantes importantes siempre a mano en una tabla útil.", "fr": "Toutes les constantes importantes sont toujours à portée de main.", "zh": "所有重要的常数都收录在便捷的表格中。"]) }
    static var onboardingSkip: String { t(["ru": "Пропустить", "en": "Skip", "de": "Überspringen", "es": "Omitir", "fr": "Passer", "zh": "跳过"]) }
    static var skip: String { t(["ru": "Пропустить", "en": "Skip", "de": "Überspringen", "es": "Omitir", "fr": "Passer", "zh": "跳过"]) }
    
    // MARK: - PDF Preview
    static var pdfPreviewTitle: String { t(["ru": "Предпросмотр PDF", "en": "PDF Preview", "de": "PDF-Vorschau", "es": "Vista previa de PDF", "fr": "Aperçu PDF", "zh": "PDF 预览"]) }
    static var pdfInputValues: String { t(["ru": "Входные параметры", "en": "Input parameters", "de": "Eingabeparameter", "es": "Parámetros de entrada", "fr": "Paramètres d'entrée", "zh": "输入参数"]) }
    static var pdfResult: String { t(["ru": "Результат", "en": "Result", "de": "Ergebnis", "es": "Resultado", "fr": "Résultat", "zh": "结果"]) }
    static var generatingPDF: String { t(["ru": "Создание PDF...", "en": "Generating PDF...", "de": "PDF wird erstellt...", "es": "Generando PDF...", "fr": "Génération du PDF...", "zh": "正在生成PDF..."]) }
    static var backToCalculation: String { t(["ru": "Вернуться к расчёту", "en": "Back to calculation", "de": "Zurück zur Berechnung", "es": "Volver al cálculo", "fr": "Retour au calcul", "zh": "返回计算"]) }
    
    // MARK: - ActionButtonsGrid
    static var graph: String { t(["ru": "График", "en": "Graph", "de": "Grafik", "es": "Gráfico", "fr": "Graphique", "zh": "图表"]) }
    static var favorite: String { t(["ru": "Избранное", "en": "Favorite", "de": "Favorit", "es": "Favorito", "fr": "Favori", "zh": "收藏"]) }
    static var multi: String { t(["ru": "Список", "en": "Multi", "de": "Multi", "es": "Multi", "fr": "Multi", "zh": "列表"]) }
    static var errorCalc: String { t(["ru": "Погрешность", "en": "Error Calc", "de": "Fehlerrechnung", "es": "Error Calc", "fr": "Calc d'erreur", "zh": "误差计算"]) }
    static var shareInputValues: String { t(["ru": "Входные значения:", "en": "Input values:", "de": "Eingabewerte:", "es": "Valores de entrada:", "fr": "Valeurs d'entrée :", "zh": "输入值："]) }
    static var shareResult: String { t(["ru": "Результат:", "en": "Result:", "de": "Ergebnis:", "es": "Resultado:", "fr": "Résultat :", "zh": "结果："]) }
    
    // MARK: - CalculationDetailView
    static var formulaNotFound: String { t(["ru": "Формула не найдена", "en": "Formula not found", "de": "Formel nicht gefunden", "es": "Fórmula no encontrada", "fr": "Formule introuvable", "zh": "未找到公式"]) }
    static var calculated: String { t(["ru": "рассчитано", "en": "calculated", "de": "berechnet", "es": "calculado", "fr": "calculé", "zh": "计算出的"]) }
    static var formulaLabel: String { t(["ru": "Формула", "en": "Formula", "de": "Formel", "es": "Fórmula", "fr": "Formule", "zh": "公式"]) }
    static var solutionLabel: String { t(["ru": "Решение", "en": "Solution", "de": "Lösung", "es": "Solución", "fr": "Solution", "zh": "解答"]) }
    static var valuesLabel: String { t(["ru": "Значения", "en": "Values", "de": "Werte", "es": "Valores", "fr": "Valeurs", "zh": "值"]) }
    static var savedAt: String { t(["ru": "Сохранено:", "en": "Saved at:", "de": "Gespeichert am:", "es": "Guardado en:", "fr": "Enregistré à :", "zh": "保存于："]) }
    static var detailTitle: String { t(["ru": "Детали расчета", "en": "Calculation Details", "de": "Berechnungsdetails", "es": "Detalles del cálculo", "fr": "Détails du calcul", "zh": "计算详情"]) }
    static var detailsTitle: String { t(["ru": "Детали", "en": "Details", "de": "Details", "es": "Detalles", "fr": "Détails", "zh": "详情"]) }
    static var newCalculation: String { t(["ru": "Новый расчет", "en": "New Calculation", "de": "Neue Berechnung", "es": "Nuevo cálculo", "fr": "Nouveau calcul", "zh": "新计算"]) }
    static var deleteCalcTitle: String { t(["ru": "Удалить расчет?", "en": "Delete calculation?", "de": "Berechnung löschen?", "es": "¿Eliminar cálculo?", "fr": "Supprimer le calcul ?", "zh": "删除计算？"]) }
    static var deleteCalcMessage: String { t(["ru": "Это действие нельзя будет отменить.", "en": "This action cannot be undone.", "de": "Diese Aktion kann nicht rückgängig gemacht werden.", "es": "Esta acción no se puede deshacer.", "fr": "Cette action est irréversible.", "zh": "此操作无法撤销。"]) }
    
    // MARK: - ErrorCalculatorView
    static var errorCalculator: String { t(["ru": "Калькулятор погрешностей", "en": "Error Calculator", "de": "Fehlerrechner", "es": "Calculadora de errores", "fr": "Calculateur d'erreurs", "zh": "误差计算器"]) }
    static var errorDescription: String { t(["ru": "Введите абсолютные погрешности измерений. Результат рассчитывается методом распространения ошибок (частные производные).", "en": "Enter absolute measurement errors. The result is calculated using error propagation (partial derivatives).", "de": "Geben Sie die absoluten Messfehler ein. Das Ergebnis wird mittels Fehlerfortpflanzung (partielle Ableitungen) berechnet.", "es": "Introduzca los errores absolutos de medición. El resultado se calcula mediante propagación de errores (derivadas parciales).", "fr": "Entrez les erreurs absolues de mesure. Le résultat est calculé par propagation des erreurs (dérivées partielles).", "zh": "输入测量的绝对误差。结果通过误差传播法（偏导数）计算。"]) }
    static var errorPlaceholder: String { t(["ru": "Погрешность", "en": "Error", "de": "Fehler", "es": "Error", "fr": "Erreur", "zh": "误差"]) }
    static var errorConstant: String { t(["ru": "Точное значение", "en": "Exact value", "de": "Exakter Wert", "es": "Valor exacto", "fr": "Valeur exacte", "zh": "精确值"]) }
    static var calculateError: String { t(["ru": "Рассчитать погрешность", "en": "Calculate error", "de": "Fehler berechnen", "es": "Calcular error", "fr": "Calculer l'erreur", "zh": "计算误差"]) }
    static var errorResults: String { t(["ru": "Результаты анализа погрешностей", "en": "Error analysis results", "de": "Ergebnisse der Fehleranalyse", "es": "Resultados del análisis de errores", "fr": "Résultats de l'analyse d'erreurs", "zh": "误差分析结果"]) }
    static var absoluteError: String { t(["ru": "Абс. погрешность", "en": "Absolute error", "de": "Absoluter Fehler", "es": "Error absoluto", "fr": "Erreur absolue", "zh": "绝对误差"]) }
    static var relativeError: String { t(["ru": "Отн. погрешность", "en": "Relative error", "de": "Relativer Fehler", "es": "Error relativo", "fr": "Erreur relative", "zh": "相对误差"]) }
    static var errorFinalResult: String { t(["ru": "Запись результата с погрешностью:", "en": "Result with uncertainty:", "de": "Ergebnis mit Unsicherheit:", "es": "Resultado con incertidumbre:", "fr": "Résultat avec incertitude :", "zh": "带不确定度的结果："]) }
    static var errorStepFormula: String { t(["ru": "Формула погрешности", "en": "Error formula", "de": "Fehlerformel", "es": "Fórmula del error", "fr": "Formule d'erreur", "zh": "误差公式"]) }
    static var errorStepDerivatives: String { t(["ru": "Частные производные", "en": "Partial derivatives", "de": "Partielle Ableitungen", "es": "Derivadas parciales", "fr": "Dérivées partielles", "zh": "偏导数"]) }
    static var errorStepRelative: String { t(["ru": "Относительная погрешность", "en": "Relative error", "de": "Relativer Fehler", "es": "Error relativo", "fr": "Erreur relative", "zh": "相对误差"]) }
    
    // MARK: - FormulaInfoView
    static var infoTitle: String { t(["ru": "Справка", "en": "Reference", "de": "Referenz", "es": "Referencia", "fr": "Référence", "zh": "参考"]) }
    static var theoryLabel: String { t(["ru": "Теория", "en": "Theory", "de": "Theorie", "es": "Teoría", "fr": "Théorie", "zh": "理论"]) }
    static var descriptionLabel: String { t(["ru": "Описание", "en": "Description", "de": "Beschreibung", "es": "Descripción", "fr": "Description", "zh": "描述"]) }
    static var problemLabel: String { t(["ru": "Условие", "en": "Problem", "de": "Aufgabe", "es": "Problema", "fr": "Problème", "zh": "题目"]) }
    static var examplesLabel: String { t(["ru": "Примеры задач", "en": "Example Problems", "de": "Beispielaufgaben", "es": "Problemas de ejemplo", "fr": "Exemples de problèmes", "zh": "例题"]) }
    static var answerLabel: String { t(["ru": "Ответ", "en": "Answer", "de": "Antwort", "es": "Respuesta", "fr": "Réponse", "zh": "答案"]) }
    static var variablesLabel: String { t(["ru": "Переменные", "en": "Variables", "de": "Variablen", "es": "Variables", "fr": "Variables", "zh": "变量"]) }
    static var applicationArea: String { t(["ru": "Область применения", "en": "Application area", "de": "Anwendungsbereich", "es": "Área de aplicación", "fr": "Domaine d'application", "zh": "应用领域"]) }
    static var school: String { t(["ru": "Школа", "en": "School", "de": "Schule", "es": "Escuela", "fr": "École", "zh": "中学"]) }
    static var university: String { t(["ru": "Университет", "en": "University", "de": "Universität", "es": "Universidad", "fr": "Université", "zh": "大学"]) }
    
    // MARK: - UnitConverterView
    static var converterTitle: String { t(["ru": "Конвертер единиц", "en": "Unit Converter", "de": "Einheitenumrechner", "es": "Conversor de unidades", "fr": "Convertisseur", "zh": "单位换算"]) }
    static var converterFrom: String { t(["ru": "Из", "en": "From", "de": "Von", "es": "De", "fr": "De", "zh": "从"]) }
    static var converterTo: String { t(["ru": "В", "en": "To", "de": "Nach", "es": "A", "fr": "Vers", "zh": "到"]) }
    static var converterAllUnits: String { t(["ru": "Все единицы", "en": "All units", "de": "Alle Einheiten", "es": "Todas las unidades", "fr": "Toutes les unités", "zh": "所有单位"]) }
    
    // MARK: - FormulaGraphView
    static var graphTitle: String { t(["ru": "График зависимости", "en": "Dependency graph", "de": "Abhängigkeitsdiagramm", "es": "Gráfico de dependencia", "fr": "Graphique de dépendance", "zh": "依赖关系图"]) }
    static var rangeSettings: String { t(["ru": "Настройки диапазона", "en": "Range settings", "de": "Bereichseinstellungen", "es": "Configuración del rango", "fr": "Paramètres de plage", "zh": "范围设置"]) }
    static var minimum: String { t(["ru": "Минимум", "en": "Minimum", "de": "Minimum", "es": "Mínimo", "fr": "Minimum", "zh": "最小值"]) }
    static var maximum: String { t(["ru": "Максимум", "en": "Maximum", "de": "Maximum", "es": "Máximo", "fr": "Maximum", "zh": "最大值"]) }
    static var step: String { t(["ru": "Шаг", "en": "Step", "de": "Schritt", "es": "Paso", "fr": "Pas", "zh": "步长"]) }
    static var fixedValues: String { t(["ru": "Фиксированные значения:", "en": "Fixed values:", "de": "Feste Werte:", "es": "Valores fijos:", "fr": "Valeurs fixées :", "zh": "固定值："]) }
    static var updateGraph: String { t(["ru": "Обновить график", "en": "Update graph", "de": "Diagramm aktualisieren", "es": "Actualizar gráfico", "fr": "Mettre à jour le graphique", "zh": "更新图表"]) }
    static var saveGraph: String { t(["ru": "Сохранить график", "en": "Save graph", "de": "Diagramm speichern", "es": "Guardar gráfico", "fr": "Enregistrer le graphique", "zh": "保存图表"]) }
    static var graphSaved: String { t(["ru": "График сохранён в Фото", "en": "Graph saved to Photos", "de": "Diagramm in Fotos gespeichert", "es": "Gráfico guardado en Fotos", "fr": "Graphique enregistré dans Photos", "zh": "图表已保存到照片"]) }
    static func graphDependency(_ yName: String, _ xName: String) -> String {
        t(["ru": "График зависимости \(yName) от \(xName)",
           "en": "Graph of \(yName) vs \(xName)",
           "de": "Diagramm von \(yName) über \(xName)",
           "es": "Gráfico de \(yName) vs \(xName)",
           "fr": "Graphique de \(yName) en fonction de \(xName)",
           "zh": "\(yName) 关于 \(xName) 的图表"])
    }
    static var pdfDate: String { t(["ru": "Дата расчета:", "en": "Calculation date:", "de": "Berechnungsdatum:", "es": "Fecha del cálculo:", "fr": "Date du calcul :", "zh": "计算日期："]) }
    
    // MARK: - Step-by-step solution
    static var stepByStep: String { t(["ru": "Пошаговое решение", "en": "Step-by-step solution", "de": "Schrittweise Lösung", "es": "Solución paso a paso", "fr": "Solution étape par étape", "zh": "逐步求解"]) }
    static var stepOriginalFormula: String { t(["ru": "Исходная формула", "en": "Original formula", "de": "Ausgangsformel", "es": "Fórmula original", "fr": "Formule initiale", "zh": "原始公式"]) }
    static var stepRearrange: String { t(["ru": "Выражаем неизвестную", "en": "Express the unknown", "de": "Unbekannte ausdrücken", "es": "Expresar la incógnita", "fr": "Exprimer l'inconnue", "zh": "表达未知量"]) }
    static var stepSubstitute: String { t(["ru": "Подставляем значения", "en": "Substitute values", "de": "Werte einsetzen", "es": "Sustituir valores", "fr": "Substituer les valeurs", "zh": "代入数值"]) }
    static var stepCalculate: String { t(["ru": "Вычисляем результат", "en": "Calculate the result", "de": "Ergebnis berechnen", "es": "Calcular el resultado", "fr": "Calculer le résultat", "zh": "计算结果"]) }
}
