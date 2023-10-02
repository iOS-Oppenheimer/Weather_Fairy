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
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        view.layer.cornerRadius = 25
        view.isHidden = true
        view.isUserInteractionEnabled = true

        return view
    }()

    lazy var timeTitle: UILabel = {
        let label = UILabel()
        label.customLabel(text: "시간별 일기예보", textColor: .white, fontSize: 15)

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
        label.customLabel(text: "5일간의 일기예보", textColor: .white, fontSize: 15)

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
        layout.minimumLineSpacing = 7
        layout.minimumInteritemSpacing = 7

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

            let currentDate = Date()
            var calendar = Calendar.current
            calendar.timeZone = TimeZone.current
            let components = calendar.dateComponents([.hour], from: currentDate)
            if let hour = components.hour {
                let nextHour = (hour + (indexPath.item * 3) + 1) % 24 // 현재 시간의 다음 시간부터 시작, 각 항목은 이전 항목보다 세 시간 뒤
                cell.timeLabel.text = String(format: "%02d:00", nextHour)
            } else {
                cell.timeLabel.text = "Time \(indexPath.item)"
            }

            // 새로운 온도 설정 로직 추가
            if indexPath.item < hourlyWeatherList.count {
                let hourlyWeather = hourlyWeatherList[indexPath.item]
                cell.timeTempLabel.text = "\(Int(hourlyWeather.main.temp))°"
            } else {
                cell.timeTempLabel.text = "Temp \(indexPath.item)"
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SecondCollectionViewCell.reuseIdentifier, for: indexPath) as! SecondCollectionViewCell

            // 오늘로부터 indexPath.item + 1 일 후의 날짜를 계산
            let currentDate = Date()
            var dateComponent = DateComponents()
            dateComponent.day = indexPath.item + 1
            if let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd"
                let dateString = dateFormatter.string(from: futureDate) // MM/dd 형태의 문자열로 변환

                let dayFormatter = DateFormatter()
                dayFormatter.dateFormat = "E"
                let dayString = dayFormatter.string(from: futureDate) // 요일을 문자열로 변환

                cell.dateLabel.text = "\(dateString)(\(dayString))"
            } else {
                cell.dateLabel.text = "Date \(indexPath.item)"
            }

            if indexPath.item < dailyWeatherList.count {
                let dailyWeather = dailyWeatherList[indexPath.item]
                cell.dateTempLabel.text = "\(Int(dailyWeather.main.temp))°"
            } else {
                cell.dateTempLabel.text = "Temp \(indexPath.item)"
            }
            return cell
        }
    }
}

// 셀 크기 조절
extension BottomWeatherForecastView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 90)
    }
}

// MARK: - 컬렉션뷰 셀

// 첫 번째 컬렉션 뷰의 셀
class FirstCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "FirstCell"

    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.customLabel(text: "", textColor: .black, fontSize: 15)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowOpacity = 0
        label.layer.shadowRadius = 0

        return label
    }()

    lazy var timeTempLabel: UILabel = {
        let label = UILabel()
        label.customLabel(text: "", textColor: .black, fontSize: 15)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowOpacity = 0
        label.layer.shadowRadius = 0

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
        addSubview(timeTempLabel)

        backgroundColor = .white
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            timeTempLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timeTempLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 10),
            timeTempLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            timeTempLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }
}

// 두 번째 컬렉션 뷰의 셀
class SecondCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "SecondCell"

    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.customLabel(text: "", textColor: .black, fontSize: 13)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowOpacity = 0
        label.layer.shadowRadius = 0

        return label
    }()

    lazy var dateTempLabel: UILabel = {
        let label = UILabel()
        label.customLabel(text: "", textColor: .black, fontSize: 15)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowOpacity = 0
        label.layer.shadowRadius = 0

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
        addSubview(dateTempLabel)

        backgroundColor = .white
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            dateTempLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateTempLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            dateTempLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            dateTempLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }
}
