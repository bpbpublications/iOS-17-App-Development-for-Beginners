/*
 Chapter - 15
 Cameras and Photo Libraries
 */

import UIKit
import AVFoundation

class WSImageViewController: UIViewController
{
    @IBAction func imagePickerAction(selectedButton: UIButton)
    {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension WSImageViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    //Mark:- UIImagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        picker.dismiss(animated: true, completion: nil)
        var _: UIImage =  (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
}

// UIVideoEditorController
class WSViewController: UIViewController, UINavigationControllerDelegate
{
    var photoOutput: AVCapturePhotoOutput!
    var videoDeviceInput: AVCaptureDeviceInput!
    var photoCaptureProcessor: AVCapturePhotoCaptureDelegate!
    var livePhotoMode, depthDataDeliveryMode, portraitEffectsMatteDeliveryMode: AVCaptureDevice.FlashMode!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UIVideoEditorController.canEditVideo(atPath: "<path of video>") {
            let editController = UIVideoEditorController()
            editController.videoPath = "<path of video>"
            editController.delegate = self
            present(editController, animated:true)
        }
    }
    
    // Photo Capture
    func photoCapture()
        {
            var photoSettings = AVCapturePhotoSettings()
        
            if  self.photoOutput.availablePhotoCodecTypes.contains(.hevc) {
                photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
            }
            if self.videoDeviceInput.device.isFlashAvailable {
                photoSettings.flashMode = .auto
            }
            photoSettings.isHighResolutionPhotoEnabled = true
            if let previewPhotoPixelFormatType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
                photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPhotoPixelFormatType]
            }
        if self.livePhotoMode == .on && self.photoOutput.isLivePhotoCaptureSupported {
                let livePhotoMovieFileName = NSUUID().uuidString
                let livePhotoMovieFilePath = (NSTemporaryDirectory() as NSString).appendingPathComponent((livePhotoMovieFileName as NSString).appendingPathExtension("mov")!)
                photoSettings.livePhotoMovieFileURL = URL(fileURLWithPath: livePhotoMovieFilePath)
            }
            photoSettings.isDepthDataDeliveryEnabled = (self.depthDataDeliveryMode == .on
                && self.photoOutput.isDepthDataDeliveryEnabled)
     
            photoSettings.isPortraitEffectsMatteDeliveryEnabled = (self.portraitEffectsMatteDeliveryMode == .on
                && self.photoOutput.isPortraitEffectsMatteDeliveryEnabled)
            if photoSettings.isDepthDataDeliveryEnabled {
                if !self.photoOutput.availableSemanticSegmentationMatteTypes.isEmpty {
                }
            }
            
            self.photoOutput.capturePhoto(with: photoSettings, delegate: photoCaptureProcessor)
        }

    
}

extension WSViewController: UIVideoEditorControllerDelegate
{
    func videoEditorController(_ editor: UIVideoEditorController,
                               didSaveEditedVideoToPath editedVideoPath: String) {
        dismiss(animated:true)
    }
    
    func videoEditorControllerDidCancel(_ editor: UIVideoEditorController) {
        dismiss(animated:true)
    }
    
    func videoEditorController(_ editor: UIVideoEditorController,
                               didFailWithError error: Error) {
        print("an error occurred: \(error.localizedDescription)")
        dismiss(animated:true)
    }
}

// camera Preview
class PreviewView: UIView {
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
}









