import UIKit

extension UILabel {
    
    func customLabel(text: String, textColor: UIColor, font: UIFont){
        self.text = text
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = textColor
        self.font = font
    }
    
    func topLabel(text: String, font: UIFont, textColor: UIColor){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = text
        self.font = font
        self.sizeToFit()
        self.textAlignment = .center
        self.textColor = textColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 2
    }
}
