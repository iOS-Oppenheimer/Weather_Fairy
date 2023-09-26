import UIKit

extension UIImageView {
    
    func customImageView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
}
