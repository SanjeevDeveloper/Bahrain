
import UIKit

class UITextViewFontSize: UITextView {

    override func awakeFromNib() {
        changeSize()
        self.keyboardType = .default
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

}
