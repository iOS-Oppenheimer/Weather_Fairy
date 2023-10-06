import UIKit
import SnapKit

class BottomMyLocationView: UIView {
    let mapkit = MyLocationUIView()

    lazy var myLocationView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.isHidden = true
        view.isUserInteractionEnabled = true
        return view
    }()

    private func setupConstraints() {
        addSubview(myLocationView)
        mapkit.translatesAutoresizingMaskIntoConstraints = false
        myLocationView.addSubview(mapkit)

        myLocationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }
        mapkit.snp.makeConstraints { make in
            make.centerX.equalTo(myLocationView)
            make.centerY.equalTo(myLocationView)
            make.width.equalTo(myLocationView)
            make.height.equalTo(myLocationView)
        }
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
