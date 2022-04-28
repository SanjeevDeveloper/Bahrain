
import UIKit

class UITextFieldCustomClass: UITextFieldFontSize {
    
    @IBInspectable var placeholderColor: UIColor = UIColor.black {
        didSet {
            if let placeholder = self.placeholder {
                let attributes = [NSAttributedStringKey.foregroundColor: placeholderColor]
                attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
            }
        }
    }
    
    //@IBInspectable var horizontalInset: CGFloat = 0
    
    @IBInspectable var borderWidth:CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var cornerRadius:CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable var borderColor:UIColor {
        get { return UIColor(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue.cgColor }
    }
    
    @IBInspectable var rightImage : UIImage?{
        didSet{
            let imageView = UIImageView(image: rightImage)
            imageView.frame.size.width += 20
            imageView.contentMode = .center
            self.rightViewMode = .always
            self.rightView = imageView
        }
    }
    
    //    override func editingRect(forBounds bounds: CGRect) -> CGRect {
    //        return bounds.insetBy(dx: horizontalInset, dy: 0)
    //    }
    //
    //    override func textRect(forBounds bounds: CGRect) -> CGRect {
    //        return bounds.insetBy(dx: horizontalInset, dy: 0)
    //    }
    
//    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
//        var rect = super.rightViewRect(forBounds: bounds)
//        rect.origin.x -= 10
//        return rect
//    }
    
    
    
    
}

extension UITextField {
    func customTextAlignment() {
        let languageIdentifier = UserDefaults.standard.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String
        if languageIdentifier == Languages.Arabic {
            self.semanticContentAttribute = .forceRightToLeft
            self.textAlignment = NSTextAlignment.right
        }
        else {
            self.semanticContentAttribute = .forceLeftToRight
            self.textAlignment = NSTextAlignment.left
        }
        
    }
}
