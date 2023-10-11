/*
 Chapter - 03
 Classes, Structure and Enumerations
 */

import UIKit

enum nameOfEnum {
    // Definition of Enumeration
}

enum PointOfCompass {
    case north
    case south
    case east
    case west
}

enum ArithmeticExp {
    case number(Int)
    indirect case addition(ArithmeticExp, ArithmeticExp)
    indirect case multiplication(ArithmeticExp, ArithmeticExp)
}

struct Cuboid
{
    var width = 0.0, height = 0.0, depth = 0.0
    var volume: Double {
        return width * height * depth
    }
}
let fourByFiveByTwo = Cuboid(width: 4.0, height: 5.0, depth: 2.0)
print("the volume of fourByFiveByTwo is \(fourByFiveByTwo.volume)")

// Property Observer
class TapCounter {
    var totalTaps: Int = 0 {
        willSet(newTotalTaps) {
            print("About to set totalTaps to \(newTotalTaps)")
        }
        didSet {
            if totalTaps > oldValue  {
                print("Added \(totalTaps - oldValue) Taps")
            }
        }
    }
}
let tapCounter = TapCounter()
tapCounter.totalTaps = 200
// About to set totaltaps to 200
// Added 200 taps
tapCounter.totalTaps = 360
// About to set totalSteps to 360
// Added 160 taps
tapCounter.totalTaps = 896
// About to set totaltaps to 896
// Added 536 taps


@propertyWrapper
struct FifteenOrLess {
    private var number: Int
    init() { self.number = 0 }
    var wrappedValue: Int {
        get { return number }
        set { number = min(newValue, 15) }
    }
}


struct Rectangle {
    @FifteenOrLess var height: Int
    @FifteenOrLess var width: Int
}
var rectangle = Rectangle()
print(rectangle.height)
// Prints "0"
rectangle.height = 10
print(rectangle.height)
// Prints "10"
rectangle.height = 24
print(rectangle.height)
// Prints "15"


// Type Properties
struct SampleStructure {
    static var storedTypeProperty = "Sample value."
    static var computedTypeProperty: Int {
        return 1
    }
}
enum SampleEnumeration {
    static var storedTypeProperty = "Sample value."
    static var computedTypeProperty: Int {
        return 6
    }
}
class SampleClass {
    static var storedTypeProperty = "Sample value."
    static var computedTypeProperty: Int {
        return 27
    }
    class var overrideComputedTypeProperty: Int {
        return 107
    }
}

// Instant Methods
class IncreaseCounter {
    var count = 0
    func increment() {
        count += 1
    }
    func increment(by amount: Int) {
        count += amount
    }
    func reset() {
        count = 0
    }
}

// Type Methods
class AnyClass {
    class func anyTypeMethod() {
        // type method implementation
    }
}
AnyClass.anyTypeMethod()


// Inheritamce
class Vehicle {
    var currentSpeed = 0.0
    var description: String {
        return "traveling at \(currentSpeed) miles per hour"
    }
    func makeNoise() {
        // do nothing - an arbitrary vehicle doesn't necessarily make a noise
    }
}
class Car: Vehicle {
    var hasBreak = true
}

let car = Car()
car.hasBreak = false
car.currentSpeed = 50.0
print("Car: \(car.description)")
// Car: traveling at 50.0 miles per hour


// Initialization

struct Celsius1 {
    var temperature: Double
    init() {
        temperature = 35.0
    }
}
var c = Celsius1()
print("The default temperature is \(c.temperature)° Celcius")
// Prints "The default temperature is 35.0° Celsius"

// Customizing Initialization
struct Celsius {
    var temperatureInCelsius: Double
    init(fromFahrenheit fahrenheit: Double) {
        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
    }
}
let boilingPointOfWater = Celsius(fromFahrenheit: 212.0)
// boilingPointOfWater.temperatureInCelsius is 100.0


