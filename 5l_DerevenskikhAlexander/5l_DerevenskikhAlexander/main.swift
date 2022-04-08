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


// MARK: - CarActions
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
}

// MARK: - Protocol Car
/// Протокол автомобиля с общими свойствами
protocol CarProtocol {
    var brand: String { get set }
    var mark: String { get set }
    var mass: Double { get set }
    var year: Int { get set }
    var fullname: String { get }
    func doAction(_ action: CarAction)
}

/// CarProtocol+fullname
extension CarProtocol {
    /// Возвращает красивую строку год, бренд, марка
    var fullname: String {
        "(\(year)) \(brand)-\(mark)"
    }
}

/// CarProtocol+Engine
extension CarProtocol {
    /// Запускает двигатель авто
    func startEngine () {
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
}

extension CarWindowedProtocol where Self: CarProtocol {
    func closeWindow() {
        print("\(fullname) Окошки закрыты")
    }
    func openWindow() {
        print("\(fullname) Окошки открыты")
    }
}

// MARK: - CarTrunkProtocol
/// Тип Машин с кузовом
protocol CarTrunkProtocol {
    var volume: Double { get set }
}


// MARK: - Car
class Car: CarProtocol {
    var brand: String
    var mark: String
    var mass: Double
    var year: Int

    init (brand: String,
          mark: String,
          mass: Double,
          year: Int) {
        self.mark = mark
        self.brand = brand
        self.mass = mass
        self.year = year
    }

    func doAction(_ action: CarAction) {
        switch action {
        case .runEngine:
            startEngine()
        case .shutDownEngine:
            stopEngine()
        default:
            print("Машина такого не умеет")
        }
    }
}

// MARK: - SportCar
/// Класс спортивной машинки
final class SportCar: Car {
    override func doAction(_ action: CarAction) {
        switch action {
        case .openWindows:
            openWindow()
        case .closeWindows:
            closeWindow()
        default:
            super.doAction(action)
        }
    }
}

extension SportCar: CarWindowedProtocol {
    var isWindowClosed: Bool { return false }

    func closeWindow() {
        print("\(fullname) В спортивной машине окна не закрываются")
    }
}

//
// extension SportCar {
//
//    func closeWindow() {
//        isWindowClosed = false
//        guard proto = self as? CarWindowedProtocol
//        (self as? CarWindowedProtocol).closeWindow()
//    }
//
//    func openWindow() {
//        isWindowClosed = true
//    }
// }

// MARK: - Игры с машинками

let sportCar = SportCar(brand: "SportCar", mark: "2101", mass: 700, year: 1980 )
sportCar.startEngine()
sportCar.openWindow()
sportCar.closeWindow()
sportCar.stopEngine()
sportCar.doAction(.openWindows)
sportCar.doAction(.closeWindows)
