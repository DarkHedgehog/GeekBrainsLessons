//
//  main.swift
//  6l_DerevenskihAlexandr
//
//  Created by Aleksandr Derevenskih on 11.04.2022.
//

import Foundation

// MARK: - Задание
//    1. Реализовать свой тип коллекции «очередь» (queue) c использованием дженериков.
//    2. Добавить ему несколько методов высшего порядка, полезных для этой коллекции (пример: filter для массивов)
//    3. * Добавить свой subscript, который будет возвращать nil в случае обращения к несуществующему индексу.

// MARK: - Queue
/// Очередь
struct Queue<T> {
    typealias QueuePushSubscriber = (T) -> Void

    /// Хранилище значений
    private var items: [T] = []
    /// Хранилище для замыкания, вызывается при добавлении значения в очередь
    private var pushSubscriber: QueuePushSubscriber?

    // MARK: - Queue.functions
    /// Поместить объект в очередь
    mutating func push(_ element: T) {
        items.append(element)

        guard let pushSubscriber = pushSubscriber else { return }

        pushSubscriber(element)
    }

    /// Достать объект из очереди
    /// вернет nil, если очередь пуста
    mutating func dequeue() -> T? {
        guard !items.isEmpty else { return nil }

        return items.removeFirst()
    }

    /// Поочередно изымает объекты из очереди и передает в closure,
    /// пока очерередь не опустеет, либо closure не вернет true
    mutating func dequeue(while continueToDequeue: (T) -> Bool) -> [T] {
        guard !items.isEmpty else { return [] }

        var result: [T] = []
        while let item = items.first {
            if !continueToDequeue(item) {
                break
            }
            result.append(items.removeFirst())
        }
        return result
    }

    // MARK: - Queue.subscribers
    /// Добавляет прослушивателя события добавления элемента в Queue
    mutating func setPush(subscriber closure: @escaping QueuePushSubscriber) {
        pushSubscriber = closure
    }

    // MARK: - Queue.subscript
    /// Возвращает элемент  где index == 0 - первый в очереди
    subscript (index: Int) -> T? {
        guard index >= 0 && index < items.count else {
            return nil
        }
        return items[index]
    }
}

// MARK: - Игры с Queue
var queue = Queue<Int>()

queue.push(12)
queue.push(23)
queue.push(34)
queue.push(45)
queue.push(56)
queue.push(67)
queue.push(78)
queue.push(89)
queue.push(99)
print(queue[0] ?? "nil")
print(queue[1] ?? "nil")
print(queue[2] ?? "nil")
print(queue[3] ?? "nil")
var tttt = queue.dequeue() ?? 0
print(" tttt \(tttt)")

var someValues = queue.dequeue { value in
    print("closure \(value)")
    return value < 50
}
print(someValues)

someValues = queue.dequeue { $0 > 50 }
print(someValues)

queue.push(12)
queue.push(23)
queue.push(34)
queue.push(45)
queue.push(56)
queue.push(67)
print(queue[0] ?? "nil")
print(queue[1] ?? "nil")
print(queue[2] ?? "nil")
print(queue[3] ?? "nil")
queue.setPush { value in
    print("\(value) добавлен" )
}
queue.push(67)
queue.push(78)
queue.push(89)
queue.push(99)
