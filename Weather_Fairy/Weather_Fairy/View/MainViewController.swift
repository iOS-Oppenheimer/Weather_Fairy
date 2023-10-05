import CoreLocation
import MapKit
import UIKit

class MainViewController: UIViewController, MiddleViewDelegate {
    private var mapViewModel: MapViewModel?
    private var mainViewModel = MainViewModel()
    private let locationManager = CLLocationManager()
    var initialLocation: CLLocation? = nil
    let notificationForWeather_Fairy = NotificationForWeather_Fairy() // 박철우 - 알림기능들에 접근하기위함
    let sceneDelegate = SceneDelegate() // 박철우 - 백그라운드알림
    let mainView = MainView()
    let currentWeather: BottomCurrentWeatherView
    let forecast: BottomWeatherForecastView
    let myLocation: BottomMyLocationView
    var cityEngName: String?
    var cityKorName: String? = nil
    var cityLat: Double?
    var cityLon: Double?
    var celsius: Double? // 박철우
    var currentWeatherData: WeatherData? // 박철우
    var myCurrentLat: Double = 0.0
    var myCurrentLon: Double = 0.0
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        MainNavigationBar.setupNavigationBar(for: self, resetButton: #selector(resetLocationButtonTapped), searchPageButton: #selector(SearchPageButtonTapped))
        // MainViewModel 인스턴스 생성 및 초기화
        mapViewModel = MapViewModel(locationManager: locationManager, mapView: mainView.bottomMyLocationView.mapkit.customMapView)
        mainView.topView.signChangeButton.addTarget(self, action: #selector(signChangeButtonTapped), for: .touchUpInside)
        mainView.middleView.delegate = self
        myLocation.mapkit.customMapView.delegate = self
        myLocation.mapkit.locationManager.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        notificationForWeather_Fairy.openingNotification()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func resetLocationButtonTapped() {
        didTapMyLocationButton() // 클릭시, mapview로 전환
        mapViewModel?.resetLocation()
        myLocation.mapkit.currentLocationLabel.text = "현재 내 위치" // 이건 무조건 내 위치로 돌아와야함!

        let currentLocation = CLLocationCoordinate2D(latitude: myCurrentLat, longitude: myCurrentLon)
        let coordinateRegion = MKCoordinateRegion(center: currentLocation, latitudinalMeters: ZOOM_IN, longitudinalMeters: ZOOM_IN)
        myLocation.mapkit.customMapView.setRegion(coordinateRegion, animated: false)
    }

    @objc func signChangeButtonTapped() {
        if mainView.topView.celsiusStackView.isHidden {
            // 화씨 -> 섭씨
            if let originalCelsiusValue = mainView.topView.originalCelsiusValue {
                mainView.topView.celsiusLabel.text = String(format: "%d", Int(originalCelsiusValue))
            }
        } else {
            // 섭씨 -> 화씨
            if let celsiusText = mainView.topView.celsiusLabel.text, let celsiusValue = Double(celsiusText) {
                mainView.topView.originalCelsiusValue = celsiusValue
                let fahrenheitValue = (celsiusValue * 1.8) + 32
                mainView.topView.fahrenheitLabel.text = String(format: "%d", Int(fahrenheitValue))
            }
        }
        // 뷰 전환
        mainView.topView.celsiusStackView.isHidden.toggle()
        mainView.topView.fahrenheitStackView.isHidden.toggle()
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

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateUI(with data: WeatherData) {
        mainView.topView.topCityName.text = cityKorName ?? currentCityName
        mainView.topView.celsiusLabel.text = "\(Int(data.main.temp))"
        currentWeatherData = data // for notificiation
        currentWeather.currentLocationItem.sunriseValue.text = mainViewModel.convertTime(data.sys.sunrise)
        currentWeather.currentLocationItem.sunsetValue.text = mainViewModel.convertTime(data.sys.sunset)
        currentWeather.currentLocationItem.windyValue.text = "\(data.wind.speed)m/s"
        currentWeather.currentLocationItem.humidityValue.text = "\(data.main.humidity)%"

        if let weatherDescription = data.weather.first?.description {
            mainView.topView.conditionsLabel.text = weatherDescription
        }

        let weatherImageInstance = WeatherImage()

        if let weatherId = data.weather.first?.id {
            let image = weatherImageInstance.getImage(id: weatherId)
            mainView.changeBackgroundImage(to: image)
        }
        if let currentWeatherData = currentWeatherData { // for notificiation
            let currentTemperature = Int(currentWeatherData.main.temp) // for notificiation
            let currentHumide = Int(currentWeatherData.main.humidity) // for notification -humide
            notificationForWeather_Fairy.showTemperatureAlert(temperature: currentTemperature, humide: currentHumide) // for notificiation
        } // for notificiation
    }
}

extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        mapViewModel?.mapView(mapView, viewFor: annotation)
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return } //가장 최근 위치 업데이트 가져오기!

        // 초기 위치가 아직 저장되지 않았을 때 실행
        if initialLocation == nil {
            //현재 위도 경도 저장
            myCurrentLat = location.coordinate.latitude
            myCurrentLon = location.coordinate.longitude
            
            //초기 위치로 설정 및 위치 업데이트 Stop
            initialLocation = location
            manager.stopUpdatingLocation()

            geocode(location: location) { cityName in
                print("City Name: \(cityName)")
            }

            mainViewModel.fetchAndUpdateWeatherData(latitude: cityLat ?? myCurrentLat, longitude: cityLon ?? myCurrentLon) { [weak self] data in
                self?.updateUI(with: data)
                self?.notificationForWeather_Fairy.dataForNotification(with: data)
            }

            mainViewModel.fetchAndUpdateHourlyWeatherData(latitude: cityLat ?? myCurrentLat, longitude: cityLon ?? myCurrentLon) { [weak self] forecast in
                self?.forecast.updateHourlyForecast(forecast)
            }

            mainViewModel.fetchAndUpdateDailyWeatherData(latitude: cityLat ?? myCurrentLat, longitude: cityLon ?? myCurrentLon) { [weak self] forecast in
                self?.forecast.updateDailyForecast(forecast)
            }

            let currentLocation = CLLocationCoordinate2D(latitude: cityLat ?? myCurrentLat, longitude: cityLon ?? myCurrentLon)
            let coordinateRegion = MKCoordinateRegion(center: currentLocation, latitudinalMeters: ZOOM_IN, longitudinalMeters: ZOOM_IN)
            myLocation.mapkit.customMapView.setRegion(coordinateRegion, animated: false)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        mapViewModel?.locationManager(manager, didFailWithError: error)
    }

    // 위치 권한이 변경될 때 호출되는 메서드
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        mapViewModel?.locationManager(manager, didChangeAuthorization: status)
    }

    // 주소를 받아오는 함수
    func geocode(location: CLLocation, completion: @escaping (String) -> Void) {
        mapViewModel?.geocode(location: location, topViewCityName: mainView.topView.topCityName)
    }
}
