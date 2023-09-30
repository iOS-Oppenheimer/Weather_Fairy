import CoreLocation
import MapKit
import SnapKit
import SwiftUI
import UIKit

class MainViewController: UIViewController, MiddleViewDelegate {
    private var viewModel: MainViewModel?
    private let locationManager = CLLocationManager()
    private let notificationForUmbrella = NotificationForUmbrella() // 박철우
    
    private let mainView = MainView()
    private let currentWeather: BottomCurrentWeatherView
    private let forecast: BottomWeatherForecastView
    private let myLocation: BottomMyLocationView
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        MainNavigationBar.setupNavigationBar(for: self, resetButton: #selector(resetLocationButtonTapped), searchPageButton: #selector(SearchPageButtonTapped))
        // MainViewModel 인스턴스 생성 및 초기화
        viewModel = MainViewModel(locationManager: locationManager, mapView: mainView.bottomMyLocationView.mapkit.customMapView)
        // viewModel?.delegate = self
        mainView.middleView.delegate = self
        // mapview delegate 설정 : mapMaker 디자인을 위해서!
        myLocation.mapkit.customMapView.delegate = self
        myLocation.mapkit.locationManager.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    override func viewDidAppear(_ animated: Bool) { // 박철우
        notificationForUmbrella.sendingPushNotification() // 박철우
    } // 박철우

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        currentWeather.currentWeatherView.isHidden = false
        forecast.weatherForecastView.isHidden = true
        myLocation.myLocationView.isHidden = true
        view.bringSubviewToFront(currentWeather)
    }

    func didTapWeatherForecastButton() {
        currentWeather.currentWeatherView.isHidden = true
        forecast.weatherForecastView.isHidden = false
        myLocation.myLocationView.isHidden = true
        view.bringSubviewToFront(forecast)
    }

    func didTapMyLocationButton() {
        currentWeather.currentWeatherView.isHidden = true
        forecast.weatherForecastView.isHidden = true
        myLocation.myLocationView.isHidden = false
        view.bringSubviewToFront(myLocation)
    }
    
    init() {
        self.currentWeather = mainView.bottomCurrentWeatherView
        self.forecast = mainView.bottomWeatherForecastView
        self.myLocation = mainView.bottomMyLocationView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        viewModel?.mapView(mapView, viewFor: annotation)
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

