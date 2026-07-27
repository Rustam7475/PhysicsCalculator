import Foundation

/// Конвертация математических выражений в LaTeX-формат.
/// Изолирован из `PhysicsModels.swift` для единственной ответственности.
enum LaTeXRenderer {

    // MARK: - Маппинг символов

    /// Маппинг символов переменных в LaTeX
    private static let latexSymbolMap: [String: String] = [
        "nu": "\\nu", "alpha": "\\alpha", "beta": "\\beta", "gamma": "\\gamma",
        "delta": "\\delta", "epsilon": "\\varepsilon", "theta": "\\theta",
        "lambda": "\\lambda", "mu": "\\mu", "rho": "\\rho", "sigma": "\\sigma",
        "tau": "\\tau", "phi": "\\phi", "omega": "\\omega",
        "eta": "\\eta", "Phi": "\\Phi",
        "DeltaS": "\\Delta S", "DeltaU": "\\Delta U", "DeltaT": "\\Delta T",
        "dPhiB": "d\\Phi_B", "dPhi": "\\Delta\\Phi", "dphi": "\\Delta\\varphi",
        "alpha1": "\\alpha_1", "alpha2": "\\alpha_2",
        "v1prime": "v'_1", "v2prime": "v'_2",
        "n_ord": "n", "Avyh": "A_{вых}", "Eup": "E_{уп}", "Ep": "E_p",
        "ρ": "\\rho", "ρ_1": "\\rho_1", "ρ_2": "\\rho_2"
    ]

    /// Конвертирует символ переменной в LaTeX-эквивалент
    static func symbolToLatex(_ symbol: String) -> String {
        latexSymbolMap[symbol] ?? symbol
    }

    /// Заменяет все символы переменных в выражении на LaTeX-эквиваленты
    static func replaceSymbolsWithLatex(_ expression: String, variables: [Variable]) -> String {
        var result = expression
        let sorted = variables.sorted { $0.symbol.count > $1.symbol.count }
        for variable in sorted {
            if let latex = latexSymbolMap[variable.symbol] {
                result = result.replacingOccurrences(of: variable.symbol, with: latex)
            }
        }
        return result
    }

    // MARK: - Основной конвертер

    /// Форматирует арифметическое выражение в LaTeX
    static func formatRuleAsLatex(_ rule: String) -> String {
        var result = rule
        // Убираем префикс function.
        result = result.replacingOccurrences(of: "function.", with: "")
        // Конвертируем sqrt(...) в \sqrt{...}
        result = convertFunctionToLatex(result, function: "sqrt", latex: "\\sqrt")
        // Конвертируем тригонометрические функции
        for fn in ["sin", "cos", "tan", "asin", "acos", "atan"] {
            result = convertFunctionToLatex(result, function: fn, latex: "\\\(fn)")
        }
        // Конвертируем pow(base, exp) в {base}^{exp}
        result = convertPowToLatex(result)
        // Конвертируем деление в \frac{}{} — ДО замены * на \cdot
        result = convertDivisionsToFrac(result)
        // Базовые замены
        result = result
            .replacingOccurrences(of: "*", with: " \\cdot ")
        // Конвертируем научную нотацию (6.62607e-34) в LaTeX (6{,}62607 \times 10^{-34})
        result = convertScientificNotationToLatex(result)
        return result
    }

    // MARK: - Конвертеры

    /// Конвертирует числа в научной нотации (напр. `6.62607e-34`) в LaTeX: `6{,}62607 \\times 10^{-34}`
    private static func convertScientificNotationToLatex(_ text: String) -> String {
        guard let regex = try? NSRegularExpression(pattern: #"(\d+\.?\d*)[eE]([+-]?\d+)"#) else { return text }
        let nsText = text as NSString
        var result = text
        let matches = regex.matches(in: text, range: NSRange(location: 0, length: nsText.length))
        for match in matches.reversed() {
            let mantissa = nsText.substring(with: match.range(at: 1))
            let exponent = nsText.substring(with: match.range(at: 2))
            guard let fullRange = Range(match.range, in: result) else { continue }
            let latex = "\(mantissa) \\times 10^{\(exponent)}"
            result.replaceSubrange(fullRange, with: latex)
        }
        return result
    }

    /// Конвертирует операции деления `/` в `\frac{числитель}{знаменатель}`
    static func convertDivisionsToFrac(_ expression: String) -> String {
        let trimmed = expression.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty { return trimmed }

        var segments: [(op: String, content: String)] = []
        var current = ""
        var depth = 0
        var braceDepth = 0
        var i = trimmed.startIndex
        var firstSegment = true

        while i < trimmed.endIndex {
            let ch = trimmed[i]
            if ch == "(" { depth += 1 }
            else if ch == ")" { depth -= 1 }
            else if ch == "{" { braceDepth += 1 }
            else if ch == "}" { braceDepth -= 1 }

            if depth == 0 && braceDepth == 0 && (ch == "+" || ch == "-") {
                let prevNonSpace = trimmed[trimmed.startIndex..<i].last(where: { !$0.isWhitespace })
                let isBinary: Bool = {
                    guard let prev = prevNonSpace else { return false }
                    return prev.isLetter || prev.isNumber || prev == ")" || prev == "}"
                }()
                let isScientific: Bool = {
                    guard let prev = prevNonSpace, (prev == "e" || prev == "E") else { return false }
                    let beforeE = trimmed[trimmed.startIndex..<i].dropLast(1).last(where: { !$0.isWhitespace })
                    return beforeE?.isNumber == true
                }()
                if isBinary && !isScientific {
                    segments.append((op: firstSegment ? "" : "", content: current.trimmingCharacters(in: .whitespaces)))
                    current = ""
                    segments.append((op: String(ch), content: ""))
                    firstSegment = false
                    i = trimmed.index(after: i)
                    continue
                }
            }
            current.append(ch)
            i = trimmed.index(after: i)
        }
        if !current.trimmingCharacters(in: .whitespaces).isEmpty {
            segments.append((op: "", content: current.trimmingCharacters(in: .whitespaces)))
        }

        var result = ""
        for seg in segments {
            if seg.content.isEmpty {
                result += " \(seg.op) "
            } else {
                result += convertMultiplicativeToFrac(seg.content)
            }
        }
        return result
    }

    /// Обрабатывает мультипликативное выражение (содержит * и /, но не + и - на верхнем уровне)
    private static func convertMultiplicativeToFrac(_ expr: String) -> String {
        let trimmed = expr.trimmingCharacters(in: .whitespaces)

        var depth = 0
        var braceDepth = 0
        var divIndex: String.Index?
        var i = trimmed.startIndex
        while i < trimmed.endIndex {
            let ch = trimmed[i]
            if ch == "(" { depth += 1 }
            else if ch == ")" { depth -= 1 }
            else if ch == "{" { braceDepth += 1 }
            else if ch == "}" { braceDepth -= 1 }
            else if ch == "/" && depth == 0 && braceDepth == 0 {
                divIndex = i
                break
            }
            i = trimmed.index(after: i)
        }

        guard let slashIdx = divIndex else {
            return processParenContents(trimmed)
        }

        let beforeSlash = String(trimmed[trimmed.startIndex..<slashIdx]).trimmingCharacters(in: .whitespaces)
        let afterSlash = String(trimmed[trimmed.index(after: slashIdx)..<trimmed.endIndex]).trimmingCharacters(in: .whitespaces)

        let numerator = beforeSlash
        let (denomToken, rest) = extractLeadingToken(afterSlash)

        let numLatex = stripOuterParens(convertDivisionsToFrac(numerator))
        let denLatex = stripOuterParens(convertDivisionsToFrac(denomToken))

        var fracResult = "\\frac{\(numLatex)}{\(denLatex)}"

        let remaining = rest.trimmingCharacters(in: .whitespaces)
        if !remaining.isEmpty {
            if remaining.hasPrefix("*") {
                let afterOp = String(remaining.dropFirst()).trimmingCharacters(in: .whitespaces)
                fracResult += " * \(convertMultiplicativeToFrac(afterOp))"
            } else if remaining.hasPrefix("/") {
                let afterOp = String(remaining.dropFirst()).trimmingCharacters(in: .whitespaces)
                let (nextDen, nextRest) = extractLeadingToken(afterOp)
                let nextDenLatex = stripOuterParens(convertDivisionsToFrac(nextDen))
                fracResult = "\\frac{\(fracResult)}{\(nextDenLatex)}"
                let nextRemaining = nextRest.trimmingCharacters(in: .whitespaces)
                if !nextRemaining.isEmpty {
                    fracResult += " \(convertMultiplicativeToFrac(nextRemaining))"
                }
            }
        }

        return fracResult
    }

    /// Извлекает первый токен из выражения: `(...)` группу или одно слово/число
    private static func extractLeadingToken(_ expr: String) -> (String, String) {
        let trimmed = expr.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty { return ("", "") }

        if trimmed.hasPrefix("(") {
            let start = trimmed.index(after: trimmed.startIndex)
            if let closing = findMatchingParen(in: trimmed, from: start) {
                let token = String(trimmed[trimmed.startIndex...closing])
                let rest = String(trimmed[trimmed.index(after: closing)..<trimmed.endIndex]).trimmingCharacters(in: .whitespaces)
                return (token, rest)
            }
        }

        if trimmed.hasPrefix("\\") {
            var idx = trimmed.startIndex
            idx = trimmed.index(after: idx)
            while idx < trimmed.endIndex && trimmed[idx].isLetter {
                idx = trimmed.index(after: idx)
            }
            while idx < trimmed.endIndex && trimmed[idx] == "{" {
                var bDepth = 1
                idx = trimmed.index(after: idx)
                while idx < trimmed.endIndex && bDepth > 0 {
                    if trimmed[idx] == "{" { bDepth += 1 }
                    else if trimmed[idx] == "}" { bDepth -= 1 }
                    idx = trimmed.index(after: idx)
                }
            }
            let token = String(trimmed[trimmed.startIndex..<idx])
            let rest = String(trimmed[idx..<trimmed.endIndex]).trimmingCharacters(in: .whitespaces)
            return (token, rest)
        }

        var idx = trimmed.startIndex
        while idx < trimmed.endIndex {
            let ch = trimmed[idx]
            if ch.isLetter || ch.isNumber || ch == "_" || ch == "." {
                idx = trimmed.index(after: idx)
            } else {
                break
            }
        }

        let token = String(trimmed[trimmed.startIndex..<idx])
        let rest = String(trimmed[idx..<trimmed.endIndex]).trimmingCharacters(in: .whitespaces)
        if token.isEmpty, let first = trimmed.first {
            return (String(first), String(trimmed.dropFirst()))
        }
        return (token, rest)
    }

    /// Убирает внешние скобки если всё выражение обёрнуто: `(a + b)` → `a + b`
    private static func stripOuterParens(_ expr: String) -> String {
        let trimmed = expr.trimmingCharacters(in: .whitespaces)
        guard trimmed.hasPrefix("(") && trimmed.hasSuffix(")") else { return trimmed }
        let inner = trimmed.index(after: trimmed.startIndex)
        if let closing = findMatchingParen(in: trimmed, from: inner),
           closing == trimmed.index(before: trimmed.endIndex) {
            return String(trimmed[inner..<closing])
        }
        return trimmed
    }

    /// Рекурсивно обрабатывает содержимое скобок в выражении
    private static func processParenContents(_ expr: String) -> String {
        var result = ""
        var i = expr.startIndex
        while i < expr.endIndex {
            if expr[i] == "(" {
                let start = expr.index(after: i)
                if let closing = findMatchingParen(in: expr, from: start) {
                    let inner = String(expr[start..<closing])
                    let processed = convertDivisionsToFrac(inner)
                    result += "(\(processed))"
                    i = expr.index(after: closing)
                    continue
                }
            }
            result.append(expr[i])
            i = expr.index(after: i)
        }
        return result
    }

    /// Конвертирует func(...) в \func{...} (для sqrt) или \func(...) (для триг.)
    private static func convertFunctionToLatex(_ input: String, function: String, latex: String) -> String {
        var result = input
        var searchStartOffset = 0
        while true {
            guard let searchStart = result.index(result.startIndex, offsetBy: searchStartOffset, limitedBy: result.endIndex),
                  searchStart < result.endIndex,
                  let range = result.range(of: "\(function)(", range: searchStart..<result.endIndex) else { break }
            if range.lowerBound > result.startIndex {
                let prev = result[result.index(before: range.lowerBound)]
                if prev == "\\" || prev.isLetter {
                    searchStartOffset = result.distance(from: result.startIndex, to: range.upperBound)
                    continue
                }
            }
            guard let closing = findMatchingParen(in: result, from: range.upperBound) else { break }
            let content = String(result[range.upperBound..<closing])
            let isSqrt = function == "sqrt"
            let replacement = isSqrt ? "\(latex){\(content)}" : "\(latex)(\(content))"
            let startOffset = result.distance(from: result.startIndex, to: range.lowerBound)
            result = result.replacingCharacters(in: range.lowerBound..<result.index(after: closing), with: replacement)
            searchStartOffset = startOffset + replacement.count
        }
        return result
    }

    /// Конвертирует pow(base, exp) в {base}^{exp}
    private static func convertPowToLatex(_ input: String) -> String {
        var result = input
        while let range = result.range(of: "pow(") {
            guard let closing = findMatchingParen(in: result, from: range.upperBound) else { break }
            let content = String(result[range.upperBound..<closing])
            let parts = content.split(separator: ",", maxSplits: 1).map { $0.trimmingCharacters(in: .whitespaces) }
            if parts.count == 2 {
                let replacement = "{\(parts[0])}^{\(parts[1])}"
                result = result.replacingCharacters(in: range.lowerBound..<result.index(after: closing), with: replacement)
            } else {
                break
            }
        }
        return result
    }

    /// Находит закрывающую скобку, учитывая вложенность
    static func findMatchingParen(in str: String, from start: String.Index) -> String.Index? {
        var depth = 1
        var idx = start
        while idx < str.endIndex {
            let ch = str[idx]
            if ch == "(" { depth += 1 }
            else if ch == ")" { depth -= 1; if depth == 0 { return idx } }
            idx = str.index(after: idx)
        }
        return nil
    }
}
