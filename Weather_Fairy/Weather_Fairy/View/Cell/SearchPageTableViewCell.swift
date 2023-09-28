import UIKit
import SwiftUI
import SnapKit

class SearchPageTableViewCell: UITableViewCell {
    static let identifier = "SearchPageTableViewCell"
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "09:44 AM"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var weatherLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Cloudy"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "21°"
        label.font = UIFont.systemFont(ofSize: 40)
        return label
    }()
    
    lazy var maxMinTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "최고: 25°C 최저: 17°C"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var englishNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var coordinatesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    

    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let backgroundImage = UIImageView(image: UIImage(named: "cloudyBG.png"))
        backgroundView = backgroundImage
        

        self.backgroundColor = .clear

        contentView.addSubview(nameLabel)
//        contentView.addSubview(englishNameLabel)
//        contentView.addSubview(coordinatesLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(weatherLabel)
        contentView.addSubview(tempLabel)
        contentView.addSubview(maxMinTempLabel)

        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(12)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.leading)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
        
        weatherLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.leading)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalTo(nameLabel.snp.top).offset(-5)
        }
        
        maxMinTempLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherLabel.snp.top)
            make.trailing.equalTo(tempLabel.snp.trailing)
        }
        
//        englishNameLabel.snp.makeConstraints { make in
//            make.leading.equalTo(nameLabel.snp.leading)
//            make.top.equalTo(nameLabel.snp.bottom).offset(5)
//        }
//        
//        coordinatesLabel.snp.makeConstraints { make in
//            make.leading.equalTo(nameLabel.snp.leading)
//            make.top.equalTo(englishNameLabel.snp.bottom).offset(5)
//            make.bottom.equalToSuperview().offset(-10)
//        }
        
        
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


