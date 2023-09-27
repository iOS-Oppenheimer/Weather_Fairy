import UIKit

class BottomMyLocationView: UIView {
    lazy var myLocationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.layer.cornerRadius = 25
        view.isHidden = true

        return view
    }()

    private func setupConstraints() {
        addSubview(myLocationView)

        let safeArea = safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            myLocationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            myLocationView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            myLocationView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            myLocationView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            myLocationView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),

        ])
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("ERROR")
    }
}
