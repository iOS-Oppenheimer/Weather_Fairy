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
        button.customButton(text: "현재 날씨")
        button.addTarget(self, action: #selector(currentWeatherButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var weatherForecastButton: UIButton = {
        let button = UIButton(type: .system)
        button.customButton(text: "기상 예보")
        button.addTarget(self, action: #selector(weatherForecastButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var myLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.customButton(text: "나의 위치")
        button.addTarget(self, action: #selector(myLocationButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var middleButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [currentWeatherButton, weatherForecastButton, myLocationButton])
        stackView.horizontalStackView(spacing: 20)
        return stackView
    }()

    lazy var buttonOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        view.layer.cornerRadius = 9
        return view
    }()

    private func setupConstraints() {
        addSubview(buttonOverlayView)
        addSubview(middleButtonStackView)

        currentWeatherButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(25)
        }
        weatherForecastButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(25)
        }

        myLocationButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(25)
        }

        middleButtonStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
        }

        buttonOverlayView.snp.makeConstraints { make in
            make.centerX.equalTo(middleButtonStackView)
            make.centerY.equalTo(middleButtonStackView)
            make.width.equalTo(middleButtonStackView).offset(15)
            make.height.equalTo(middleButtonStackView).offset(15)
        }
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
        self.backgroundColor = UIColor.clear
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("ERROR")
    }
}
