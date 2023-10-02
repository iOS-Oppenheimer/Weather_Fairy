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
        button.layer.cornerRadius = 5
        return button
    }()

    lazy var conditionsLabel: UILabel = {
        let label = UILabel()
        label.customLabel(text: "기상 상태", textColor: .white, fontSize: 22)
        return label
    }()

    lazy var celsiusStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [celsiusLabel, celsiusSignLabel])
        stackView.horizontalStackViewForCenter(spacing: 2)
        return stackView
    }()

    lazy var fahrenheitStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fahrenheitLabel, fahrenheitSignLabel])
        stackView.horizontalStackViewForCenter(spacing: 2)
        stackView.isHidden = true

        return stackView
    }()

    lazy var temperatureStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [celsiusStackView, fahrenheitStackView, signChangeButton])
        stackView.horizontalStackViewForCenter(spacing: 1)
        return stackView
    }()

    lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cityName, temperatureStackView, conditionsLabel])
        stackView.verticalStackViewForCenter(spacing: 5)
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("ERROR")
    }
}
