import UIKit

extension UIStackView {
    
    func verticalStackView(spacing: CGFloat){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .vertical
        self.alignment = .leading
        self.spacing = spacing
    }
    
    func horizontalStackView(spacing: CGFloat){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .horizontal
        self.alignment = .leading
        self.spacing = spacing
    }
}
