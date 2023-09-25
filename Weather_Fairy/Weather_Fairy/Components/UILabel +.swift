import UIKit

extension UILabel {
    
    func customLabel(text: String, textColor: UIColor, font: UIFont){
        self.text = text
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = textColor
        self.font = font
    }
}
