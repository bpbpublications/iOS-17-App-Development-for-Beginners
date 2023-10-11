/*
 Chapter - 16
 Machine Learning with Core ML
 */

import UIKit
import CoreML
import Vision
import NaturalLanguage
import Speech
import AVFoundation
import SoundAnalysis


// Create Vision Request
let image = UIImage().cgImage // Give image which you want to put here for vision request
let orientation: CGImagePropertyOrientation = .down
let imageRequestHandler = VNImageRequestHandler(cgImage: image!,
                                                        orientation: orientation,
                                                        options: [:])

var rectangleDetectionRequest: VNDetectRectanglesRequest = {
            let rectDetectRequest = VNDetectRectanglesRequest()
            rectDetectRequest.maximumObservations = 8
            rectDetectRequest.minimumConfidence = 0.6
            rectDetectRequest.minimumAspectRatio = 0.3
            return rectDetectRequest
        }()


DispatchQueue.global(qos: .userInitiated).async {
    do {
        try imageRequestHandler.perform([rectangleDetectionRequest])
    } catch let error as NSError {
        print("Failed to perform image request: \(error)")
        //self.presentAlert("Image Request Failed", error: error)
        return
    }
}

let recognizer = NLLanguageRecognizer()
recognizer.processString("We are processing Language Recognizer")

// Dominant language Identification.
    if let language = recognizer.dominantLanguage {
        print(language.rawValue)
    } else {
        print("Language not recognized")
    }

// Two language hypothesis generation.
    let hypotheses = recognizer.languageHypotheses(withMaximum: 2)
    print(hypotheses)

let maintext = """
    Discrimination means being treated less favourably than others; traditionally, for reasons related to factors that you could not change, such as your colour, race, nationality, ethnicity or sex.
    """
 
    let tokenizer = NLTokenizer(unit: .word)
    tokenizer.string = maintext
 
    tokenizer.enumerateTokens(in: maintext.startIndex..<text.endIndex) { tokenRange, _ in
        print(text[tokenRange])
        return true
    }


// Parts of Speech tagging
let Speechtext = "This is a sample text to test NSTagger"
    let speechTagger = NLTagger(tagSchemes: [.lexicalClass])
speechTagger.string = Speechtext
    let speechOptions: NLTagger.Options = [.omitPunctuation, .omitWhitespace]
speechTagger.enumerateTags(in: Speechtext.startIndex..<text.endIndex, unit: .word, scheme: .lexicalClass, options: speechOptions) { tag, tokenRange in
        if let tag = tag {
            print("\(text[tokenRange]): \(tag.rawValue)")
        }
        return true
    }


// Named Entity Recognition
let text = "The American Red Cross was established in Washington, D.C., by Clara Barton."
 
    let tagger = NLTagger(tagSchemes: [.nameType])
    tagger.string = text
 
    let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
    let tags: [NLTag] = [.personalName, .placeName, .organizationName]
 
    tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .nameType, options: options) { tag, tokenRange in
        if let tag = tag, tags.contains(tag) {
            print("\(text[tokenRange]): \(tag.rawValue)")
        }
        let (hypotheses, _) = tagger.tagHypotheses(at: tokenRange.lowerBound, unit: .word, scheme: .nameType, maximumCount: 1)
        print(hypotheses)
            
       return true
    }


// Speech framework
class SpeechViewController: UIViewController, SFSpeechRecognizerDelegate
{
    var speechRecognizer: SFSpeechRecognizer!
    @IBOutlet var recordAction: UIButton!
    
    
    override public func viewDidAppear(_ animated: Bool) {
           speechRecognizer.delegate = self
     
           SFSpeechRecognizer.requestAuthorization { authStatus in
     
          OperationQueue.main.addOperation {
                 switch authStatus {
                    case .authorized:
                       self.recordAction.isEnabled = true
     
                    case .denied:
                       self.recordAction.isEnabled = false
                       self.recordAction.setTitle("User Access Denied to speech recognition", for: .disabled)
     
                    case .restricted:
                       self.recordAction.isEnabled = false
                       self.recordAction.setTitle("Speech Recognition restricted on this device", for: .disabled)
     
                    case .notDetermined:
                       self.recordAction.isEnabled = false
                       self.recordAction.setTitle("Speech recognition not yet authorized", for: .disabled)
                 }
              }
           }
        }

}

// Sound Ananlysis
let defaultConfig = MLModelConfiguration()
let soundClassifier = SoundClassifier(configuration: defaultConfig)
let request = try SNClassifySoundRequest(mlModel: soundClassifier.model)

let resultsObserver = ResultsObserver()
    class ResultsObserver: NSObject, SNResultsObserving {
        
        func request(_ request: SNRequest, didProduce result: SNResult) {
            
            guard let result = result as? SNClassificationResult else  { return }
            guard let classification = result.classifications.first else { return}
            let timeInSeconds = result.timeRange.start.seconds
            let formattedTime = String(format: "%.2f", timeInSeconds)
            print("Result Analysis  for audio at time: \(formattedTime)")
            let percent = classification.confidence * 100.0
            let percentString = String(format: "%.2f%%", percent)
            print("\(classification.identifier): \(percentString) confidence.\n")
        }
        
        func request(_ request: SNRequest, didFailWithError error: Error) {
            print("The the analysis failed: \(error.localizedDescription)")
        }
        
        func requestDidComplete(_ request: SNRequest) {
            print("The request completed successfully!")
        }
    }

