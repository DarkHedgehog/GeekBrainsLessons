//
//  main.swift
//  Lesson01
//
//  Created by Aleksandr Derevenskih on 24.03.2022.
//

import Foundation

//-------------------------------------
// 1. Решить квадратное уравнение.
//-------------------------------------
print ("1. Решить квадратное уравнение.")

print ("\tКвадратное уравнение — это уравнение вида ax^2 + bx + c = 0, ")
let a: Double = 5
let b: Double = 2
let c: Double = -5

print("\tпример: \(a)x^2 \(b >= 0 ? "+ \(b)" : "- \(abs(b))")x \(c >= 0 ? "+ \(c)" : "- \(abs(c))")")

let deskriminant = pow(b, 2) - 4 * a * c
if (deskriminant < 0) {
    print("\tКорней нет")
} else if (deskriminant == 0) {
    print("\tКорень один")
    let solution = ( -b / (2 * a) )
    print ("\tРешение : x = \(solution)")
} else if (deskriminant > 0){
    print("\tЕсть 2 различных корня")
    let solution1 = ( -b - sqrt(deskriminant)) / (2 * a)
    let solution2 = ( -b + sqrt(deskriminant)) / (2 * a)
    print ("\tРешение 1: x = \(solution1), Решение 2: x = \(solution2)" )
}

//-------------------------------------
// 2. Даны катеты прямоугольного треугольника. Найти площадь, периметр и гипотенузу треугольника.
//-------------------------------------
print ("\n2. Даны катеты прямоугольного треугольника. Найти площадь, периметр и гипотенузу треугольника.")
let katetA = 1.2
let katetB = 2.3

let hypotenuse = sqrt(pow(katetA, 2) + pow(katetB, 2))

print ("\n\tПри катетах \(katetA), \(katetB) гипотенуза = \(hypotenuse)")


//-------------------------------------
// 2. Пользователь вводит сумму вклада в банк и годовой процент. Найти сумму вклада через 5 лет.
//-------------------------------------
print("\n3. Пользователь вводит сумму вклада в банк и годовой процент. Найти сумму вклада через 5 лет.")

let deposit = 100.01
let yearsPeriod: Double = 5.1
let yearPercent = 10.0

let percentNotIncluded: Double = deposit + round ((yearsPeriod * deposit * yearPercent)) / 100.0
print("\n\tВклад в банк: \(deposit), срок вклада: \(yearsPeriod), процент: \(yearPercent)")
print("\tПроценты не кладутся на депозит - сумма на конец периода: \(percentNotIncluded)")

var deposidWithPercents = deposit
var yearsToCalc = yearsPeriod
while yearsToCalc > 0 {
    let period = yearsToCalc > 1.0 ? 1.0 : yearsToCalc;
    let percentSumm: Double = round (period * deposidWithPercents * yearPercent) / 100.0
    deposidWithPercents += percentSumm
    yearsToCalc -= period
}
deposidWithPercents = round(deposidWithPercents * 100) / 100.0
print("\tПроценты кладутся на депозит - сумма на конец периода: \(deposidWithPercents)")
