import UIKit

extension UILabel {
    
    func customLabel(text: String, textColor: UIColor, font: UIFont){
        self.text = text
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = textColor
        self.font = font
    }
    
    func currentLocationLabel(text: String, textColor: UIColor, font: UIFont){
        self.text = text
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = textColor
        self.font = font
        self.textAlignment = .center
        self.textColor = .systemBackground
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 2
    }
}
