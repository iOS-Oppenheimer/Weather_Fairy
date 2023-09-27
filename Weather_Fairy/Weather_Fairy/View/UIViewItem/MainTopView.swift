import UIKit

class TopView: UIView {
    var originalCelsiusValue: Double?
    lazy var cityName: UILabel = {
        let label = UILabel()
        label.topLabel(text: "서울특별시", font: UIFont.systemFont(ofSize: 32, weight: .bold), textColor: .white)

        return label
    }()

    lazy var celsiusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "25"
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
        button.addTarget(self, action: #selector(signChangeButtonTapped), for: .touchUpInside)

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
        stackView.isHidden = true

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

        return stackView
    }()

    private func setupConstraints() {
        addSubview(topStackView)
        topStackView.translatesAutoresizingMaskIntoConstraints = false

        let safeArea = safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            topStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            topStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            topStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            topStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            topStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topStackView.trailingAnchor.constraint(equalTo: trailingAnchor),

        ])
    }

    @objc func signChangeButtonTapped() {
        if celsiusStackView.isHidden {
            // 화씨 -> 섭씨
            if let originalCelsiusValue = originalCelsiusValue {
                celsiusLabel.text = String(format: "%d", Int(originalCelsiusValue))
            }
        } else {
            // 섭씨 -> 화씨
            if let celsiusText = celsiusLabel.text, let celsiusValue = Double(celsiusText) {
                originalCelsiusValue = celsiusValue
                let fahrenheitValue = (celsiusValue * 1.8) + 32
                fahrenheitLabel.text = String(format: "%d", Int(fahrenheitValue))
            }
        }

        // 뷰 전환
        celsiusStackView.isHidden.toggle()
        fahrenheitStackView.isHidden.toggle()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.systemGray
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("ERROR")
    }
}
