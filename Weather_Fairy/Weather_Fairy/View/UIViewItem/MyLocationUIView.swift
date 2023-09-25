import MapKit
import SnapKit
import UIKit

class MyLocationUIView: UIView {
    var mapView: MKMapView!
    
    lazy var country: UILabel = {
        let label = UILabel()
        label.customLabel(text: "경기도 용인시", textColor: .black, font: UIFont.systemFont(ofSize: 20))
        return label
    }()
    
    lazy var customMapView: UIView = {
        mapView = MKMapView()
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.layer.cornerRadius = 25

        // 지도의 초기 중심 위치와 확대/축소 정도 설정
        let initialLocation = CLLocationCoordinate2D(latitude: 37.3230, longitude: 127.0943) // 경기도 용인시 수지구 위치
        let regionRadius: CLLocationDistance = 10000 // 반경 10km
        let coordinateRegion = MKCoordinateRegion(center: initialLocation, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: false)

        return mapView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [country, customMapView])
        stackView.verticalStackView(spacing: 10)
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(200)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(15)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-15)
            make.width.equalTo(frame.width) // 이 부분은 너비를 화면 너비와 일치하게 설정합니다.
        }

        customMapView.snp.makeConstraints { make in
            make.height.equalTo(300)
            make.width.equalTo(frame.width) // 이 부분은 너비를 화면 너비와 일치하게 설정합니다.
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
