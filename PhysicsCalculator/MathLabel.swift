import SwiftUI
import SwiftMath // Импортируем библиотеку SwiftMath


// Обертка UIViewRepresentable для использования MTMathUILabel в SwiftUI (для iOS)
struct MathLabel: UIViewRepresentable {
    // Свойства, которые мы хотим передать в MTMathUILabel
    var latex: String
    var fontSize: CGFloat = 20 // Размер шрифта по умолчанию
    var textColor: UIColor = .label // Цвет текста по умолчанию (адаптивный)
    var textAlignment: MTTextAlignment = .center // Выравнивание по умолчанию

    // Создает экземпляр UIKit View (MTMathUILabel)
    func makeUIView(context: Context) -> MTMathUILabel {
        let label = MTMathUILabel()
        label.latex = latex
        label.fontSize = fontSize
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.labelMode = .text // Отображаем как текст, а не значок
        // Устанавливаем устойчивость к сжатию, чтобы текст не обрезался легко
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return label
    }

    // Обновляет существующий UIKit View при изменении данных в SwiftUI
    func updateUIView(_ uiView: MTMathUILabel, context: Context) {
        // Обновляем только те свойства, которые могли измениться
        if uiView.latex != latex { uiView.latex = latex }
        if uiView.fontSize != fontSize { uiView.fontSize = fontSize }
        if uiView.textColor != textColor { uiView.textColor = textColor }
        if uiView.textAlignment != textAlignment { uiView.textAlignment = textAlignment }
    }
}

// Опционально: Добавим модификаторы для удобной настройки из SwiftUI
extension MathLabel {
    func fontSize(_ size: CGFloat) -> MathLabel {
        var view = self; view.fontSize = size; return view
    }
    func textColor(_ color: Color) -> MathLabel {
        var view = self; view.textColor = UIColor(color); return view
    }
    func textAlignment(_ alignment: MTTextAlignment) -> MathLabel {
        var view = self; view.textAlignment = alignment; return view
    }
}

// Предпросмотр для MathLabel
#Preview {
    VStack {
        MathLabel(latex: "x = \\frac{-b \\pm \\sqrt{b^2-4ac}}{2a}")
            .fontSize(24)
            .textColor(.blue) // Используем SwiftUI Color
            .textAlignment(.left) // Используем MTTextAlignment
            .padding()
        MathLabel(latex: "F = m \\cdot a")
            .padding()
    }
}
