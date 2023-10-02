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
    
    func verticalStackViewForCenter(spacing: CGFloat){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .vertical
        self.alignment = .center
        self.spacing = spacing
    }
    
    func horizontalStackViewForCenter(spacing: CGFloat){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .horizontal
        self.alignment = .center
        self.spacing = spacing
    }
}
