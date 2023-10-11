/*
 Chapter - 10
 Concurrency in Swift and SwiftUI
 */

/* Concurrency in iOS */

func listContacts(fromContact name: String) async -> [String] {
    let contactResult = // ... some code asynchronous with networking ...
    return contactResult
}


listContacts(fromContact: "Contact Book") { contactNames in
    let sortedNames = contactNames.sorted()
    let name = sortedNames[0]
    downloadContactInfo(named: name) { contactPhoto in
        show(contactPhoto)
    }
}

let contactNames = await listContacts(fromContact: "Contact Book")
let sortedNames = contactNames.sorted()
let name = sortedNames[0]
let contact = await downloadContactCard(named: name)
show(contact)

/* Asynchronous */
import Foundation

let taketask = FileHandle.standardInput
for try await line in taketask.bytes.lines {
    print(line)
}

let firstContact = await downloadContactCard(named: contactNames[0])
let secondContact = await downloadContactCard(named: contactNames[1])
let thirdContact = await downloadContactCard(named: contactNames[2])

let contacts = [firstContact, secondContact, thirdContact]
show(contacts)

async let first1Contact = downloadContactCard(named: photoNames[0])
async let second1Contact = downloadContactCard(named: photoNames[1])
async let third1Contact = downloadContactCard(named: photoNames[2])

let contacts = await [first1Contact, second1Contact, third1Contact]
show(contacts)

/* Task and Task Group */
await includeTaskGroup(of: Data.self) { taskG in
    let pNames = await getListOfPhotos(inGallery: "Winter Holiday")
    for name in pNames {
        taskG.addTask { await downloadPhoto(named: name) }
    }
}

let newContact = // ... new contact data ...
let handle = Task {
    return await add(newContact, toContactBookNamed: "Office Group")
}
let result = await handle.value

actor TempeLogger {
    let textLabel: String
    var measure: [Int]
    private(set) var maxValue: Int
    
    init(textLabel: String, measurement: Int) {
        self.textLabel = textLabel
        self.measure = [measure]
        self.maxValue = measurement
    }
}

extension TempeLogger
{
    func updateTemperature(with measurement: Int) {
        measurements.append(measurement)
        if measurement > maxValue {
            maxValue = measurement
        }
    }
}

/* Sendables Type */
struct TempMeasuring: Sendable {
    var measurement: Int
}
extension TempLogger {
    func addReading(from reading: TempMeasuring) {
        measurements.append(reading.measurement)
    }
}
let log = TempLogger(label: "Water Bottle", measurement: 75)
let read = TempLogger(measure: 35)
await log.addReading(from: read)

Because TempMeasuring is a structure with only sendable attributes and is not marked as public or @usableFromInline, it is automatically sendable. Here is a variant of the structure where sendable protocol adherence is assumed:

struct TempMeasuring {
    var measurement: Int
}


/* Concurrency in SwiftUI */
import SwiftUI

class MyObject: ObservableObject {
    @Published var value = 0
}
struct MyView: View {
    @ObservedObject var myObject: MyObject
    var body: some View {
        Text("Value: \(myObject.value)")
    }
}

import SwiftUI
struct MainActor: View {
    @State private var name = "John Doe"
    @State private var age = 25
    var body: some View {
        VStack {
            Text("Name: \(name)")
            Text("Age: \(age)")
            
            Button(action: {
                self.name = "Jane Smith"
                self.age = 30
            }) {
                Text("Change Actor")
            }
        }
    }
}

struct ContentView: View {
    @mainactor var actor: MainActor
    
    var body: some View {
        actor
    }
}
