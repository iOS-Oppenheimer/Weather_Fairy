
import UIKit

class MiddleView: UIView {
    let topView = TopView()

    lazy var currentWeatherButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.setTitleColor(.systemBackground, for: .normal)
        button.setTitle("현재 날씨", for: .normal)
        button.titleLabel?.font = UIFont(name: "Marker Felt", size: 15)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 0
        button.layer.cornerRadius = 7
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)

        // button.addTarget(self, action: #selector(currentWeatherButtonTapped), for: .touchUpInside)

        return button
    }()

    lazy var weatherForecastButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.setTitleColor(.systemBackground, for: .normal)
        button.setTitle("기상 예보", for: .normal)
        button.titleLabel?.font = UIFont(name: "Marker Felt", size: 15)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 0
        button.layer.cornerRadius = 7
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)

        // button.addTarget(self, action: #selector(weatherForecastButtonTapped), for: .touchUpInside)

        return button
    }()

    lazy var myLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.setTitleColor(.systemBackground, for: .normal)
        button.setTitle("나의 위치", for: .normal)
        button.titleLabel?.font = UIFont(name: "Marker Felt", size: 15)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 0
        button.layer.cornerRadius = 7
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)

        // button.addTarget(self, action: #selector(myLocationButtonTapped), for: .touchUpInside)

        return button
    }()

    lazy var middleButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [currentWeatherButton, weatherForecastButton, myLocationButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 20

        return stackView
    }()

    lazy var buttonOverlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.layer.cornerRadius = 9

        return view
    }()

    private func setupConstraints() {
        addSubview(middleButtonStackView)
        addSubview(buttonOverlayView)
        middleButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonOverlayView.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            currentWeatherButton.widthAnchor.constraint(equalToConstant: 80),
            currentWeatherButton.heightAnchor.constraint(equalToConstant: 25),
            weatherForecastButton.widthAnchor.constraint(equalToConstant: 80),
            weatherForecastButton.heightAnchor.constraint(equalToConstant: 25), myLocationButton.widthAnchor.constraint(equalToConstant: 80),
            myLocationButton.heightAnchor.constraint(equalToConstant: 25),

            middleButtonStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            middleButtonStackView.topAnchor.constraint(equalTo: topView.conditionsLabel.bottomAnchor, constant: 50),
            middleButtonStackView.heightAnchor.constraint(equalToConstant: 25),

            buttonOverlayView.centerXAnchor.constraint(equalTo: middleButtonStackView.centerXAnchor),
            buttonOverlayView.centerYAnchor.constraint(equalTo: middleButtonStackView.centerYAnchor),
            buttonOverlayView.widthAnchor.constraint(equalTo: middleButtonStackView.widthAnchor, constant: 15),
            buttonOverlayView.heightAnchor.constraint(equalTo: middleButtonStackView.heightAnchor, constant: 15),
        ])
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("ERROR")
    }
}
