import Cocoa

var greeting = "Hello, playground"
var uint: UInt = UInt.max

class Foo {
    var foo: String = "aa"
}

class Bar: Foo {
    var bar: String
    init(_ bar: String) {
        self.bar = bar
    }
}

let bar = Bar("safasf")
print (bar.foo)




