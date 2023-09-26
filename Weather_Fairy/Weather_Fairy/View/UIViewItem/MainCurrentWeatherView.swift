
import UIKit

class BottomCurrentWeatherView: UIView {
    let middleView = MiddleView()
    lazy var currentWeatherView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.4)
        view.layer.cornerRadius = 9
        view.isHidden = false

        return view
    }()

    private func setupConstraints() {
        addSubview(currentWeatherView)

        let safeArea = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            currentWeatherView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            currentWeatherView.topAnchor.constraint(equalTo: middleView.buttonOverlayView.bottomAnchor, constant: 50),
            currentWeatherView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            currentWeatherView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            currentWeatherView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -80),

        ])
    }
}
