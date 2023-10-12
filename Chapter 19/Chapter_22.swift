/*
 Chapter - 22
 Advance iOS with New Frameworks
 */

/*
  To Run Below code you might need to update your Xcode to Version 15 or 15+
 */

import RealityKit
class MyARExperience: ARExperience {
    override func didInitialize() {
        // Create a scene
        let scene = Scene()
        // Create an entity
        let entity = ModelEntity(mesh: .box(width: 0.1, height: 0.1, depth: 0.1))
        entity.position = .init(x: 0, y: 0, z: -0.5)
        // Add the entity to the scene
        scene.add(entity)
        // Set the scene as the root node of the experience
        self.root = scene
    }
}


import UIKit
import RealityKit
class ViewController: UIViewController {
    @IBOutlet var arView: ARView!
    var virtualObject: Entity?
    override func viewDidLoad() {
        super.viewDidLoad()
        let placeObjectButton = UIButton(type: .system)
        placeObjectButton.setTitle("Place Object", for: .normal)
        placeObjectButton.addTarget(self, action: #selector(placeVirtualObject), for: .touchUpInside)
        placeObjectButton.frame = CGRect(x: 20, y: 20, width: 120, height: 40)
        view.addSubview(placeObjectButton)
    }
    @objc func placeVirtualObject() {
        // Code to place virtual object in the AR scene
        // Create or load the virtual object entity
    }
}


@objc func placeVirtualObject() {
    let modelEntity = try! Entity.loadModel(named: "VirtualObject.usdz")
    modelEntity.setPosition([0, 0, -1], relativeTo: arView.cameraTransform)
    arView.scene.addAnchor(modelEntity)
}

/* Vision Kit */
import UIKit
import VisionKit
class ViewController: UIViewController, VNDocumentCameraViewControllerDelegate {
    
    func scanDocument() {
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        present(documentCameraViewController, animated: true, completion: nil)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        for pageIndex in 0..<scan.pageCount {
            let image = scan.imageOfPage(at: pageIndex)
            // Perform desired processing on the scanned image
            // Save or export the scanned image as needed
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

/* Handle Scan Dcouments */
extension ViewController: VNDocumentCameraViewControllerDelegate
{
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        for pageIndex in 0..<scan.pageCount {
            let image = scan.imageOfPage(at: pageIndex)
            // Perform desired processing on the scanned image
            // Save or export the scanned image as needed
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

/* Activity Kit */
import ActivityKit
class WorkoutActivity: Activity {
    var distance: Double = 0
    var time: TimeInterval = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Customize the UI elements for the workout tracking activity
        // e.g., Add labels, buttons, and text fields
    }
    override func completeActivity() {
        super.completeActivity()
        // Perform any necessary actions when the workout activity is completed
        // e.g., Save the workout data to a database
    }
}

let activityManager = ActivityManager()
let workoutActivity = WorkoutActivity()
activityManager.pushActivity(workoutActivity)

let activityView = ActivityView(frame: view.bounds)
activityView.activityManager = activityManager
view.addSubview(activityView)

/* SF Symbol */

import SwiftUI
struct ContentView: View {
  var body: some View {
    VStack {
      Text("SF Symbols")
        .font(.largeTitle)
      Image(systemSymbol: "heart.fill")
        .foregroundColor(.red)
      Image(systemSymbol: "gear")
        .foregroundColor(.blue)
    }
  }
}

// Add an effect in SwiftUI.
Image(systemName: “globe”)
    // Add effect with discrete image view.
    .symbolEffect(.pulse, options: .repeat(5))
Image(systemName: “globe”)
    // Add effect with indefinite image view.
    .symbolEffect(.pulse)


// Add an effect in SwiftUI.
Image(systemName: "wifi").symbolEffect(.variableColor.reversing)




