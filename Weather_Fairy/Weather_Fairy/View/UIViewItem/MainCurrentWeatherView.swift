import UIKit

class BottomCurrentWeatherView: UIView {
    let currentLocationItem = CurrentLocationViewItem()

    lazy var currentWeatherView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        view.layer.cornerRadius = 25
        view.isHidden = false
        // view.backgroundColor = .clear

        return view
    }()

    private func setupConstraints() {
        addSubview(currentWeatherView)
        currentLocationItem.translatesAutoresizingMaskIntoConstraints = false
        currentWeatherView.addSubview(currentLocationItem)

        NSLayoutConstraint.activate([
            currentWeatherView.centerXAnchor.constraint(equalTo: centerXAnchor),
            currentWeatherView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            currentWeatherView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            currentWeatherView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            currentWeatherView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),

            currentLocationItem.centerXAnchor.constraint(equalTo: currentWeatherView.centerXAnchor),
            currentLocationItem.centerYAnchor.constraint(equalTo: currentWeatherView.centerYAnchor),
            currentLocationItem.leadingAnchor.constraint(equalTo: currentWeatherView.leadingAnchor, constant: 5),
            currentLocationItem.trailingAnchor.constraint(equalTo: currentWeatherView.trailingAnchor, constant: -5),
            currentLocationItem.heightAnchor.constraint(equalToConstant: 120),

            currentLocationItem.mainStackView.topAnchor.constraint(equalTo: currentLocationItem.topAnchor),
            currentLocationItem.mainStackView.bottomAnchor.constraint(equalTo: currentLocationItem.bottomAnchor),
            currentLocationItem.mainStackView.leadingAnchor.constraint(equalTo: currentLocationItem.leadingAnchor),
            currentLocationItem.mainStackView.trailingAnchor.constraint(equalTo: currentLocationItem.trailingAnchor)
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
