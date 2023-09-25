import MapKit
import CoreLocation
import SnapKit
import UIKit

class MyLocationUIView: UIView {
    var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
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
        locationManager.requestWhenInUseAuthorization()
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(200)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(15)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-15)
            make.width.equalTo(frame.width)
        }

        customMapView.snp.makeConstraints { make in
            make.height.equalTo(250)
            make.width.equalTo(frame.width)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
