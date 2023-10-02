import UIKit

class CurrentLocationViewItem: UIView {
    // 대기질
    lazy var sunriseImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "sunrise"))
        imageView.customImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 1)
        imageView.layer.shadowOpacity = 0.7
        imageView.layer.shadowRadius = 2.0
        return imageView
    }()
    
    lazy var sunrise: UILabel = {
        let label = UILabel()
        label.customLabel(text: "일출시간", textColor: .white, fontSize: 23)
        return label
    }()
    
    lazy var sunriseValue: UILabel = {
        let label = UILabel()
        label.customLabel(text: "00", textColor: .white, fontSize: 18)
        return label
    }()
    
    lazy var sunriseStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [sunriseImage, sunrise, sunriseValue])
        stackView.verticalStackView(spacing: 5)
        stackView.alignment = .center
        return stackView
    }()
    
    // 바람
    lazy var windyImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "windy"))
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 1)
        imageView.layer.shadowOpacity = 0.7
        imageView.layer.shadowRadius = 2.0

        imageView.customImageView()
        return imageView
    }()
    
    lazy var windy: UILabel = {
        let label = UILabel()
        label.customLabel(text: "바람", textColor: .white, fontSize: 23)
        return label
    }()
    
    lazy var windyValue: UILabel = {
        let label = UILabel()
        label.customLabel(text: "00", textColor: .white, fontSize: 18)
        return label
    }()
    
    lazy var windyStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [windyImageView, windy, windyValue])
        stackView.verticalStackView(spacing: 5)
        stackView.alignment = .center
        return stackView
    }()
    
    // 습도
    lazy var humidityImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "humidity"))
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 1)
        imageView.layer.shadowOpacity = 0.7
        imageView.layer.shadowRadius = 2.0
        imageView.customImageView()
        return imageView
    }()
    
    lazy var humidity: UILabel = {
        let label = UILabel()
        label.customLabel(text: "습도", textColor: .white, fontSize: 23)
        return label
    }()
    
    lazy var humidityValue: UILabel = {
        let label = UILabel()
        label.customLabel(text: "00", textColor: .white, fontSize: 18)
        return label
    }()
    
    lazy var humidityStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [humidityImageView, humidity, humidityValue])
        stackView.verticalStackView(spacing: 5)
        stackView.alignment = .center
        return stackView
    }()
    
    // 강수확률
    lazy var sunsetImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "sunset"))
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 1)
        imageView.layer.shadowOpacity = 0.7
        imageView.layer.shadowRadius = 2.0
        imageView.customImageView()
        return imageView
    }()
    
    lazy var sunset: UILabel = {
        let label = UILabel()
        label.customLabel(text: "일몰시간", textColor: .white, fontSize: 23)
        return label
    }()
    
    lazy var sunsetValue: UILabel = {
        let label = UILabel()
        label.customLabel(text: "00", textColor: .white, fontSize: 18)
        return label
    }()
    
    lazy var sunsetStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [sunsetImageView, sunset, sunsetValue])
        stackView.verticalStackView(spacing: 5)
        stackView.alignment = .center
        return stackView
    }()
    
    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
     
    func setupCurrentWeatherView() {
        mainStackView.addArrangedSubview(sunriseStackView)
        mainStackView.addArrangedSubview(windyStackView)
        mainStackView.addArrangedSubview(humidityStackView)
        mainStackView.addArrangedSubview(sunsetStackView)
        addSubview(mainStackView)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCurrentWeatherView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCurrentWeatherView()
    }
}
