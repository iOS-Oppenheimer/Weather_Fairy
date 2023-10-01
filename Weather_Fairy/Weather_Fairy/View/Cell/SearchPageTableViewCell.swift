import UIKit
import SwiftUI
import SnapKit

class SearchPageTableViewCell: UITableViewCell {
    static let identifier = "SearchPageTableViewCell"
    
    var cityKorName: String?
    var cityEngName: String?
    var cityLat: Double?
    var cityLon: Double?
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
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var engNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var weatherLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 40)
        return label
    }()
    
    lazy var maxMinTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    func setLocationData(data: (String, String, Double, Double)) {
        cityKorName = data.1
        cityEngName = data.0
        cityLat = data.2
        cityLon = data.3
    }
    
    func setWeatherData(weatherInfo: (String, String, Int, Int, Int, String)) {
        weatherMain = weatherInfo.0
        weatherIcon = weatherInfo.1
        weatherTemp = weatherInfo.2
        weatherMinTemp = weatherInfo.3
        weatherMaxTemp = weatherInfo.4
        cityTime = weatherInfo.5
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
        
        let backgroundImage = UIImageView(image: UIImage(named: "cloudyBG.png"))
        backgroundView = backgroundImage
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
            make.top.equalToSuperview().offset(12)
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
            make.bottom.equalToSuperview().offset(-12)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalTo(korNameLabel.snp.top).offset(-5)
        }
        
        maxMinTempLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherLabel.snp.top)
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
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)가 구현되지 않음")
    }
}
