import SnapKit
import UIKit

class BottomCurrentWeatherView: UIView {
    let currentLocationItem = CurrentLocationViewItem()

    lazy var currentWeatherView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.isHidden = false

        return view
    }()

    private func setupConstraints() {
        addSubview(currentWeatherView)
        currentWeatherView.addSubview(currentLocationItem)

        currentWeatherView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }
        currentLocationItem.snp.makeConstraints { make in
            make.centerX.equalTo(currentWeatherView)
            make.centerY.equalTo(currentWeatherView)
            make.width.equalTo(340)
            make.height.equalTo(120)
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
