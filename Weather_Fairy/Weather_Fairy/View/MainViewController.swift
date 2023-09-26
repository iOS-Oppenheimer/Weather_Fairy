import CoreLocation
import MapKit
import SnapKit
import SwiftUI
import UIKit

class MainViewController: UIViewController {
    var locationView: MyLocationUIView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        setupNavigationBar()
        setupBackgroundImage()
        setupViews()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupViews() {

    }

    private func setupBackgroundImage() {
        if let backgroundImage = UIImage(named: "background") {
            let backgroundImageView = UIImageView(frame: view.bounds)
            backgroundImageView.image = backgroundImage
            backgroundImageView.contentMode = .scaleAspectFill
            backgroundImageView.clipsToBounds = true
            view.insertSubview(backgroundImageView, at: 0)
        }
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = UIColor.systemBackground
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()

        navBarAppearance.backgroundColor = .clear // #F8F0E5
        navBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

        // 현재 위치 초기화 버튼
        if let resetLocationImage = UIImage(named: "paperplane") {
            let resetLocationButtonSize = CGSize(width: 25, height: 25)
            UIGraphicsBeginImageContextWithOptions(resetLocationButtonSize, false, UIScreen.main.scale)
            resetLocationImage.draw(in: CGRect(origin: .zero, size: resetLocationButtonSize))

            if let resizedResetLocationImage = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()

                let resetLocationButton = UIBarButtonItem(image: resizedResetLocationImage.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(resetLocationButtonTapped))
                resetLocationButton.imageInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)

                navigationItem.leftBarButtonItem = resetLocationButton
            }

            UIGraphicsEndImageContext()
        }

        // 검색 화면 이동 버튼
        if let searchPageImage = UIImage(named: "grid4") {
            let searchPageImageSize = CGSize(width: 25, height: 25)
            UIGraphicsBeginImageContextWithOptions(searchPageImageSize, false, UIScreen.main.scale)
            searchPageImage.draw(in: CGRect(origin: .zero, size: searchPageImageSize))

            if let resizedSearchPageImage = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()

                let SearchPageButton = UIBarButtonItem(image: resizedSearchPageImage.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(SearchPageButtonTapped))
                SearchPageButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
                navigationItem.rightBarButtonItems = [SearchPageButton, navigationItem.rightBarButtonItem].compactMap { $0 }
            }
            UIGraphicsEndImageContext()
        }
    }

    @objc func resetLocationButtonTapped() {
        locationManager.startUpdatingLocation()
        let status = locationView.locationManager.authorizationStatus

        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            if let currentLocation = locationView.locationManager.location {
                let latitude = currentLocation.coordinate.latitude
                let longitude = currentLocation.coordinate.longitude
                print("현재 위치 - 위도: \(latitude), 경도: \(longitude)")

                // 현재 위치를 중심으로 지도를 이동
                let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let regionRadius: CLLocationDistance = 10000
                let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
                locationView.customMapView.setRegion(coordinateRegion, animated: true)
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

    @objc func SearchPageButtonTapped() {}

}


