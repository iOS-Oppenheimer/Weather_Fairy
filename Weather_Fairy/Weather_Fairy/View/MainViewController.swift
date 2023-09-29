import CoreLocation
import MapKit
import SnapKit
import SwiftUI
import UIKit

class MainViewController: UIViewController, MiddleViewDelegate {
    private var viewModel: MainViewModel?
    let locationManager = CLLocationManager()
    
    let notificationForUmbrella = NotificationForUmbrella() // 박철우
    let bottomMyLocationView = BottomMyLocationView()
    let bottomWeatherForecastView = BottomWeatherForecastView()
    let bottomCurrentWeatherView = BottomCurrentWeatherView()
    let middleView = MiddleView()
    let topView = TopView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // MainViewModel 인스턴스 생성 및 초기화
        viewModel = MainViewModel(locationManager: locationManager, mapView: bottomMyLocationView.mapkit.customMapView)
        // viewModel?.delegate = self

        middleView.delegate = self
        // mapview delegate 설정 : mapMaker 디자인을 위해서!
        bottomMyLocationView.mapkit.customMapView.delegate = self
        view.backgroundColor = .systemBackground
        bottomMyLocationView.mapkit.locationManager.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        setupNavigationBar()
        setupBackgroundImage()
        setupViews()
    }

    override func viewDidAppear(_ animated: Bool) { // 박철우
        notificationForUmbrella.sendingPushNotification() // 박철우
    } // 박철우

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupViews() {
        view.addSubview(topView)
        view.addSubview(middleView)
        view.addSubview(bottomCurrentWeatherView)
        view.addSubview(bottomMyLocationView)
        view.addSubview(bottomWeatherForecastView)

        // view.addSubview(locationView)

        // topView 위치, 크기 설정
        topView.frame = CGRect(x: 0, y: 110, width: UIScreen.main.bounds
            .width, height: 230)

        // middleView 위치, 크기 설정
        let middleHeight: CGFloat = 50
        let middleYPosition = topView.frame.origin.y + topView.frame.height
        middleView.frame = CGRect(x: 0, y: middleYPosition, width: UIScreen.main.bounds.width, height: middleHeight)

        // 현재 날씨 뷰의 위치, 크기 설정
        let bottomCurrentWeatherViewHeight: CGFloat = 350
        let bottomCurrentWeatherViewHeightYPosition = middleYPosition + middleHeight
        bottomCurrentWeatherView.frame = CGRect(x: 0, y: bottomCurrentWeatherViewHeightYPosition, width: UIScreen.main.bounds.width, height: bottomCurrentWeatherViewHeight)

        // 기상 예보 뷰의 위치, 크기 설정
        let bottomWeatherForecastViewHeight: CGFloat = 350
        let bottomWeatherForecastViewYPosition = middleYPosition + middleHeight
        bottomWeatherForecastView.frame = CGRect(x: 0, y: bottomWeatherForecastViewYPosition, width: UIScreen.main.bounds.width, height: bottomWeatherForecastViewHeight)

        // 나의 위치 뷰의 위치, 크기 설정
        let bottomMyLocationViewHeight: CGFloat = 350
        let bottomMyLocationViewYPosition = middleYPosition + middleHeight
        bottomMyLocationView.frame = CGRect(x: 0, y: bottomMyLocationViewYPosition, width: UIScreen.main.bounds.width, height: bottomMyLocationViewHeight)
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
        didTapMyLocationButton()
        viewModel?.resetLocation()
    }

    @objc func SearchPageButtonTapped() {
        let searchPageVC = SearchPageViewController()
        navigationController?.pushViewController(searchPageVC, animated: true)
    }

    func didTapCurrentWeatherButton() {
        bottomCurrentWeatherView.currentWeatherView.isHidden = false
        bottomWeatherForecastView.weatherForecastView.isHidden = true
        bottomMyLocationView.myLocationView.isHidden = true
        view.bringSubviewToFront(bottomCurrentWeatherView)
    }

    func didTapWeatherForecastButton() {
        bottomCurrentWeatherView.currentWeatherView.isHidden = true
        bottomWeatherForecastView.weatherForecastView.isHidden = false
        bottomMyLocationView.myLocationView.isHidden = true
        view.bringSubviewToFront(bottomWeatherForecastView)
    }

    func didTapMyLocationButton() {
        bottomCurrentWeatherView.currentWeatherView.isHidden = true
        bottomWeatherForecastView.weatherForecastView.isHidden = true
        bottomMyLocationView.myLocationView.isHidden = false
        view.bringSubviewToFront(bottomMyLocationView)
    }
}

extension MainViewController: MKMapViewDelegate {
    // UI 관련 로직은 View에서 해야함.
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
}

extension MainViewController: CLLocationManagerDelegate {
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            viewModel?.locationManager(manager, didUpdateLocations: locations)
        }

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            viewModel?.locationManager(manager, didFailWithError: error)
        }
      
        // 위치 권한이 변경될 때 호출되는 메서드
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            viewModel?.locationManager(manager, didChangeAuthorization: status)
        }
    }

    // MARK: - Preview

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
