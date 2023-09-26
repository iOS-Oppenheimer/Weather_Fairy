import CoreLocation
import MapKit
import SnapKit
import SwiftUI
import UIKit

class MainViewController: UIViewController {
    let locationView = MyLocationUIView(frame: CGRect(x: 0, y: 480, width: UIScreen.main.bounds
            .width, height: 250))
    let currentLocationView = CurrentWeatherViewItem(frame: CGRect(x: 60, y: 100, width: UIScreen.main.bounds.width, height: 0))
    let locationManager = CLLocationManager()
  
  lazy var cityName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "서울특별시"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.sizeToFit()
        label.textAlignment = .center
        label.textColor = .systemBackground
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowOpacity = 0.8
        label.layer.shadowRadius = 2

        return label
    }()

    lazy var celsiusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "21"
        label.font = UIFont.systemFont(ofSize: 100, weight: .bold)
        label.sizeToFit()
        label.textAlignment = .center
        label.textColor = .systemBackground
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowOpacity = 0.8
        label.layer.shadowRadius = 2

        return label
    }()

    lazy var celsiusSignLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "℃"
        label.font = UIFont.systemFont(ofSize: 80, weight: .bold)
        label.sizeToFit()
        label.textAlignment = .center
        label.textColor = .systemBackground
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowOpacity = 0.8
        label.layer.shadowRadius = 2

        return label
    }()

    lazy var celsiusStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [celsiusLabel, celsiusSignLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 2

        return stackView
    }()

    lazy var fahrenheitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "69.8"
        label.font = UIFont.systemFont(ofSize: 100, weight: .bold)
        label.sizeToFit()
        label.textAlignment = .center
        label.textColor = .systemBackground
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowOpacity = 0.8
        label.layer.shadowRadius = 2

        return label
    }()

    lazy var fahrenheitSignLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "℉"
        label.font = UIFont.systemFont(ofSize: 80, weight: .bold)
        label.sizeToFit()
        label.textAlignment = .center
        label.textColor = .systemBackground
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowOpacity = 0.8
        label.layer.shadowRadius = 2

        return label
    }()

    lazy var fahrenheitStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fahrenheitLabel, fahrenheitSignLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 2

        return stackView
    }()

    lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [celsiusStackView, fahrenheitStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 0

        return stackView
    }()

    private lazy var signChangeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        if let changeImage = UIImage(named: "change") {
            let changeImageSize = CGSize(width: 25, height: 25)
            UIGraphicsBeginImageContextWithOptions(changeImageSize, false, UIScreen.main.scale)
            changeImage.draw(in: CGRect(origin: .zero, size: changeImageSize))
            if let resizedchangeImage = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                button.setImage(resizedchangeImage.withRenderingMode(.alwaysOriginal), for: .normal)
            } else {
                UIGraphicsEndImageContext()
            }
        }
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = UIColor.systemBackground.cgColor
        button.layer.borderWidth = 0
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(signChangeButtonTapped), for: .touchUpInside)

        return button
    }()

    lazy var conditionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "한때 흐림"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.sizeToFit()
        label.textAlignment = .center
        label.textColor = .systemBackground
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowOpacity = 0.8
        label.layer.shadowRadius = 2

        return label
    }()

    lazy var currentWeatherButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.setTitleColor(.systemBackground, for: .normal)
        button.setTitle("현재 날씨", for: .normal)
        button.titleLabel?.font = UIFont(name: "Marker Felt", size: 15)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 0
        button.layer.cornerRadius = 7
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)

        button.addTarget(self, action: #selector(currentWeatherButtonTapped), for: .touchUpInside)

        return button
    }()

    lazy var weatherForecastButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.setTitleColor(.systemBackground, for: .normal)
        button.setTitle("기상 예보", for: .normal)
        button.titleLabel?.font = UIFont(name: "Marker Felt", size: 15)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 0
        button.layer.cornerRadius = 7
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)

        button.addTarget(self, action: #selector(weatherForecastButtonTapped), for: .touchUpInside)

        return button
    }()

    lazy var myLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.setTitleColor(.systemBackground, for: .normal)
        button.setTitle("나의 위치", for: .normal)
        button.titleLabel?.font = UIFont(name: "Marker Felt", size: 15)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 0
        button.layer.cornerRadius = 7
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)

        button.addTarget(self, action: #selector(myLocationButtonTapped), for: .touchUpInside)

        return button
    }()

    lazy var middleButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [currentWeatherButton, weatherForecastButton, myLocationButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 20

        return stackView
    }()

    lazy var buttonOverlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.layer.cornerRadius = 9

        return view
    }()

    lazy var currentWeatherView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.4)
        view.layer.cornerRadius = 9
        view.isHidden = false

        return view
    }()

    lazy var weatherForecastView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        view.layer.cornerRadius = 9
        view.isHidden = true

        return view
    }()

    lazy var myLocationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.layer.cornerRadius = 9
        view.isHidden = true

        return view
    }()

    lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [currentWeatherView, weatherForecastView, myLocationView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 0

        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        locationView.locationManager.delegate = self

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        fahrenheitStackView.isHidden = true
        setupNavigationBar()
        setupBackgroundImage()
        setupViews()
        setUpConstraints()
      
        // MapKit 띄우기
        view.addSubview(locationView)
        view.addSubview(currentLocationView)
    } //: viewDidLoad()
  
  override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupViews() {
        view.addSubview(bottomStackView)
        view.addSubview(buttonOverlayView)
        view.addSubview(middleButtonStackView)
        view.addSubview(conditionsLabel)
        view.addSubview(cityName)
        view.addSubview(signChangeButton)
        view.addSubview(topStackView)
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

    private func setUpConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            cityName.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            cityName.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30),
            cityName.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 40),
            cityName.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -40),
            cityName.heightAnchor.constraint(equalToConstant: 35),
            cityName.widthAnchor.constraint(equalToConstant: 70),

            topStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            topStackView.topAnchor.constraint(equalTo: cityName.bottomAnchor, constant: 5),
            topStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            topStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
            topStackView.heightAnchor.constraint(equalToConstant: 120),

            signChangeButton.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: -10),
            signChangeButton.rightAnchor.constraint(equalTo: topStackView.rightAnchor, constant: -20),

            conditionsLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            conditionsLabel.topAnchor.constraint(equalTo: signChangeButton.bottomAnchor, constant: 10),

            currentWeatherButton.widthAnchor.constraint(equalToConstant: 80),
            currentWeatherButton.heightAnchor.constraint(equalToConstant: 25),
            weatherForecastButton.widthAnchor.constraint(equalToConstant: 80),
            weatherForecastButton.heightAnchor.constraint(equalToConstant: 25), myLocationButton.widthAnchor.constraint(equalToConstant: 80),
            myLocationButton.heightAnchor.constraint(equalToConstant: 25),

            middleButtonStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            middleButtonStackView.topAnchor.constraint(equalTo: conditionsLabel.bottomAnchor, constant: 50),
            middleButtonStackView.heightAnchor.constraint(equalToConstant: 25),

            buttonOverlayView.centerXAnchor.constraint(equalTo: middleButtonStackView.centerXAnchor),
            buttonOverlayView.centerYAnchor.constraint(equalTo: middleButtonStackView.centerYAnchor),
            buttonOverlayView.widthAnchor.constraint(equalTo: middleButtonStackView.widthAnchor, constant: 15),
            buttonOverlayView.heightAnchor.constraint(equalTo: middleButtonStackView.heightAnchor, constant: 15),

            currentWeatherView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            currentWeatherView.topAnchor.constraint(equalTo: buttonOverlayView.bottomAnchor, constant: 50),
            currentWeatherView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            currentWeatherView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            currentWeatherView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -80),

            weatherForecastView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            weatherForecastView.topAnchor.constraint(equalTo: buttonOverlayView.bottomAnchor, constant: 50),
            weatherForecastView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            weatherForecastView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            weatherForecastView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -80),

            myLocationView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            myLocationView.topAnchor.constraint(equalTo: buttonOverlayView.bottomAnchor, constant: 50),
            myLocationView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            myLocationView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            myLocationView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -80),
        ])
    }

    @objc func signChangeButtonTapped() {
        celsiusStackView.isHidden = !celsiusStackView.isHidden
        fahrenheitStackView.isHidden = !fahrenheitStackView.isHidden
    }

    @objc func currentWeatherButtonTapped() {
        currentWeatherView.isHidden = false
        weatherForecastView.isHidden = true
        myLocationView.isHidden = true
    }

    @objc func weatherForecastButtonTapped() {
        currentWeatherView.isHidden = true
        weatherForecastView.isHidden = false
        myLocationView.isHidden = true
    }

    @objc func myLocationButtonTapped() {
        currentWeatherView.isHidden = true
        weatherForecastView.isHidden = true
        myLocationView.isHidden = false
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

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            //locationManager.stopUpdatingLocation()
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if error == nil {
                    let firstPlacemark = placemarks?[0]
                    self.cityName.text = firstPlacemark?.locality ?? "Unknown"
                } else {
                    print("error")
                }
            }
        }
        
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
                    self.locationView.locationManager.requestWhenInUseAuthorization()
                }
            case .denied:
                print("GPS 권한 요청 거부됨")
                DispatchQueue.main.async {
                    // 위치 권한을 요청하는 코드 추가
                    self.locationView.locationManager.requestWhenInUseAuthorization()
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
}
