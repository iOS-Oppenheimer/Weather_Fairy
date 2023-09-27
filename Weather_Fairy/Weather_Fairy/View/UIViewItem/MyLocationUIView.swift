import CoreLocation
import MapKit
import SnapKit
import UIKit

class MyLocationUIView: UIView {
    var mapView: MKMapView!
    
    lazy var currentLocationLabel: UILabel = {
        let label = UILabel()
        label.currentLocationLabel(text: "부산광역시", textColor: .white, font: UIFont(name: "Jua", size: 20) ?? UIFont())
        label.textAlignment = .left
        return label
    }()
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    lazy var customMapView: MKMapView = {
        mapView = MKMapView()
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isUserInteractionEnabled = true
        mapView.isScrollEnabled = true
        mapView.isZoomEnabled = true
        mapView.mapType = .standard
        mapView.layer.cornerRadius = 25
        mapView.showsUserLocation = true
        
        let initialLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        let regionRadius: CLLocationDistance = 10000
        let coordinateRegion = MKCoordinateRegion(center: initialLocation, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)

        return mapView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupMapView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupMapView()
    }
    
    private func setupMapView() {
        addSubview(currentLocationLabel)
        addSubview(customMapView)
        currentLocationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview()
        }
                
        customMapView.snp.makeConstraints { make in
            make.top.equalTo(currentLocationLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
