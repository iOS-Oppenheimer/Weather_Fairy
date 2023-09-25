import MapKit
import CoreLocation
import SnapKit
import UIKit

class MyLocationUIView: UIView {
    var mapView: MKMapView!
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    lazy var country: UILabel = {
        let label = UILabel()
        label.customLabel(text: "경기도 용인시", textColor: .black, font: UIFont.systemFont(ofSize: 20))
        return label
    }()
    
    lazy var customMapView: MKMapView = {
        mapView = MKMapView()
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isUserInteractionEnabled = true
        mapView.isScrollEnabled = true
        mapView.isZoomEnabled = true
        mapView.mapType = .standard
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
        }

        customMapView.snp.makeConstraints { make in
            make.height.equalTo(250)
            make.width.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // 위치 권한이 변경될 때 호출되는 메서드
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                print("GPS 권한 설정됨")
            case .restricted, .notDetermined:
                print("GPS 권한 설정되지 않음")
                DispatchQueue.main.async {
                    // 위치 권한을 요청하는 코드 추가
                    self.locationManager.requestWhenInUseAuthorization()
                }
            case .denied:
                print("GPS 권한 요청 거부됨")
                DispatchQueue.main.async {
                    // 위치 권한을 요청하는 코드 추가
                    self.locationManager.requestWhenInUseAuthorization()
                }
            default:
                print("GPS: Default")
            }
        }
}
