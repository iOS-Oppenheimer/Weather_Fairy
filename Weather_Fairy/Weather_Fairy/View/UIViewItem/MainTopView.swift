import SnapKit
import UIKit

class TopView: UIView {
    var originalCelsiusValue: Double?
    lazy var cityName: UILabel = {
        let label = UILabel()
        label.customLabel(text: "시", textColor: .white, fontSize: 32)

        return label
    }()

    lazy var celsiusLabel: UILabel = {
        let label = UILabel()
        label.customLabel(text: "0", textColor: .white, fontSize: 100)

        return label
    }()

    lazy var celsiusSignLabel: UILabel = {
        let label = UILabel()
        label.customLabel(text: "℃", textColor: .white, fontSize: 65)

        return label
    }()

    lazy var fahrenheitLabel: UILabel = {
        let label = UILabel()
        label.customLabel(text: "0", textColor: .white, fontSize: 100)

        return label
    }()

    lazy var fahrenheitSignLabel: UILabel = {
        let label = UILabel()
        label.customLabel(text: "℉", textColor: .white, fontSize: 65)

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
        label.customLabel(text: "기상 상태", textColor: .white, fontSize: 22)

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
        topStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }

    @objc func signChangeButtonTapped() {
        DispatchQueue.main.async {
            if self.celsiusStackView.isHidden {
                // 화씨 -> 섭씨
                if let originalCelsiusValue = self.originalCelsiusValue {
                    self.celsiusLabel.text = String(format: "%d", Int(originalCelsiusValue))
                }
            } else {
                // 섭씨 -> 화씨
                if let celsiusText = self.celsiusLabel.text, let celsiusValue = Double(celsiusText) {
                    self.originalCelsiusValue = celsiusValue
                    let fahrenheitValue = (celsiusValue * 1.8) + 32
                    self.fahrenheitLabel.text = String(format: "%d", Int(fahrenheitValue))
                }
            }

            // 뷰 전환
            self.celsiusStackView.isHidden.toggle()
            self.fahrenheitStackView.isHidden.toggle()
        }
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
