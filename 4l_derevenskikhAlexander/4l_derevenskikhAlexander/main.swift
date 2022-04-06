//
//  main.swift
//  4l_derevenskikhAlexander
//
//  Created by Aleksandr Derevenskih on 04.04.2022.
//

import Foundation

// MARK: - Задание
// 1. Описать класс Car c общими свойствами автомобилей и пустым методом действия по аналогии с прошлым заданием.
//
// 2. Описать пару его наследников trunkCar и sportСar. Подумать, какими отличительными свойствами обладают эти автомобили.
// Описать в каждом наследнике специфичные для него свойства.
// 3. Взять из прошлого урока enum с действиями над автомобилем. Подумать, какие особенные действия имеет trunkCar, а какие – sportCar. Добавить эти действия в перечисление.
//
// 4. В каждом подклассе переопределить метод действия с автомобилем в соответствии с его классом.
//
// 5. Создать несколько объектов каждого класса. Применить к ним различные действия.
//
// 6. Вывести значения свойств экземпляров в консоль.

// MARK: - CarAction

/// Действия, допустимые с автомобилями
enum CarAction {
    /// Open all windows
    case openWindows
    /// Close all windows
    case closeWindows
    /// Rin the engine
    case runEngine
    /// Engine shut down
    case shutDownEngine
    /// Load the cargo
    case loadStuff(volume: Double)
    /// Unload Load the cargo
    case unloadStuff(volume: Double)
    /// Подготовить машину для погрузки
    case openForLoad
    /// Завершить погрузку
    case closeForLoad
    /// Затонировать окна
    case toneWindows(level: Int, color: CGColor)
}


// MARK: - Car Базовый класс автомобиля

/// Базовый класс автомобиля
class Car {
    /// Тип кузова автомобиля
    enum CarType: String {
        case sedan
        case pickup
        case sport
        case trunk
        case unknown

        func toString() -> String {
            switch self {
            case .sedan:
                return "Sedan"
            case .pickup:
                return "Pickup"
            case .sport:
                return "Sportcar"
            case .trunk:
                return "Trunk"
            default:
                return "Unknown car type"
            }
        }
    }
    /// тип кузова автомобиля
    var type: CarType = .unknown

    /// Марка автомобиля
    var mark: String

    /// Год выпуска
    var year: Int

    /// Запущен ли двигатель
    var isEngineActive = false {
        willSet {
            if newValue != isEngineActive {
                print(self.mark + " " + (newValue ? "заведена" : "заглушена"))
            }
        }
    }

    /// Открыты ли окна
    var isWindowsOpened = false {
        willSet {
            if newValue != isWindowsOpened {
                print(self.mark + " окошки " + (newValue ? " открыты" : " закрыты"))
            }
        }
    }

    /// конструктор с базовыми параметрами
    init (mark: String, year: Int) {
        self.mark = mark
        self.year = year
        print("\(mark) произведено на свет \(year)")
    }

    /// Действия через enum CarAction
    func doAction(_ action: CarAction) {
        switch action {
        case .openWindows:
            self.isWindowsOpened = true
        case .closeWindows:
            self.isWindowsOpened = false
        case .runEngine:
            self.isEngineActive = true
        case .shutDownEngine:
            self.isEngineActive = false
        default:
            print("Машина такого не умеет")
        }
    }
}

// MARK: - TrunkCar

final class TrunkCar: Car {
    /// Состояние грузового отсека - открыт ли для погрузки
    enum LoadState: String {
        case opened
        case closed
        func toString() -> String {
            switch self {
            case .opened:
                return "Кузов для погрузки открыт"
            case .closed:
                return "Кузов для погрузки закрыт"
            }
        }
    }

    /// Тип значений по умолчанию для инициализатора по типу грузовика
    struct DefaultTrunkValues {
        let mark: String
        let year: Int
        let maxVolume: Double
    }

    /// Тип грузовика
    enum TrunkType {
        case fura
        case kamase
        case unknown

        func defaultValues() -> DefaultTrunkValues {
            switch self {
            case .fura:
                return DefaultTrunkValues(mark: "Volvo", year: 2000, maxVolume: 5000)
            case .kamase:
                return DefaultTrunkValues(mark: "Kamaz", year: 1965, maxVolume: 1300)
            case .unknown:
                return DefaultTrunkValues(mark: "", year: 0, maxVolume: 0)
            }
        }
    }

    /// Подтип грузовика
    var trunkType: TrunkType = .unknown

    /// Объем грузовика
    var maxVolume: Double

    /// Заполненный объем - приватная
    private var filledVolume = 0.0

    /// Заполненный объем
    var volume: Double {
        get {
            return self.filledVolume
        }
        set {
            if newValue > self.maxVolume {
                self.filledVolume = self.maxVolume
            } else {
                self.filledVolume = newValue
            }
        }
    }

    /// Состояние кузова грузовика - откруто или закрыто для погрузки
    var loadState: LoadState = .closed {
        willSet {
            print(newValue.rawValue)
        }
    }

    /// Загрузить груз в машину. Возвращает значение, сколько удалось загрузить
    func loadStuff (volume: Double) -> Double {
        if volume <= 0 { return 0 }

        let freeVolume = self.maxVolume - self.volume

        if freeVolume < volume {
            print(self.mark + " Нет столько места. Запрошено \(volume), влезло лишь \(freeVolume)")
            self.volume += freeVolume
            return freeVolume
        } else {
            print(self.mark + " влезло все - \(volume)")
            self.volume += volume
            return volume
        }
    }

    /// Разгрузить  машину. Возвращает значение, сколько удалось разгрузить
    func unloadStuff (volume: Double) -> Double {
        if volume <= 0 { return 0 }

        let result = min(volume, self.volume)

        self.volume -= result

        print(self.mark + " выгружено - \(result), осталось \(self.volume)")

        return result
    }

    init(mark: String, year: Int, maxVolume: Double) {
        self.maxVolume = maxVolume
        super.init(mark: mark, year: year)
        self.type = .trunk
    }

    convenience init(type: TrunkType) {
        let defaults = type.defaultValues()
        self.init(mark: defaults.mark, year: defaults.year, maxVolume: defaults.maxVolume)
        trunkType = type
    }

    override func doAction(_ action: CarAction) {
        switch action {
        case .loadStuff(volume: let volume):
            _ = self.loadStuff(volume: volume)
        case .unloadStuff(volume: let volume):
            _ = self.unloadStuff(volume: volume)
        case .openForLoad:
            self.loadState = .opened
        case .closeForLoad:
            self.loadState = .closed
        default:
            super.doAction(action)
        }
    }
}

// MARK: - SportCar

class SportCar: Car {
    /// Уровень затонированности окон. 0 - не затонированно
    var toneLevel: Int
    /// Цвет тонировки. при toneLevel == 0 не используется
    var toneColor: CGColor
    /// Затонированны ли окна
    var isWindowsToned: Bool { toneLevel != 0 }

    override init(mark: String, year: Int) {
        toneLevel = 0
        toneColor = .white
        super.init(mark: mark, year: year)
    }

    override func doAction(_ action: CarAction) {
        switch action {
        // Интересная запись. при ожидаемой записи
        // case .toneWindows(let level, let color):
        // получал ругань lint
        // Pattern Matching Keywords Violation: Combine multiple pattern matching bindings by moving keywords out of tuples. (pattern_matching_keywords)
        // NOTE: https://realm.github.io/SwiftLint/pattern_matching_keywords.html
        case let .toneWindows(level, color):
            toneLevel = level
            toneColor = color
        default:
            super.doAction(action)
        }
    }
}

// MARK: - play with cars
let trunk = TrunkCar(mark: "ZIL", year: 1990, maxVolume: 4000)
print(trunk.type)
let trunkVolvo = TrunkCar(type: .fura)
print(trunkVolvo)
let ladaCar = SportCar(mark: "VAZ21099", year: 1999)
ladaCar.doAction(.toneWindows(level: 4, color: .black))
print(ladaCar.toneColor, ladaCar.toneLevel)
