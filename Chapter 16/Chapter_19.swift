/*
 Chapter 19
 Mobile App Architectures and Design Patterns
 */


import UIKit

// Property pattern
protocol Fruit {
    func set(price: String?)
    func clone() -> Fruit
}
 
class Orange: Fruit {
    var count: Int
    var price: String?
    
    init(count: Int) {
        self.count = count
    }
    
    func set(price: String?) {
        self.price = price
    }
    
    // function definition for cloning the object
    func clone() -> Fruit {
        return Orange(count: self.count)
    }
}
 
let prototype = Orange(count: 6)
let redOrange: Orange = prototype.clone() as! Orange
print(redOrange.count) // 6
redOrange.set(price: "$4")
print(redOrange.price!) // $4


// Factory Pattern
protocol Fruit1 {
    func getPrice() -> String
    func getCount() -> Int
}

 
class Banana: Fruit1 {
    func getPrice() -> String {return "$2"}
    func getCount() -> Int {return 5}
}
 
class Grapes: Fruit1 {
    func getPrice() -> String {return "$3.5"}
    func getCount() -> Int {return 1}
}
// Enum of Fruit Type
enum FruitType {
    case orange, banana, grapes
}

// A factory class with static method
class FruitFactory {
    // Return object of class that implements Fruit protocol
    static func getFruit(forType type: FruitType) -> Fruit1? {
        switch type {
        case .banana:
            return Banana()
        case .grapes:
            return Grapes()
        }
    }
}

let banana = FruitFactory.getFruit(forType: .banana)
banana?.getPrice() // "$5
banana?.getCount() // 2

// Abstract factory Pattern
protocol ApplianceFactory {
    static func createTable() -> Table
    static func createChair() -> Chair
}
protocol Table {
    func count() -> Int
}
 
protocol Chair {
    func count() -> Int
}
class Factory: ApplianceFactory {
    static func createChair() -> Chair {return MyChair()}
    static func createTable() -> Table {return MyTable()}
}
private class MyChair: Chair {
    func count() -> Int {return 4}
}
private class MyTable: Table {
    func count() -> Int {return 1}
}
let chair = Factory.createChair()
chair.count() // 4

// Builder Pattern
protocol ShoeShop {
    func produceShoe()
}
// class that conforms to Shoe Shop protocol
class Nike: ShoeShop {
    func produceShoe() {
        print("Shoe Produce")
    }
}
class Director {
    let shoeShop: ShoeShop
    
    init(shoeShop: ShoeShop) {
        self.shoeShop = shoeShop
    }
    func produce() {
        shoeShop.produceShoe()
    }
}
let nike = Nike()
let director = Director(shoeShop: nike)
print(director.produce())


// Singlton Pattern
class Automobile {
    static let sharedInstance = Automobile()
    // private initialization
    private init() {}
    
    func getName() -> String {
        return "Car"
    }
    func getModel() -> String {
        return "Honda Amaze"
    }
}

// Facade Design
import XCTest
class Facade {
    
    private var subsystem1: Subsystem1
    private var subsystem2: Subsystem2
    
    init(subsystem1: Subsystem1 = Subsystem1(),
         subsystem2: Subsystem2 = Subsystem2()) {
        self.subsystem1 = subsystem1
        self.subsystem2 = subsystem2
    }
    
    func operation() -> String {
        
        var result = "Facade - Sub Systems:"
        result += " " + subsystem1.operation1()
        result += " " + subsystem2.operation1()
        result += "\n" + "Facade orders Sub Systems to perform the Action:\n"
        result += " " + subsystem1.operationN()
        result += " " + subsystem2.operationZ()
        return result
    }
}
class Subsystem1 {
    func operation1() -> String {
        return "Subsystem ONE: Ready!\n"
    }
    func operationN() -> String {
        return "Subsystem ONE: Go!\n"
    }
}
class Subsystem2 {
    func operation1() -> String {
        return "Subsystem TWO: Get ready!\n"
    }
    func operationZ() -> String {
        return "Subsystem TWO: Fire!\n"
    }
}
 
class Client {
    static func clientCode(facade: Facade) {
        print(facade.operation())
    }
}


// Let's see how it all works together -
class FacadeConceptual: XCTestCase {
    func testFacadeConceptual() {
        
        let subsystem1 = Subsystem1()
        let subsystem2 = Subsystem2()
        let facade = Facade(subsystem1: subsystem1, subsystem2: subsystem2)
        Client.clientCode(facade: facade)
    }
}

let concept = FacadeConceptual()
concept.testFacadeConceptual()


// Adapter
import Foundation
import EventKit
 
// Event protocol
protocol Event {
    var title: String { get }
    var startDate: String { get }
    var endDate: String { get }
}
 
// Adapter Wrapper Class
class EventAdapter {
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd. HH:mm"
        return dateFormatter
    }()
    private var event: EKEvent
    
    init(event: EKEvent) {
        self.event = event
    }
}
 
// Adapter Implementation
extension EventAdapter: Event {
    var title: String {
        return self.event.title
    }
    var startDate: String {
        return self.dateFormatter.string(from: event.startDate)
    }
    var endDate: String {
        return self.dateFormatter.string(from: event.endDate)
    }
}


// Test Adapter Implementation
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
 
let calendarEvent = EKEvent(eventStore: EKEventStore())
calendarEvent.title = "iOS Class Deadline"
calendarEvent.startDate = dateFormatter.date(from: "09/30/2021 10:00")
calendarEvent.endDate = dateFormatter.date(from: "09/30/2021 11:00")
 
// Use Adapter class as an Event protocol
let adapter = EventAdapter(event: calendarEvent)
adapter.title
adapter.startDate
adapter.endDate


// Bridge
protocol Switch {
    var appliance: Appliance { get set }
    func turnOn()
}
 
protocol Appliance {
    func run()
}
 
final class RemoteControl: Switch {
    var appliance: Appliance
    
    func turnOn() {
        self.appliance.run()
    }
    
    init(appliance: Appliance) {
        self.appliance = appliance
    }
}
 
final class TV: Appliance {
    func run() {
        print("Television Turned ON");
    }
}
 
final class VacuumCleaner: Appliance {
    func run() {
        print("Vacuum Cleaner Turned ON")
    }
}
 
let tvRemoteControl = RemoteControl(appliance: TV())
tvRemoteControl.turnOn()
 
let remoteControlVC = RemoteControl(appliance: VacuumCleaner())
remoteControlVC.turnOn()


// Decorator
protocol Transporting {
    func getSpeed() -> Double
    func getTraction() -> Double
}
 
final class RaceCar: Transporting {
    private let speed = 10.0
    private let traction = 10.0
    
    func getSpeed() -> Double {return speed}
    func getTraction() -> Double {return traction}
}
 
let raceCar = RaceCar()
let defaultSpeed = raceCar.getSpeed()
let defaultTraction = raceCar.getTraction()
 
class TireDecorator: Transporting {
    private let transportable: Transporting
    init(transportable: Transporting) {
        self.transportable = transportable
    }
    func getSpeed() -> Double {
        return transportable.getSpeed()
    }
    
    func getTraction() -> Double {
        return transportable.getTraction()
    }
}
 
class OffRoadTireDecorator: Transporting {
    private let transportable: Transporting
    
    init(transportable: Transporting) {
        self.transportable = transportable
    }
    
    func getSpeed() -> Double {
        return transportable.getSpeed() - 3.0
    }
    
    func getTraction() -> Double {
        return transportable.getTraction() + 3.0
    }
}
 
class ChainedTireDecorator: Transporting {
    private let transportable: Transporting
    
    init(transportable: Transporting) {
        self.transportable = transportable
    }
    
    func getSpeed() -> Double {
        return transportable.getSpeed() - 1.0
    }
    
    func getTraction() -> Double {
        return transportable.getTraction() * 1.1
    }
}
 
// Create Race Car
let defaultRaceCar = RaceCar()
defaultRaceCar.getSpeed() // 10
defaultRaceCar.getTraction() // 10
 
// Modify Race Car
let offRoadRaceCar = OffRoadTireDecorator(transportable: defaultRaceCar)
offRoadRaceCar.getSpeed() // 7
offRoadRaceCar.getTraction() // 13


// Template Pattern
protocol Office {
    func officeSchedule()
}
protocol Employee {
    func work()
    func getPaid()
}
class MyOffice: Office {
    var delegate: Employee
    
    init(employee: Employee) {
        self.delegate = employee
    }
    func officeSchedule() {
        delegate.work()
        delegate.getPaid()
    }
}
class Developer: Employee {
    
    func work() {
        print("Developer has worked 60 hours per week this month")
    }
    func getPaid() {
        print("Developer has earned Rs 80,000 this month")
    }
}
 
class ProjectManager: Employee {
    func work() {
        print("Project Manager has worked 55 hours per week this month")
    }
    func getPaid(){
        print("Project Manager has earned Rs 100,000 this month")
    }
}
 
let xyzOfficeDev = MyOffice(employee: Developer())
let xyzOfficeManager = MyOffice(employee: ProjectManager())
xyzOfficeDev.officeSchedule()
xyzOfficeManager.officeSchedule()


// State Pattern
protocol Human {
    func getState() -> ManState
    func set(state: ManState)
}
 
protocol ManState {
    func stand()
    func walk()
    func toString() -> String
}
 
extension ManState {
    func stand() {}
    func walk() {}
}
 
class Man: Human {
    var state: ManState?
    init() {state = nil}
    func set(state: ManState) {
        self.state = state
    }
    func getState() -> ManState {
        return state!
    }
}
 
class StandingState: ManState {
    var human: Human
    init(_ human: Human) {
        self.human = human
    }
    func stand() {
        print("The Man State is - Standing Position")
        human.set(state: self)
    }
    
    func toString() -> String {
        return "Standing State"
    }
}
 
class WalkingState: ManState {
    
    var human: Human
    init(_ human: Human) {
        self.human = human
    }
    func walk() {
        print("The Man State is - Walking Position")
        human.set(state: self)
    }
    func toString() -> String {
        return "Walking State"
    }
}
 
let man = Man()
let standingState = StandingState(man)
standingState.stand()
print(man.getState().toString())
 
let walkingState = WalkingState(man)
walkingState.walk()
print(man.getState().toString())


// Observer Pattern
protocol Observable {
    func add(customer: Observer)
    func remove(customer : Observer)
    func notify()
}

protocol Observer {
    var id: Int { get set }
    func update()
}

class  OrangeSeller: Observable {
    private var observers: [Observer] = []
    private var count: Int = 0
    var fruitCount: Int {
        set {
            count = newValue
            notify()
        }
        get {return count}
    }
    func add(customer: Observer) {
        observers.append(customer)
    }
    func remove(customer : Observer) {
        observers = observers.filter{ $0.id != customer.id }
    }
    func notify() {
        for observer in observers {
            observer.update()
        }
    }
}

class Customer: Observer {
    var id: Int
    var observable:  OrangeSeller
    var name: String
    init(name: String, observable:  OrangeSeller, customerId: Int) {
        self.name = name
        self.observable = observable
        self.id = customerId
        self.observable.add(customer: self)
    }
    func update() {
        print("Wait, \(name)! \(observable.fruitCount) Oranges arrived at shop.")
    }
}

let seller = OrangeSeller()
let james = Customer(name: "James", observable: seller, customerId: 101)
let david = Customer(name: "David", observable: seller, customerId: 102)
seller.fruitCount = 10
seller.remove(customer: james)
seller.fruitCount = 20

// Mediator Pattern
protocol Receiver {
    var name: String { get }
    func receive(message: String)
}
protocol Sender {
    var teams: [Receiver] { get set }
    func send(message: String, sender: Receiver)
}
 
class Mediator: Sender {
    var teams: [Receiver] = []
    
    func register(candidate: Receiver) {
        teams.append(candidate)
    }
    
    func send(message: String, sender: Receiver) {
        for team in teams {
            if team.name != sender.name {
                team.receive(message: message)
            }
        }
    }
}
struct TeamA: Receiver {
    var name: String
    init(name: String) {
        self.name = name
    }
    func receive(message: String) {
        print("\(name) Received: \(message)")
    }
}
 
struct TeamB: Receiver {
    var name: String
    init(name: String) {
        self.name = name
    }
    func receive(message: String) {
        print("\(name) Received: \(message)")
    }
}
 
let mediator = Mediator()
let teamA = TeamA(name: "The Roadies")
let teamB = TeamB(name: "The League of Extraordinary Gentlemen")
mediator.register(candidate: teamA)
mediator.register(candidate: teamB)
mediator.send(message: "Selected for final! from \(teamA.name)", sender: teamA)
mediator.send(message: "Not selected for final! from \(teamB.name)", sender: teamB)


// Iterator Pattern
struct GreatFilms: Sequence {
    let films: [String]
    
    func makeIterator() -> GreatFilmsIterator {
        return GreatFilmsIterator(films)
    }
}
 
struct GreatFilmsIterator: IteratorProtocol {
    
    var films: [String]
    var cursor: Int = 0
    
    init(_ films: [String]) {
        self.films = films
    }
    
    mutating func next() -> String? {
        defer { cursor += 1 }
        return films.count > cursor ? films[cursor] : nil
    }
}
 
let myFilms = GreatFilms(films: ["3 Idiots", "The Great Gatsby", "Godfather Trilogy"])
for film in myFilms {
    print(film)
}

// ReSwift
import ReSwift // If Gives error Install ReSwift Library
 
let mainStore = Store<AppState>(
    reducer: counterReducer,
    state: nil
)
 
func counterReducer(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()
    
    switch action {
    case _ as CounterActionIncrease:
        state.counter += 1
    case _ as CounterActionDecrease:
        state.counter -= 1
    default:
        break
    }
    
    return state
}
 
struct AppState: StateType {
    var counter: Int = 0
}

struct CounterActionIncrease: Action {}
struct CounterActionDecrease: Action {}
 
class ViewController: UIViewController, StoreSubscriber {
    typealias StoreSubscriberStateType = AppState
 
    
    @IBOutlet weak var counterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainStore.subscribe(self)
    }
    
    func newState(state: AppState) {
        counterLabel.text = "\(mainStore.state.counter)"
    }
    
    @IBAction func downTouch(_ sender: AnyObject) {
        mainStore.dispatch(CounterActionDecrease());
    }
    @IBAction func upTouch(_ sender: AnyObject) {
        mainStore.dispatch(CounterActionIncrease());
    }
}

