import UIKit

class BottomWeatherForecastView: UIView, UICollectionViewDelegate {
    var hourlyWeatherList: [HourlyWeather] = []
    var dailyWeatherList: [DailyWeather] = []

    func updateHourlyForecast(_ hourlyList: [HourlyWeather]) {
        hourlyWeatherList = hourlyList
        firstCollectionView.reloadData()
    }

    func updateDailyForecast(_ dailyList: [DailyWeather]) {
        dailyWeatherList = dailyList
        secondCollectionView.reloadData()
    }

    lazy var weatherForecastView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        // view.backgroundColor = .gray
        view.layer.cornerRadius = 25
        view.isHidden = true
        view.isUserInteractionEnabled = true

        return view
    }()

    lazy var timeTitle: UILabel = {
        let label = UILabel()
        label.customLabel(text: "시간별 일기예보", textColor: .white, fontSize: 16)

        return label
    }()

    lazy var firstCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "FirstCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(white: 1, alpha: 0.3)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.cornerRadius = 20
        collectionView.layer.masksToBounds = true
        layout.minimumLineSpacing = 7
        layout.minimumInteritemSpacing = 7

        collectionView.dataSource = self
        collectionView.delegate = self

        return collectionView
    }()

    lazy var dateTitle: UILabel = {
        let label = UILabel()
        label.customLabel(text: "5일간의 일기예보", textColor: .white, fontSize: 16)

        return label
    }()

    lazy var secondCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "SecondCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(white: 1, alpha: 0.3)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.cornerRadius = 20
        collectionView.layer.masksToBounds = true
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3

        collectionView.dataSource = self
        collectionView.delegate = self

        return collectionView
    }()

    private func setupConstraints() {
        weatherForecastView.addSubview(timeTitle)
        weatherForecastView.addSubview(dateTitle)
        weatherForecastView.addSubview(firstCollectionView)
        weatherForecastView.addSubview(secondCollectionView)
        addSubview(weatherForecastView)

        let safeArea = safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            weatherForecastView.centerXAnchor.constraint(equalTo: centerXAnchor),
            weatherForecastView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            weatherForecastView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            weatherForecastView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            weatherForecastView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),

            timeTitle.topAnchor.constraint(equalTo: weatherForecastView.topAnchor, constant: 5),
            timeTitle.bottomAnchor.constraint(equalTo: firstCollectionView.topAnchor, constant: -5),
            timeTitle.leadingAnchor.constraint(equalTo: weatherForecastView.leadingAnchor, constant: 10),

            firstCollectionView.topAnchor.constraint(equalTo: weatherForecastView.topAnchor, constant: 25),
            firstCollectionView.leadingAnchor.constraint(equalTo: weatherForecastView.leadingAnchor, constant: 10),
            firstCollectionView.trailingAnchor.constraint(equalTo: weatherForecastView.trailingAnchor, constant: -10),
            firstCollectionView.heightAnchor.constraint(equalToConstant: 110),

            dateTitle.bottomAnchor.constraint(equalTo: secondCollectionView.topAnchor, constant: -5),
            dateTitle.leadingAnchor.constraint(equalTo: weatherForecastView.leadingAnchor, constant: 10),

            secondCollectionView.bottomAnchor.constraint(equalTo: weatherForecastView.bottomAnchor, constant: -15),
            secondCollectionView.leadingAnchor.constraint(equalTo: weatherForecastView.leadingAnchor, constant: 10),
            secondCollectionView.trailingAnchor.constraint(equalTo: weatherForecastView.trailingAnchor, constant: -10),
            secondCollectionView.heightAnchor.constraint(equalToConstant: 110),

        ])
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        firstCollectionView.register(FirstCollectionViewCell.self, forCellWithReuseIdentifier: FirstCollectionViewCell.reuseIdentifier)
        secondCollectionView.register(SecondCollectionViewCell.self, forCellWithReuseIdentifier: SecondCollectionViewCell.reuseIdentifier)

        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("ERROR")
    }
}

// 데이터 소스 메서드에서 셀 구성
extension BottomWeatherForecastView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == firstCollectionView {
            return 10
        } else {
            return 5
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == firstCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FirstCollectionViewCell.reuseIdentifier, for: indexPath) as! FirstCollectionViewCell
            timeForHourly(cell: cell, indexPath: indexPath)
            weatherDataForHourly(cell: cell, indexPath: indexPath)
            return cell

        } else if collectionView == secondCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SecondCollectionViewCell.reuseIdentifier, for: indexPath) as! SecondCollectionViewCell
            dateForDaily(cell: cell, indexPath: indexPath)
            weatherDataForDaily(cell: cell, indexPath: indexPath)
            return cell
        }
        return UICollectionViewCell()
    }

    // 셀 시간 설정
    private func timeForHourly(cell: FirstCollectionViewCell, indexPath: IndexPath) {
        let currentDate = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let components = calendar.dateComponents([.hour], from: currentDate)

        if let hour = components.hour {
            let nextHour = (hour + (indexPath.item * 3) + 1) % 24
            cell.timeLabel.text = String(format: "%02d:00", nextHour)
        } else {
            cell.timeLabel.text = "Time \(indexPath.item)"
        }
    }

    // 셀 날짜 설정
    private func dateForDaily(cell: SecondCollectionViewCell, indexPath: IndexPath) {
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.day = indexPath.item + 1

        if let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd"
            let dateString = dateFormatter.string(from: futureDate)

            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "E"
            let dayString = dayFormatter.string(from: futureDate)

            cell.dateLabel.text = "\(dateString)(\(dayString))"
        } else {
            cell.dateLabel.text = "Date \(indexPath.item)"
        }
    }

    // 시간별 날씨 설정
    private func weatherDataForHourly(cell: FirstCollectionViewCell, indexPath: IndexPath) {
        if indexPath.item < hourlyWeatherList.count {
            let hourlyWeather = hourlyWeatherList[indexPath.item]
            cell.timeTempLabel.text = "\(Int(hourlyWeather.main.temp))°"

            weatherIconForCell(cell: cell, weather: hourlyWeather.weather.first)
        } else {
            cell.timeTempLabel.text = "Temp \(indexPath.item)"
        }
    }

    // 날짜별 날씨 설정
    private func weatherDataForDaily(cell: SecondCollectionViewCell, indexPath: IndexPath) {
        if indexPath.item < dailyWeatherList.count {
            let dailyWeather = dailyWeatherList[indexPath.item]
            cell.dateTempLabel.text = "\(Int(dailyWeather.main.temp))°"

            weatherIconForCell(cell: cell, weather: dailyWeather.weather.first)
        } else {
            cell.dateTempLabel.text = "Temp \(indexPath.item)"
        }
    }

    // 아이콘 설정
    private func weatherIconForCell(cell: UICollectionViewCell, weather: Weather?) {
        if let weather = weather {
            let iconURLString = "https://openweathermap.org/img/wn/\(weather.icon).png"

            if let cell = cell as? FirstCollectionViewCell {
                cell.firstWeatherIcon(iconURLString: iconURLString)
            } else if let cell = cell as? SecondCollectionViewCell {
                cell.secondWeatherIcon(iconURLString: iconURLString)
            }
        }
    }
}

// 셀 크기 조절
extension BottomWeatherForecastView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 90)
    }
}

// MARK: - 컬렉션뷰 셀

// 첫 번째 컬렉션 뷰의 셀
class FirstCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "FirstCell"

    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.customLabel(text: "", textColor: .white, fontSize: 15)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 1)
        label.layer.shadowOpacity = 0.6
        label.layer.shadowRadius = 1
        return label
    }()

    lazy var firstWeatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    lazy var timeTempLabel: UILabel = {
        let label = UILabel()
        label.customLabel(text: "", textColor: .white, fontSize: 15)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 1)
        label.layer.shadowOpacity = 0.6
        label.layer.shadowRadius = 1
        label.layer.shadowRadius = 1
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(timeLabel)
        addSubview(firstWeatherIconImageView)
        addSubview(timeTempLabel)
        // backgroundColor = .clear
        // backgroundColor = UIColor.white.withAlphaComponent(0.5)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            firstWeatherIconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            firstWeatherIconImageView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 5),
            firstWeatherIconImageView.bottomAnchor.constraint(equalTo: timeTempLabel.topAnchor, constant: -5),
            firstWeatherIconImageView.widthAnchor.constraint(equalToConstant: 20),

            timeTempLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timeTempLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            timeTempLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            timeTempLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }

    func firstWeatherIcon(iconURLString: String) {
        if let url = URL(string: iconURLString) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        self.firstWeatherIconImageView.image = image
                    }
                }
            }.resume()
        }
    }
}

// 두 번째 컬렉션 뷰의 셀
class SecondCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "SecondCell"

    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.customLabel(text: "", textColor: .white, fontSize: 13)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 1)
        label.layer.shadowOpacity = 0.6
        label.layer.shadowRadius = 1

        return label
    }()

    lazy var secondWeatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    lazy var dateTempLabel: UILabel = {
        let label = UILabel()
        label.customLabel(text: "", textColor: .white, fontSize: 15)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 1)
        label.layer.shadowOpacity = 0.6
        label.layer.shadowRadius = 1

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(dateLabel)
        addSubview(secondWeatherIconImageView)
        addSubview(dateTempLabel)
        // backgroundColor = .clear
        // backgroundColor = UIColor.white.withAlphaComponent(0.5)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            secondWeatherIconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            secondWeatherIconImageView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            secondWeatherIconImageView.bottomAnchor.constraint(equalTo: dateTempLabel.topAnchor, constant: -5),
            secondWeatherIconImageView.widthAnchor.constraint(equalToConstant: 20),

            dateTempLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateTempLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            dateTempLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            dateTempLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }

    func secondWeatherIcon(iconURLString: String) {
        if let url = URL(string: iconURLString) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        self.secondWeatherIconImageView.image = image
                    }
                }
            }.resume()
        }
    }
}
