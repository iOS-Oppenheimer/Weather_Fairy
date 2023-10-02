import CoreLocation
import MapKit
import UIKit

class MainViewController: UIViewController, MiddleViewDelegate {
    private var mapViewModel: MapViewModel?
    private let locationManager = CLLocationManager()
    // let notificationForWeather_Fairy = NotificationForWeather_Fairy() // 박철우 - 알림기능들에 접근하기위함

    let mainView = MainView()
    let currentWeather: BottomCurrentWeatherView
    let forecast: BottomWeatherForecastView
    let myLocation: BottomMyLocationView
    var cityEngName: String?
    var cityKorName: String?
    var cityLat: Double?
    var cityLon: Double?

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
        // notificationForWeather_Fairy.openingNotification() // 박철우 - 어플이 처음 켜졌을때 메인페이지에서 딱 한번만 보여줄 알림 만들었습니다.

        changeTexts()
    }

    override func viewDidAppear(_ animated: Bool) { // 박철우
        // notificationForWeather_Fairy.sendingPushNotification() // 박철우
    } // 박철우

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func resetLocationButtonTapped() {
        didTapMyLocationButton()
        mapViewModel?.resetLocation()
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

    func changeTexts() {
        myLocation.mapkit.currentLocationLabel.text = cityKorName ?? "부산"
        // 현재위치(받아오는 lat, lon) 설정해줘야함 -> 하드코딩 바꾸기
        let currentLocation = CLLocationCoordinate2D(latitude: cityLat ?? 35.1796, longitude: cityLon ?? 129.0756)
        let coordinateRegion = MKCoordinateRegion(center: currentLocation, latitudinalMeters: ZOOM_IN, longitudinalMeters: ZOOM_IN)
        myLocation.mapkit.customMapView.setRegion(coordinateRegion, animated: false)
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

    func fetchWeatherData(latitude: Double, longitude: Double) {
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(geoAPIKey)&units=metric&lang=kr"

        guard let url = URL(string: urlStr) else { return }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                print("Failed to fetch data with error: ", error)
                return
            }

            guard let data = data else { return }

            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherData.self, from: data)

                DispatchQueue.main.async {
                    // UI 업데이트 및 배경 이미지 변경
                    self?.updateUI(with: weatherData)
                }

            } catch {
                print("Failed to parse JSON with error: ", error)
            }
        }

        task.resume()
    }

    func updateUI(with data: WeatherData) {
        mainView.topView.celsiusLabel.text = "\(Int(data.main.temp))"

        currentWeather.currentLocationItem.sunriseValue.text = convertTime(data.sys.sunrise)
        currentWeather.currentLocationItem.sunsetValue.text = convertTime(data.sys.sunset)
        currentWeather.currentLocationItem.windyValue.text = "\(data.wind.speed)m/s"
        currentWeather.currentLocationItem.humidityValue.text = "\(data.main.humidity)%"

        if let weatherDescription = data.weather.first?.description {
            mainView.topView.conditionsLabel.text = weatherDescription
        }

        let weatherImageInstance = WeatherCellBackgroundImage()

        if let weatherId = data.weather.first?.id {
            let image = weatherImageInstance.getImage(id: weatherId)
            mainView.changeBackgroundImage(to: image)
        }
    }

    func convertTime(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }

    func fetchHourlyWeatherData(latitude: Double, longitude: Double) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(geoAPIKey)&units=metric&lang=kr"

        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Failed to fetch data with error: ", error)
                return
            }

            guard let data = data else {
                print("No data returned from the server")
                return
            }

            do {
                let decoder = JSONDecoder()
                let hourlyForecast = try decoder.decode(HourlyForecast.self, from: data)
                print("Hourly Forecast Data: \(hourlyForecast)")
                DispatchQueue.main.async {
                    // 받아온 데이터를 BottomWeatherForecastView에 전달
                    self.forecast.updateHourlyForecast(hourlyForecast.list)
                    print("UI Should be updated")
                }
            } catch {
                print("Failed to parse JSON with error: ", error)
            }
        }
        task.resume()
    }

    func fetchDailyWeatherData(latitude: Double, longitude: Double) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(geoAPIKey)&units=metric&lang=kr&cnt=40"

        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Failed to fetch data with error: ", error)
                return
            }

            guard let data = data else {
                print("No data returned from the server")
                return
            }

            do {
                let decoder = JSONDecoder()
                let dailyForecast = try decoder.decode(DailyForecast.self, from: data)
                DispatchQueue.main.async {
                    // 받아온 데이터를 BottomWeatherForecastView에 전달
                    self.forecast.updateDailyForecast(dailyForecast.list)
                }
            } catch {
                print("Failed to parse JSON with error: ", error)
            }
        }

        task.resume()
    }
}

extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        mapViewModel?.mapView(mapView, viewFor: annotation)
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        fetchWeatherData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

        fetchHourlyWeatherData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

        fetchDailyWeatherData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

        geocode(location: location) { cityName in
            print("City Name: \(cityName)")
        }

        manager.stopUpdatingLocation()
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
        mapViewModel?.geocode(location: location, topViewCityName: mainView.topView.cityName)
    }
}
