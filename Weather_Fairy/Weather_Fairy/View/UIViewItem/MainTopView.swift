
import UIKit

class TopView: UIView {
    lazy var cityName: UILabel = {
        let label = UILabel()
        label.topLabel(text: "서울특별시", font: UIFont.systemFont(ofSize: 32, weight: .bold), textColor: .white)

        return label
    }()

    lazy var celsiusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "21"
        label.font = UIFont.systemFont(ofSize: 100, weight: .bold)
        label.sizeToFit()
        label.textAlignment = .center
        label.textColor = .systemBackground
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowOpacity = 0.8
        label.layer.shadowRadius = 2

        return label
    }()

    lazy var celsiusSignLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "℃"
        label.font = UIFont.systemFont(ofSize: 80, weight: .bold)
        label.sizeToFit()
        label.textAlignment = .center
        label.textColor = .systemBackground
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowOpacity = 0.8
        label.layer.shadowRadius = 2

        return label
    }()

    lazy var fahrenheitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "69.8"
        label.font = UIFont.systemFont(ofSize: 100, weight: .bold)
        label.sizeToFit()
        label.textAlignment = .center
        label.textColor = .systemBackground
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowOpacity = 0.8
        label.layer.shadowRadius = 2

        return label
    }()

    lazy var fahrenheitSignLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "℉"
        label.font = UIFont.systemFont(ofSize: 80, weight: .bold)
        label.sizeToFit()
        label.textAlignment = .center
        label.textColor = .systemBackground
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowOpacity = 0.8
        label.layer.shadowRadius = 2

        return label
    }()

    lazy var signChangeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        if let changeImage = UIImage(named: "change") {
            let changeImageSize = CGSize(width: 25, height: 25)
            UIGraphicsBeginImageContextWithOptions(changeImageSize, false, UIScreen.main.scale)
            changeImage.draw(in: CGRect(origin: .zero, size: changeImageSize))
            if let resizedchangeImage = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                button.setImage(resizedchangeImage.withRenderingMode(.alwaysOriginal), for: .normal)
            } else {
                UIGraphicsEndImageContext()
            }
        }
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = UIColor.systemBackground.cgColor
        button.layer.borderWidth = 0
        button.layer.cornerRadius = 5
        // button.addTarget(self, action: #selector(signChangeButtonTapped), for: .touchUpInside)

        return button
    }()

    lazy var conditionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "한때 흐림"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.sizeToFit()
        label.textAlignment = .center
        label.textColor = .systemBackground
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowOpacity = 0.8
        label.layer.shadowRadius = 2

        return label
    }()

    lazy var celsiusStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [celsiusLabel, celsiusSignLabel])
        stackView.horizontalStackView(spacing: 2)
        stackView.alignment = .center
        
        return stackView
    }()

    lazy var fahrenheitStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fahrenheitLabel, fahrenheitSignLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 2

        return stackView
    }()

    lazy var temperatureStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [celsiusStackView, fahrenheitStackView, signChangeButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 1

        return stackView
    }()

    lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cityName, temperatureStackView, conditionsLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.backgroundColor = .black

        return stackView
    }()

    private func setupConstraints() {
        addSubview(topStackView)
        topStackView.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(conditionsLabel)
//        addSubview(signChangeButton)
//        addSubview(cityName)
//        addSubview(temperatureStackView)
//        conditionsLabel.translatesAutoresizingMaskIntoConstraints = false
//        signChangeButton.translatesAutoresizingMaskIntoConstraints = false
//        cityName.translatesAutoresizingMaskIntoConstraints = false
//        temperatureStackView.translatesAutoresizingMaskIntoConstraints = false

        let safeArea = safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            topStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
//            cityName.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
//            cityName.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30),
//            cityName.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 40),
//            cityName.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -40),
//            cityName.heightAnchor.constraint(equalToConstant: 35),
//            cityName.widthAnchor.constraint(equalToConstant: 70),
//
//            temperatureStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
//            temperatureStackView.topAnchor.constraint(equalTo: cityName.bottomAnchor, constant: 5),
//            temperatureStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
//            temperatureStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
//            temperatureStackView.heightAnchor.constraint(equalToConstant: 120),
//
//            signChangeButton.topAnchor.constraint(equalTo: temperatureStackView.bottomAnchor, constant: -10),
//            signChangeButton.rightAnchor.constraint(equalTo: temperatureStackView.rightAnchor, constant: -20),
//
//            conditionsLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
//            conditionsLabel.topAnchor.constraint(equalTo: signChangeButton.bottomAnchor, constant: 10),
        ])
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        // setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("ERROR")
    }
}
