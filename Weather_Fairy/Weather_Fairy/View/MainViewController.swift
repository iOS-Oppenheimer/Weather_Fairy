import CoreLocation
import MapKit
import UIKit

struct WeatherData: Codable {
    let list: [WeatherInfo]

    struct WeatherInfo: Codable {
        let main: MainInfo
        let dt_txt: String

        struct MainInfo: Codable {
            let temp: Double
        }
    }
}

class MainViewController: UIViewController, MiddleViewDelegate {

    private var mapViewModel: MapViewModel?
    private let locationManager = CLLocationManager()
    let notificationForWeather_Fairy = NotificationForWeather_Fairy() //박철우 - 알림기능들에 접근하기위함

    let mainView = MainView()
    let currentWeather: BottomCurrentWeatherView
    let forecast: BottomWeatherForecastView
    let myLocation: BottomMyLocationView

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        MainNavigationBar.setupNavigationBar(for: self, resetButton: #selector(resetLocationButtonTapped), searchPageButton: #selector(SearchPageButtonTapped))
        // MainViewModel 인스턴스 생성 및 초기화
        mapViewModel = MapViewModel(locationManager: locationManager, mapView: mainView.bottomMyLocationView.mapkit.customMapView)
        // viewModel?.delegate = self
        mainView.middleView.delegate = self
        // mapview delegate 설정 : mapMaker 디자인을 위해서!
        myLocation.mapkit.customMapView.delegate = self
        myLocation.mapkit.locationManager.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        notificationForWeather_Fairy.openingNotification()//박철우 - 어플이 처음 켜졌을때 메인페이지에서 딱 한번만 보여줄 알림 만들었습니다.
    }
    override func viewDidAppear(_ animated: Bool) {//박철우
        notificationForWeather_Fairy.sendingPushNotification() //박철우
    }//박철우


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func resetLocationButtonTapped() {
        didTapMyLocationButton()
        mapViewModel?.resetLocation()
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

    func fetchWeatherData(latitude: Double, longitude: Double) {
        let apiKey = "9156be3c6ef5ecaa3de3ae9adb9063cd"
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric&lang=kr"

        guard let url = URL(string: urlStr) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Failed to fetch data with error: ", error)
                return
            }

            guard let data = data else { return }

            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                    DispatchQueue.main.async {
                        if let mainDict = jsonResult["main"] as? [String: Any],
                           let tempValue = mainDict["temp"] as? Double
                        {
                            self.mainView.topView.celsiusLabel.text = "\(Int(tempValue))"
                        }
                    }
                }

            } catch {
                print("Failed to parse JSON with error: ", error)
            }
        }

        task.resume()
    }

    func fetchThreeHourForecastData(city: String) {
        let apiKey = "\(geoAPIKey)"
        let urlString = "http://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=\(apiKey)&units=metric"

        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }

            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherData.self, from: data)

                DispatchQueue.main.async {
                    self?.mainView.bottomWeatherForecastView.updateForecastData(with: weatherData.list)
                }

            } catch {
                print("Failed to parse JSON data: \(error.localizedDescription)")
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

        geocode(location: location)

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
    func geocode(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, _ in
            if let placemark = placemarks?.first,
               let cityName = placemark.locality
            {
                DispatchQueue.main.async {
                    self.mainView.topView.cityName.text = cityName
                }
            }
        }
    }
}
