import UIKit

class CurrentLocationViewItem: UIView {
    // 대기질
    lazy var tempMaxImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "airQuality"))
        imageView.customImageView()
        return imageView
    }()
    
    lazy var tempMax: UILabel = {
        let label = UILabel()
        label.customLabel(text: "최고온도", textColor: .white, fontSize: 25)
        return label
    }()
    
    lazy var tempMaxValue: UILabel = {
        let label = UILabel()
        label.customLabel(text: "34℃", textColor: .white, fontSize: 25)
        return label
    }()
    
    lazy var tempMaxStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [tempMaxImage, tempMax, tempMaxValue])
        stackView.verticalStackViewForCenter(spacing: 10)
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
        label.customLabel(text: "바람", textColor: .white, fontSize: 25)
        return label
    }()
    
    lazy var windyValue: UILabel = {
        let label = UILabel()
        label.customLabel(text: "2/ms", textColor: .white, fontSize: 25)
        return label
    }()
    
    lazy var windyStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [windyImageView, windy, windyValue])
        stackView.verticalStackViewForCenter(spacing: 10)
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
        label.customLabel(text: "습도", textColor: .white, fontSize: 25)
        return label
    }()
    
    lazy var humidityValue: UILabel = {
        let label = UILabel()
        label.customLabel(text: "60%", textColor: .white, fontSize: 25)
        return label
    }()
    
    lazy var humidityStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [humidityImageView, humidity, humidityValue])
        stackView.verticalStackViewForCenter(spacing: 10)
        return stackView
    }()
    
    // 강수확률
    lazy var tempMinImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "umbrella"))
        imageView.customImageView()
        return imageView
    }()
    
    lazy var tempMin: UILabel = {
        let label = UILabel()
        label.customLabel(text: "최저온도", textColor: .white, fontSize: 25)
        return label
    }()
    
    lazy var tempMinValue: UILabel = {
        let label = UILabel()
        label.customLabel(text: "31℃", textColor: .white, fontSize: 25)
        return label
    }()
    
    lazy var tempMinStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [tempMinImageView, tempMin, tempMinValue])
        stackView.verticalStackViewForCenter(spacing: 10)
        return stackView
    }()
    
    private func setupCurrentWeatherView() {
        let stackView = UIStackView(arrangedSubviews: [tempMaxStackView, windyStackView, humidityStackView, tempMinStackView])
        stackView.horizontalStackView(spacing: 25)
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
