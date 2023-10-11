/*
 Chapter - 04
 Protocols, Extensions and Error handling
 */

import UIKit
import Foundation
import AVKit
import CoreGraphics

// Optional Chaining
class Letter {
        var address: Address?
}

class Address {
    var houseNumber = 201
}

// Error handling
enum CoffeeMachineError: Error {
    case invalidSelection
    case insufficientWater(waterNeedediInml: Int)
    case outOfStock
}

throw CoffeeMachineError.insufficientWater(waterNeedediInml: 5)

func canThrowErrors() throws -> String {
    return "can Throw Errors"
}
func cannotThrowErrors() -> String {
    return "can not Throw Errors"
}

// Type Casting
class Media {
    var name: String
    init(name: String) {
        self.name = name
    }
}

class Movie: Media {
    var director: String
    init(name: String, director: String) {
        self.director = director
        super.init(name: name)
    }
}
class Song: Media {
    var artist: String
    init(name: String, artist: String) {
        self.artist = artist
        super.init(name: name)
    }
}

// Initializers
struct Size {
    var width = 0.0, height = 0.0
}
struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
}

extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}

// Methods
extension Int {
    func Repeat(task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
}

4.Repeat {
    print("Hello World !")
}

// Protocol
protocol ToggleProtocol {
    mutating func toggle()
}

enum OnOffSwitch: ToggleProtocol {
    case off, on
    mutating func toggle() {
        switch self {
        case .off:
            self = .on
        case .on:
            self = .off
        }
    }
}
var lightSwitch = OnOffSwitch.off
lightSwitch.toggle()

// Delegations
protocol ImageImporterDelegate: AnyObject {
    func imageImporter(_ importer: ImageImporter,
                      shouldImportImage image: UIImage) -> Bool

    func imageImporter(_ importer: ImageImporter,
                      didAbortWithError error: Error)

    func imageImporterDidFinish(_ importer: ImageImporter)
}

class ImageImporter {
    weak var delegate: ImageImporterDelegate?
    private func processFileIfNeeded(_ file: UIImage) {
        guard let delegate = delegate else {
            return
        }

        let shouldImport = delegate.imageImporter(self, shouldImportImage: file)
        guard shouldImport else {
            return
        }
        processFileIfNeeded(file)
    }
}

// Genric
func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temporaryA = a
    a = b
    b = temporaryA
}











