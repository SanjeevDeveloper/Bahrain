
import UIKit

class UITextFieldFontSize: UITextField {

    override func awakeFromNib() {
        self.customTextAlignment()
        self.keyboardType = .default
        changeSize()
    }
    
    fileprivate func changeSize() {
        let currentSize = self.font!.pointSize
        if (UIScreen.main.bounds.height == 667){
            self.font = self.font!.withSize(currentSize-3)
        }
        else if (UIScreen.main.bounds.height == 568){
            self.font = self.font!.withSize(currentSize-4)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let leftview = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.bounds.size.height))
        self.leftViewMode = .always
        self.leftView = leftview
        
        let rightview = UIView(frame: CGRect(x: self.bounds.size.width, y: 0, width: 10, height: self.bounds.size.height))
        self.leftViewMode = .always
        self.rightView = rightview
    }

}
