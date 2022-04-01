//
//  main.swift
//  Lesson02
//
//  Created by Aleksandr Derevenskih on 29.03.2022.
//

/*
1. Написать функцию, которая определяет, четное число или нет.

2. Написать функцию, которая определяет, делится ли число без остатка на 3.

3. Создать возрастающий массив из 100 чисел.

4. Удалить из этого массива все четные числа и все числа, которые не делятся на 3.

*/


// 1. Написать функцию, которая определяет, четное число или нет.

/// возвращает true, если число четное
func isNumberEven(_ value: Int) -> Bool {
    return (value % 2) == 0
}

// 2. Написать функцию, которая определяет, делится ли число без остатка на 3.

/// возвращает true, если число делится на 3 без остатка
func isNumberMulti3(_ value: Int) -> Bool {
    return (value % 3) == 0
}

// 3. Создать возрастающий массив из 100 чисел.

func makeLadderArray(_ count: Int) -> [Int] {
    var ladder = [Int](repeating: 0, count: count )
    for index in 0...ladder.count-1 {
        ladder[index] = index
    }

    return ladder
}



// 4. Удалить из этого массива все четные числа и все числа, которые не делятся на 3.

var ladderIndexed = makeLadderArray(100)

var index = ladderIndexed.count - 1

while index > 0 {
    if isNumberEven(ladderIndexed[index]) || !isNumberMulti3(ladderIndexed[index]) {
        ladderIndexed.remove(at: index)
    }
    index -= 1
}

var ladderForIn = makeLadderArray(100)

for item in ladderForIn where isNumberEven(item) || !isNumberMulti3(item) {
//    ladderForIn.removeFirst(item)
}
print (ladderIndexed)
print (ladderForIn)



