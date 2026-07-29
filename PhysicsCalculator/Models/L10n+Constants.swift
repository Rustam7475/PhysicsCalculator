import Foundation

extension L10n {
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
    static var constAvogadroDesc: String { t(["ru": "Число частиц в одном моле вещества", "en": "Number of particles in one mole", "de": "Anzahl der Teilchen in einem Mol", "es": "Número de partículas en un mol", "fr": "Nombre de particules dans eine mole", "zh": "一摩尔物质中的粒子数"]) }
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
            "h_Дж·с": ["ru": "Постоянная Планка", "en": "Planck constant", "de": "Planck-Konstante", "es": "Constante de Planck", "fr": "Constante de Planck", "zh": "普朗к常数"],
            "ε0_Ф/м": ["ru": "Электрическая постоянная", "en": "Vacuum permittivity", "de": "Elektrische Feldkonstante", "es": "Permitividad del vacío", "fr": "Permittivité du vide", "zh": "真空介电常数"],
            "μ0_Гн/м": ["ru": "Магнитная постоянная", "en": "Vacuum permeability", "de": "Magnetische Feldkonstante", "es": "Permeabilidad del vacío", "fr": "Perméabilité du vide", "zh": "真空磁导率"],
            "σ_Вт/(м²·К⁴)": ["ru": "Постоянная Стефана-Больцмана", "en": "Stefan-Boltzmann constant", "de": "Stefan-Boltzmann-Konstante", "es": "Constante de Stefan-Boltzmann", "fr": "Constante de Stefan-Boltzmann", "zh": "斯特藩-玻尔兹曼常数"],
            "G_Н·м²/кг²": ["ru": "Гравитационная постоянная", "en": "Gravitational constant", "de": "Gravitationskonstante", "es": "Constante gravitacional", "fr": "Constante gravitationnelle", "zh": "万有引力常数"],
            "k_Н·м²/Кл²": ["ru": "Коэффициент Кулона", "en": "Coulomb constant", "de": "Coulomb-Konstante", "es": "Constante de Coulomb", "fr": "Constante de Coulomb", "zh": "库仑常数"],
        ]
        return t(map[key] ?? ["en": symbol])
    }
}
