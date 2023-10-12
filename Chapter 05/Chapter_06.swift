/*
 Chapter - 06
 Automatic Reference Counting with Memory Safety
 */


/* ARC */
class Student {
    let name: String
    init(name: String) {
        self.name = name
        print("\(name) is initialised")
    }
    deinit {
        print("\(name) is deinitialised")
    }
}

var ref1: Student?
var ref2: Student?
var ref3: Student?
var ref4: Student?

ref1 = Student(name: "David Warner")

ref2 = ref1
ref3 = ref1
ref4 = ref1

ref1 = nil
ref2 = nil
ref3 = nil

/* Strong Reference Cycle */
class Student {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Department?
    deinit { print("\(name) is deinitialized") }
}

class Scholarship {
    let amount: Int32
    init(amount: String) { self.amount = amount }
    var awardedTo: Student?
    deinit { print("Scholarship \(amount) is deinitialized") }
}

class Customer {
    let name: String
    var card: CreditCard?
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
}

class CreditCard {
    let number: String
    weak var customer: Customer?
    
    init(number: String, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    
    deinit {
        print("Card #\(number) is being deinitialized")
    }
}

// Create a customer and credit card
var john: Customer? = Customer(name: "John")
var johnsCard: CreditCard? = CreditCard(number: "1234-5678-9101-1121", customer: john!)

// Assign the credit card to the customer
john?.card = johnsCard

// Destroy the original references to the objects
john = nil
johnsCard = nil

/* Unowned Optional */
class CreditCard {
    let number: String
    unowned let customer: Customer
    
    init(number: String, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    
    deinit {
        print("Card #\(number) is being deinitialized")
    }
}

// Create a customer and credit card
var peter: Customer? = Customer(name: "Peter")
var peterCard: CreditCard? = CreditCard(number: "1234-5678-9101-1121", customer: peter!)

// Assign the credit card to the customer
peter?.card = peterCard

// Destroy the original references to the objects
peter = nil
peterCard = nil

/* Strong Reference - Closure */
class MyClass {
    var closure: (() -> Void)?
    init() {
        closure = {
            guard let strongRef = self else { return }
            // Use strongRef to do something.
        }
    }
    
    closure = { [weak self] in
        guard let strongRef = self else { return }
        // Do something with strongRef
    }
    
    var value = 10
    
    let incrementer = { [value] in
        value += 1
        print(value)
    }
    
    incrementer() // prints 11
    incrementer() // prints 12
    
    func addOneNumber(than num: Int) -> Int {
        return number + 1
    }
    
    var numone = 1
    myOne = addOneNumber(than: numone)
    print(myOne)
    // Prints "2”
    
    func modifyArray(array: inout [Int]) {
        // Modify the array
        array[0] = 100
        array[1] = 200
        array[2] = 300
        
        DispatchQueue.global(qos: .background).async {
            print(array[0]) // This will cause a conflicting access error
        }
    }
    
    var numbers = [1, 2, 3]
    modifyArray(array: &numbers)
    
    // Output: "fatal error: conflicting accesses to In-Out parameter 'array'"
    
    
    struct Student {
        var name: String
        var health: Int
        var gradeScore: Int
        
        static let maxHealth = 10
        mutating func restoreHealth() {
            health = Student.maxHealth
        }
    }
    
    func balance(_ x: inout Int, _ y: inout Int) {
        let sum = x + y
        x = sum / 2
        y = sum - x
    }
    
    extension Student {
        mutating func shareHealth(with classmate: inout Student) {
            balance(&classmate.health, &health)
        }
    }
    
    var jane = Student(name: "Jane", health: 10, gradeScore: 10)
    var john = Student(name: "John", health: 5, gradeScore: 10)
    jane.shareHealth(with: &john)
    jane.shareHealth(with: &jane) // This will cause a runtime error due to conflicting access to self in the changeName method.
    
    
    /* Properties */
    
    struct Person {
                var name: String
                var age: Int
            }
    var person1 = Person(name: "John", age: 30)
     
    Here it will show a conflicting access error because we are trying to access the age property of person1. while another thread is changing it.


    DispatchQueue.global().async {
                person1.age = 35
            }
    print(person1.age)

