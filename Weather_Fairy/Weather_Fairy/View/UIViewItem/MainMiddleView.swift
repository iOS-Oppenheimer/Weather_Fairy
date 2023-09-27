import UIKit

protocol MiddleViewDelegate: AnyObject {
    func didTapCurrentWeatherButton()
    func didTapWeatherForecastButton()
    func didTapMyLocationButton()
}

class MiddleView: UIView {
    weak var delegate: MiddleViewDelegate?

    let topView = TopView()
    let bottomCurrentWeatherView = BottomCurrentWeatherView()
    let bottomWeatherForecastView = BottomWeatherForecastView()
    let bottomMyLocationView = BottomMyLocationView()

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

        button.addTarget(self, action: #selector(currentWeatherButtonTapped), for: .touchUpInside)

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

        button.addTarget(self, action: #selector(weatherForecastButtonTapped), for: .touchUpInside)

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

        button.addTarget(self, action: #selector(myLocationButtonTapped), for: .touchUpInside)

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
        addSubview(buttonOverlayView)
        addSubview(middleButtonStackView)

        let safeArea = safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            currentWeatherButton.widthAnchor.constraint(equalToConstant: 80),
            currentWeatherButton.heightAnchor.constraint(equalToConstant: 25),

            weatherForecastButton.widthAnchor.constraint(equalToConstant: 80),
            weatherForecastButton.heightAnchor.constraint(equalToConstant: 25),

            myLocationButton.widthAnchor.constraint(equalToConstant: 80),
            myLocationButton.heightAnchor.constraint(equalToConstant: 25),

            middleButtonStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            middleButtonStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            middleButtonStackView.heightAnchor.constraint(equalToConstant: 25),

            buttonOverlayView.centerXAnchor.constraint(equalTo: middleButtonStackView.centerXAnchor),
            buttonOverlayView.centerYAnchor.constraint(equalTo: middleButtonStackView.centerYAnchor),
            buttonOverlayView.widthAnchor.constraint(equalTo: middleButtonStackView.widthAnchor, constant: 15),
            buttonOverlayView.heightAnchor.constraint(equalTo: middleButtonStackView.heightAnchor, constant: 15),
        ])
    }

    @objc func currentWeatherButtonTapped() {
        delegate?.didTapCurrentWeatherButton()
    }

    @objc func weatherForecastButtonTapped() {
        delegate?.didTapWeatherForecastButton()
    }

    @objc func myLocationButtonTapped() {
        delegate?.didTapMyLocationButton()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.systemGray2
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("ERROR")
    }
}
