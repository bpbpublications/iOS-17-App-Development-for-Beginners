/*
 Chapter - 17
 Multithreading in iOS
 */

/* Dispatch Queue */
import Dispatch

DispatchQueue.main.async {
    label.text = "Access to main Queue"
}

import Dispatch
let globalQueue = DispatchQueue.global()
globalQueue.async {
    // Resize image
    let newImage = resizeImage(image: originalImage, newSize: CGSize(width: 300, height: 300))
    // Perform other processing tasks
}


let globalQueue = DispatchQueue.global()
globalQueue.async {
    // Make network request
    let data = fetchData(url: "https://example.com/api")
    
    // Perform other processing tasks
}

/* Custom Queue */

let myQueue = DispatchQueue(label: "myQueue")
myQueue.async {
    // Perform task here
}

/* QOS - Quality Of Services */

let queue = DispatchQueue(label: "com.example.app.background", qos: .background)
queue.async {
    // Perform background task
}

/* Dispatch Group */
let group = DispatchGroup()
// Start first request
group.enter()
API.getFirstEndpoint { result in
    // Handle first request result
    group.leave()
}
// Start second request
group.enter()
API.getSecondEndpoint { result in
    // Handle second request result
    group.leave()
}
// Start third request
group.enter()
API.getThirdEndpoint { result in
    // Handle third request result
    group.leave()
}
// Wait for all requests to complete
group.notify(queue: .main) {
    // Update user interface with results from all requests
}

/* Dispatch Work Item */
let workItem = DispatchWorkItem {
    // Perform some background task here
}
let queue = DispatchQueue.global(qos: .background)
queue.async(execute: workItem)

/* Run Loop SHeduling */
class ViewController: UIViewController {
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
    }
    
    @objc func updateTimeLabel() {
        timeLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .medium)
    }
}

class MyThread: Thread {
    override func main() {
        let runLoop = RunLoop.current
        runLoop.add(Port(), forMode: .default)
        runLoop.run()
    }
}

let thread = MyThread()
thread.start()

/* Thread Class */
let newThread = Thread {
    // Perform task on new thread
    print("Task running on new thread")
}
// Start the thread
newThread.start()

newThread.join()
print("Thread has completed")

/* Multithreading with Opeartions */
class CustomOperation: NSOperation {
    var name: String
    init(name: String) {
        self.name = name
    }
    override func main() {
        print("Starting operation: \(name)")
        for i in 0...10 {
            print("\(name) - iteration: \(i)")
            sleep(1)
        }
        print("Finished operation: \(name)")
    }
}

let operationQueue = NSOperationQueue()
let operation1 = CustomOperation(name: "Operation 1")
let operation2 = CustomOperation(name: "Operation 2")
operationQueue.addOperation(operation1)
operationQueue.addOperation(operation2)

operationQueue.start()


/* BlockOpeartion */
let operation1 = BlockOperation {
    print("Operation 1 started")
    sleep(3)
    print("Operation 1 finished")
}

let operation2 = BlockOperation {
    print("Operation 2 started")
    sleep(2)
    print("Operation 2 finished")
}

