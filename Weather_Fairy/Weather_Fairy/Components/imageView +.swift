import UIKit

extension UIImageView {
    
    func customImageView(widthAnchor: CGFloat, heightAnchor: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .scaleAspectFit
        self.widthAnchor.constraint(equalToConstant: widthAnchor).isActive = true
        self.heightAnchor.constraint(equalToConstant: heightAnchor).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 2.0
    }
}
