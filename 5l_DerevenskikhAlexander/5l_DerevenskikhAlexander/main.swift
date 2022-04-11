//
//  main.swift
//  5l_DerevenskikhAlexander
//
//  Created by Aleksandr Derevenskih on 07.04.2022.
//
import Foundation

// MARK: - Lesson-5 Задание
// 1. Создать протокол «Car» и описать свойства, общие для автомобилей, а также метод действия.
// 2. Создать расширения для протокола «Car» и реализовать в них методы конкретных действий с автомобилем: открыть/закрыть окно, запустить/заглушить двигатель и т.д. (по одному методу на действие, реализовывать следует только те действия, реализация которых общая для всех автомобилей).
// 3. Создать два класса, имплементирующих протокол «Car» - trunkCar и sportСar. Описать в них свойства, отличающиеся для спортивного автомобиля и цистерны.
// 4. Для каждого класса написать расширение, имплементирующее протокол CustomStringConvertible.
// 5. Создать несколько объектов каждого класса. Применить к ним различные действия.
// 6. Вывести сами объекты в консоль.

// MARK: - CGColor+hexString
extension CGColor {
    var hexString: String {
        guard let components = components else {
            return "непонятный цвет"
        }
        // Утащено со stackoverflow - swiftway
        return components[0..<3]
            .map { String(format: "%02lX", Int($0 * 255)) }
            .reduce("#", +)
    }
}

// MARK: - String+URL
extension String {
    ///  Вернуть из строки URL
    var url: URL? {
        URL(string: self)
    }
}

// MARK: - Brands of Cars
// Варианты брэндов
enum CarBrand {
    case bmv
    case lada
    case chery
    case audi
}

// Логотипы
extension CarBrand {
    var logo: URL? {
        switch self {
        case .bmv:
            return "https://wallsdesk.com/wp-content/uploads/2016/05/Logo-Of-BMW.png".url
        case .lada:
            return "https://www.carlogos.org/logo/Lada-logo-silver-1366x768.jpg".url
        case .chery:
            return "https://www.carlogos.org/logo/Chery-logo-2013-3840x2160.png".url
        case .audi:
            return "https://pluspng.com/img-png/audi-logo-png-audi-logo-transparan-png-2000.gif".url
        }
    }
}


// MARK: - Car Protocol
/// Протокол автомобиля с общими свойствами
protocol CarProtocol {
    var brand: CarBrand { get set }
    var mark: String { get set }
    var mass: Double { get set }
    var year: Int { get set }
    var fullname: String { get }
    func runEngine()
    func stopEngine()
}

/// CarProtocol+fullname
extension CarProtocol {
    /// Возвращает "красивую" строку год, бренд, марка
    var fullname: String {
        "(\(year)) \(brand)-\(mark)"
    }
}

/// CarProtocol+Engine
extension CarProtocol {
    /// Запускает двигатель авто
    func runEngine () {
        print("\(fullname) Двигатель запущен")
    }
    /// Глушит двигатель авто
    func stopEngine() {
        print("\(fullname) Двигатель заглушен")
    }
}

// MARK: - CarWindowedProtocol

/// Тип для машин с окошками
protocol CarWindowedProtocol {
    var isWindowClosed: Bool { get }
    func closeWindow()
    func openWindow()
}

extension CarWindowedProtocol where Self: CarProtocol {
    func closeWindow() {
        print("\(fullname) Окошки закрыты")
    }
    func openWindow() {
        print("\(fullname) Окошки открыты")
    }
}

// MARK: - CarCargoBayProtocol
/// Грузовой отсек для Car
protocol CarCargoBayProtocol {
    var volume: Double { get set }
    func openCargoBay()
    func closeCargoBay()
}

extension CarWindowedProtocol where Self: CarProtocol {
    func openCargoBay() {
        print("\(fullname) Грузовой отсек открыт")
    }
    func closeCargoBay() {
        print("\(fullname) Грузовой отсек закрыт")
    }
}

// MARK: - CarNitroProtocol
/// Протокол закиси азота для Car
protocol CarNitroProtocol {
    func forceNitro()
}

extension CarNitroProtocol where Self: CarProtocol {
    func forceNitro() {
        print("\(fullname) Nitro используется")
    }
}

// MARK: - Colored Car
/// Добавляет требования к окрасу
protocol Colorable {
    var color: CGColor { get set }
}


// MARK: - SportCar CarProtocol
/// Класс спортивной машинки
final class SportCar: CarProtocol {
    var brand: CarBrand
    var mark: String
    var mass: Double
    var year: Int

    private var bodyColor: CGColor = .init(red: 0.3, green: 0.4, blue: 0.5, alpha: 0.6)
    private var isEngineStarted = false
    private var isForcedRun = false
    private var isWindowsOpened = false

    init (brand: CarBrand, mark: String, mass: Double, year: Int) {
        self.brand = brand
        self.mark = mark
        self.mass = mass
        self.year = year
    }

    func runEngine() {
        isEngineStarted = true
    }

    func stopEngine() {
        isEngineStarted = false
    }
}

// MARK: - SportCar CarNitroProtocol
extension SportCar: CarNitroProtocol {
    /// Run nitro mode
    func forceNitro() {
        // run nitro only if engine is started
        isForcedRun = isEngineStarted
    }
}

// MARK: - SportCar Colorable
extension SportCar: Colorable {
    var color: CGColor {
        get {
            bodyColor
        }
        set {
            bodyColor = newValue
        }
    }
}

// MARK: - SportCar: CarWindowedProtocol
extension SportCar: CarWindowedProtocol {
    var isWindowClosed: Bool {
        !isWindowsOpened
    }
    func closeWindow() {
        isWindowsOpened = false
    }
    func openWindow() {
        isWindowsOpened = true
    }
}

// MARK: - SportCar: CustomStringConvertible
extension SportCar: CustomStringConvertible {
    var description: String {
        return fullname +
        ", Двигатель - " + (isEngineStarted ? "заведен" : "заглушен") +
        ", Форсаж - " + (isForcedRun ? "включен" : "отключен") +
        ", Окна - " + (isWindowsOpened ? "открыты" : "закрыты") +
        ", цвет - " + color.hexString
    }
}
// MARK: - TrunkCar
final class TrunkCar: CarProtocol {
    var brand: CarBrand
    var mark: String
    var mass: Double
    var year: Int

    private var cargoVolume = 0.0
    private var isEngineStarted = false
    private var isCargoBayOpened = false

    init (brand: CarBrand, mark: String, mass: Double, year: Int) {
        self.brand = brand
        self.mark = mark
        self.mass = mass
        self.year = year
    }
}

// MARK: - TrunkCar: CarWindowedProtocol
extension TrunkCar: CarWindowedProtocol {
    // В грузовике окна всегда заварены
    var isWindowClosed: Bool {
        return true
    }
}

// MARK: - TrunkCar: CarCargoBayProtocol
extension TrunkCar: CarCargoBayProtocol {
    var volume: Double {
        get {
            cargoVolume
        }
        set {
            cargoVolume = newValue
        }
    }
    func closeCargoBay() {
        isCargoBayOpened = false
    }
    func openCargoBay() {
        isCargoBayOpened = true
    }
}

// MARK: - TrunkCar: CustomStringConvertible
extension TrunkCar: CustomStringConvertible {
    var description: String {
        return fullname +
        ", Двигатель - " + (isEngineStarted ? "заведен" : "заглушен") +
        ", Окна - " + (isWindowClosed ? "открыты" : "закрыты") +
        ", Груз - " + cargoVolume +
        ", Грузовой отсек - " + (isCargoBayOpened ? "открыт" : "закрыт")
    }
}

// MARK: - Игры с машинками

let sportCar = SportCar(brand: .lada, mark: "2101", mass: 700, year: 1980 )
let trunkCar = TrunkCar(brand: .chery, mark: "Pickup", mass: 2700, year: 2025)
sportCar.runEngine()
sportCar.stopEngine()
print(sportCar.color)
print(sportCar.description)
print(String(describing: sportCar))
trunkCar.runEngine()
print(String(describing: trunkCar))
