import UIKit

class BottomCurrentWeatherView: UIView {
    lazy var currentWeatherView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.4)
        view.layer.cornerRadius = 25
        view.isHidden = false

        return view
    }()

    private func setupConstraints() {
        addSubview(currentWeatherView)

        let safeArea = safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            currentWeatherView.centerXAnchor.constraint(equalTo: centerXAnchor),
            currentWeatherView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            currentWeatherView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            currentWeatherView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            currentWeatherView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),

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
