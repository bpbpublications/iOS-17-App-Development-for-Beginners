/*
 Chapter - 05
 Subscripts and Generics in Swift
 */

/* Subscripts */
subscript(index: Int) -> Int {
    get {
        You can return appropriate values from here.
    }
    set(newValue) {
        From here, you can perform any required operation.
    }
}

struct MathTable {
    let multiplierX: Int
    subscript(index: Int) -> Int {
        return multiplierX * index
    }
}
let exampleMathTable = MathTable(multiplierX: 5)
print("six times three is \(exampleMathTable[4])")
// It Prints "six times three is 20”

struct DataTable {
    let rows: Int, columns: Int
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
    }
    
    subscript(row: Int, column: Int) -> Double {
        get {
            // return some calcualted values based on row and column
        }
        set {
            // do some basic operation on data table in case required
        }
    }
}

var data = DataTable(rows: 2, columns: 2)

enum WeekDays: Int {
    case Sunday = 1, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
    static subscript(n: Int) -> Planet {
        return WeekDays(rawValue: n)!
    }
}
let day = WeekDays[4]
print(day)

/* Generics */
func swapValues<T>(_ a: inout T, _ b: inout T) {
    let temporaryA = a
    a = b
    b = temporaryA
}

extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

/* Opaque Types */
protocol Shape {
    func drawShape() -> String
}

struct CombineShape<T: Shape, U: Shape>: Shape
{
    var top: T
    var bottom: U
    func draw() -> String {
        return top.drawShape() + "\n" + bottom.drawShape()
    }
}


let combineShapes = CombineShape(top: triangle, bottom: circle)
print(combineShapes.drawShape())

func flip<T: Shape>(_ shape: T) -> some Shape {
    return FlippedShape(shape: shape)
}
func join<T: Shape, U: Shape>(_ top: T, _ bottom: U) -> some Shape {
    CombineShape(top: top, bottom: bottom)
}

let opaqueJoinedShapes = join(smallTriangle, flip(smallTriangle))
print(opaqueJoinedShapes.drawShape())

func prototypeReturnFlip<T: Shape>(_ shape: T) -> Shape {
    return FlippedShape(shape: shape)
}

/* Access Control */
open class SampleClass {}

public class SampleClass {}
public var sampleVariable = 0

internal class SampleInternalClass {}
internal let sampleConstant = 0

fileprivate class SamplePrivateClass {}
fileprivate func samplePrivateFunction() {}

private func samplePrivatFunction() {}
private class SamplePrivateClass {}


