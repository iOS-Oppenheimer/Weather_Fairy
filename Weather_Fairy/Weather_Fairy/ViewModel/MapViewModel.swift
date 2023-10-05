import CoreLocation
import Foundation
import MapKit

var currentCityName: String?

class MapViewModel: NSObject, CLLocationManagerDelegate, MKMapViewDelegate {
    private var locationManager: CLLocationManager
    private var mapView: MKMapView

    init(locationManager: CLLocationManager, mapView: MKMapView) {
        self.locationManager = locationManager
        self.mapView = mapView
        super.init()

        // Location Manager 설정
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        // MapView 설정
        self.mapView.delegate = self
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? MapAnnotation {
            let identifier = "customAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.image = UIImage(named: "pin")
                annotationView?.canShowCallout = true
                let imageSize = CGSize(width: 20, height: 25)
                annotationView?.frame = CGRect(origin: .zero, size: imageSize)
            } else {
                annotationView?.annotation = annotation
            }

            return annotationView
        }
        return nil
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 위치 업데이트가 발생했을 때의 로직을 여기에 구현
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // 위치 업데이트 실패 시의 로직을 여기에 구현
        print("Error \(error)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            DispatchQueue.main.async {
                self.locationManager.requestWhenInUseAuthorization()
            }
        case .denied:
            print("GPS 권한 요청 거부됨")
            DispatchQueue.main.async {
                self.locationManager.requestWhenInUseAuthorization()
            }
        default:
            print("GPS: Default")
        }
    }

    func resetLocation() {
        locationManager.startUpdatingLocation()
        let status = locationManager.authorizationStatus
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            if let currentLocation = locationManager.location {
                let latitude = currentLocation.coordinate.latitude
                let longitude = currentLocation.coordinate.longitude
                print("현재 위치 - 위도: \(latitude), 경도: \(longitude)")

                // 현재 위치를 중심으로 지도를 이동
                let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let annotation = MapAnnotation(coordinate: location, title: "25")
                let regionRadius: CLLocationDistance = ZOOM_OUT // ZOOM_OUT 값은 적절한 값으로 대체해야 합니다.
                let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
                mapView.setRegion(coordinateRegion, animated: true)
                mapView.addAnnotation(annotation)
            } else {
                print("위치 정보를 가져올 수 없습니다.")
            }
        case .notDetermined:
            print("위치 권한이 아직 요청되지 않았습니다.")
        case .denied, .restricted:
            print("위치 정보에 동의하지 않았거나 액세스가 제한되었습니다.")
        @unknown default:
            print("알 수 없는 위치 권한 상태입니다.")
        }
    }

    func geocode(location: CLLocation, completion: @escaping (String?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, _ in
            if let placemark = placemarks?.first,
               let cityName = placemark.locality
            {
                DispatchQueue.main.async {
                    currentCityName = cityName
                    completion(cityName)
                }
            } else {
                completion(nil)
            }
        }
    }
}

protocol MainViewModelDelegate: AnyObject {
    func didUpdateLocationWithPlacemark(_ placemark: CLPlacemark?)
}
