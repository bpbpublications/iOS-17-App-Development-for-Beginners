/*
 Chapter - 11
 Storing Data in Sqlite and Core Data
 */

import UIKit
import CoreData

func getPropertyList(withName name: String) -> [String]?
{
    if  let path = Bundle.main.path(forResource: name, ofType: "plist"),
        let xml = FileManager.default.contents(atPath: path)
    {
        return (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [String]
    }
    
    return nil
}

if let states = getPropertyList(withName: "States") {
    print(states)
}


import Foundation
import SQLite3

class DBManager
{
    
    init()
        {
            db = openDatabase()
            createTable()
        }
     
        let dbPath: String = "DB.sqlite"
        var db:OpaquePointer?
    
    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    func createTable()
    {
        let createTableString = "CREATE TABLE IF NOT EXISTS person(Id INTEGER PRIMARY KEY, name TEXT, age INTEGER);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("person table created.")
            } else {
                print("person table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insert(id:Int, name:String, age:Int)
        {
             let insertStatementString = "INSERT INTO person (Id, name, age) VALUES (?, ?, ?);"
            var insertStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                sqlite3_bind_int(insertStatement, 1, Int32(id))
                sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
                sqlite3_bind_int(insertStatement, 3, Int32(age))
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("Successfully inserted row.")
                } else {
                    print("Could not insert row.")
                }
            } else {
                print("INSERT statement could not be prepared.")
            }
            sqlite3_finalize(insertStatement)
        }

    func read() -> [Person] {
            let queryStatementString = "SELECT * FROM person;"
            var queryStatement: OpaquePointer? = nil
            var psns : [Person] = []
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    let id = sqlite3_column_int(queryStatement, 0)
                    let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                    let year = sqlite3_column_int(queryStatement, 2)
                    psns.append(Person(id: Int(id), name: name, age: Int(year)))
                    print("Query Result:")
                    print("\(id) | \(name) | \(year)")
                }
            } else {
                print("SELECT statement could not be prepared")
            }
            sqlite3_finalize(queryStatement)
            return psns
        }

    
    func deleteByID(id:Int)
    {
            let deleteStatementStirng = "DELETE FROM person WHERE Id = ?;"
            var deleteStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
                sqlite3_bind_int(deleteStatement, 1, Int32(id))
                if sqlite3_step(deleteStatement) == SQLITE_DONE {
                    print("Successfully deleted row.")
                } else {
                    print("Could not delete row.")
                }
            } else {
                print("DELETE statement could not be prepared")
            }
            sqlite3_finalize(deleteStatement)
     }
    
    func insertData(){
            
           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }  // If this gives error import AppDelegate
           let managedContext = appDelegate.persistentContainer.viewContext
           let personEntity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
            
            for i in 1...5 {
                
                let person = NSManagedObject(entity: personEntity, insertInto: managedContext)
                person.setValue(i, forKeyPath: "id")
                person.setValue("Mike \(i)", forKey: "name")
                person.setValue(20 + i, forKey: "age")
            }
            do {
                try managedContext.save()
               
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }


    
    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "CoreDataSample")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
     
     
        func saveContext () {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }

    func retrieveData()
         {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }  // If this gives error import AppDelegate
                let managedContext = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
                do {
                    let result = try managedContext.fetch(fetchRequest)
                    for data in result as! [NSManagedObject] {
                        print(data.value(forKey: "name") as! String)
                    }
                    
                } catch {
                    
                    print("Failed")
                }
         }

    func deleteData()
        {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }  // If this gives error import AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
            fetchRequest.predicate = NSPredicate(format: "name = %@", "Mike 3")
            do
            {
                let test = try managedContext.fetch(fetchRequest)
                let objectToDelete = test[0] as! NSManagedObject
                managedContext.delete(objectToDelete)
                do{
                    try managedContext.save()
                }
                catch
                {
                    print(error)
                }
            }
            catch
            {
                print(error)
            }
        }

    
    
    
}

class Person
{
    
    var name: String = ""
    var age: Int = 0
    var id: Int = 0
    
    init(id:Int, name:String, age:Int)
    {
        self.id = id
        self.name = name
        self.age = age
    }
    
}


/* Swift Data - This Code Only Work with Xcode 15 version */

import SwiftData


@Model
class HolidayPlan
{
    var name: String
    var tripDestination: String
    var endDate: Date
    var startDate: Date
}

/* Model Container */
let container = try ModelContainer(
    for: [HolidayPlan.self],
    configurations: ModelConfiguration(url: URL("path"))
)

struct ContextView : View {
    @Environment(\.modelContext) private var context
}

/* Predict with SwiftData */
let day = Date()
let holidayPredicate = Predicate<HolidayPlan> {
    $0.destination == "My City" &&
        $0.name.contains("Mariage") &&
        $0.startDate > day
}





