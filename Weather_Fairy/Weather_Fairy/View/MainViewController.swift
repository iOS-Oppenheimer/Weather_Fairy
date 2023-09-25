import CoreLocation
import MapKit
import SnapKit
import SwiftUI
import UIKit

class MainViewController: UIViewController {
    let myLocationView = MyLocationUIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        myLocationView.locationManager.delegate = self

        // NavigationBarButton 구현
        let presentLocationBarItem = UIBarButtonItem.presentLocationItemButton(target: self, action: #selector(presentLocationTapped))
        let menuBarItem = UIBarButtonItem.menuItemButton(target: self, action: #selector(menuTapped))
        navigationItem.leftBarButtonItem = presentLocationBarItem
        navigationItem.rightBarButtonItem = menuBarItem

        // MapKit 띄우기
        let locationView = MyLocationUIView(frame: CGRect(x: 0, y: 300, width: UIScreen.main.bounds
                .width, height: 250))
        view.addSubview(locationView)
    } //: viewDidLoad()

    // ========================================🔽 navigation Bar Tapped구현==========================================
    @objc func presentLocationTapped() {
        let status = myLocationView.locationManager.authorizationStatus

        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            if let currentLocation = myLocationView.locationManager.location {
                let latitude = currentLocation.coordinate.latitude
                let longitude = currentLocation.coordinate.longitude
                print("현재 위치 - 위도: \(latitude), 경도: \(longitude)")

                // 현재 위치를 중심으로 지도를 이동
                let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let regionRadius: CLLocationDistance = 200
                let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
                myLocationView.customMapView.setRegion(coordinateRegion, animated: true)
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

    @objc func menuTapped() {}
} //: UIViewController

extension MainViewController: CLLocationManagerDelegate {
    // 위치 권한이 변경될 때 호출되는 메서드
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            DispatchQueue.main.async {
                // 위치 권한을 요청하는 코드 추가
                self.myLocationView.locationManager.requestWhenInUseAuthorization()
            }
        case .denied:
            print("GPS 권한 요청 거부됨")
            DispatchQueue.main.async {
                // 위치 권한을 요청하는 코드 추가
                self.myLocationView.locationManager.requestWhenInUseAuthorization()
            }
        default:
            print("GPS: Default")
        }
    }
}

// MainViewController Preview
struct MainViewController_Previews: PreviewProvider {
    static var previews: some View {
        MainVCRepresentable()
            .edgesIgnoringSafeArea(.all)
    }
}

struct MainVCRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let mainViewController = MainViewController()
        return UINavigationController(rootViewController: mainViewController)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    typealias UIViewControllerType = UIViewController
}
