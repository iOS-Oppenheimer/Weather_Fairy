import UIKit
import SwiftUI
import SnapKit

class SearchPageTableViewCell: UITableViewCell {
    static let identifier = "SearchPageTableViewCell"
    
    var cityKorName: String?
    var cityEngName: String?
    var cityLat: Double?
    var cityLon: Double?
    var weatherId : Int?
    var weatherMain: String?
    var weatherIcon: String?
    var weatherTemp: Int?
    var weatherMinTemp: Int?
    var weatherMaxTemp: Int?
    var cityTime: String?
    
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        return indicator
    }()
  
    
    lazy var korNameLabel: UILabel = {
        let label = UILabel()
        label.customLabel(text: "", textColor: .white, fontSize: 20)
        return label
    }()
    
    
    
    lazy var engNameLabel: UILabel = {
        let label = UILabel()
        label.customLabel(text: "", textColor: .white, fontSize: 12)
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.customLabel(text: "", textColor: .white, fontSize: 12)
        return label
    }()
    
    lazy var weatherLabel: UILabel = {
        let label = UILabel()
        label.customLabel(text: "", textColor: .white, fontSize: 20)
        return label
    }()
    
    lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.customLabel(text: "", textColor: .white, fontSize: 40)
        return label
    }()
    
    lazy var maxMinTempLabel: UILabel = {
        let label = UILabel()
        label.customLabel(text: "", textColor: .white, fontSize: 12)
        return label
    }()
    
    func setLocationData(data: (String, String, Double, Double)) {
        cityKorName = data.1
        cityEngName = data.0
        cityLat = data.2
        cityLon = data.3
    }
    
    func setWeatherData(weatherInfo: (Int, String, String, Int, Int, Int, String)) {
        weatherId = weatherInfo.0
        weatherMain = weatherInfo.1
        weatherIcon = weatherInfo.2
        weatherTemp = weatherInfo.3
        weatherMinTemp = weatherInfo.4
        weatherMaxTemp = weatherInfo.5
        cityTime = weatherInfo.6

        if let id = weatherId {
            let backgroundImage = UIImageView()
            backgroundImage.contentMode = .scaleAspectFill
            backgroundImage.clipsToBounds = true
            backgroundImage.image = WeatherCellBackgroundImage().getImage(id: id)
            backgroundView = backgroundImage
        }
    }
    
    func configure() {
        DispatchQueue.main.async {
            self.korNameLabel.text = self.cityKorName
            self.engNameLabel.text = self.cityEngName
            self.weatherLabel.text = self.weatherMain
            self.tempLabel.text = self.weatherTemp.map { "\($0)°" }
            self.maxMinTempLabel.text = self.weatherMaxTemp.flatMap { maxTemp in
                self.weatherMinTemp.map { minTemp in
                    "최고: \(maxTemp)°C 최저: \(minTemp)°C"
                }
            }
            self.timeLabel.text = self.cityTime
        }
    }
    
    func showLoadingSpinner() {
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingSpinner() {
        loadingIndicator.stopAnimating()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        let backgroundImage = UIImageView(image: UIImage(named: "cloudyBG.png"))
//        backgroundView = backgroundImage
        selectionStyle = .none
        
        self.backgroundColor = .clear
        
        contentView.addSubview(korNameLabel)
        contentView.addSubview(engNameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(weatherLabel)
        contentView.addSubview(tempLabel)
        contentView.addSubview(maxMinTempLabel)
        contentView.addSubview(loadingIndicator)
        
        korNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
        }
        
        engNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(korNameLabel.snp.leading)
            make.top.equalTo(korNameLabel.snp.bottom).offset(6)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(korNameLabel.snp.leading)
            make.top.equalTo(engNameLabel.snp.bottom).offset(6)
        }
        
        weatherLabel.snp.makeConstraints { make in
            make.leading.equalTo(korNameLabel.snp.leading)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalTo(korNameLabel.snp.top).offset(5)
        }
        
        maxMinTempLabel.snp.makeConstraints { make in
            make.bottom.equalTo(weatherLabel.snp.bottom)
            make.trailing.equalTo(tempLabel.snp.trailing)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)가 구현되지 않음")
    }
}
