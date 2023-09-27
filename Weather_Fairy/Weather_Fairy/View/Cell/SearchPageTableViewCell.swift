import UIKit
import SwiftUI
import SnapKit

class SearchPageTableViewCell: UITableViewCell {
    static let identifier = "SearchPageTableViewCell"
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var englishNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var coordinatesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
//    private lazy var tempLabel: UILabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .lightGray
        self.backgroundColor = .clear

        contentView.addSubview(nameLabel)
        contentView.addSubview(englishNameLabel)
        contentView.addSubview(coordinatesLabel)

        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(10)
        }
        
        englishNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.leading)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        
        coordinatesLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.leading)
            make.top.equalTo(englishNameLabel.snp.bottom).offset(5)
            make.bottom.equalToSuperview().offset(-10)
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


