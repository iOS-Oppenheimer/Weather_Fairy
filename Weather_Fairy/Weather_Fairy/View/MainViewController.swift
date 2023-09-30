import CoreLocation
import MapKit
import SnapKit
import SwiftUI
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
    let notificationForUmbrella = NotificationForUmbrella() // 박철우
    let bottomMyLocationView = BottomMyLocationView()
    let bottomWeatherForecastView = BottomWeatherForecastView()
    let bottomCurrentWeatherView = BottomCurrentWeatherView()
    let middleView = MiddleView()
    let topView = TopView()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        middleView.delegate = self
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
        locationManager.startUpdatingLocation()
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
                            self.topView.celsiusLabel.text = "\(Int(tempValue))"
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
                    self?.bottomWeatherForecastView.updateForecastData(with: weatherData.list)
                }

            } catch {
                print("Failed to parse JSON data: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}

// MARK: - CLLocationManagerDelegate

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        fetchWeatherData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

        geocode(location: location)

        manager.stopUpdatingLocation()

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error \(error)")
        }
        //     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //         guard let location = locations.last else {
        //             print("위치 업데이트 실패")
        //             return
        //         }
        //         print("location: \(location.coordinate.latitude),\(location.coordinate.longitude)")
        //     }

        // 위치 권한이 변경될 때 호출되는 메서드
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                print("GPS 권한 설정됨")
            case .restricted, .notDetermined:
                print("GPS 권한 설정되지 않음")
                DispatchQueue.main.async {
                    // 위치 권한을 요청하는 코드 추가
                    self.bottomMyLocationView.mapkit.locationManager.requestWhenInUseAuthorization()
                }
            case .denied:
                print("GPS 권한 요청 거부됨")
                DispatchQueue.main.async {
                    // 위치 권한을 요청하는 코드 추가
                    self.bottomMyLocationView.mapkit.locationManager.requestWhenInUseAuthorization()
                }
            default:
                print("GPS: Default")
            }
        }
        // 주소를 받아오는 함수
        func geocode(location: CLLocation) {
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, _ in
                if let placemark = placemarks?.first,
                   let cityName = placemark.locality
                {
                    DispatchQueue.main.async {
                        self.topView.cityName.text = cityName
                    }
                }
            }
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
}
