import Foundation

/// Centralized localization for all UI strings.
/// Supported languages: ru, en, de, es, fr, zh
enum L10n {
    
    private static var code: String { AppSettings.shared.currentLanguageCode }
    
    private static func t(_ dict: [String: String]) -> String {
        dict[code] ?? dict["en"] ?? ""
    }
    
    // MARK: - Tabs
    
    static var tabSections: String { t(["ru": "Разделы", "en": "Sections", "de": "Bereiche", "es": "Secciones", "fr": "Sections", "zh": "分类"]) }
    static var tabFavorites: String { t(["ru": "Избранное", "en": "Favorites", "de": "Favoriten", "es": "Favoritos", "fr": "Favoris", "zh": "收藏"]) }
    static var tabHistory: String { t(["ru": "История", "en": "History", "de": "Verlauf", "es": "Historial", "fr": "Historique", "zh": "历史"]) }
    static var tabSettings: String { t(["ru": "Настройки", "en": "Settings", "de": "Einstellungen", "es": "Ajustes", "fr": "Paramètres", "zh": "设置"]) }
    static var tabConstants: String { t(["ru": "Константы", "en": "Constants", "de": "Konstanten", "es": "Constantes", "fr": "Constantes", "zh": "常数"]) }
    static var tabConverter: String { t(["ru": "Конвертер", "en": "Converter", "de": "Umrechner", "es": "Conversor", "fr": "Convertisseur", "zh": "换算"]) }
    
    // MARK: - Common
    
    static var cancel: String { t(["ru": "Отмена", "en": "Cancel", "de": "Abbrechen", "es": "Cancelar", "fr": "Annuler", "zh": "取消"]) }
    static var delete: String { t(["ru": "Удалить", "en": "Delete", "de": "Löschen", "es": "Eliminar", "fr": "Supprimer", "zh": "删除"]) }
    static var reset: String { t(["ru": "Сбросить", "en": "Reset", "de": "Zurücksetzen", "es": "Restablecer", "fr": "Réinitialiser", "zh": "重置"]) }
    static var retry: String { t(["ru": "Повторить", "en": "Retry", "de": "Wiederholen", "es": "Reintentar", "fr": "Réessayer", "zh": "重试"]) }
    static var done: String { t(["ru": "Готово", "en": "Done", "de": "Fertig", "es": "Hecho", "fr": "Terminé", "zh": "完成"]) }
    static var close: String { t(["ru": "Закрыть", "en": "Close", "de": "Schließen", "es": "Cerrar", "fr": "Fermer", "zh": "关闭"]) }
    static var back: String { t(["ru": "Назад", "en": "Back", "de": "Zurück", "es": "Atrás", "fr": "Retour", "zh": "返回"]) }
    static var loading: String { t(["ru": "Загрузка данных...", "en": "Loading data...", "de": "Daten laden...", "es": "Cargando datos...", "fr": "Chargement des données...", "zh": "加载数据..."]) }
    static var noName: String { t(["ru": "Без имени", "en": "Unnamed", "de": "Ohne Name", "es": "Sin nombre", "fr": "Sans nom", "zh": "未命名"]) }
    
    // MARK: - SectionsView
    
    static var sectionsTitle: String { t(["ru": "Разделы физики", "en": "Physics Sections", "de": "Physik-Bereiche", "es": "Secciones de física", "fr": "Sections de physique", "zh": "物理分类"]) }
    static var searchPlaceholder: String { t(["ru": "Поиск по формулам", "en": "Search formulas", "de": "Formeln suchen", "es": "Buscar fórmulas", "fr": "Rechercher des formules", "zh": "搜索公式"]) }
    static var levelLabel: String { t(["ru": "Уровень", "en": "Level", "de": "Niveau", "es": "Nivel", "fr": "Niveau", "zh": "等级"]) }
    static var levelSchool: String { t(["ru": "Школьный", "en": "School", "de": "Schule", "es": "Escolar", "fr": "Scolaire", "zh": "中学"]) }
    static var levelUniversity: String { t(["ru": "Университетский", "en": "University", "de": "Universität", "es": "Universitario", "fr": "Universitaire", "zh": "大学"]) }
    static var selectSection: String { t(["ru": "Выберите раздел", "en": "Select section", "de": "Bereich wählen", "es": "Seleccionar sección", "fr": "Choisir une section", "zh": "选择分类"]) }
    static var selectSubsection: String { t(["ru": "Выберите подраздел", "en": "Select subsection", "de": "Unterbereich wählen", "es": "Seleccionar subsección", "fr": "Choisir une sous-section", "zh": "选择子分类"]) }
    static var searchResults: String { t(["ru": "Результаты поиска", "en": "Search results", "de": "Suchergebnisse", "es": "Resultados de búsqueda", "fr": "Résultats de recherche", "zh": "搜索结果"]) }
    static var nothingFound: String { t(["ru": "Ничего не найдено", "en": "Nothing found", "de": "Nichts gefunden", "es": "No se encontró nada", "fr": "Aucun résultat", "zh": "未找到结果"]) }
    static var selectPhysicsSection: String { t(["ru": "Выберите раздел физики", "en": "Select a physics section", "de": "Wählen Sie einen Physik-Bereich", "es": "Seleccione una sección de física", "fr": "Choisissez une section de physique", "zh": "请选择物理分类"]) }
    static var selectPhysicsSubsection: String { t(["ru": "Выберите подраздел физики", "en": "Select a physics subsection", "de": "Wählen Sie einen Physik-Unterbereich", "es": "Seleccione una subsección de física", "fr": "Choisissez une sous-section de physique", "zh": "请选择物理子分类"]) }
    static var noFormulasInSection: String { t(["ru": "В этом разделе пока нет формул", "en": "No formulas in this section yet", "de": "Noch keine Formeln in diesem Bereich", "es": "Aún no hay fórmulas en esta sección", "fr": "Pas encore de formules dans cette section", "zh": "该分类暂无公式"]) }
    
    // MARK: - CalculationView
    
    static var calculate: String { t(["ru": "Рассчитать", "en": "Calculate", "de": "Berechnen", "es": "Calcular", "fr": "Calculer", "zh": "计算"]) }
    static var willBeCalculated: String { t(["ru": "Будет рассчитано", "en": "Will be calculated", "de": "Wird berechnet", "es": "Se calculará", "fr": "Sera calculé", "zh": "将被计算"]) }
    
    // MARK: - CalculationResultView
    
    static var result: String { t(["ru": "Результат", "en": "Result", "de": "Ergebnis", "es": "Resultado", "fr": "Résultat", "zh": "结果"]) }
    static var inputValues: String { t(["ru": "Введённые значения", "en": "Input values", "de": "Eingabewerte", "es": "Valores ingresados", "fr": "Valeurs saisies", "zh": "输入值"]) }
    static var copy: String { t(["ru": "Копировать", "en": "Copy", "de": "Kopieren", "es": "Copiar", "fr": "Copier", "zh": "复制"]) }
    static var graph: String { t(["ru": "График", "en": "Graph", "de": "Diagramm", "es": "Gráfico", "fr": "Graphique", "zh": "图表"]) }
    static var share: String { t(["ru": "Поделиться", "en": "Share", "de": "Teilen", "es": "Compartir", "fr": "Partager", "zh": "分享"]) }
    static var favorite: String { t(["ru": "Избранное", "en": "Favorite", "de": "Favorit", "es": "Favorito", "fr": "Favori", "zh": "收藏"]) }
    static var newCalculation: String { t(["ru": "Новый расчёт", "en": "New calculation", "de": "Neue Berechnung", "es": "Nuevo cálculo", "fr": "Nouveau calcul", "zh": "新计算"]) }
    static var backToCalculation: String { t(["ru": "Вернуться к расчёту", "en": "Back to calculation", "de": "Zurück zur Berechnung", "es": "Volver al cálculo", "fr": "Retour au calcul", "zh": "返回计算"]) }
    
    // MARK: - Step-by-step solution
    
    static var stepByStep: String { t(["ru": "Пошаговое решение", "en": "Step-by-step solution", "de": "Schrittweise Lösung", "es": "Solución paso a paso", "fr": "Solution étape par étape", "zh": "逐步求解"]) }
    static var stepOriginalFormula: String { t(["ru": "Исходная формула", "en": "Original formula", "de": "Ausgangsformel", "es": "Fórmula original", "fr": "Formule initiale", "zh": "原始公式"]) }
    static var stepRearrange: String { t(["ru": "Выражаем неизвестную", "en": "Express the unknown", "de": "Unbekannte ausdrücken", "es": "Expresar la incógnita", "fr": "Exprimer l'inconnue", "zh": "表达未知量"]) }
    static var stepSubstitute: String { t(["ru": "Подставляем значения", "en": "Substitute values", "de": "Werte einsetzen", "es": "Sustituir valores", "fr": "Substituer les valeurs", "zh": "代入数值"]) }
    static var stepCalculate: String { t(["ru": "Вычисляем результат", "en": "Calculate the result", "de": "Ergebnis berechnen", "es": "Calcular el resultado", "fr": "Calculer le résultat", "zh": "计算结果"]) }
    
    // MARK: - Error calculator
    
    static var errorCalc: String { t(["ru": "Погрешн.", "en": "Error", "de": "Fehler", "es": "Error", "fr": "Erreur", "zh": "误差"]) }
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
    
    // MARK: - Share text
    
    static var shareInputValues: String { t(["ru": "📥 Введённые значения:", "en": "📥 Input values:", "de": "📥 Eingabewerte:", "es": "📥 Valores ingresados:", "fr": "📥 Valeurs saisies:", "zh": "📥 输入值:"]) }
    static var shareResult: String { t(["ru": "📊 Результат:", "en": "📊 Result:", "de": "📊 Ergebnis:", "es": "📊 Resultado:", "fr": "📊 Résultat:", "zh": "📊 结果:"]) }
    
    // MARK: - FavoritesView
    
    static var favoritesTitle: String { t(["ru": "Избранное", "en": "Favorites", "de": "Favoriten", "es": "Favoritos", "fr": "Favoris", "zh": "收藏"]) }
    static var noFavorites: String { t(["ru": "Нет сохранённых расчётов", "en": "No saved calculations", "de": "Keine gespeicherten Berechnungen", "es": "No hay cálculos guardados", "fr": "Aucun calcul enregistré", "zh": "没有收藏的计算"]) }
    static var addToFavoritesHint: String { t(["ru": "Добавляйте расчёты в избранное,\nчтобы быстро к ним возвращаться", "en": "Add calculations to favorites\nfor quick access", "de": "Fügen Sie Berechnungen zu Favoriten hinzu,\num schnell darauf zuzugreifen", "es": "Añada cálculos a favoritos\npara acceder rápidamente", "fr": "Ajoutez des calculs aux favoris\npour y accéder rapidement", "zh": "将计算添加到收藏夹\n以便快速访问"]) }
    
    // MARK: - HistoryView
    
    static var historyTitle: String { t(["ru": "История", "en": "History", "de": "Verlauf", "es": "Historial", "fr": "Historique", "zh": "历史"]) }
    static var historyEmpty: String { t(["ru": "История пуста", "en": "History is empty", "de": "Verlauf ist leer", "es": "El historial está vacío", "fr": "L'historique est vide", "zh": "历史记录为空"]) }
    static var historyHint: String { t(["ru": "Здесь будут появляться\nваши последние расчёты", "en": "Your recent calculations\nwill appear here", "de": "Hier erscheinen\nIhre letzten Berechnungen", "es": "Aquí aparecerán\nsus cálculos recientes", "fr": "Vos calculs récents\napparaîtront ici", "zh": "您最近的计算\n将显示在这里"]) }
    static var clearHistoryTitle: String { t(["ru": "Очистить историю?", "en": "Clear history?", "de": "Verlauf löschen?", "es": "¿Borrar historial?", "fr": "Effacer l'historique ?", "zh": "清除历史记录？"]) }
    static var clearHistoryMessage: String { t(["ru": "Все записи истории будут удалены. Избранное не затронется.", "en": "All history entries will be deleted. Favorites won't be affected.", "de": "Alle Verlaufseinträge werden gelöscht. Favoriten bleiben erhalten.", "es": "Se eliminarán todas las entradas del historial. Los favoritos no se verán afectados.", "fr": "Toutes les entrées de l'historique seront supprimées. Les favoris ne seront pas affectés.", "zh": "所有历史记录将被删除。收藏不会受到影响。"]) }
    static var clear: String { t(["ru": "Очистить", "en": "Clear", "de": "Löschen", "es": "Borrar", "fr": "Effacer", "zh": "清除"]) }
    static var historySearch: String { t(["ru": "Поиск по истории", "en": "Search history", "de": "Verlauf durchsuchen", "es": "Buscar en historial", "fr": "Rechercher dans l'historique", "zh": "搜索历史"]) }
    static var historyToday: String { t(["ru": "Сегодня", "en": "Today", "de": "Heute", "es": "Hoy", "fr": "Aujourd'hui", "zh": "今天"]) }
    static var historyYesterday: String { t(["ru": "Вчера", "en": "Yesterday", "de": "Gestern", "es": "Ayer", "fr": "Hier", "zh": "昨天"]) }
    static var historyThisWeek: String { t(["ru": "На этой неделе", "en": "This week", "de": "Diese Woche", "es": "Esta semana", "fr": "Cette semaine", "zh": "本周"]) }
    static var historyThisMonth: String { t(["ru": "В этом месяце", "en": "This month", "de": "Diesen Monat", "es": "Este mes", "fr": "Ce mois-ci", "zh": "本月"]) }
    static var historyEarlier: String { t(["ru": "Ранее", "en": "Earlier", "de": "Früher", "es": "Anterior", "fr": "Plus ancien", "zh": "更早"]) }
    static var addToFavorites: String { t(["ru": "В избранное", "en": "Favorite", "de": "Favorit", "es": "Favorito", "fr": "Favori", "zh": "收藏"]) }
    
    // MARK: - CalculationDetailView
    
    static var detailTitle: String { t(["ru": "Детали расчёта", "en": "Calculation details", "de": "Berechnungsdetails", "es": "Detalles del cálculo", "fr": "Détails du calcul", "zh": "计算详情"]) }
    static var formulaLabel: String { t(["ru": "Формула:", "en": "Formula:", "de": "Formel:", "es": "Fórmula:", "fr": "Formule :", "zh": "公式："]) }
    static var solutionLabel: String { t(["ru": "Решение:", "en": "Solution:", "de": "Lösung:", "es": "Solución:", "fr": "Solution :", "zh": "求解："]) }
    static var valuesLabel: String { t(["ru": "Значения:", "en": "Values:", "de": "Werte:", "es": "Valores:", "fr": "Valeurs :", "zh": "数值："]) }
    static var savedAt: String { t(["ru": "Сохранено:", "en": "Saved:", "de": "Gespeichert:", "es": "Guardado:", "fr": "Enregistré :", "zh": "保存于："]) }
    static var calculated: String { t(["ru": "Рассчитано", "en": "Calculated", "de": "Berechnet", "es": "Calculado", "fr": "Calculé", "zh": "已计算"]) }
    static var deleteCalcTitle: String { t(["ru": "Удалить расчёт?", "en": "Delete calculation?", "de": "Berechnung löschen?", "es": "¿Eliminar cálculo?", "fr": "Supprimer le calcul ?", "zh": "删除计算？"]) }
    static var deleteCalcMessage: String { t(["ru": "Этот расчёт будет удалён из избранного.", "en": "This calculation will be removed from favorites.", "de": "Diese Berechnung wird aus den Favoriten entfernt.", "es": "Este cálculo se eliminará de favoritos.", "fr": "Ce calcul sera supprimé des favoris.", "zh": "此计算将从收藏中删除。"]) }
    static var formulaNotFound: String { t(["ru": "Формула не найдена", "en": "Formula not found", "de": "Formel nicht gefunden", "es": "Fórmula no encontrada", "fr": "Formule introuvable", "zh": "未找到公式"]) }
    static var detailsTitle: String { t(["ru": "Детали расчета", "en": "Calculation details", "de": "Berechnungsdetails", "es": "Detalles del cálculo", "fr": "Détails du calcul", "zh": "计算详情"]) }
    
    // MARK: - FormulaGraphView
    
    static var rangeSettings: String { t(["ru": "Настройки диапазона", "en": "Range settings", "de": "Bereichseinstellungen", "es": "Configuración del rango", "fr": "Paramètres de plage", "zh": "范围设置"]) }
    static var minimum: String { t(["ru": "Минимум", "en": "Minimum", "de": "Minimum", "es": "Mínimo", "fr": "Minimum", "zh": "最小值"]) }
    static var maximum: String { t(["ru": "Максимум", "en": "Maximum", "de": "Maximum", "es": "Máximo", "fr": "Maximum", "zh": "最大值"]) }
    static var step: String { t(["ru": "Шаг", "en": "Step", "de": "Schritt", "es": "Paso", "fr": "Pas", "zh": "步长"]) }
    static var updateGraph: String { t(["ru": "Обновить график", "en": "Update graph", "de": "Diagramm aktualisieren", "es": "Actualizar gráfico", "fr": "Mettre à jour le graphique", "zh": "更新图表"]) }
    static var fixedValues: String { t(["ru": "Фиксированные значения:", "en": "Fixed values:", "de": "Feste Werte:", "es": "Valores fijos:", "fr": "Valeurs fixées :", "zh": "固定值："]) }
    static var saveGraph: String { t(["ru": "Сохранить график", "en": "Save graph", "de": "Diagramm speichern", "es": "Guardar gráfico", "fr": "Enregistrer le graphique", "zh": "保存图表"]) }
    static var graphSaved: String { t(["ru": "График сохранён в Фото", "en": "Graph saved to Photos", "de": "Diagramm in Fotos gespeichert", "es": "Gráfico guardado en Fotos", "fr": "Graphique enregistré dans Photos", "zh": "图表已保存到照片"]) }
    static var graphTitle: String { t(["ru": "График зависимости", "en": "Dependency graph", "de": "Abhängigkeitsdiagramm", "es": "Gráfico de dependencia", "fr": "Graphique de dépendance", "zh": "依赖关系图"]) }
    
    static func graphDependency(_ yName: String, _ xName: String) -> String {
        t(["ru": "График зависимости \(yName) от \(xName)",
           "en": "Graph of \(yName) vs \(xName)",
           "de": "Diagramm von \(yName) über \(xName)",
           "es": "Gráfico de \(yName) vs \(xName)",
           "fr": "Graphique de \(yName) en fonction de \(xName)",
           "zh": "\(yName) 关于 \(xName) 的图表"])
    }
    
    // MARK: - MultiCalcView
    
    static var multiCalcTitle: String { t(["ru": "Мультирасчёт", "en": "Multi-calc", "de": "Mehrfachberechnung", "es": "Multi-cálculo", "fr": "Multi-calcul", "zh": "批量计算"]) }
    static func multiCalcSubtitle(_ name: String, _ symbol: String) -> String {
        t(["ru": "Расчёт: \(name) (\(symbol))",
           "en": "Calculate: \(name) (\(symbol))",
           "de": "Berechnung: \(name) (\(symbol))",
           "es": "Cálculo: \(name) (\(symbol))",
           "fr": "Calcul : \(name) (\(symbol))",
           "zh": "计算：\(name) (\(symbol))"])
    }
    static var addRow: String { t(["ru": "Добавить строку", "en": "Add row", "de": "Zeile hinzufügen", "es": "Añadir fila", "fr": "Ajouter une ligne", "zh": "添加行"]) }
    static var removeRow: String { t(["ru": "Удалить", "en": "Remove", "de": "Entfernen", "es": "Eliminar", "fr": "Supprimer", "zh": "删除"]) }
    static var calculateAll: String { t(["ru": "Рассчитать все", "en": "Calculate all", "de": "Alle berechnen", "es": "Calcular todo", "fr": "Tout calculer", "zh": "全部计算"]) }
    static var statistics: String { t(["ru": "Статистика", "en": "Statistics", "de": "Statistik", "es": "Estadísticas", "fr": "Statistiques", "zh": "统计"]) }
    static var statMin: String { t(["ru": "Мин", "en": "Min", "de": "Min", "es": "Mín", "fr": "Min", "zh": "最小"]) }
    static var statMax: String { t(["ru": "Макс", "en": "Max", "de": "Max", "es": "Máx", "fr": "Max", "zh": "最大"]) }
    static var statAvg: String { t(["ru": "Среднее", "en": "Average", "de": "Mittel", "es": "Promedio", "fr": "Moyenne", "zh": "平均"]) }
    static var noRuleFound: String { t(["ru": "Не найдено правило расчёта", "en": "Calculation rule not found", "de": "Berechnungsregel nicht gefunden", "es": "Regla de cálculo no encontrada", "fr": "Règle de calcul introuvable", "zh": "未找到计算规则"]) }
    static var multi: String { t(["ru": "Мульти", "en": "Multi", "de": "Multi", "es": "Multi", "fr": "Multi", "zh": "批量"]) }
    
    // MARK: - FormulaInfoView
    
    static var infoTitle: String { t(["ru": "Справка", "en": "Reference", "de": "Referenz", "es": "Referencia", "fr": "Référence", "zh": "参考"]) }
    static var descriptionLabel: String { t(["ru": "Описание", "en": "Description", "de": "Beschreibung", "es": "Descripción", "fr": "Description", "zh": "描述"]) }
    static var theoryLabel: String { t(["ru": "Теория", "en": "Theory", "de": "Theorie", "es": "Teoría", "fr": "Théorie", "zh": "理论"]) }
    static var examplesLabel: String { t(["ru": "Примеры задач", "en": "Example Problems", "de": "Beispielaufgaben", "es": "Problemas de ejemplo", "fr": "Exemples de problèmes", "zh": "例题"]) }
    static var problemLabel: String { t(["ru": "Условие", "en": "Problem", "de": "Aufgabe", "es": "Problema", "fr": "Problème", "zh": "题目"]) }
    static var answerLabel: String { t(["ru": "Ответ", "en": "Answer", "de": "Antwort", "es": "Respuesta", "fr": "Réponse", "zh": "答案"]) }
    static var variablesLabel: String { t(["ru": "Переменные", "en": "Variables", "de": "Variablen", "es": "Variables", "fr": "Variables", "zh": "变量"]) }
    static var applicationArea: String { t(["ru": "Область применения", "en": "Application area", "de": "Anwendungsbereich", "es": "Área de aplicación", "fr": "Domaine d'application", "zh": "应用领域"]) }
    static var school: String { t(["ru": "Школа", "en": "School", "de": "Schule", "es": "Escuela", "fr": "École", "zh": "中学"]) }
    static var university: String { t(["ru": "Университет", "en": "University", "de": "Universität", "es": "Universidad", "fr": "Université", "zh": "大学"]) }
    
    // MARK: - SettingsView
    
    static var settingsTitle: String { t(["ru": "Настройки", "en": "Settings", "de": "Einstellungen", "es": "Ajustes", "fr": "Paramètres", "zh": "设置"]) }
    static var appearance: String { t(["ru": "Внешний вид", "en": "Appearance", "de": "Erscheinungsbild", "es": "Apariencia", "fr": "Apparence", "zh": "外观"]) }
    static var themeLabel: String { t(["ru": "Тема", "en": "Theme", "de": "Thema", "es": "Tema", "fr": "Thème", "zh": "主题"]) }
    static var languageLabel: String { t(["ru": "Язык", "en": "Language", "de": "Sprache", "es": "Idioma", "fr": "Langue", "zh": "语言"]) }
    static var aboutApp: String { t(["ru": "О приложении", "en": "About", "de": "Über die App", "es": "Acerca de", "fr": "À propos", "zh": "关于"]) }
    static var version: String { t(["ru": "Версия", "en": "Version", "de": "Version", "es": "Versión", "fr": "Version", "zh": "版本"]) }
    
    // Theme names
    static var themeLight: String { t(["ru": "Светлая", "en": "Light", "de": "Hell", "es": "Claro", "fr": "Clair", "zh": "浅色"]) }
    static var themeDark: String { t(["ru": "Тёмная", "en": "Dark", "de": "Dunkel", "es": "Oscuro", "fr": "Sombre", "zh": "深色"]) }
    static var themeOLED: String { t(["ru": "OLED чёрная", "en": "OLED Black", "de": "OLED Schwarz", "es": "OLED Negro", "fr": "OLED Noir", "zh": "OLED 黑色"]) }
    static var themeSystem: String { t(["ru": "Системная", "en": "System", "de": "System", "es": "Sistema", "fr": "Système", "zh": "系统"]) }
    
    // Language names (shown in their own language, stay the same)
    static var langSystem: String { t(["ru": "Как в системе", "en": "System default", "de": "Systemstandard", "es": "Predeterminado", "fr": "Par défaut", "zh": "系统默认"]) }
    
    // MARK: - PDFPreview
    
    static var pdfPreviewTitle: String { t(["ru": "Предпросмотр PDF", "en": "PDF Preview", "de": "PDF-Vorschau", "es": "Vista previa PDF", "fr": "Aperçu PDF", "zh": "PDF 预览"]) }
    static var generatingPDF: String { t(["ru": "Генерация PDF...", "en": "Generating PDF...", "de": "PDF wird erstellt...", "es": "Generando PDF...", "fr": "Génération du PDF...", "zh": "生成 PDF..."]) }
    static var pdfInputValues: String { t(["ru": "Введенные значения:", "en": "Input values:", "de": "Eingabewerte:", "es": "Valores ingresados:", "fr": "Valeurs saisies :", "zh": "输入值："]) }
    static var pdfResult: String { t(["ru": "Результат:", "en": "Result:", "de": "Ergebnis:", "es": "Resultado:", "fr": "Résultat :", "zh": "结果："]) }
    static var pdfDate: String { t(["ru": "Дата расчета:", "en": "Calculation date:", "de": "Berechnungsdatum:", "es": "Fecha del cálculo:", "fr": "Date du calcul :", "zh": "计算日期："]) }
    
    // MARK: - OnboardingView
    
    static var onboardingTitle1: String { "PhysicsCalculator" }
    static var onboardingDesc1: String { t(["ru": "Ваш помощник в решении задач по физике. Выбирайте формулу, вводите данные — получайте результат мгновенно.", "en": "Your physics problem-solving assistant. Choose a formula, enter data — get results instantly.", "de": "Ihr Assistent bei Physikaufgaben. Formel wählen, Daten eingeben — sofort Ergebnis erhalten.", "es": "Su asistente para resolver problemas de física. Elija una fórmula, ingrese datos — obtenga resultados al instante.", "fr": "Votre assistant pour résoudre les problèmes de physique. Choisissez une formule, entrez les données — obtenez le résultat instantanément.", "zh": "您的物理解题助手。选择公式，输入数据——即刻获得结果。"]) }
    static var onboardingTitle2: String { t(["ru": "126+ формул", "en": "126+ formulas", "de": "126+ Formeln", "es": "126+ fórmulas", "fr": "126+ formules", "zh": "126+ 公式"]) }
    static var onboardingDesc2: String { t(["ru": "Механика, термодинамика, электромагнетизм, оптика, ядерная и атомная физика. Школа и университет.", "en": "Mechanics, thermodynamics, electromagnetism, optics, nuclear & atomic physics. School and university.", "de": "Mechanik, Thermodynamik, Elektromagnetismus, Optik, Kern- und Atomphysik. Schule und Universität.", "es": "Mecánica, termodinámica, electromagnetismo, óptica, física nuclear y atómica. Escuela y universidad.", "fr": "Mécanique, thermodynamique, électromagnétisme, optique, physique nucléaire et atomique. École et université.", "zh": "力学、热力学、电磁学、光学、核物理和原子物理。中学和大学。"]) }
    static var onboardingTitle3: String { t(["ru": "Конвертер единиц", "en": "Unit converter", "de": "Einheitenumrechner", "es": "Conversor de unidades", "fr": "Convertisseur d'unités", "zh": "单位换算"]) }
    static var onboardingDesc3: String { t(["ru": "13 категорий — длина, масса, энергия, давление, температура и другие. 80+ единиц с мгновенной конвертацией.", "en": "13 categories — length, mass, energy, pressure, temperature and more. 80+ units with instant conversion.", "de": "13 Kategorien — Länge, Masse, Energie, Druck, Temperatur und mehr. 80+ Einheiten mit sofortiger Umrechnung.", "es": "13 categorías — longitud, masa, energía, presión, temperatura y más. 80+ unidades con conversión instantánea.", "fr": "13 catégories — longueur, masse, énergie, pression, température et plus. 80+ unités avec conversion instantanée.", "zh": "13个类别——长度、质量、能量、压强、温度等。80+单位即时换算。"]) }
    static var onboardingTitle4: String { t(["ru": "Графики и экспорт", "en": "Graphs & export", "de": "Diagramme & Export", "es": "Gráficos y exportación", "fr": "Graphiques & export", "zh": "图表与导出"]) }
    static var onboardingDesc4: String { t(["ru": "Стройте графики зависимостей, сохраняйте результаты в PDF, делитесь расчётами.", "en": "Build dependency graphs, save results to PDF, share calculations.", "de": "Erstellen Sie Abhängigkeitsdiagramme, speichern Sie Ergebnisse als PDF, teilen Sie Berechnungen.", "es": "Construya gráficos de dependencia, guarde resultados en PDF, comparta cálculos.", "fr": "Construisez des graphiques de dépendance, enregistrez les résultats en PDF, partagez les calculs.", "zh": "构建依赖关系图，将结果保存为 PDF，分享计算。"]) }
    static var onboardingTitle5: String { t(["ru": "Погрешности и решение", "en": "Errors & solution", "de": "Fehler & Lösung", "es": "Errores y solución", "fr": "Erreurs & solution", "zh": "误差与解题"]) }
    static var onboardingDesc5: String { t(["ru": "Калькулятор погрешностей, пошаговое решение, мультирасчёт для лабораторных работ.", "en": "Error calculator, step-by-step solution, multi-calc for lab work.", "de": "Fehlerrechner, Schritt-für-Schritt-Lösung, Mehrfachberechnung für Laborarbeiten.", "es": "Calculadora de errores, solución paso a paso, multi-cálculo para laboratorio.", "fr": "Calculateur d'erreurs, solution étape par étape, multi-calcul pour les travaux pratiques.", "zh": "误差计算器、逐步解题、批量计算用于实验。"]) }
    static var onboardingTitle6: String { t(["ru": "Справочник констант", "en": "Constants reference", "de": "Konstantenreferenz", "es": "Referencia de constantes", "fr": "Référence des constantes", "zh": "常数参考"]) }
    static var onboardingDesc6: String { t(["ru": "Все физические константы под рукой. Автоподстановка констант в формулы.", "en": "All physical constants at your fingertips. Auto-substitution of constants in formulas.", "de": "Alle physikalischen Konstanten griffbereit. Automatische Einsetzung von Konstanten in Formeln.", "es": "Todas las constantes físicas a su alcance. Sustitución automática de constantes en fórmulas.", "fr": "Toutes les constantes physiques à portée de main. Substitution automatique des constantes dans les formules.", "zh": "所有物理常数触手可及。公式中自动代入常数。"]) }
    static var next: String { t(["ru": "Далее", "en": "Next", "de": "Weiter", "es": "Siguiente", "fr": "Suivant", "zh": "下一步"]) }
    static var start: String { t(["ru": "Начать", "en": "Start", "de": "Starten", "es": "Empezar", "fr": "Commencer", "zh": "开始"]) }
    static var skip: String { t(["ru": "Пропустить", "en": "Skip", "de": "Überspringen", "es": "Omitir", "fr": "Passer", "zh": "跳过"]) }
    
    // MARK: - CalculationViewModel errors
    
    static var selectUnknownVariable: String { t(["ru": "Выберите неизвестную величину", "en": "Select the unknown variable", "de": "Wählen Sie die unbekannte Variable", "es": "Seleccione la variable desconocida", "fr": "Sélectionnez la variable inconnue", "zh": "选择未知变量"]) }
    static func enterCorrectValue(_ name: String) -> String {
        t(["ru": "Введите корректное значение для \(name)",
           "en": "Enter a valid value for \(name)",
           "de": "Geben Sie einen gültigen Wert für \(name) ein",
           "es": "Ingrese un valor válido para \(name)",
           "fr": "Entrez une valeur valide pour \(name)",
           "zh": "请为 \(name) 输入有效值"])
    }
    static func noRuleFor(_ symbol: String) -> String {
        t(["ru": "Не найдено правило расчета для \(symbol)",
           "en": "No calculation rule found for \(symbol)",
           "de": "Keine Berechnungsregel für \(symbol) gefunden",
           "es": "No se encontró regla de cálculo para \(symbol)",
           "fr": "Aucune règle de calcul trouvée pour \(symbol)",
           "zh": "未找到 \(symbol) 的计算规则"])
    }
    
    // MARK: - CalculationService errors
    
    static var invalidResult: String { t(["ru": "Результат не определен (деление на ноль или переполнение)", "en": "Result undefined (division by zero or overflow)", "de": "Ergebnis undefiniert (Division durch Null oder Überlauf)", "es": "Resultado indefinido (división por cero o desbordamiento)", "fr": "Résultat indéfini (division par zéro ou dépassement)", "zh": "结果未定义（除以零或溢出）"]) }
    static func evaluationError(_ msg: String) -> String {
        t(["ru": "Ошибка при вычислении: \(msg)",
           "en": "Calculation error: \(msg)",
           "de": "Berechnungsfehler: \(msg)",
           "es": "Error de cálculo: \(msg)",
           "fr": "Erreur de calcul : \(msg)",
           "zh": "计算错误：\(msg)"])
    }
    
    // MARK: - DataService errors

    static var fileNotFound: String { t(["ru": "Файл с данными не найден", "en": "Data file not found", "de": "Datendatei nicht gefunden", "es": "Archivo de datos no encontrado", "fr": "Fichier de données introuvable", "zh": "未找到数据文件"]) }
    static func decodingError(_ err: String) -> String {
        t(["ru": "Ошибка декодирования: \(err)",
           "en": "Decoding error: \(err)",
           "de": "Dekodierungsfehler: \(err)",
           "es": "Error de decodificación: \(err)",
           "fr": "Erreur de décodage : \(err)",
           "zh": "解码错误：\(err)"])
    }
    
    // MARK: - UnitConverter names
    
    static func unitName(_ id: String) -> String {
        let map: [String: [String: String]] = [
            // Length
            "m": ["ru": "Метры", "en": "Meters", "de": "Meter", "es": "Metros", "fr": "Mètres", "zh": "米"],
            "km": ["ru": "Километры", "en": "Kilometers", "de": "Kilometer", "es": "Kilómetros", "fr": "Kilomètres", "zh": "千米"],
            "cm": ["ru": "Сантиметры", "en": "Centimeters", "de": "Zentimeter", "es": "Centímetros", "fr": "Centimètres", "zh": "厘米"],
            "mm": ["ru": "Миллиметры", "en": "Millimeters", "de": "Millimeter", "es": "Milímetros", "fr": "Millimètres", "zh": "毫米"],
            "mi": ["ru": "Мили", "en": "Miles", "de": "Meilen", "es": "Millas", "fr": "Miles", "zh": "英里"],
            "ft": ["ru": "Футы", "en": "Feet", "de": "Fuß", "es": "Pies", "fr": "Pieds", "zh": "英尺"],
            // Time
            "s": ["ru": "Секунды", "en": "Seconds", "de": "Sekunden", "es": "Segundos", "fr": "Secondes", "zh": "秒"],
            "ms_time": ["ru": "Миллисекунды", "en": "Milliseconds", "de": "Millisekunden", "es": "Milisegundos", "fr": "Millisecondes", "zh": "毫秒"],
            "min": ["ru": "Минуты", "en": "Minutes", "de": "Minuten", "es": "Minutos", "fr": "Minutes", "zh": "分钟"],
            "h_time": ["ru": "Часы", "en": "Hours", "de": "Stunden", "es": "Horas", "fr": "Heures", "zh": "小时"],
            // Mass
            "kg": ["ru": "Килограммы", "en": "Kilograms", "de": "Kilogramm", "es": "Kilogramos", "fr": "Kilogrammes", "zh": "千克"],
            "g_mass": ["ru": "Граммы", "en": "Grams", "de": "Gramm", "es": "Gramos", "fr": "Grammes", "zh": "克"],
            "mg": ["ru": "Миллиграммы", "en": "Milligrams", "de": "Milligramm", "es": "Miligramos", "fr": "Milligrammes", "zh": "毫克"],
            "t": ["ru": "Тонны", "en": "Tons", "de": "Tonnen", "es": "Toneladas", "fr": "Tonnes", "zh": "吨"],
            "lb": ["ru": "Фунты", "en": "Pounds", "de": "Pfund", "es": "Libras", "fr": "Livres", "zh": "磅"],
            // Speed
            "ms_speed": ["ru": "м/с", "en": "m/s", "de": "m/s", "es": "m/s", "fr": "m/s", "zh": "m/s"],
            "kmh": ["ru": "км/ч", "en": "km/h", "de": "km/h", "es": "km/h", "fr": "km/h", "zh": "km/h"],
            "mph": ["ru": "мили/ч", "en": "mph", "de": "mph", "es": "mph", "fr": "mph", "zh": "mph"],
            // Force
            "N": ["ru": "Ньютоны", "en": "Newtons", "de": "Newton", "es": "Newtons", "fr": "Newtons", "zh": "牛顿"],
            "kN": ["ru": "Килоньютоны", "en": "Kilonewtons", "de": "Kilonewton", "es": "Kilonewtons", "fr": "Kilonewtons", "zh": "千牛顿"],
            "dyn": ["ru": "Дины", "en": "Dynes", "de": "Dyn", "es": "Dinas", "fr": "Dynes", "zh": "达因"],
            // Pressure
            "Pa": ["ru": "Паскали", "en": "Pascals", "de": "Pascal", "es": "Pascales", "fr": "Pascals", "zh": "帕斯卡"],
            "kPa": ["ru": "Килопаскали", "en": "Kilopascals", "de": "Kilopascal", "es": "Kilopascales", "fr": "Kilopascals", "zh": "千帕"],
            "atm": ["ru": "Атмосферы", "en": "Atmospheres", "de": "Atmosphären", "es": "Atmósferas", "fr": "Atmosphères", "zh": "大气压"],
            "mmHg": ["ru": "мм рт. ст.", "en": "mmHg", "de": "mmHg", "es": "mmHg", "fr": "mmHg", "zh": "mmHg"],
            "bar": ["ru": "Бары", "en": "Bars", "de": "Bar", "es": "Bares", "fr": "Bars", "zh": "巴"],
            // Energy
            "J": ["ru": "Джоули", "en": "Joules", "de": "Joule", "es": "Julios", "fr": "Joules", "zh": "焦耳"],
            "kJ": ["ru": "Килоджоули", "en": "Kilojoules", "de": "Kilojoule", "es": "Kilojulios", "fr": "Kilojoules", "zh": "千焦"],
            "cal": ["ru": "Калории", "en": "Calories", "de": "Kalorien", "es": "Calorías", "fr": "Calories", "zh": "卡路里"],
            "kcal": ["ru": "Килокалории", "en": "Kilocalories", "de": "Kilokalorien", "es": "Kilocalorías", "fr": "Kilocalories", "zh": "千卡"],
            "eV": ["ru": "Электронвольты", "en": "Electronvolts", "de": "Elektronenvolt", "es": "Electronvoltios", "fr": "Électronvolts", "zh": "电子伏特"],
            // Power
            "W": ["ru": "Ватты", "en": "Watts", "de": "Watt", "es": "Vatios", "fr": "Watts", "zh": "瓦特"],
            "kW": ["ru": "Киловатты", "en": "Kilowatts", "de": "Kilowatt", "es": "Kilovatios", "fr": "Kilowatts", "zh": "千瓦"],
            "hp": ["ru": "Лошадиные силы", "en": "Horsepower", "de": "Pferdestärken", "es": "Caballos de fuerza", "fr": "Chevaux", "zh": "马力"],
            // Temperature
            "K": ["ru": "Кельвины", "en": "Kelvin", "de": "Kelvin", "es": "Kelvin", "fr": "Kelvin", "zh": "开尔文"],
            "C_temp": ["ru": "Цельсий", "en": "Celsius", "de": "Celsius", "es": "Celsius", "fr": "Celsius", "zh": "摄氏度"],
            "F_temp": ["ru": "Фаренгейт", "en": "Fahrenheit", "de": "Fahrenheit", "es": "Fahrenheit", "fr": "Fahrenheit", "zh": "华氏度"],
            // Frequency
            "Hz": ["ru": "Герцы", "en": "Hertz", "de": "Hertz", "es": "Hercios", "fr": "Hertz", "zh": "赫兹"],
            "kHz": ["ru": "Килогерцы", "en": "Kilohertz", "de": "Kilohertz", "es": "Kilohercios", "fr": "Kilohertz", "zh": "千赫兹"],
            "MHz": ["ru": "Мегагерцы", "en": "Megahertz", "de": "Megahertz", "es": "Megahercios", "fr": "Mégahertz", "zh": "兆赫兹"],
            // Current
            "A": ["ru": "Амперы", "en": "Amperes", "de": "Ampere", "es": "Amperios", "fr": "Ampères", "zh": "安培"],
            "mA": ["ru": "Миллиамперы", "en": "Milliamperes", "de": "Milliampere", "es": "Miliamperios", "fr": "Milliampères", "zh": "毫安"],
            "uA": ["ru": "Микроамперы", "en": "Microamperes", "de": "Mikroampere", "es": "Microamperios", "fr": "Microampères", "zh": "微安"],
            // Voltage
            "V": ["ru": "Вольты", "en": "Volts", "de": "Volt", "es": "Voltios", "fr": "Volts", "zh": "伏特"],
            "kV": ["ru": "Киловольты", "en": "Kilovolts", "de": "Kilovolt", "es": "Kilovoltios", "fr": "Kilovolts", "zh": "千伏"],
            "mV": ["ru": "Милливольты", "en": "Millivolts", "de": "Millivolt", "es": "Milivoltios", "fr": "Millivolts", "zh": "毫伏"],
            // Resistance
            "Ohm": ["ru": "Омы", "en": "Ohms", "de": "Ohm", "es": "Ohmios", "fr": "Ohms", "zh": "欧姆"],
            "kOhm": ["ru": "Килоомы", "en": "Kilohms", "de": "Kilohm", "es": "Kiloohmios", "fr": "Kilohms", "zh": "千欧"],
            "MOhm": ["ru": "Мегаомы", "en": "Megohms", "de": "Megohm", "es": "Megaohmios", "fr": "Mégohms", "zh": "兆欧"],
            // Charge
            "C_charge": ["ru": "Кулоны", "en": "Coulombs", "de": "Coulomb", "es": "Culombios", "fr": "Coulombs", "zh": "库仑"],
            "mC": ["ru": "Милликулоны", "en": "Millicoulombs", "de": "Millicoulomb", "es": "Miliculombios", "fr": "Millicoulombs", "zh": "毫库仑"],
            "uC": ["ru": "Микрокулоны", "en": "Microcoulombs", "de": "Mikrocoulomb", "es": "Microculombios", "fr": "Microcoulombs", "zh": "微库仑"],
            // Area
            "m2": ["ru": "м²", "en": "m²", "de": "m²", "es": "m²", "fr": "m²", "zh": "m²"],
            "cm2": ["ru": "см²", "en": "cm²", "de": "cm²", "es": "cm²", "fr": "cm²", "zh": "cm²"],
            "km2": ["ru": "км²", "en": "km²", "de": "km²", "es": "km²", "fr": "km²", "zh": "km²"],
            // Volume
            "m3": ["ru": "м³", "en": "m³", "de": "m³", "es": "m³", "fr": "m³", "zh": "m³"],
            "L": ["ru": "Литры", "en": "Liters", "de": "Liter", "es": "Litros", "fr": "Litres", "zh": "升"],
            "cm3": ["ru": "см³", "en": "cm³", "de": "cm³", "es": "cm³", "fr": "cm³", "zh": "cm³"],
            // Acceleration
            "ms2": ["ru": "м/с²", "en": "m/s²", "de": "m/s²", "es": "m/s²", "fr": "m/s²", "zh": "m/s²"],
            "g_acc": ["ru": "g (9.81)", "en": "g (9.81)", "de": "g (9,81)", "es": "g (9,81)", "fr": "g (9,81)", "zh": "g (9.81)"],
            // Angle
            "rad": ["ru": "Радианы", "en": "Radians", "de": "Radiant", "es": "Radianes", "fr": "Radians", "zh": "弧度"],
            "deg": ["ru": "Градусы", "en": "Degrees", "de": "Grad", "es": "Grados", "fr": "Degrés", "zh": "度"],
        ]
        return t(map[id] ?? ["en": id])
    }
    
    // MARK: - ConstantsView
    
    static var constantsTitle: String { t(["ru": "Константы", "en": "Constants", "de": "Konstanten", "es": "Constantes", "fr": "Constantes", "zh": "常数"]) }
    static var searchConstants: String { t(["ru": "Поиск констант", "en": "Search constants", "de": "Konstanten suchen", "es": "Buscar constantes", "fr": "Rechercher des constantes", "zh": "搜索常数"]) }
    
    // Category names
    static var catUniversal: String { t(["ru": "Фундаментальные", "en": "Fundamental", "de": "Fundamentale", "es": "Fundamentales", "fr": "Fondamentales", "zh": "基本常数"]) }
    static var catElectromagnetic: String { t(["ru": "Электромагнитные", "en": "Electromagnetic", "de": "Elektromagnetische", "es": "Electromagnéticas", "fr": "Électromagnétiques", "zh": "电磁常数"]) }
    static var catAtomic: String { t(["ru": "Атомные и ядерные", "en": "Atomic & Nuclear", "de": "Atom- & Kernphysik", "es": "Atómicas y nucleares", "fr": "Atomiques et nucléaires", "zh": "原子与核常数"]) }
    static var catThermodynamic: String { t(["ru": "Термодинамические", "en": "Thermodynamic", "de": "Thermodynamische", "es": "Termodinámicas", "fr": "Thermodynamiques", "zh": "热力学常数"]) }
    static var catAstrophysical: String { t(["ru": "Астрофизические", "en": "Astrophysical", "de": "Astrophysikalische", "es": "Astrofísicas", "fr": "Astrophysiques", "zh": "天体物理常数"]) }
    static var catMathematical: String { t(["ru": "Математические", "en": "Mathematical", "de": "Mathematische", "es": "Matemáticas", "fr": "Mathématiques", "zh": "数学常数"]) }
    
    // Fundamental
    static var constSpeedOfLight: String { t(["ru": "Скорость света в вакууме", "en": "Speed of light in vacuum", "de": "Lichtgeschwindigkeit im Vakuum", "es": "Velocidad de la luz en el vacío", "fr": "Vitesse de la lumière dans le vide", "zh": "真空中的光速"]) }
    static var constSpeedOfLightDesc: String { t(["ru": "Максимальная скорость передачи информации", "en": "Maximum speed of information transfer", "de": "Maximale Geschwindigkeit der Informationsübertragung", "es": "Velocidad máxima de transferencia de información", "fr": "Vitesse maximale de transfert d'information", "zh": "信息传递的最大速度"]) }
    static var constGravitational: String { t(["ru": "Гравитационная постоянная", "en": "Gravitational constant", "de": "Gravitationskonstante", "es": "Constante gravitacional", "fr": "Constante gravitationnelle", "zh": "万有引力常数"]) }
    static var constGravitationalDesc: String { t(["ru": "Определяет силу гравитационного взаимодействия", "en": "Determines the strength of gravitational interaction", "de": "Bestimmt die Stärke der Gravitationswechselwirkung", "es": "Determina la fuerza de la interacción gravitacional", "fr": "Détermine l'intensité de l'interaction gravitationnelle", "zh": "决定引力相互作用的强度"]) }
    static var constPlanck: String { t(["ru": "Постоянная Планка", "en": "Planck constant", "de": "Planck-Konstante", "es": "Constante de Planck", "fr": "Constante de Planck", "zh": "普朗克常数"]) }
    static var constPlanckDesc: String { t(["ru": "Связывает энергию фотона с частотой", "en": "Relates photon energy to frequency", "de": "Verknüpft Photonenenergie mit Frequenz", "es": "Relaciona la energía del fotón con la frecuencia", "fr": "Relie l'énergie du photon à la fréquence", "zh": "将光子能量与频率联系起来"]) }
    static var constReducedPlanck: String { t(["ru": "Приведённая постоянная Планка", "en": "Reduced Planck constant", "de": "Reduzierte Planck-Konstante", "es": "Constante de Planck reducida", "fr": "Constante de Planck réduite", "zh": "约化普朗克常数"]) }
    static var constReducedPlanckDesc: String { t(["ru": "ℏ = h/(2π), используется в квантовой механике", "en": "ℏ = h/(2π), used in quantum mechanics", "de": "ℏ = h/(2π), in der Quantenmechanik verwendet", "es": "ℏ = h/(2π), usada en mecánica cuántica", "fr": "ℏ = h/(2π), utilisée en mécanique quantique", "zh": "ℏ = h/(2π)，用于量子力学"]) }
    static var constAvogadro: String { t(["ru": "Число Авогадро", "en": "Avogadro's number", "de": "Avogadro-Zahl", "es": "Número de Avogadro", "fr": "Nombre d'Avogadro", "zh": "阿伏伽德罗常数"]) }
    static var constAvogadroDesc: String { t(["ru": "Число частиц в одном моле вещества", "en": "Number of particles in one mole", "de": "Anzahl der Teilchen in einem Mol", "es": "Número de partículas en un mol", "fr": "Nombre de particules dans une mole", "zh": "一摩尔物质中的粒子数"]) }
    static var constGasConst: String { t(["ru": "Универсальная газовая постоянная", "en": "Universal gas constant", "de": "Universelle Gaskonstante", "es": "Constante universal de los gases", "fr": "Constante universelle des gaz", "zh": "通用气体常数"]) }
    static var constGasConstDesc: String { t(["ru": "R = Nₐ · kB", "en": "R = Nₐ · kB", "de": "R = Nₐ · kB", "es": "R = Nₐ · kB", "fr": "R = Nₐ · kB", "zh": "R = Nₐ · kB"]) }
    static var constStefanBoltzmann: String { t(["ru": "Постоянная Стефана-Больцмана", "en": "Stefan-Boltzmann constant", "de": "Stefan-Boltzmann-Konstante", "es": "Constante de Stefan-Boltzmann", "fr": "Constante de Stefan-Boltzmann", "zh": "斯特藩-玻尔兹曼常数"]) }
    static var constStefanBoltzmannDesc: String { t(["ru": "Связывает мощность теплового излучения с температурой", "en": "Relates thermal radiation power to temperature", "de": "Verknüpft Wärmestrahlungsleistung mit Temperatur", "es": "Relaciona la potencia de radiación térmica con la temperatura", "fr": "Relie la puissance de rayonnement thermique à la température", "zh": "将热辐射功率与温度联系起来"]) }
    
    // Electromagnetic
    static var constElementaryCharge: String { t(["ru": "Элементарный заряд", "en": "Elementary charge", "de": "Elementarladung", "es": "Carga elemental", "fr": "Charge élémentaire", "zh": "基本电荷"]) }
    static var constElementaryChargeDesc: String { t(["ru": "Заряд электрона (по модулю)", "en": "Charge of electron (absolute value)", "de": "Ladung des Elektrons (Betrag)", "es": "Carga del electrón (valor absoluto)", "fr": "Charge de l'électron (valeur absolue)", "zh": "电子电荷（绝对值）"]) }
    static var constCoulomb: String { t(["ru": "Постоянная Кулона", "en": "Coulomb constant", "de": "Coulomb-Konstante", "es": "Constante de Coulomb", "fr": "Constante de Coulomb", "zh": "库仑常数"]) }
    static var constCoulombDesc: String { t(["ru": "k = 1/(4πε₀)", "en": "k = 1/(4πε₀)", "de": "k = 1/(4πε₀)", "es": "k = 1/(4πε₀)", "fr": "k = 1/(4πε₀)", "zh": "k = 1/(4πε₀)"]) }
    static var constPermittivity: String { t(["ru": "Электрическая постоянная", "en": "Vacuum permittivity", "de": "Elektrische Feldkonstante", "es": "Permitividad del vacío", "fr": "Permittivité du vide", "zh": "真空介电常数"]) }
    static var constPermittivityDesc: String { t(["ru": "Диэлектрическая проницаемость вакуума", "en": "Permittivity of free space", "de": "Dielektrizitätskonstante des Vakuums", "es": "Permitividad del espacio libre", "fr": "Permittivité de l'espace libre", "zh": "自由空间的介电常数"]) }
    static var constPermeability: String { t(["ru": "Магнитная постоянная", "en": "Vacuum permeability", "de": "Magnetische Feldkonstante", "es": "Permeabilidad del vacío", "fr": "Perméabilité du vide", "zh": "真空磁导率"]) }
    static var constPermeabilityDesc: String { t(["ru": "Магнитная проницаемость вакуума", "en": "Permeability of free space", "de": "Magnetische Permeabilität des Vakuums", "es": "Permeabilidad del espacio libre", "fr": "Perméabilité de l'espace libre", "zh": "自由空间的磁导率"]) }
    static var constFluxQuantum: String { t(["ru": "Квант магнитного потока", "en": "Magnetic flux quantum", "de": "Magnetisches Flussquantum", "es": "Cuanto de flujo magnético", "fr": "Quantum de flux magnétique", "zh": "磁通量子"]) }
    static var constFluxQuantumDesc: String { t(["ru": "Φ₀ = h/(2e)", "en": "Φ₀ = h/(2e)", "de": "Φ₀ = h/(2e)", "es": "Φ₀ = h/(2e)", "fr": "Φ₀ = h/(2e)", "zh": "Φ₀ = h/(2e)"]) }
    
    // Atomic
    static var constElectronMass: String { t(["ru": "Масса электрона", "en": "Electron mass", "de": "Elektronenmasse", "es": "Masa del electrón", "fr": "Masse de l'électron", "zh": "电子质量"]) }
    static var constElectronMassDesc: String { t(["ru": "Масса покоя электрона", "en": "Rest mass of electron", "de": "Ruhmasse des Elektrons", "es": "Masa en reposo del electrón", "fr": "Masse au repos de l'électron", "zh": "电子的静止质量"]) }
    static var constProtonMass: String { t(["ru": "Масса протона", "en": "Proton mass", "de": "Protonenmasse", "es": "Masa del protón", "fr": "Masse du proton", "zh": "质子质量"]) }
    static var constProtonMassDesc: String { t(["ru": "Масса покоя протона", "en": "Rest mass of proton", "de": "Ruhmasse des Protons", "es": "Masa en reposo del protón", "fr": "Masse au repos du proton", "zh": "质子的静止质量"]) }
    static var constNeutronMass: String { t(["ru": "Масса нейтрона", "en": "Neutron mass", "de": "Neutronenmasse", "es": "Masa del neutrón", "fr": "Masse du neutron", "zh": "中子质量"]) }
    static var constNeutronMassDesc: String { t(["ru": "Масса покоя нейтрона", "en": "Rest mass of neutron", "de": "Ruhmasse des Neutrons", "es": "Masa en reposo del neutrón", "fr": "Masse au repos du neutron", "zh": "中子的静止质量"]) }
    static var constAMU: String { t(["ru": "Атомная единица массы", "en": "Atomic mass unit", "de": "Atomare Masseneinheit", "es": "Unidad de masa atómica", "fr": "Unité de masse atomique", "zh": "原子质量单位"]) }
    static var constAMUDesc: String { t(["ru": "1/12 массы атома углерода-12", "en": "1/12 of carbon-12 atom mass", "de": "1/12 der Masse eines Kohlenstoff-12-Atoms", "es": "1/12 de la masa del átomo de carbono-12", "fr": "1/12 de la masse d'un atome de carbone-12", "zh": "碳-12原子质量的1/12"]) }
    static var constBohrRadius: String { t(["ru": "Боровский радиус", "en": "Bohr radius", "de": "Bohrscher Radius", "es": "Radio de Bohr", "fr": "Rayon de Bohr", "zh": "玻尔半径"]) }
    static var constBohrRadiusDesc: String { t(["ru": "Радиус первой орбиты атома водорода", "en": "Radius of first hydrogen orbit", "de": "Radius der ersten Wasserstoffbahn", "es": "Radio de la primera órbita del hidrógeno", "fr": "Rayon de la première orbite de l'hydrogène", "zh": "氢原子第一轨道半径"]) }
    static var constRydberg: String { t(["ru": "Постоянная Ридберга", "en": "Rydberg constant", "de": "Rydberg-Konstante", "es": "Constante de Rydberg", "fr": "Constante de Rydberg", "zh": "里德伯常数"]) }
    static var constRydbergDesc: String { t(["ru": "Используется в спектроскопии атома водорода", "en": "Used in hydrogen atom spectroscopy", "de": "Verwendet in der Wasserstoffspektroskopie", "es": "Usada en espectroscopía del hidrógeno", "fr": "Utilisée en spectroscopie de l'hydrogène", "zh": "用于氢原子光谱学"]) }
    
    // Thermodynamic
    static var constBoltzmann: String { t(["ru": "Постоянная Больцмана", "en": "Boltzmann constant", "de": "Boltzmann-Konstante", "es": "Constante de Boltzmann", "fr": "Constante de Boltzmann", "zh": "玻尔兹曼常数"]) }
    static var constBoltzmannDesc: String { t(["ru": "Связывает температуру со средней энергией частиц", "en": "Relates temperature to average particle energy", "de": "Verknüpft Temperatur mit mittlerer Teilchenenergie", "es": "Relaciona la temperatura con la energía media de las partículas", "fr": "Relie la température à l'énergie moyenne des particules", "zh": "将温度与粒子平均能量联系起来"]) }
    static var constAtmosphere: String { t(["ru": "Стандартная атмосфера", "en": "Standard atmosphere", "de": "Standardatmosphäre", "es": "Atmósfera estándar", "fr": "Atmosphère standard", "zh": "标准大气压"]) }
    static var constAtmosphereDesc: String { t(["ru": "Нормальное атмосферное давление на уровне моря", "en": "Normal atmospheric pressure at sea level", "de": "Normaler atmosphärischer Druck auf Meereshöhe", "es": "Presión atmosférica normal al nivel del mar", "fr": "Pression atmosphérique normale au niveau de la mer", "zh": "海平面标准大气压"]) }
    static var constWien: String { t(["ru": "Постоянная Вина", "en": "Wien displacement constant", "de": "Wiensche Verschiebungskonstante", "es": "Constante de desplazamiento de Wien", "fr": "Constante de déplacement de Wien", "zh": "维恩位移常数"]) }
    static var constWienDesc: String { t(["ru": "Определяет длину волны максимума излучения чёрного тела", "en": "Determines peak wavelength of black body radiation", "de": "Bestimmt die Wellenlänge des Strahlungsmaximums", "es": "Determina la longitud de onda del máximo de radiación", "fr": "Détermine la longueur d'onde du maximum de rayonnement", "zh": "确定黑体辐射峰值波长"]) }
    static var constAbsoluteZero: String { t(["ru": "Абсолютный нуль (в °C)", "en": "Absolute zero (in °C)", "de": "Absoluter Nullpunkt (in °C)", "es": "Cero absoluto (en °C)", "fr": "Zéro absolu (en °C)", "zh": "绝对零度（°C）"]) }
    static var constAbsoluteZeroDesc: String { t(["ru": "0 K = −273.15 °C", "en": "0 K = −273.15 °C", "de": "0 K = −273,15 °C", "es": "0 K = −273,15 °C", "fr": "0 K = −273,15 °C", "zh": "0 K = −273.15 °C"]) }
    
    // MARK: - Unit Converter

    static var converterTitle: String { t(["ru": "Конвертер единиц", "en": "Unit Converter", "de": "Einheitenumrechner", "es": "Conversor de unidades", "fr": "Convertisseur", "zh": "单位换算"]) }
    static var converterFrom: String { t(["ru": "Из", "en": "From", "de": "Von", "es": "De", "fr": "De", "zh": "从"]) }
    static var converterTo: String { t(["ru": "В", "en": "To", "de": "Nach", "es": "A", "fr": "Vers", "zh": "到"]) }
    static var converterAllUnits: String { t(["ru": "Все единицы", "en": "All units", "de": "Alle Einheiten", "es": "Todas las unidades", "fr": "Toutes les unités", "zh": "所有单位"]) }

    // Astrophysical
    static var constStandardGravity: String { t(["ru": "Ускорение свободного падения", "en": "Standard gravity", "de": "Normfallbeschleunigung", "es": "Gravedad estándar", "fr": "Pesanteur standard", "zh": "标准重力加速度"]) }
    static var constStandardGravityDesc: String { t(["ru": "На поверхности Земли (стандартное)", "en": "At Earth's surface (standard)", "de": "An der Erdoberfläche (Standard)", "es": "En la superficie de la Tierra (estándar)", "fr": "À la surface de la Terre (standard)", "zh": "地球表面（标准值）"]) }
    static var constEarthMass: String { t(["ru": "Масса Земли", "en": "Earth mass", "de": "Erdmasse", "es": "Masa de la Tierra", "fr": "Masse de la Terre", "zh": "地球质量"]) }
    static var constEarthMassDesc: String { "" }
    static var constEarthRadius: String { t(["ru": "Средний радиус Земли", "en": "Mean Earth radius", "de": "Mittlerer Erdradius", "es": "Radio medio de la Tierra", "fr": "Rayon moyen de la Terre", "zh": "地球平均半径"]) }
    static var constEarthRadiusDesc: String { "" }
    static var constSunMass: String { t(["ru": "Масса Солнца", "en": "Sun mass", "de": "Sonnenmasse", "es": "Masa del Sol", "fr": "Masse du Soleil", "zh": "太阳质量"]) }
    static var constSunMassDesc: String { "" }
    static var constAU: String { t(["ru": "Астрономическая единица", "en": "Astronomical unit", "de": "Astronomische Einheit", "es": "Unidad astronómica", "fr": "Unité astronomique", "zh": "天文单位"]) }
    static var constAUDesc: String { t(["ru": "Среднее расстояние от Земли до Солнца", "en": "Mean Earth–Sun distance", "de": "Mittlere Entfernung Erde–Sonne", "es": "Distancia media Tierra–Sol", "fr": "Distance moyenne Terre–Soleil", "zh": "地球到太阳的平均距离"]) }
    static var constLightYear: String { t(["ru": "Световой год", "en": "Light-year", "de": "Lichtjahr", "es": "Año luz", "fr": "Année-lumière", "zh": "光年"]) }
    static var constLightYearDesc: String { t(["ru": "Расстояние, проходимое светом за 1 год", "en": "Distance light travels in 1 year", "de": "Strecke, die Licht in 1 Jahr zurücklegt", "es": "Distancia que la luz recorre en 1 año", "fr": "Distance parcourue par la lumière en 1 an", "zh": "光在1年内传播的距离"]) }
    
    // Mathematical
    static var constPi: String { t(["ru": "Число π (пи)", "en": "Pi (π)", "de": "Kreiszahl π (Pi)", "es": "Número π (pi)", "fr": "Nombre π (pi)", "zh": "圆周率 π"]) }
    static var constPiDesc: String { t(["ru": "Отношение длины окружности к диаметру", "en": "Ratio of circumference to diameter", "de": "Verhältnis von Umfang zu Durchmesser", "es": "Relación de la circunferencia al diámetro", "fr": "Rapport de la circonférence au diamètre", "zh": "圆周长与直径之比"]) }
    static var constEuler: String { t(["ru": "Число Эйлера (e)", "en": "Euler's number (e)", "de": "Eulersche Zahl (e)", "es": "Número de Euler (e)", "fr": "Nombre d'Euler (e)", "zh": "欧拉数 (e)"]) }
    static var constEulerDesc: String { t(["ru": "Основание натурального логарифма", "en": "Base of natural logarithm", "de": "Basis des natürlichen Logarithmus", "es": "Base del logaritmo natural", "fr": "Base du logarithme naturel", "zh": "自然对数的底"]) }
    
    // MARK: - PhysicalConstants names (legacy - used in CalculationView)
    
    static func constantName(_ symbol: String, _ unit: String) -> String {
        let key = "\(symbol)_\(unit)"
        let map: [String: [String: String]] = [
            "g_м/с²": ["ru": "Ускорение свободного падения", "en": "Gravitational acceleration", "de": "Fallbeschleunigung", "es": "Aceleración gravitacional", "fr": "Accélération gravitationnelle", "zh": "重力加速度"],
            "R_Дж/(моль·К)": ["ru": "Газовая постоянная", "en": "Gas constant", "de": "Gaskonstante", "es": "Constante de los gases", "fr": "Constante des gaz", "zh": "气体常数"],
            "c_м/с": ["ru": "Скорость света", "en": "Speed of light", "de": "Lichtgeschwindigkeit", "es": "Velocidad de la luz", "fr": "Vitesse de la lumière", "zh": "光速"],
            "k_B_Дж/К": ["ru": "Постоянная Больцмана", "en": "Boltzmann constant", "de": "Boltzmann-Konstante", "es": "Constante de Boltzmann", "fr": "Constante de Boltzmann", "zh": "玻尔兹曼常数"],
            "N_A_1/моль": ["ru": "Число Авогадро", "en": "Avogadro's number", "de": "Avogadro-Zahl", "es": "Número de Avogadro", "fr": "Nombre d'Avogadro", "zh": "阿伏伽德罗常数"],
            "e_Кл": ["ru": "Элементарный заряд", "en": "Elementary charge", "de": "Elementarladung", "es": "Carga elemental", "fr": "Charge élémentaire", "zh": "基本电荷"],
            "h_Дж·с": ["ru": "Постоянная Планка", "en": "Planck constant", "de": "Planck-Konstante", "es": "Constante de Planck", "fr": "Constante de Planck", "zh": "普朗克常数"],
            "ε0_Ф/м": ["ru": "Электрическая постоянная", "en": "Vacuum permittivity", "de": "Elektrische Feldkonstante", "es": "Permitividad del vacío", "fr": "Permittivité du vide", "zh": "真空介电常数"],
            "μ0_Гн/м": ["ru": "Магнитная постоянная", "en": "Vacuum permeability", "de": "Magnetische Feldkonstante", "es": "Permeabilidad del vacío", "fr": "Perméabilité du vide", "zh": "真空磁导率"],
            "σ_Вт/(м²·К⁴)": ["ru": "Постоянная Стефана-Больцмана", "en": "Stefan-Boltzmann constant", "de": "Stefan-Boltzmann-Konstante", "es": "Constante de Stefan-Boltzmann", "fr": "Constante de Stefan-Boltzmann", "zh": "斯特藩-玻尔兹曼常数"],
            "G_Н·м²/кг²": ["ru": "Гравитационная постоянная", "en": "Gravitational constant", "de": "Gravitationskonstante", "es": "Constante gravitacional", "fr": "Constante gravitationnelle", "zh": "万有引力常数"],
            "k_Н·м²/Кл²": ["ru": "Коэффициент Кулона", "en": "Coulomb constant", "de": "Coulomb-Konstante", "es": "Constante de Coulomb", "fr": "Constante de Coulomb", "zh": "库仑常数"],
        ]
        return t(map[key] ?? ["en": symbol])
    }
    
    // MARK: - Physics data translations (sections, subsections, formulas, variables)
    
    /// Translated name for a physics data entry by its English name.
    /// Used for de/es/fr/zh — ru/en come from JSON directly.
    static func physicsName(_ nameEn: String) -> String {
        guard let translations = _physicsNameMap[nameEn],
              let translated = translations[code] else {
            return nameEn
        }
        return translated
    }
    
    // swiftlint:disable line_length
    private static let _physicsNameMap: [String: [String: String]] = [
        // ── Sections ──
        "Mechanics": ["de": "Mechanik", "es": "Mecánica", "fr": "Mécanique", "zh": "力学"],
        "Thermodynamics": ["de": "Thermodynamik", "es": "Termodinámica", "fr": "Thermodynamique", "zh": "热力学"],
        "Electromagnetism": ["de": "Elektromagnetismus", "es": "Electromagnetismo", "fr": "Électromagnétisme", "zh": "电磁学"],
        "Optics": ["de": "Optik", "es": "Óptica", "fr": "Optique", "zh": "光学"],
        // ── Subsections ──
        "Kinematics": ["de": "Kinematik", "es": "Cinemática", "fr": "Cinématique", "zh": "运动学"],
        "Dynamics": ["de": "Dynamik", "es": "Dinámica", "fr": "Dynamique", "zh": "动力学"],
        "Work, Energy, Power": ["de": "Arbeit, Energie, Leistung", "es": "Trabajo, Energía, Potencia", "fr": "Travail, Énergie, Puissance", "zh": "功、能、功率"],
        "Rotational Motion": ["de": "Rotationsbewegung", "es": "Movimiento rotacional", "fr": "Mouvement de rotation", "zh": "转动"],
        "Fluid Statics": ["de": "Hydrostatik", "es": "Hidrostática", "fr": "Hydrostatique", "zh": "流体静力学"],
        "Gravitation": ["de": "Gravitation", "es": "Gravitación", "fr": "Gravitation", "zh": "万有引力"],
        "Ideal Gas": ["de": "Ideales Gas", "es": "Gas ideal", "fr": "Gaz parfait", "zh": "理想气体"],
        "Laws of Thermodynamics": ["de": "Hauptsätze der Thermodynamik", "es": "Leyes de la termodinámica", "fr": "Lois de la thermodynamique", "zh": "热力学定律"],
        "Heat Transfer & Capacity": ["de": "Wärmeübertragung & Kapazität", "es": "Transferencia de calor y capacidad", "fr": "Transfert de chaleur et capacité", "zh": "传热与热容"],
        "Phase Transitions": ["de": "Phasenübergänge", "es": "Transiciones de fase", "fr": "Transitions de phase", "zh": "相变"],
        "Real Gas": ["de": "Reales Gas", "es": "Gas real", "fr": "Gaz réel", "zh": "实际气体"],
        "Electrostatics": ["de": "Elektrostatik", "es": "Electrostática", "fr": "Électrostatique", "zh": "静电学"],
        "DC Circuits": ["de": "Gleichstromkreise", "es": "Circuitos de CC", "fr": "Circuits à courant continu", "zh": "直流电路"],
        "Magnetism": ["de": "Magnetismus", "es": "Magnetismo", "fr": "Magnétisme", "zh": "磁学"],
        "Electromagnetic Induction": ["de": "Elektromagnetische Induktion", "es": "Inducción electromagnética", "fr": "Induction électromagnétique", "zh": "电磁感应"],
        "Maxwell's Equations": ["de": "Maxwell-Gleichungen", "es": "Ecuaciones de Maxwell", "fr": "Équations de Maxwell", "zh": "麦克斯韦方程组"],
        "Geometric Optics": ["de": "Geometrische Optik", "es": "Óptica geométrica", "fr": "Optique géométrique", "zh": "几何光学"],
        "Wave Optics": ["de": "Wellenoptik", "es": "Óptica ondulatoria", "fr": "Optique ondulatoire", "zh": "波动光学"],
        "Quantum Optics": ["de": "Quantenoptik", "es": "Óptica cuántica", "fr": "Optique quantique", "zh": "量子光学"],
        // ── Formulas ──
        "Average Velocity": ["de": "Durchschnittsgeschwindigkeit", "es": "Velocidad media", "fr": "Vitesse moyenne", "zh": "平均速度"],
        "Acceleration": ["de": "Beschleunigung", "es": "Aceleración", "fr": "Accélération", "zh": "加速度"],
        "Newton's Second Law": ["de": "Zweites Newtonsches Gesetz", "es": "Segunda ley de Newton", "fr": "Deuxième loi de Newton", "zh": "牛顿第二定律"],
        "Momentum Conservation (2 bodies)": ["de": "Impulserhaltung (2 Körper)", "es": "Conservación del momento (2 cuerpos)", "fr": "Conservation de la quantité de mouvement (2 corps)", "zh": "动量守恒（两物体）"],
        "Kinetic Energy": ["de": "Kinetische Energie", "es": "Energía cinética", "fr": "Énergie cinétique", "zh": "动能"],
        "Ideal Gas Law": ["de": "Ideale Gasgleichung", "es": "Ley del gas ideal", "fr": "Loi des gaz parfaits", "zh": "理想气体状态方程"],
        "Second Law of Thermodynamics (Entropy)": ["de": "Zweiter Hauptsatz (Entropie)", "es": "Segunda ley (Entropía)", "fr": "Deuxième loi (Entropie)", "zh": "热力学第二定律（熵）"],
        "Ohm's Law (circuit section)": ["de": "Ohmsches Gesetz (Teilstromkreis)", "es": "Ley de Ohm (sección)", "fr": "Loi d'Ohm (portion de circuit)", "zh": "欧姆定律（电路段）"],
        "Faraday's Law (Induced EMF)": ["de": "Faradaysches Induktionsgesetz", "es": "Ley de Faraday (FEM inducida)", "fr": "Loi de Faraday (FÉM induite)", "zh": "法拉第定律（感应电动势）"],
        "Thin Lens Formula": ["de": "Dünne Linsenformel", "es": "Fórmula de la lente delgada", "fr": "Formule des lentilles minces", "zh": "薄透镜公式"],
        "Malus's Law": ["de": "Gesetz von Malus", "es": "Ley de Malus", "fr": "Loi de Malus", "zh": "马吕斯定律"],
        "Isothermal Process (Boyle's Law)": ["de": "Isothermer Prozess (Boyle)", "es": "Proceso isotérmico (Boyle)", "fr": "Processus isotherme (Boyle)", "zh": "等温过程（波义耳定律）"],
        "Archimedes' Principle": ["de": "Archimedisches Prinzip", "es": "Principio de Arquímedes", "fr": "Principe d'Archimède", "zh": "阿基米德原理"],
        "Hydrostatic Pressure": ["de": "Hydrostatischer Druck", "es": "Presión hidrostática", "fr": "Pression hydrostatique", "zh": "静水压强"],
        "Total Pressure at Bottom": ["de": "Gesamtdruck am Boden", "es": "Presión total en el fondo", "fr": "Pression totale au fond", "zh": "底部总压强"],
        "Communicating Vessels": ["de": "Kommunizierende Röhren", "es": "Vasos comunicantes", "fr": "Vases communicants", "zh": "连通器"],
        "Displacement with Constant Acceleration": ["de": "Gleichm. beschl. Bewegung", "es": "Desplazamiento con aceleración constante", "fr": "Déplacement à accélération constante", "zh": "匀变速直线运动位移"],
        "Velocity-Displacement Relation": ["de": "Geschwindigkeits-Weg-Beziehung", "es": "Relación velocidad-desplazamiento", "fr": "Relation vitesse-déplacement", "zh": "速度-位移关系"],
        "Free Fall": ["de": "Freier Fall", "es": "Caída libre", "fr": "Chute libre", "zh": "自由落体"],
        "Centripetal Acceleration": ["de": "Zentripetalbeschleunigung", "es": "Aceleración centrípeta", "fr": "Accélération centripète", "zh": "向心加速度"],
        "Weight": ["de": "Gewichtskraft", "es": "Peso", "fr": "Poids", "zh": "重力"],
        "Sliding Friction Force": ["de": "Gleitreibungskraft", "es": "Fuerza de fricción", "fr": "Force de frottement", "zh": "滑动摩擦力"],
        "Hooke's Law": ["de": "Hookesches Gesetz", "es": "Ley de Hooke", "fr": "Loi de Hooke", "zh": "胡克定律"],
        "Momentum": ["de": "Impuls", "es": "Momento lineal", "fr": "Quantité de mouvement", "zh": "动量"],
        "Potential Energy": ["de": "Potentielle Energie", "es": "Energía potencial", "fr": "Énergie potentielle", "zh": "势能"],
        "Mechanical Work": ["de": "Mechanische Arbeit", "es": "Trabajo mecánico", "fr": "Travail mécanique", "zh": "机械功"],
        "Power": ["de": "Leistung", "es": "Potencia", "fr": "Puissance", "zh": "功率"],
        "Elastic Potential Energy": ["de": "Elastische Energie", "es": "Energía potencial elástica", "fr": "Énergie potentielle élastique", "zh": "弹性势能"],
        "Law of Universal Gravitation": ["de": "Gravitationsgesetz", "es": "Ley de gravitación universal", "fr": "Loi de la gravitation universelle", "zh": "万有引力定律"],
        "First Cosmic Velocity": ["de": "Erste kosmische Geschwindigkeit", "es": "Primera velocidad cósmica", "fr": "Première vitesse cosmique", "zh": "第一宇宙速度"],
        "Gravitational Acceleration": ["de": "Gravitationsbeschleunigung", "es": "Aceleración gravitacional", "fr": "Accélération gravitationnelle", "zh": "重力加速度"],
        "Torque": ["de": "Drehmoment", "es": "Momento de fuerza", "fr": "Couple de forces", "zh": "力矩"],
        "Angular Velocity": ["de": "Winkelgeschwindigkeit", "es": "Velocidad angular", "fr": "Vitesse angulaire", "zh": "角速度"],
        "Linear and Angular Velocity Relation": ["de": "Lineare und Winkelgeschwindigkeit", "es": "Relación velocidad lineal y angular", "fr": "Relation vitesse linéaire et angulaire", "zh": "线速度与角速度关系"],
        "Isobaric Process (Gay-Lussac's Law)": ["de": "Isobarer Prozess (Gay-Lussac)", "es": "Proceso isobárico (Gay-Lussac)", "fr": "Processus isobare (Gay-Lussac)", "zh": "等压过程（盖-吕萨克定律）"],
        "Isochoric Process (Charles's Law)": ["de": "Isochorer Prozess (Charles)", "es": "Proceso isocórico (Charles)", "fr": "Processus isochore (Charles)", "zh": "等容过程（查理定律）"],
        "First Law of Thermodynamics": ["de": "Erster Hauptsatz", "es": "Primera ley de la termodinámica", "fr": "Premier principe", "zh": "热力学第一定律"],
        "Heat Engine Efficiency": ["de": "Wärmekraftwirkungsgrad", "es": "Eficiencia del motor térmico", "fr": "Rendement du moteur thermique", "zh": "热机效率"],
        "Heat for Temperature Change": ["de": "Wärme bei Temperaturänderung", "es": "Calor para cambio de temperatura", "fr": "Chaleur pour changement de température", "zh": "温度变化热量"],
        "Heat of Combustion": ["de": "Verbrennungswärme", "es": "Calor de combustión", "fr": "Chaleur de combustion", "zh": "燃烧热"],
        "Heat of Fusion": ["de": "Schmelzwärme", "es": "Calor de fusión", "fr": "Chaleur de fusion", "zh": "熔化热"],
        "Heat of Vaporization": ["de": "Verdampfungswärme", "es": "Calor de vaporización", "fr": "Chaleur de vaporisation", "zh": "汽化热"],
        "Van der Waals Equation (1 mole)": ["de": "Van-der-Waals-Gleichung (1 Mol)", "es": "Ecuación de Van der Waals (1 mol)", "fr": "Équation de Van der Waals (1 mole)", "zh": "范德瓦尔斯方程（1摩尔）"],
        "Coulomb's Law": ["de": "Coulomb-Gesetz", "es": "Ley de Coulomb", "fr": "Loi de Coulomb", "zh": "库仑定律"],
        "Electric Field Strength": ["de": "Elektrische Feldstärke", "es": "Intensidad del campo eléctrico", "fr": "Intensité du champ électrique", "zh": "电场强度"],
        "Capacitance": ["de": "Kapazität", "es": "Capacitancia", "fr": "Capacité", "zh": "电容"],
        "Capacitor Energy": ["de": "Kondensatorenergie", "es": "Energía del condensador", "fr": "Énergie du condensateur", "zh": "电容器能量"],
        "Electric Power": ["de": "Elektrische Leistung", "es": "Potencia eléctrica", "fr": "Puissance électrique", "zh": "电功率"],
        "Electric Work": ["de": "Elektrische Arbeit", "es": "Trabajo eléctrico", "fr": "Travail électrique", "zh": "电功"],
        "Joule-Lenz Law": ["de": "Joule-Lenz-Gesetz", "es": "Ley de Joule-Lenz", "fr": "Loi de Joule-Lenz", "zh": "焦耳-楞次定律"],
        "Series Resistance": ["de": "Reihenschaltung", "es": "Resistencia en serie", "fr": "Résistance en série", "zh": "串联电阻"],
        "Parallel Resistance": ["de": "Parallelschaltung", "es": "Resistencia en paralelo", "fr": "Résistance en parallèle", "zh": "并联电阻"],
        "Ampere Force": ["de": "Ampèresche Kraft", "es": "Fuerza de Ampère", "fr": "Force d'Ampère", "zh": "安培力"],
        "Lorentz Force": ["de": "Lorentzkraft", "es": "Fuerza de Lorentz", "fr": "Force de Lorentz", "zh": "洛伦兹力"],
        "Magnetic Flux": ["de": "Magnetischer Fluss", "es": "Flujo magnético", "fr": "Flux magnétique", "zh": "磁通量"],
        "Induced EMF": ["de": "Induktionsspannung", "es": "FEM inducida", "fr": "FÉM induite", "zh": "感应电动势"],
        "Snell's Law": ["de": "Snelliussches Brechungsgesetz", "es": "Ley de Snell", "fr": "Loi de Snell-Descartes", "zh": "斯涅尔定律"],
        "Diffraction Grating": ["de": "Beugungsgitter", "es": "Rejilla de difracción", "fr": "Réseau de diffraction", "zh": "衍射光栅"],
        "Photon Energy": ["de": "Photonenenergie", "es": "Energía del fotón", "fr": "Énergie du photon", "zh": "光子能量"],
        "Photoelectric Effect (Einstein)": ["de": "Photoeffekt (Einstein)", "es": "Efecto fotoeléctrico (Einstein)", "fr": "Effet photoélectrique (Einstein)", "zh": "光电效应（爱因斯坦）"],
        "De Broglie Wavelength": ["de": "De-Broglie-Wellenlänge", "es": "Longitud de onda de De Broglie", "fr": "Longueur d'onde de De Broglie", "zh": "德布罗意波长"],
        // ── Variables ──
        "Velocity": ["de": "Geschwindigkeit", "es": "Velocidad", "fr": "Vitesse", "zh": "速度"],
        "Distance": ["de": "Strecke", "es": "Distancia", "fr": "Distance", "zh": "距离"],
        "Time": ["de": "Zeit", "es": "Tiempo", "fr": "Temps", "zh": "时间"],
        "Final Velocity": ["de": "Endgeschwindigkeit", "es": "Velocidad final", "fr": "Vitesse finale", "zh": "末速度"],
        "Initial Velocity": ["de": "Anfangsgeschwindigkeit", "es": "Velocidad inicial", "fr": "Vitesse initiale", "zh": "初速度"],
        "Force": ["de": "Kraft", "es": "Fuerza", "fr": "Force", "zh": "力"],
        "Mass": ["de": "Masse", "es": "Masa", "fr": "Masse", "zh": "质量"],
        "Mass 1": ["de": "Masse 1", "es": "Masa 1", "fr": "Masse 1", "zh": "质量1"],
        "Velocity 1 (before)": ["de": "Geschw. 1 (vorher)", "es": "Velocidad 1 (antes)", "fr": "Vitesse 1 (avant)", "zh": "速度1（碰前）"],
        "Mass 2": ["de": "Masse 2", "es": "Masa 2", "fr": "Masse 2", "zh": "质量2"],
        "Velocity 2 (before)": ["de": "Geschw. 2 (vorher)", "es": "Velocidad 2 (antes)", "fr": "Vitesse 2 (avant)", "zh": "速度2（碰前）"],
        "Velocity 1 (after)": ["de": "Geschw. 1 (nachher)", "es": "Velocidad 1 (después)", "fr": "Vitesse 1 (après)", "zh": "速度1（碰后）"],
        "Velocity 2 (after)": ["de": "Geschw. 2 (nachher)", "es": "Velocidad 2 (después)", "fr": "Vitesse 2 (après)", "zh": "速度2（碰后）"],
        "Pressure": ["de": "Druck", "es": "Presión", "fr": "Pression", "zh": "压强"],
        "Volume": ["de": "Volumen", "es": "Volumen", "fr": "Volume", "zh": "体积"],
        "Amount (moles)": ["de": "Stoffmenge (Mol)", "es": "Cantidad (moles)", "fr": "Quantité (moles)", "zh": "物质的量（摩尔）"],
        "Gas Constant": ["de": "Gaskonstante", "es": "Constante de los gases", "fr": "Constante des gaz", "zh": "气体常数"],
        "Temperature": ["de": "Temperatur", "es": "Temperatura", "fr": "Température", "zh": "温度"],
        "Entropy Change": ["de": "Entropieänderung", "es": "Cambio de entropía", "fr": "Variation d'entropie", "zh": "熵变"],
        "Current": ["de": "Stromstärke", "es": "Corriente", "fr": "Courant", "zh": "电流"],
        "Voltage": ["de": "Spannung", "es": "Voltaje", "fr": "Tension", "zh": "电压"],
        "Resistance": ["de": "Widerstand", "es": "Resistencia", "fr": "Résistance", "zh": "电阻"],
        "Magnetic Flux Change": ["de": "Magnetische Flussänderung", "es": "Cambio de flujo magnético", "fr": "Variation de flux magnétique", "zh": "磁通量变化"],
        "Time Interval": ["de": "Zeitintervall", "es": "Intervalo de tiempo", "fr": "Intervalle de temps", "zh": "时间间隔"],
        "Focal Length": ["de": "Brennweite", "es": "Distancia focal", "fr": "Distance focale", "zh": "焦距"],
        "Object Distance": ["de": "Gegenstandsweite", "es": "Distancia del objeto", "fr": "Distance objet", "zh": "物距"],
        "Image Distance": ["de": "Bildweite", "es": "Distancia de imagen", "fr": "Distance image", "zh": "像距"],
        "Intensity (after)": ["de": "Intensität (nachher)", "es": "Intensidad (después)", "fr": "Intensité (après)", "zh": "透射光强"],
        "Intensity (before)": ["de": "Intensität (vorher)", "es": "Intensidad (antes)", "fr": "Intensité (avant)", "zh": "入射光强"],
        "Angle": ["de": "Winkel", "es": "Ángulo", "fr": "Angle", "zh": "角度"],
        "Pressure 1": ["de": "Druck 1", "es": "Presión 1", "fr": "Pression 1", "zh": "压强1"],
        "Volume 1": ["de": "Volumen 1", "es": "Volumen 1", "fr": "Volume 1", "zh": "体积1"],
        "Pressure 2": ["de": "Druck 2", "es": "Presión 2", "fr": "Pression 2", "zh": "压强2"],
        "Volume 2": ["de": "Volumen 2", "es": "Volumen 2", "fr": "Volume 2", "zh": "体积2"],
        "Buoyant force": ["de": "Auftriebskraft", "es": "Fuerza de empuje", "fr": "Poussée d'Archimède", "zh": "浮力"],
        "Fluid density": ["de": "Fluiddichte", "es": "Densidad del fluido", "fr": "Densité du fluide", "zh": "流体密度"],
        "Gravitational acceleration": ["de": "Fallbeschleunigung", "es": "Aceleración gravitacional", "fr": "Accélération gravitationnelle", "zh": "重力加速度"],
        "Volume of immersed part": ["de": "Eintauchvolumen", "es": "Volumen sumergido", "fr": "Volume immergé", "zh": "浸入体积"],
        "Fluid column height": ["de": "Flüssigkeitssäulenhöhe", "es": "Altura de columna", "fr": "Hauteur de colonne", "zh": "液柱高度"],
        "Total pressure": ["de": "Gesamtdruck", "es": "Presión total", "fr": "Pression totale", "zh": "总压强"],
        "Atmospheric pressure": ["de": "Atmosphärendruck", "es": "Presión atmosférica", "fr": "Pression atmosphérique", "zh": "大气压强"],
        "Height of first fluid": ["de": "Höhe der 1. Flüssigkeit", "es": "Altura del primer fluido", "fr": "Hauteur du premier fluide", "zh": "第一液体高度"],
        "Height of second fluid": ["de": "Höhe der 2. Flüssigkeit", "es": "Altura del segundo fluido", "fr": "Hauteur du deuxième fluide", "zh": "第二液体高度"],
        "Density of first fluid": ["de": "Dichte der 1. Flüssigkeit", "es": "Densidad del primer fluido", "fr": "Densité du premier fluide", "zh": "第一液体密度"],
        "Density of second fluid": ["de": "Dichte der 2. Flüssigkeit", "es": "Densidad del segundo fluido", "fr": "Densité du deuxième fluide", "zh": "第二液体密度"],
        "Displacement": ["de": "Verschiebung", "es": "Desplazamiento", "fr": "Déplacement", "zh": "位移"],
        "Height": ["de": "Höhe", "es": "Altura", "fr": "Hauteur", "zh": "高度"],
        "Centripetal acceleration": ["de": "Zentripetalbeschleunigung", "es": "Aceleración centrípeta", "fr": "Accélération centripète", "zh": "向心加速度"],
        "Linear velocity": ["de": "Lineargeschwindigkeit", "es": "Velocidad lineal", "fr": "Vitesse linéaire", "zh": "线速度"],
        "Radius": ["de": "Radius", "es": "Radio", "fr": "Rayon", "zh": "半径"],
        "Friction Force": ["de": "Reibungskraft", "es": "Fuerza de fricción", "fr": "Force de frottement", "zh": "摩擦力"],
        "Friction coefficient": ["de": "Reibungskoeffizient", "es": "Coeficiente de fricción", "fr": "Coefficient de frottement", "zh": "摩擦系数"],
        "Normal Force": ["de": "Normalkraft", "es": "Fuerza normal", "fr": "Force normale", "zh": "法向力"],
        "Elastic Force": ["de": "Elastische Kraft", "es": "Fuerza elástica", "fr": "Force élastique", "zh": "弹力"],
        "Spring constant": ["de": "Federkonstante", "es": "Constante del resorte", "fr": "Constante de raideur", "zh": "弹簧劲度系数"],
        "Deformation": ["de": "Verformung", "es": "Deformación", "fr": "Déformation", "zh": "形变量"],
        "Work": ["de": "Arbeit", "es": "Trabajo", "fr": "Travail", "zh": "功"],
        "Cosine of angle": ["de": "Kosinus des Winkels", "es": "Coseno del ángulo", "fr": "Cosinus de l'angle", "zh": "夹角余弦值"],
        "Elastic Energy": ["de": "Elastische Energie", "es": "Energía elástica", "fr": "Énergie élastique", "zh": "弹性能"],
        "Gravitational Force": ["de": "Gravitationskraft", "es": "Fuerza gravitacional", "fr": "Force gravitationnelle", "zh": "万有引力"],
        "Gravitational constant": ["de": "Gravitationskonstante", "es": "Constante gravitacional", "fr": "Constante gravitationnelle", "zh": "万有引力常数"],
        "First cosmic velocity": ["de": "Erste kosmische Geschw.", "es": "Primera velocidad cósmica", "fr": "Première vitesse cosmique", "zh": "第一宇宙速度"],
        "Planet radius": ["de": "Planetenradius", "es": "Radio del planeta", "fr": "Rayon de la planète", "zh": "行星半径"],
        "Mass of celestial body": ["de": "Masse des Himmelskörpers", "es": "Masa del cuerpo celeste", "fr": "Masse du corps céleste", "zh": "天体质量"],
        "Distance to axis": ["de": "Abstand zur Achse", "es": "Distancia al eje", "fr": "Distance à l'axe", "zh": "到轴距离"],
        "Angular velocity": ["de": "Winkelgeschwindigkeit", "es": "Velocidad angular", "fr": "Vitesse angulaire", "zh": "角速度"],
        "Angular displacement": ["de": "Winkelverschiebung", "es": "Desplazamiento angular", "fr": "Déplacement angulaire", "zh": "角位移"],
        "Temperature 1": ["de": "Temperatur 1", "es": "Temperatura 1", "fr": "Température 1", "zh": "温度1"],
        "Temperature 2": ["de": "Temperatur 2", "es": "Temperatura 2", "fr": "Température 2", "zh": "温度2"],
        "Heat": ["de": "Wärme", "es": "Calor", "fr": "Chaleur", "zh": "热量"],
        "Internal Energy Change": ["de": "Änderung der inneren Energie", "es": "Cambio de energía interna", "fr": "Variation d'énergie interne", "zh": "内能变化"],
        "Efficiency": ["de": "Wirkungsgrad", "es": "Eficiencia", "fr": "Rendement", "zh": "效率"],
        "Heat received": ["de": "Aufgenommene Wärme", "es": "Calor recibido", "fr": "Chaleur reçue", "zh": "吸收热量"],
        "Heat rejected": ["de": "Abgegebene Wärme", "es": "Calor liberado", "fr": "Chaleur libérée", "zh": "释放热量"],
        "Specific heat capacity": ["de": "Spez. Wärmekapazität", "es": "Capacidad calorífica específica", "fr": "Capacité thermique massique", "zh": "比热容"],
        "Temperature change": ["de": "Temperaturänderung", "es": "Cambio de temperatura", "fr": "Variation de température", "zh": "温度变化"],
        "Specific heat of combustion": ["de": "Spez. Verbrennungswärme", "es": "Calor específico de combustión", "fr": "Pouvoir calorifique", "zh": "燃烧热值"],
        "Fuel mass": ["de": "Brennstoffmasse", "es": "Masa de combustible", "fr": "Masse de combustible", "zh": "燃料质量"],
        "Specific heat of fusion": ["de": "Spez. Schmelzwärme", "es": "Calor específico de fusión", "fr": "Chaleur latente de fusion", "zh": "熔化热值"],
        "Specific heat of vaporization": ["de": "Spez. Verdampfungswärme", "es": "Calor específico de vaporización", "fr": "Chaleur latente de vaporisation", "zh": "汽化热值"],
        "Constant a": ["de": "Konstante a", "es": "Constante a", "fr": "Constante a", "zh": "常数a"],
        "Molar volume": ["de": "Molares Volumen", "es": "Volumen molar", "fr": "Volume molaire", "zh": "摩尔体积"],
        "Constant b": ["de": "Konstante b", "es": "Constante b", "fr": "Constante b", "zh": "常数b"],
        "Coulomb constant": ["de": "Coulomb-Konstante", "es": "Constante de Coulomb", "fr": "Constante de Coulomb", "zh": "库仑常数"],
        "Charge 1": ["de": "Ladung 1", "es": "Carga 1", "fr": "Charge 1", "zh": "电荷1"],
        "Charge 2": ["de": "Ladung 2", "es": "Carga 2", "fr": "Charge 2", "zh": "电荷2"],
        "Electric field": ["de": "Elektrisches Feld", "es": "Campo eléctrico", "fr": "Champ électrique", "zh": "电场"],
        "Charge": ["de": "Ladung", "es": "Carga", "fr": "Charge", "zh": "电荷"],
        "Energy": ["de": "Energie", "es": "Energía", "fr": "Énergie", "zh": "能量"],
        "Total Resistance": ["de": "Gesamtwiderstand", "es": "Resistencia total", "fr": "Résistance totale", "zh": "总电阻"],
        "Resistance 1": ["de": "Widerstand 1", "es": "Resistencia 1", "fr": "Résistance 1", "zh": "电阻1"],
        "Resistance 2": ["de": "Widerstand 2", "es": "Resistencia 2", "fr": "Résistance 2", "zh": "电阻2"],
        "Ampere force": ["de": "Ampèresche Kraft", "es": "Fuerza de Ampère", "fr": "Force d'Ampère", "zh": "安培力"],
        "Magnetic flux density": ["de": "Magnetische Flussdichte", "es": "Densidad de flujo magnético", "fr": "Densité de flux magnétique", "zh": "磁感应强度"],
        "Conductor length": ["de": "Leiterlänge", "es": "Longitud del conductor", "fr": "Longueur du conducteur", "zh": "导体长度"],
        "Lorentz force": ["de": "Lorentzkraft", "es": "Fuerza de Lorentz", "fr": "Force de Lorentz", "zh": "洛伦兹力"],
        "Charge velocity": ["de": "Ladungsgeschwindigkeit", "es": "Velocidad de la carga", "fr": "Vitesse de la charge", "zh": "电荷速度"],
        "Magnetic flux": ["de": "Magnetischer Fluss", "es": "Flujo magnético", "fr": "Flux magnétique", "zh": "磁通量"],
        "Area": ["de": "Fläche", "es": "Área", "fr": "Surface", "zh": "面积"],
        "Magnetic flux change": ["de": "Magnetische Flussänderung", "es": "Cambio de flujo magnético", "fr": "Variation de flux magnétique", "zh": "磁通量变化"],
        "Time interval": ["de": "Zeitintervall", "es": "Intervalo de tiempo", "fr": "Intervalle de temps", "zh": "时间间隔"],
        "Refractive index 1": ["de": "Brechungsindex 1", "es": "Índice de refracción 1", "fr": "Indice de réfraction 1", "zh": "折射率1"],
        "Angle of incidence": ["de": "Einfallswinkel", "es": "Ángulo de incidencia", "fr": "Angle d'incidence", "zh": "入射角"],
        "Refractive index 2": ["de": "Brechungsindex 2", "es": "Índice de refracción 2", "fr": "Indice de réfraction 2", "zh": "折射率2"],
        "Angle of refraction": ["de": "Brechungswinkel", "es": "Ángulo de refracción", "fr": "Angle de réfraction", "zh": "折射角"],
        "Grating period": ["de": "Gitterperiode", "es": "Período de la rejilla", "fr": "Période du réseau", "zh": "光栅常数"],
        "Diffraction angle": ["de": "Beugungswinkel", "es": "Ángulo de difracción", "fr": "Angle de diffraction", "zh": "衍射角"],
        "Order of maximum": ["de": "Beugungsordnung", "es": "Orden del máximo", "fr": "Ordre du maximum", "zh": "衍射级数"],
        "Wavelength": ["de": "Wellenlänge", "es": "Longitud de onda", "fr": "Longueur d'onde", "zh": "波长"],
        "Photon energy": ["de": "Photonenenergie", "es": "Energía del fotón", "fr": "Énergie du photon", "zh": "光子能量"],
        "Planck constant": ["de": "Planck-Konstante", "es": "Constante de Planck", "fr": "Constante de Planck", "zh": "普朗克常数"],
        "Frequency": ["de": "Frequenz", "es": "Frecuencia", "fr": "Fréquence", "zh": "频率"],
        "Work function": ["de": "Austrittsarbeit", "es": "Función de trabajo", "fr": "Travail de sortie", "zh": "逸出功"],
        "Electron mass": ["de": "Elektronenmasse", "es": "Masa del electrón", "fr": "Masse de l'électron", "zh": "电子质量"],
        "Electron velocity": ["de": "Elektronengeschwindigkeit", "es": "Velocidad del electrón", "fr": "Vitesse de l'électron", "zh": "电子速度"],
        "De Broglie wavelength": ["de": "De-Broglie-Wellenlänge", "es": "Longitud de onda de De Broglie", "fr": "Longueur d'onde de De Broglie", "zh": "德布罗意波长"],
        "Particle momentum": ["de": "Teilchenimpuls", "es": "Momento de la partícula", "fr": "Quantité de mouvement de la particule", "zh": "粒子动量"],
        // ── New Sections ──
        "Oscillations & Waves": ["de": "Schwingungen & Wellen", "es": "Oscilaciones y ondas", "fr": "Oscillations et ondes", "zh": "振动与波"],
        "Modern Physics": ["de": "Moderne Physik", "es": "Física moderna", "fr": "Physique moderne", "zh": "近代物理"],
        // ── New Subsections ──
        "Mechanical Oscillations": ["de": "Mechanische Schwingungen", "es": "Oscilaciones mecánicas", "fr": "Oscillations mécaniques", "zh": "机械振动"],
        "Waves": ["de": "Wellen", "es": "Ondas", "fr": "Ondes", "zh": "波"],
        "Acoustics": ["de": "Akustik", "es": "Acústica", "fr": "Acoustique", "zh": "声学"],
        "Special Relativity": ["de": "Spezielle Relativitätstheorie", "es": "Relatividad especial", "fr": "Relativité restreinte", "zh": "狭义相对论"],
        "Nuclear Physics": ["de": "Kernphysik", "es": "Física nuclear", "fr": "Physique nucléaire", "zh": "核物理"],
        "Fluid Dynamics": ["de": "Fluiddynamik", "es": "Dinámica de fluidos", "fr": "Dynamique des fluides", "zh": "流体动力学"],
        // ── New Formulas ──
        "Period of Simple Pendulum": ["de": "Pendelschwingungsdauer", "es": "Periodo del péndulo simple", "fr": "Période du pendule simple", "zh": "单摆周期"],
        "Period of Spring Pendulum": ["de": "Federschwingungsdauer", "es": "Periodo del péndulo de resorte", "fr": "Période du pendule à ressort", "zh": "弹簧摆周期"],
        "Oscillation Frequency": ["de": "Schwingungsfrequenz", "es": "Frecuencia de oscilación", "fr": "Fréquence d'oscillation", "zh": "振荡频率"],
        "Angular Frequency": ["de": "Kreisfrequenz", "es": "Frecuencia angular", "fr": "Pulsation", "zh": "角频率"],
        "Harmonic Oscillation": ["de": "Harmonische Schwingung", "es": "Oscilación armónica", "fr": "Oscillation harmonique", "zh": "简谐振动"],
        "Total Energy of Oscillation": ["de": "Gesamtenergie der Schwingung", "es": "Energía total de la oscilación", "fr": "Énergie totale d'oscillation", "zh": "振荡总能量"],
        "Damped Oscillation Amplitude": ["de": "Gedämpfte Schwingungsamplitude", "es": "Amplitud de oscilación amortiguada", "fr": "Amplitude d'oscillation amortie", "zh": "阻尼振荡振幅"],
        "Wave Velocity": ["de": "Wellengeschwindigkeit", "es": "Velocidad de onda", "fr": "Vitesse d'onde", "zh": "波速"],
        "Wavelength via Period": ["de": "Wellenlänge über Periode", "es": "Longitud de onda por periodo", "fr": "Longueur d'onde par période", "zh": "由周期求波长"],
        "Standing Wave Length": ["de": "Stehende Welle (Länge)", "es": "Onda estacionaria (longitud)", "fr": "Onde stationnaire (longueur)", "zh": "驻波长度"],
        "Wave Intensity": ["de": "Wellenintensität", "es": "Intensidad de onda", "fr": "Intensité d'onde", "zh": "波的强度"],
        "Speed of Sound in Air": ["de": "Schallgeschwindigkeit in Luft", "es": "Velocidad del sonido en aire", "fr": "Vitesse du son dans l'air", "zh": "空气中的声速"],
        "Doppler Effect (Sound)": ["de": "Doppler-Effekt (Schall)", "es": "Efecto Doppler (sonido)", "fr": "Effet Doppler (son)", "zh": "多普勒效应（声）"],
        "Sound Intensity Level": ["de": "Schallintensitätspegel", "es": "Nivel de intensidad sonora", "fr": "Niveau d'intensité sonore", "zh": "声强级"],
        "Mass–Energy Equivalence": ["de": "Masse-Energie-Äquivalenz", "es": "Equivalencia masa-energía", "fr": "Équivalence masse-énergie", "zh": "质能等价"],
        "Time Dilation": ["de": "Zeitdilatation", "es": "Dilatación del tiempo", "fr": "Dilatation du temps", "zh": "时间膨胀"],
        "Length Contraction": ["de": "Längenkontraktion", "es": "Contracción de longitudes", "fr": "Contraction des longueurs", "zh": "长度收缩"],
        "Relativistic Momentum": ["de": "Relativistischer Impuls", "es": "Momento relativista", "fr": "Quantité de mouvement relativiste", "zh": "相对论动量"],
        "Total Relativistic Energy": ["de": "Relativist. Gesamtenergie", "es": "Energía relativista total", "fr": "Énergie relativiste totale", "zh": "相对论总能量"],
        "Radioactive Decay Law": ["de": "Radioaktives Zerfallsgesetz", "es": "Ley de desintegración radiactiva", "fr": "Loi de désintégration radioactive", "zh": "放射性衰变定律"],
        "Half-Life": ["de": "Halbwertszeit", "es": "Vida media", "fr": "Demi-vie", "zh": "半衰期"],
        "Nuclear Binding Energy": ["de": "Kernbindungsenergie", "es": "Energía de enlace nuclear", "fr": "Énergie de liaison nucléaire", "zh": "原子核结合能"],
        "Radioactive Activity": ["de": "Radioaktivität", "es": "Actividad radiactiva", "fr": "Activité radioactive", "zh": "放射性活度"],
        "Bernoulli's Equation (simplified)": ["de": "Bernoulli-Gleichung (vereinfacht)", "es": "Ecuación de Bernoulli (simplificada)", "fr": "Équation de Bernoulli (simplifiée)", "zh": "伯努利方程（简化）"],
        "Continuity Equation": ["de": "Kontinuitätsgleichung", "es": "Ecuación de continuidad", "fr": "Équation de continuité", "zh": "连续性方程"],
        "Carnot Efficiency": ["de": "Carnot-Wirkungsgrad", "es": "Eficiencia de Carnot", "fr": "Rendement de Carnot", "zh": "卡诺效率"],
        "Fourier's Law of Heat Conduction": ["de": "Fouriersches Wärmeleitungsgesetz", "es": "Ley de Fourier de conducción", "fr": "Loi de Fourier de conduction", "zh": "傅里叶导热定律"],
        "Solenoid Inductance": ["de": "Spuleninduktivität", "es": "Inductancia del solenoide", "fr": "Inductance du solénoïde", "zh": "螺线管电感"],
        "Energy of Magnetic Field in Inductor": ["de": "Magnetfeldenergie der Spule", "es": "Energía del campo magnético", "fr": "Énergie du champ magnétique", "zh": "电感磁场能量"],
        "Lens Magnification": ["de": "Linsenvergrößerung", "es": "Aumento de la lente", "fr": "Grossissement de la lentille", "zh": "透镜放大率"],
        "Thin Film Interference Maximum": ["de": "Dünnschichtinterferenz (Maximum)", "es": "Interferencia de película delgada (máximo)", "fr": "Interférence en couche mince (maximum)", "zh": "薄膜干涉极大"],
        // ── New Variables ──
        "Period": ["de": "Periode", "es": "Periodo", "fr": "Période", "zh": "周期"],
        "Pendulum length": ["de": "Pendellänge", "es": "Longitud del péndulo", "fr": "Longueur du pendule", "zh": "摆长"],
        "Angular frequency": ["de": "Kreisfrequenz", "es": "Frecuencia angular", "fr": "Pulsation", "zh": "角频率"],
        "Amplitude": ["de": "Amplitude", "es": "Amplitud", "fr": "Amplitude", "zh": "振幅"],
        "Total energy": ["de": "Gesamtenergie", "es": "Energía total", "fr": "Énergie totale", "zh": "总能量"],
        "Amplitude at time t": ["de": "Amplitude zur Zeit t", "es": "Amplitud en el tiempo t", "fr": "Amplitude au temps t", "zh": "t时刻振幅"],
        "Initial amplitude": ["de": "Anfangsamplitude", "es": "Amplitud inicial", "fr": "Amplitude initiale", "zh": "初始振幅"],
        "Damping coefficient": ["de": "Dämpfungskoeffizient", "es": "Coeficiente de amortiguamiento", "fr": "Coefficient d'amortissement", "zh": "阻尼系数"],
        "Wave velocity": ["de": "Wellengeschwindigkeit", "es": "Velocidad de onda", "fr": "Vitesse d'onde", "zh": "波速"],
        "String length": ["de": "Saitenlänge", "es": "Longitud de la cuerda", "fr": "Longueur de la corde", "zh": "弦长"],
        "Harmonic number": ["de": "Harmonische Nummer", "es": "Número de armónico", "fr": "Numéro d'harmonique", "zh": "谐波序号"],
        "Intensity": ["de": "Intensität", "es": "Intensidad", "fr": "Intensité", "zh": "强度"],
        "Speed of sound": ["de": "Schallgeschwindigkeit", "es": "Velocidad del sonido", "fr": "Vitesse du son", "zh": "声速"],
        "Observed frequency": ["de": "Beobachtete Frequenz", "es": "Frecuencia observada", "fr": "Fréquence observée", "zh": "观测频率"],
        "Source frequency": ["de": "Quellenfrequenz", "es": "Frecuencia de la fuente", "fr": "Fréquence de la source", "zh": "声源频率"],
        "Observer velocity": ["de": "Beobachtergeschwindigkeit", "es": "Velocidad del observador", "fr": "Vitesse de l'observateur", "zh": "观察者速度"],
        "Source velocity": ["de": "Quellengeschwindigkeit", "es": "Velocidad de la fuente", "fr": "Vitesse de la source", "zh": "声源速度"],
        "Sound level": ["de": "Schallpegel", "es": "Nivel sonoro", "fr": "Niveau sonore", "zh": "声级"],
        "Sound intensity": ["de": "Schallintensität", "es": "Intensidad sonora", "fr": "Intensité sonore", "zh": "声强"],
        "Reference intensity": ["de": "Bezugsintensität", "es": "Intensidad de referencia", "fr": "Intensité de référence", "zh": "参考强度"],
        "Speed of light": ["de": "Lichtgeschwindigkeit", "es": "Velocidad de la luz", "fr": "Vitesse de la lumière", "zh": "光速"],
        "Observed time": ["de": "Beobachtete Zeit", "es": "Tiempo observado", "fr": "Temps observé", "zh": "观测时间"],
        "Proper time": ["de": "Eigenzeit", "es": "Tiempo propio", "fr": "Temps propre", "zh": "固有时间"],
        "Observed length": ["de": "Beobachtete Länge", "es": "Longitud observada", "fr": "Longueur observée", "zh": "观测长度"],
        "Proper length": ["de": "Eigenlänge", "es": "Longitud propia", "fr": "Longueur propre", "zh": "固有长度"],
        "Rest mass": ["de": "Ruhemasse", "es": "Masa en reposo", "fr": "Masse au repos", "zh": "静止质量"],
        "Number of nuclei": ["de": "Anzahl der Kerne", "es": "Número de núcleos", "fr": "Nombre de noyaux", "zh": "原子核数"],
        "Initial number of nuclei": ["de": "Anfangsanzahl der Kerne", "es": "Número inicial de núcleos", "fr": "Nombre initial de noyaux", "zh": "初始核数"],
        "Decay constant": ["de": "Zerfallskonstante", "es": "Constante de desintegración", "fr": "Constante de désintégration", "zh": "衰变常数"],
        "Half-life": ["de": "Halbwertszeit", "es": "Vida media", "fr": "Demi-vie", "zh": "半衰期"],
        "Binding energy": ["de": "Bindungsenergie", "es": "Energía de enlace", "fr": "Énergie de liaison", "zh": "结合能"],
        "Mass defect": ["de": "Massendefekt", "es": "Defecto de masa", "fr": "Défaut de masse", "zh": "质量亏损"],
        "Activity": ["de": "Aktivität", "es": "Actividad", "fr": "Activité", "zh": "活度"],
        "Static pressure": ["de": "Statischer Druck", "es": "Presión estática", "fr": "Pression statique", "zh": "静压"],
        "Flow velocity": ["de": "Strömungsgeschwindigkeit", "es": "Velocidad del flujo", "fr": "Vitesse d'écoulement", "zh": "流速"],
        "Cross-section area 1": ["de": "Querschnittsfläche 1", "es": "Área de sección 1", "fr": "Section 1", "zh": "截面积1"],
        "Flow velocity 1": ["de": "Strömungsgeschw. 1", "es": "Velocidad del flujo 1", "fr": "Vitesse d'écoulement 1", "zh": "流速1"],
        "Cross-section area 2": ["de": "Querschnittsfläche 2", "es": "Área de sección 2", "fr": "Section 2", "zh": "截面积2"],
        "Flow velocity 2": ["de": "Strömungsgeschw. 2", "es": "Velocidad del flujo 2", "fr": "Vitesse d'écoulement 2", "zh": "流速2"],
        "Cold temperature": ["de": "Kalte Temperatur", "es": "Temperatura fría", "fr": "Température froide", "zh": "冷源温度"],
        "Hot temperature": ["de": "Heiße Temperatur", "es": "Temperatura caliente", "fr": "Température chaude", "zh": "热源温度"],
        "Thermal conductivity": ["de": "Wärmeleitfähigkeit", "es": "Conductividad térmica", "fr": "Conductivité thermique", "zh": "导热系数"],
        "Temperature difference": ["de": "Temperaturdifferenz", "es": "Diferencia de temperatura", "fr": "Différence de température", "zh": "温差"],
        "Wall thickness": ["de": "Wandstärke", "es": "Espesor de la pared", "fr": "Épaisseur de la paroi", "zh": "壁厚"],
        "Inductance": ["de": "Induktivität", "es": "Inductancia", "fr": "Inductance", "zh": "电感"],
        "Vacuum permeability": ["de": "Vakuumpermeabilität", "es": "Permeabilidad del vacío", "fr": "Perméabilité du vide", "zh": "真空磁导率"],
        "Number of turns": ["de": "Windungszahl", "es": "Número de espiras", "fr": "Nombre de spires", "zh": "匝数"],
        "Cross-section area": ["de": "Querschnittsfläche", "es": "Área de sección", "fr": "Section transversale", "zh": "截面积"],
        "Solenoid length": ["de": "Solenoidlänge", "es": "Longitud del solenoide", "fr": "Longueur du solénoïde", "zh": "螺线管长度"],
        "Magnification": ["de": "Vergrößerung", "es": "Aumento", "fr": "Grossissement", "zh": "放大率"],
        "Image size": ["de": "Bildgröße", "es": "Tamaño de imagen", "fr": "Taille de l'image", "zh": "像的大小"],
        "Object size": ["de": "Gegenstandsgröße", "es": "Tamaño del objeto", "fr": "Taille de l'objet", "zh": "物的大小"],
        "Refractive index": ["de": "Brechungsindex", "es": "Índice de refracción", "fr": "Indice de réfraction", "zh": "折射率"],
        "Film thickness": ["de": "Schichtdicke", "es": "Espesor de película", "fr": "Épaisseur du film", "zh": "薄膜厚度"],
        // Maxwell's Equations - formula names
        "Displacement Current": ["de": "Verschiebungsstrom", "es": "Corriente de desplazamiento", "fr": "Courant de déplacement", "zh": "位移电流"],
        "Electromagnetic Wave Speed": ["de": "Geschwindigkeit der EM-Welle", "es": "Velocidad de la onda EM", "fr": "Vitesse de l'onde EM", "zh": "电磁波速度"],
        "E–B Relation in EM Wave": ["de": "E–B-Beziehung in EM-Welle", "es": "Relación E–B en onda EM", "fr": "Relation E–B dans une onde EM", "zh": "电磁波中E-B关系"],
        "EM Field Energy Density": ["de": "EM-Energiedichte", "es": "Densidad de energía del campo EM", "fr": "Densité d'énergie du champ EM", "zh": "电磁场能量密度"],
        "Poynting Vector (Intensity)": ["de": "Poynting-Vektor (Intensität)", "es": "Vector de Poynting (intensidad)", "fr": "Vecteur de Poynting (intensité)", "zh": "坡印廷矢量（强度）"],
        "Wave Impedance of Free Space": ["de": "Wellenwiderstand des freien Raums", "es": "Impedancia de onda del espacio libre", "fr": "Impédance d'onde du vide", "zh": "自由空间波阻抗"],
        "Intensity from Point Source": ["de": "Intensität einer Punktquelle", "es": "Intensidad de fuente puntual", "fr": "Intensité d'une source ponctuelle", "zh": "点源辐射强度"],
        "EM Wave Speed in Medium": ["de": "EM-Wellengeschwindigkeit im Medium", "es": "Velocidad de onda EM en medio", "fr": "Vitesse de l'onde EM dans un milieu", "zh": "介质中电磁波速度"],
        "Radiation Pressure": ["de": "Strahlungsdruck", "es": "Presión de radiación", "fr": "Pression de rayonnement", "zh": "辐射压力"],
        // Maxwell's Equations - variable names
        "Displacement current": ["de": "Verschiebungsstrom", "es": "Corriente de desplazamiento", "fr": "Courant de déplacement", "zh": "位移电流"],
        "Change in electric flux": ["de": "Änderung des elektrischen Flusses", "es": "Cambio del flujo eléctrico", "fr": "Variation du flux électrique", "zh": "电通量变化"],
        "Wave speed": ["de": "Wellengeschwindigkeit", "es": "Velocidad de onda", "fr": "Vitesse de l'onde", "zh": "波速"],
        "Electric field strength": ["de": "Elektrische Feldstärke", "es": "Intensidad de campo eléctrico", "fr": "Intensité du champ électrique", "zh": "电场强度"],
        "Energy density": ["de": "Energiedichte", "es": "Densidad de energía", "fr": "Densité d'énergie", "zh": "能量密度"],
        "Poynting vector": ["de": "Poynting-Vektor", "es": "Vector de Poynting", "fr": "Vecteur de Poynting", "zh": "坡印廷矢量"],
        "Wave impedance": ["de": "Wellenwiderstand", "es": "Impedancia de onda", "fr": "Impédance d'onde", "zh": "波阻抗"],
        "Source power": ["de": "Quellenleistung", "es": "Potencia de la fuente", "fr": "Puissance de la source", "zh": "光源功率"],
        "Speed in medium": ["de": "Geschwindigkeit im Medium", "es": "Velocidad en el medio", "fr": "Vitesse dans le milieu", "zh": "介质中速度"],
        "Speed of light in vacuum": ["de": "Lichtgeschwindigkeit im Vakuum", "es": "Velocidad de la luz en el vacío", "fr": "Vitesse de la lumière dans le vide", "zh": "真空中光速"],
        "Relative permittivity": ["de": "Relative Permittivität", "es": "Permitividad relativa", "fr": "Permittivité relative", "zh": "相对介电常数"],
        "Relative permeability": ["de": "Relative Permeabilität", "es": "Permeabilidad relativa", "fr": "Perméabilité relative", "zh": "相对磁导率"],
        "Radiation pressure": ["de": "Strahlungsdruck", "es": "Presión de radiación", "fr": "Pression de rayonnement", "zh": "辐射压力"],
        "Reflection coefficient": ["de": "Reflexionskoeffizient", "es": "Coeficiente de reflexión", "fr": "Coefficient de réflexion", "zh": "反射系数"],
    ]
    // swiftlint:enable line_length
    
    // MARK: - Premium / IAP
    
    static var premiumTitle: String { t(["ru": "Premium", "en": "Premium", "de": "Premium", "es": "Premium", "fr": "Premium", "zh": "高级版"]) }
    static var premiumUnlock: String { t(["ru": "Разблокировать всё", "en": "Unlock Everything", "de": "Alles freischalten", "es": "Desbloquear todo", "fr": "Tout débloquer", "zh": "解锁所有功能"]) }
    static var premiumDescription: String { t(["ru": "Получите доступ ко всем 126 формулам, графикам, экспорту PDF, калькулятору погрешностей и избранному.", "en": "Get access to all 126 formulas, graphs, PDF export, error calculator, and favorites.", "de": "Erhalten Sie Zugang zu allen 126 Formeln, Diagrammen, PDF-Export, Fehlerrechner und Favoriten.", "es": "Accede a las 126 fórmulas, gráficos, exportación PDF, calculadora de errores y favoritos.", "fr": "Accédez aux 126 formules, graphiques, export PDF, calculateur d'erreurs et favoris.", "zh": "获取全部126个公式、图表、PDF导出、误差计算器和收藏夹。"]) }
    static var premiumRestore: String { t(["ru": "Восстановить покупку", "en": "Restore Purchase", "de": "Kauf wiederherstellen", "es": "Restaurar compra", "fr": "Restaurer l'achat", "zh": "恢复购买"]) }
    static var premiumAlreadyActive: String { t(["ru": "Premium уже активен", "en": "Premium is active", "de": "Premium ist aktiv", "es": "Premium está activo", "fr": "Premium est actif", "zh": "高级版已激活"]) }
    static var premiumFeatureFormulas: String { t(["ru": "Все 126 формул", "en": "All 126 formulas", "de": "Alle 126 Formeln", "es": "Las 126 fórmulas", "fr": "Les 126 formules", "zh": "全部126个公式"]) }
    static var premiumFeatureGraphs: String { t(["ru": "Графики зависимостей", "en": "Dependency graphs", "de": "Abhängigkeitsdiagramme", "es": "Gráficos de dependencia", "fr": "Graphiques de dépendance", "zh": "依赖关系图表"]) }
    static var premiumFeaturePDF: String { t(["ru": "Экспорт PDF", "en": "PDF export", "de": "PDF-Export", "es": "Exportación PDF", "fr": "Export PDF", "zh": "PDF导出"]) }
    static var premiumFeatureError: String { t(["ru": "Калькулятор погрешностей", "en": "Error calculator", "de": "Fehlerrechner", "es": "Calculadora de errores", "fr": "Calculateur d'erreurs", "zh": "误差计算器"]) }
    static var premiumFeatureFavorites: String { t(["ru": "Избранное", "en": "Favorites", "de": "Favoriten", "es": "Favoritos", "fr": "Favoris", "zh": "收藏夹"]) }
    static var premiumRequired: String { t(["ru": "Доступно в Premium", "en": "Available in Premium", "de": "In Premium verfügbar", "es": "Disponible en Premium", "fr": "Disponible en Premium", "zh": "高级版功能"]) }
    static var premiumFormulaLocked: String { t(["ru": "Формула доступна в Premium-версии", "en": "Formula available in Premium", "de": "Formel in Premium verfügbar", "es": "Fórmula disponible en Premium", "fr": "Formule disponible en Premium", "zh": "此公式为高级版内容"]) }
    static var premiumBuyOnce: String { t(["ru": "Одна покупка — навсегда", "en": "One-time purchase — forever", "de": "Einmaliger Kauf — für immer", "es": "Compra única — para siempre", "fr": "Achat unique — pour toujours", "zh": "一次购买，永久使用"]) }
    static var premiumPurchaseError: String { t(["ru": "Ошибка покупки. Попробуйте позже.", "en": "Purchase failed. Please try again.", "de": "Kauf fehlgeschlagen. Bitte erneut versuchen.", "es": "Error en la compra. Inténtelo de nuevo.", "fr": "Erreur d'achat. Veuillez réessayer.", "zh": "购买失败，请稍后重试。"]) }
}
