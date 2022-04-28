/** This is custom made class which initialize the default image picker with third party cropper.
 
 Cropper used
 URL :- https://github.com/sprint84/PhotoCropEditor
 
 */
import UIKit
import AVFoundation

public protocol CustomImagePickerProtocol {
    func didFinishPickingImage(image: UIImage)
    func didCancelPickingImage()
    func didGotError(error: String)
}

public class CustomImagePicker: NSObject {
    
    private var viewController:UIViewController?
    public var delegate:CustomImagePickerProtocol!
    /**
     This property helps to keep the aspect ratio of the cropper. Default value is false.
     */
    public var keepAspectRatio = false
    
    /**
     set the bar-tint color of the navigation
     */
    public var barTintColor: UIColor?
    
    /**
     set the tint color of the navigationItems of cropper
     */
    public var tintColor: UIColor?
    
    /**
     set the background color of the cropper
     */
    public var backgroundColor: UIColor?
    
    
    /**
     This function will present the custom image picker.
     */
    
    public func openImagePickerOn(_ controller:UIViewController) {
        self.viewController = controller
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraBtnTitle = MSSLocalizedKeys.sharedInstance.localizedTextFor(key:MSSLocalizedKeys.CustomImagePickerText.openCamera.rawValue)
        
        let galleryBtnTitle = MSSLocalizedKeys.sharedInstance.localizedTextFor(key:MSSLocalizedKeys.CustomImagePickerText.openGallery.rawValue)
        
        let cameraBtn = UIAlertAction(title:cameraBtnTitle , style: .default) { (action) in
            
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                self.openCamera()
            }
            else if AVCaptureDevice.authorizationStatus(for: .video) ==  .denied {
                self.delegate.didGotError(error: MSSLocalizedKeys.sharedInstance.localizedTextFor(key: MSSLocalizedKeys.GeneralText.cameraPermission.rawValue))
            }
            else if AVCaptureDevice.authorizationStatus(for: .video) ==  .notDetermined {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted) in
                    if granted {
                        self.openCamera()
                    }
                })
            }
        }
        
        let galleryBtn = UIAlertAction(title:galleryBtnTitle , style: .default) { (action) in
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.viewController?.present(imagePicker, animated: true, completion: nil)
        }
        
        let cancelBtn = UIAlertAction(title:MSSLocalizedKeys.sharedInstance.localizedTextFor(key: MSSLocalizedKeys.GeneralText.cancel.rawValue) , style: .cancel) { (action) in
            
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(cameraBtn)
        alertController.addAction(galleryBtn)
        alertController.addAction(cancelBtn)
        
        alertController.popoverPresentationController?.sourceView = viewController?.view
        
        self.viewController?.present(alertController, animated: true, completion: nil)
    }
    
    func openCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        self.viewController?.present(imagePicker, animated: true, completion: nil)
    }
}

extension CustomImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        guard let pickedImage = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage) else { return }
        
        let controller = CropViewController()
        controller.delegate = self
        controller.image = pickedImage
        controller.keepAspectRatio = self.keepAspectRatio
        if self.keepAspectRatio {
            controller.cropAspectRatio = 1
        }
        picker.dismiss(animated: true, completion: nil)
        
        let navigationController = UINavigationController(rootViewController: controller)
        if let barTintColor = self.barTintColor {
            navigationController.navigationBar.barTintColor = barTintColor
        }
        if let tintColor = self.tintColor {
            navigationController.navigationBar.tintColor = tintColor
        }
        if let backgroundColor = self.backgroundColor {
            controller.backgroundColor = backgroundColor
        }
        self.viewController?.present(navigationController, animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension CustomImagePicker: CropViewControllerDelegate {
    
    public func cropViewController(_ controller: CropViewController, didFinishCroppingImage image: UIImage, transform: CGAffineTransform, cropRect: CGRect) {
        delegate.didFinishPickingImage(image: image)
        controller.dismiss(animated: true, completion: nil)
    }
    
    public func cropViewControllerDidCancel(_ controller: CropViewController) {
        delegate.didCancelPickingImage()
        controller.dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
