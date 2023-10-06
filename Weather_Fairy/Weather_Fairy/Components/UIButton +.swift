import UIKit

extension UIButton {
    
    func customButton(text: String){
        self.setTitleColor(.systemBackground, for: .normal)
        self.setTitle(text, for: .normal)
        self.titleLabel?.font = UIFont(name: "Jua", size: 18)
        self.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0
        self.layer.cornerRadius = 7
        
    }
}
