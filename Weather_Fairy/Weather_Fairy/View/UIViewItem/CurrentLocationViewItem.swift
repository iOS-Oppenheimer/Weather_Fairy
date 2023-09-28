import UIKit

class CurrentLocationViewItem: UIView {
    // 대기질
    lazy var airQualityImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "airQuality"))
        imageView.customImageView()
        return imageView
    }()
    
    lazy var airQuality: UILabel = {
        let label = UILabel()
        label.customLabel(text: "대기질", textColor: .black, fontSize: 20)
     
        return label
    }()
    
    lazy var airQualityValue: UILabel = {
        let label = UILabel()
        label.customLabel(text: "34 좋음", textColor: .black, fontSize: 20)

        return label
    }()
    
    lazy var airQualityStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [airQualityImage, airQuality, airQualityValue])
        stackView.verticalStackView(spacing: 10)
        stackView.alignment = .center
        return stackView
    }()
    
    // 바람
    lazy var windyImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "windy"))
        imageView.customImageView()
        return imageView
    }()
    
    lazy var windy: UILabel = {
        let label = UILabel()
        label.customLabel(text: "바람", textColor: .white, fontSize: 20)

        return label
    }()
    
    lazy var windyValue: UILabel = {
        let label = UILabel()
        label.customLabel(text: "2/ms", textColor: .black, fontSize: 20)

        return label
    }()
    
    lazy var windyStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [windyImageView, windy, windyValue])
        stackView.verticalStackView(spacing: 10)
        stackView.alignment = .center
        return stackView
    }()
    
    // 습도
    lazy var humidityImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "humidity"))
        imageView.customImageView()
        return imageView
    }()
    
    lazy var humidity: UILabel = {
        let label = UILabel()
        label.customLabel(text: "습도", textColor: .black, fontSize: 20)

        return label
    }()
    
    lazy var humidityValue: UILabel = {
        let label = UILabel()
        label.customLabel(text: "60%", textColor: .black, fontSize: 20)

        return label
    }()
    
    lazy var humidityStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [humidityImageView, humidity, humidityValue])
        stackView.verticalStackView(spacing: 10)
        stackView.alignment = .center
        return stackView
    }()
    
    // 강수확률
    lazy var rainfallImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "umbrella"))
        imageView.customImageView()
        return imageView
    }()
    
    lazy var rainfall: UILabel = {
        let label = UILabel()
        label.customLabel(text: "강수확률", textColor: .black, fontSize: 20)

        return label
    }()
    
    lazy var rainfallValue: UILabel = {
        let label = UILabel()
        label.customLabel(text: "80%", textColor: .black, fontSize: 20)

        return label
    }()
    
    lazy var rainfallStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [rainfallImageView, rainfall, rainfallValue])
        stackView.verticalStackView(spacing: 10)
        stackView.alignment = .center
        return stackView
    }()
    
    private func setupCurrentWeatherView() {
        let stackView = UIStackView(arrangedSubviews: [airQualityStackView, windyStackView, humidityStackView, rainfallStackView])
        stackView.horizontalStackView(spacing: 30)
        stackView.layer.borderColor = UIColor.red.cgColor
        stackView.layer.borderWidth = 2.0
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
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
