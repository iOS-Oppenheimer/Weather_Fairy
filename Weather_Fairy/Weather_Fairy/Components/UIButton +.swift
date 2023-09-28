import UIKit

extension UIButton {
    
    func customeButton(tintColor: UIColor, clipsToBounds: Bool, frame: CGRect){
        self.tintColor = tintColor
        self.clipsToBounds = clipsToBounds
        self.frame = frame
    }
}
