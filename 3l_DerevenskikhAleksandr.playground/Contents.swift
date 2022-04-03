import Cocoa


//1. Описать несколько структур – любой легковой автомобиль SportCar и любой грузовик TrunkCar.
//
//2. Структуры должны содержать марку авто, год выпуска, объем багажника/кузова, запущен ли двигатель, открыты ли окна, заполненный объем багажника.
//
//3. Описать перечисление с возможными действиями с автомобилем: запустить/заглушить двигатель, открыть/закрыть окна, погрузить/выгрузить из кузова/багажника груз определенного объема.
//
//4. Добавить в структуры метод с одним аргументом типа перечисления, который будет менять свойства структуры в зависимости от действия.
//
//5. Инициализировать несколько экземпляров структур. Применить к ним различные действия.
//
//6. Вывести значения свойств экземпляров в консоль.

enum CarType: String {
    case sedan = "Седан"
    case pickup = "Пикап"
    case truck = "Грузовик"
    case sport = "Спорткар"
}

enum CarAction {
    case openWindows
    case closeWindows
    case runEngine
    case shutDownEngine
    case loadStuff(volume: Double)
    case unloadStuff(volume: Double)
    case openForLoad
    case closeForLoad
}

/// Жаль что нет наследования
struct SportCar {

    ///  тип кузова автомобиля
    let type: CarType = .sport

    /// Марка автомобиля
    let mark: String

    /// Год выпуска
    let year: Int

    /// объем
    let maxVolume: Double

    /// заполненный объем - приватная
    private var filledVolume = 0.0

    /// заполненный объем
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

    /// запущен ли двигатель
    var isEngineActive = false {
        willSet {
            if newValue != isEngineActive {
                print(self.mark + " " + (newValue ? "заведена" : "заглушена"))
            }
        }
    }

    ///открыты ли окна
    var isWindowsOpened = false {
        willSet {
            if newValue != isWindowsOpened {
                print(self.mark + " окошки " + (newValue ? " открыты" : " закрыты"))
            }
        }
    }

    /// конструктор с базовыми параметрами
    init (mark: String, year: Int, maxVolume: Double) {

        self.mark = mark
        self.year = year
        self.maxVolume = maxVolume

        print ("\(self.mark) произведено на свет \(self.year)")
    }

    /// Загрузить груз в машину. Возвращает значение, сколько удалось загрузить
    mutating func loadStuff (volume: Double) -> Double {
        if volume <= 0 { return 0 }

        let freeVolume = self.maxVolume - self.volume

        if (freeVolume < volume) {
            print(self.mark + " впихнуть невпихуемое - нет столько места. Запрошено \(volume), влезло лишь \(freeVolume)")
            self.volume += freeVolume
            return freeVolume;
        } else {
            print(self.mark + " влезло все - \(volume)")
            self.volume += volume
            return volume;
        }
    }

    /// Разгрузить  машину. Возвращает значение, сколько удалось разгрузить
    mutating func unloadStuff (volume: Double) -> Double {

        if volume <= 0 { return 0 }

        let result = min(volume, self.volume)

        self.volume -= result

        print(self.mark + " выгружено - \(result), осталось \(self.volume)")

        return result;
    }

    /// Действия через enum CarAction
    mutating func doAction(_ action: CarAction) {
        switch action {
        case .openWindows:
            self.isWindowsOpened = true
        case .closeWindows:
            self.isWindowsOpened = false
        case .runEngine:
            self.isEngineActive = true;
        case .shutDownEngine:
            self.isEngineActive = false;
        case .loadStuff(volume: let volume):
            self.loadStuff(volume: volume)
        case .unloadStuff(volume: let volume):
            self.unloadStuff(volume: volume)
        default:
            print("Машина такого не умеет")
        }
    }
}

/// Отличия от SportCar - loadState указывает, открыт ли грузовик для погрузки.
/// В закрытый грузовик добавить груз не получится
struct TrunkCar {

    enum LoadState: String {
        case opened = "Кузов для погрузки открыт"
        case closed = "Кузов для погрузки закрыт"
    }

    ///  тип кузова автомобиля
    let type: CarType = .sport

    /// Марка автомобиля
    let mark: String

    /// Год выпуска
    let year: Int

    /// объем
    let maxVolume: Double

    var loadState: LoadState = .closed{
        willSet {
            print(newValue.rawValue)
        }
    }

    /// заполненный объем - приватная
    private var filledVolume = 0.0

    /// запущен ли двигатель
    var isEngineActive = false {
        willSet {
            if newValue != isEngineActive {
                print(self.mark + " " + (newValue ? "заведена" : "заглушена"))
            }
        }
    }

    ///открыты ли окна
    var isWindowsOpened = false {
        willSet {
            if newValue != isWindowsOpened {
                print(self.mark + " окошки " + (newValue ? " открыты" : " закрыты"))
            }
        }
    }

    /// конструктор с базовыми параметрами
    init (mark: String, year: Int, maxVolume: Double) {

        self.mark = mark
        self.year = year
        self.maxVolume = maxVolume

        print ("\(self.mark) произведено на свет \(self.year)")
    }

    /// Загрузить груз в машину. Возвращает значение, сколько удалось загрузить
    mutating func loadStuff (volume: Double) -> Double {

        if volume <= 0 { return 0 }

        if (self.loadState != .opened) {
            print ("Попытка загрузить закрытую машину")
            return 0
        }

        let freeVolume = self.maxVolume - self.filledVolume

        if (freeVolume < volume) {
            print(self.mark + " впихнуть невпихуемое - нет столько места. Запрошено \(volume), влезло лишь \(freeVolume)")
            self.filledVolume += freeVolume
            return freeVolume;
        } else {
            print(self.mark + " влезло все - \(volume)")
            self.filledVolume += volume
            return volume;
        }
    }

    /// Разгрузить  машину. Возвращает значение, сколько удалось разгрузить
    mutating func unloadStuff (volume: Double) -> Double {

        if volume <= 0 { return 0 }

        if (self.loadState != .opened) {
            print ("Попытка разгрузить закрытую машину")
            return 0
        }


        let result = min(volume, self.filledVolume)

        self.filledVolume -= result

        print(self.mark + " выгружено - \(result), осталось \(self.filledVolume)")

        return result;
    }

    /// Действия через enum CarAction
    mutating func doAction(_ action: CarAction) {

        switch action {

        case .openWindows:
            self.isWindowsOpened = true
        case .closeWindows:
            self.isWindowsOpened = false
        case .runEngine:
            self.isEngineActive = true;
        case .shutDownEngine:
            self.isEngineActive = false;
        case .loadStuff(volume: let volume):
            self.loadStuff(volume: volume)
        case .unloadStuff(volume: let volume):
            self.unloadStuff(volume: volume)
        case .openForLoad:
            self.loadState = .opened
        case .closeForLoad:
            self.loadState = .closed
        }
    }
}

var sportCar = SportCar(mark: "Lada", year: 1999, maxVolume: 700);
var trunkCar = TrunkCar(mark: "ЗИЛ", year: 1999, maxVolume: 3000);

sportCar.isEngineActive = true
sportCar.isEngineActive
sportCar.loadStuff(volume: 100)
sportCar.loadStuff(volume: 200)
sportCar.loadStuff(volume: 300)
sportCar.loadStuff(volume: 400)
sportCar.unloadStuff(volume: 10)
sportCar.unloadStuff(volume: 100)
sportCar.unloadStuff(volume: 1000)
sportCar.volume


trunkCar.doAction(.openWindows)
trunkCar.doAction(.runEngine)
trunkCar.doAction(.shutDownEngine)
trunkCar.doAction(.loadStuff(volume: 1000))
trunkCar.doAction(.openForLoad)
trunkCar.doAction(.loadStuff(volume: 1234))
trunkCar.doAction(.loadStuff(volume: 4321))
trunkCar.doAction(.runEngine)
trunkCar.doAction(.unloadStuff(volume: 321))
trunkCar.doAction(.unloadStuff(volume: 4321))
trunkCar.doAction(.closeForLoad)

print(sportCar)
print(sportCar.type)
print(sportCar.type.rawValue)


//
//// Игры с guard vs if
//
//func foo (_ str: String? ) {
//    guard let str = str else { return }
//    print(str)
//}
//func bar (_ str: String? ) {
//    if str == nil { return }
//
//    if let str = str {
//        print(str)
//    }
//}
//foo("a")
//bar("b")
//foo(nil)
//bar(nil)
