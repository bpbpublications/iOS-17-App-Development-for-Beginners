/*
 Chapter - 13
 App Gesture and Animations in iOS
 */

import UIKit


class viewController: UIViewController
{
    // Tap Gesture
    func tapHandle(_ gestureRecognizer : UITapGestureRecognizer ) {
        guard gestureRecognizer.view != nil else { return }
        
        if gestureRecognizer.state == .ended {
            let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut, animations: {
                gestureRecognizer.view!.center.x += 100
                gestureRecognizer.view!.center.y += 100
            })
            animator.startAnimation()
        }
    }
    
    // Pinch Gesture
    func handlePinch(_ gestureRecognizer : UIPinchGestureRecognizer) {   guard gestureRecognizer.view != nil else { return }
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            gestureRecognizer.view?.transform = (gestureRecognizer.view?.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale))!
            gestureRecognizer.scale = 1.0
        }
    }
    
    // Swipe
    func handleSwipe(_ gestureRecognizer : UISwipeGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            // Perform action.
        }
    }
    
    // Pan Gesture
    var initialCenter = CGPoint()  // The initial center point of the view.
    func handlePan(_ gestureRecognizer : UIPanGestureRecognizer) {
        guard gestureRecognizer.view != nil else {return}
        let piece = gestureRecognizer.view!
        
        let translation = gestureRecognizer.translation(in: piece.superview)
        if gestureRecognizer.state == .began {
            initialCenter = piece.center
        }
        if gestureRecognizer.state != .cancelled {
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            piece.center = newCenter
        }
        else {
            piece.center = initialCenter
        }
    }
    
    // Long Press
    var viewForReset = UIView()
    func showResetMenu(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            self.becomeFirstResponder()
            // Perform action.
        }
    }
}

// Hover Gesture
class ViewController: UIViewController {
    @IBOutlet var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hover = UIHoverGestureRecognizer(target: self, action: #selector(hovering(_:)))
        button.addGestureRecognizer(hover)
    }
    
    @objc
    func hovering(_ recognizer: UIHoverGestureRecognizer) {
        switch recognizer.state {
        case .began, .changed:
            button.titleLabel?.textColor = UIColor.red
        case .ended:
            button.titleLabel?.textColor = UIColor.link
        default:
            break
        }
    }
}

// Implement Custom Gesture
enum CheckmarkPhases {
    case notStarted
    case initialPoint
    case downStroke
    case upStroke
}
class CheckmarkRecognizer : UIGestureRecognizer {
    var strokePhase : CheckmarkPhases = .notStarted
    var initialTouchPoint : CGPoint = CGPoint.zero
    var trackedTouch : UITouch? = nil
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        if touches.count != 1 {
            self.state = .failed
        }
        
        if self.trackedTouch == nil {
            self.trackedTouch = touches.first
            self.strokePhase = .initialPoint
            self.initialTouchPoint = (self.trackedTouch?.location(in: self.view))!
        } else {
            for touch in touches {
                if touch != self.trackedTouch {
                    self.ignore(touch, for: event)
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        let newTouch = touches.first
        guard newTouch == self.trackedTouch else {
            self.state = .failed
            return
        }
        let newPoint = (newTouch?.location(in: self.view))!
        let previousPoint = (newTouch?.previousLocation(in: self.view))!
        if self.strokePhase == .initialPoint {
            if newPoint.x >= initialTouchPoint.x && newPoint.y >= initialTouchPoint.y {
                self.strokePhase = .downStroke
            } else {         self.state = .failed
            }
        } else if self.strokePhase == .downStroke {
            if newPoint.x >= previousPoint.x {
                if newPoint.y < previousPoint.y {
                    self.strokePhase = .upStroke
                }
            } else {
                self.state = .failed
            }
        } else if self.strokePhase == .upStroke {
            if newPoint.x < previousPoint.x || newPoint.y > previousPoint.y {
                self.state = .failed
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
           super.touchesEnded(touches, with: event)
           let newTouch = touches.first
           let newPoint = (newTouch?.location(in: self.view))!
           guard newTouch == self.trackedTouch else {
              self.state = .failed
              return
           }
           if self.state == .possible &&
                 self.strokePhase == .upStroke &&
                 newPoint.y < initialTouchPoint.y {
              self.state = .recognized
           } else {
              self.state = .failed
           }
        }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
           super.touchesCancelled(touches, with: event)
           self.initialTouchPoint = CGPoint.zero
           self.strokePhase = .notStarted
           self.trackedTouch = nil
           self.state = .cancelled
        }
         
        override func reset() {
           super.reset()
           self.initialTouchPoint = CGPoint.zero
           self.strokePhase = .notStarted
           self.trackedTouch = nil
        }
}

/* Animations in iOS */

/* Property Animation*/
UIView.animate(withDuration: 0.5) {
    myView.alpha = 0.0
}

/* Transition */
UIView.transition(with: containerView, duration: 0.3, options: .transitionFlipFromLeft, animations: {
    containerView.addSubview(newView)
}, completion: nil)

/* Transformation */

UIView.animate(withDuration: 0.5) {
    myView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
}

/* Key Frame Animation */
UIView.animateKeyframes(withDuration: 2.0, delay: 0.0, options: [], animations: {
    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.2) {
        myView.transform = CGAffineTransform(rotationAngle: .pi / 4)
    }
    UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.3) {
        myView.transform = CGAffineTransform(translationX: 100, y: 100)
    }
    // Additional keyframes can be added
}, completion: nil)








