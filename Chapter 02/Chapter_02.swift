/*
 Chapter - 02
 Swift Fundamentals

 */

// Type Constant and Variable
let numberOfCounts = 10
var levelOfGame = 0
var a = 90, b = 20, c = 178

var apple, orange, grapes: String
apple = "Apple"

var cube, cone, rhombus: Double
cube = 3.4

// Opeartors

let x = "Class"
if x == "Class" {
    print("My Class")
} else {
    print("I'm sorry \(x), but I don't recognize you")
}

var classString = "My" + "Class"

// Ternary Conditional Operator

let cellIndix = 0 // value of index cell change at run time
let heightCell1 = 50
let heightOtherCell = 30
var height = cellIndix == 0 ? heightCell1 : heightOtherCell

if (cellIndix == 0)
{
    height = heightCell1
}
else {
    height = heightOtherCell
}

// Range Operator
for index in 1...3 {
    print("\(index) times 3 is \(index * 3)")
}



// Half Open range Operator
let names = ["Ram", "Ajay", "Vijay", "Rubi"]
let countNumber = names.count;
for i in 0..<countNumber {
    print("Person \(i + 1) is called \(names[i])")
}

// One Sided Range
for name in names[2...] {
    print(name)
}
for name in names[...2] {
    print(name)
}

// Logical NOT
let gateEntry = false
if !gateEntry {
    print("No Access")
}

// Logical AND
let enterCodeToUnlock = true
let fingerPrintToMatch = false
if enterCodeToUnlock && fingerPrintToMatch {
    print("Welcome To Office")
} else {
    print("NO ACCESS")
}

// Logical OR 

let haveOfficeKey = false
let knowDigitalDoorPassword = true
if haveOfficeKey || knowDigitalDoorPassword {
    print("Welcome To Office")
} else {
    print("NO ACCESS")
}

// Combine Logical Operator
if enterCodeToUnlock && fingerPrintToMatch || haveOfficeKey || knowDigitalDoorPassword {
    print("Welcome To Office!")
} else {
    print("NO ACCESS")
}

// Strings
var mutableString = "This String is"
mutableString += "Mutable"

let immutableString = "This String is not"
//immutableString += "Mutable" (Compile time error)
print(immutableString)

// Character
for character in "CHARACTER" {
    print(character)
}

// Concating Strings and character
let string1 = "Hello"
let string2 = " World"
var firstLine = string1 + string2
print(firstLine)
var question = "What is the capital of India "
let questionMark : Character = "?"
question.append(questionMark) 
print(question)

// String Interpolation
let addition = 3
let sentence = "\(addition) plus 10 is \(addition + 10)"

// Array
var listOfString = [String]()
var listOfInt  = [Int]()
let countList = "\(listOfString.count) string items"

listOfInt.append(5)
listOfInt.append(9)
print("\(listOfString.count) string items")
print(listOfInt)
listOfInt.remove(at: 1)
print(listOfInt)

var numbers = [2, 3, 4, 8, 2, 7, 3, 2]
numbers.removeAll {$0 == 2} 
print(numbers)


// Set
var characters = Set<Character>()
characters.insert("c")
print(characters.count)       
characters = [] 
print(characters.count)

// Dictionary

var friendsName = [Int: String]()

var roads: [String: String] = ["ABC": "Grand Trunk Road", "BCE": "Delhi"]
print(roads.count)  // prints - 2
roads ["PVC"] = "MJ Road"
print(roads.count)  // Now prints - 3

for (roadsCode, roadsName) in roads {
    print("\(roadsCode): \(roadsName))
}
// "ABC": "Grand Trunk Road"
// "BCE": "Delhi"

// For In Loops

let names = ["Ram", "Shaym", "Ajay", "Sunita"]
for name in names {
    print("Hey, \(name)!")
}

for index in 1...4 {
    print("\(index) times 4 is \(index * 4)")
}

// if else
var bookprice = 400
if bookprice < 450 {
    print(“I can buy this book.”)
}

var bookprice = 500
if bookprice < 450 {
    print(“I can buy this book.”)
}
else {
    print(“I can not buy this book.”)
}

var bookprice = 245
if bookprice > 450 {
    print(“I can not buy this book.”)
}
else if bookprice < 250 {
    print(“It's too cheap, I can easily buy this book.”)
}
else {
    print(“It’s in my budget, I can buy this book.”)
}


// Continue
let inputStatement = "Welcome to this University !"
var outputStatement = ""
let characterRemove: [Character] = ["a", "e", "i", "o", "u", " "]
for character in inputStatement {
    if characterRemove.contains(character) {
        continue
    }
    outputStatement.append(character)
}
print(outputStatement)

// fallthrough
let integerToCheck = 5
var sentence = "The number \(integerToCheck) is"
switch integerToDescribe {
case 2, 3, 5, 7:
    sentence += " a prime number, and also"
    fallthrough
default:
    sentence += " an integer"
}
print(sentence)

// Early Exit
var number = - 2
guard number >= 0 else {
    return nil
}


// Fucntion
func meetToFriends(friendName: String) -> String {
    let meetMessage = "Hey, " + friendName + "!"
    return meetMessage
}

func meetToFriends(friendName: String, isGreeted: Bool) -> String {
    if isGreeted {
        return meetAgain(friendName: person)
    } else {
        return meetToFriends(friendName: person)
    }
}

print(meetToFriends(friendName: "Ram", isGreeted: true))

// Clousure
let friendsName = ["Suraj", "Vijay", "Pratibha", "Nirav", "Vishal"]
func back(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}
var reverseNames = friendsName.sorted(by: back)
// reverseNames - ["Vishal", "Vijay", "Suraj", "Pratibha", "Nirav"]

{ (parameters) -> return type in
    statements
}
reverseNames = names.sorted(by: { (s1: String, s2: String) -> Bool in
    return s1 > s2
})
}

func aFuntionThatTakesClosure(closure: () -> Void) {
    // function body goes here
}
// Here's how you call this function without using a trailing closure:
aFunctionThatTakesClosure(closure: {
    // closure's body goes here
})
// Here's how you call this function with a trailing closure instead:
aFunctionThatTakesClosure() {
    // trailing closure's body goes here
}













