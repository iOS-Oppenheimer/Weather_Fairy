import UIKit

class BottomCurrentWeatherView: UIView {
    let currentLocationItem = CurrentLocationViewItem()
    
    lazy var currentWeatherView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.4)
        view.layer.cornerRadius = 25
        view.isHidden = false

        return view
    }()

    private func setupConstraints() {
        addSubview(currentWeatherView)
        currentLocationItem.translatesAutoresizingMaskIntoConstraints = false
        currentWeatherView.addSubview(currentLocationItem)

        let safeArea = safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            currentWeatherView.centerXAnchor.constraint(equalTo: centerXAnchor),
            currentWeatherView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            currentWeatherView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            currentWeatherView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            currentWeatherView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),

            currentLocationItem.centerXAnchor.constraint(equalTo: currentWeatherView.centerXAnchor),
            currentLocationItem.centerYAnchor.constraint(equalTo: currentWeatherView.centerYAnchor),
            currentLocationItem.widthAnchor.constraint(equalToConstant: 340), // 원하는 너비 설정
            currentLocationItem.heightAnchor.constraint(equalToConstant: 120) // 원하는 높이 설정

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
