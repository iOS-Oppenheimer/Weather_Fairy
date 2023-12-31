import UIKit
import SwiftUI
import SnapKit

class SearchPageTableViewCell: UITableViewCell {
    static let identifier = "SearchPageTableViewCell"
    
    var cityKorName: String?
    var cityEngName: String?
    var cityLat: Double?
    var cityLon: Double?
    var weatherId : String?
    var weatherMain: String?
    var weatherIcon: String?
    var weatherTemp: String?
    var weatherMinTemp: String?
    var weatherMaxTemp: String?
    var cityTime: String?
    var weatherData: WeatherData?
    
    
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
        label.customLabel(text: "", textColor: .white, fontSize: 20)
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
    
    func setWeatherData(data: [String], timeData: String) {
        weatherTemp = data[0]
        weatherMinTemp = data[1]
        weatherMaxTemp = data[2]
        weatherMain = data[3]
        weatherId = data[4]
        weatherIcon = data[5]
        cityTime = timeData
        
        setBackGroundImage(id: weatherId ?? "")
    }
    
    func setBackGroundImage(id: String) {
        if let weatherId = weatherId {
            // "Optional(800)"에서 "800"만 추출
            if let startIndex = weatherId.firstIndex(of: "("),
               let endIndex = weatherId.lastIndex(of: ")"),
               startIndex < endIndex {
                let startIndex = weatherId.index(after: startIndex)
                let id = weatherId[startIndex..<endIndex]
                
                if let idInt = Int(id) {
                    let backgroundImage = UIImageView()
                    backgroundImage.contentMode = .scaleAspectFill
                    backgroundImage.clipsToBounds = true
                    backgroundImage.image = WeatherCellBackgroundImage().getImage(id: idInt)
                    backgroundView = backgroundImage
                }
            }
        }
    }
    
    func configure() {
        DispatchQueue.main.async {
            let letterSpacing: CGFloat = 10.0
            let attributedText = NSAttributedString(string: self.cityKorName ?? "",
                                                   attributes: [
                                                       NSAttributedString.Key.kern: letterSpacing,
                                                       NSAttributedString.Key.foregroundColor: UIColor.white,
                                                       NSAttributedString.Key.font: UIFont(name: "Jua", size: 24) as Any
                                                   ])
            self.korNameLabel.attributedText = attributedText
            
            // 나머지 레이블에는 자간을 적용하지 않음
            self.engNameLabel.text = self.cityEngName
            self.weatherLabel.text = self.weatherMain
            self.tempLabel.text = self.weatherTemp.map { "\($0)" }
            self.maxMinTempLabel.text = self.weatherMaxTemp.flatMap { maxTemp in
                self.weatherMinTemp.map { minTemp in
                    "최고: \(maxTemp) 최저: \(minTemp)"
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
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
        }
        
        engNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(korNameLabel.snp.leading)
            make.top.equalTo(korNameLabel.snp.bottom).offset(5)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(korNameLabel.snp.leading)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        maxMinTempLabel.snp.makeConstraints { make in
            make.trailing.equalTo(tempLabel.snp.trailing)
            make.top.equalTo(tempLabel.snp.bottom).offset(6)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalTo(korNameLabel.snp.top)
        }
        
        weatherLabel.snp.makeConstraints { make in
            make.bottom.equalTo(timeLabel.snp.bottom)
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
