import UIKit

class BottomWeatherForecastView: UIView, UICollectionViewDelegate {
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
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        collectionView.dataSource = self
        collectionView.delegate = self

        return collectionView
    }()

    lazy var dateTitle: UILabel = {
        let label = UILabel()
        label.customLabel(text: "10일간의 일기예보", textColor: .white, fontSize: 15)

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
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

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
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == firstCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FirstCollectionViewCell.reuseIdentifier, for: indexPath) as! FirstCollectionViewCell
            cell.timeLabel.text = "Time \(indexPath.item)"
            cell.timeTempLabel.text = "Temp \(indexPath.item)"
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SecondCollectionViewCell.reuseIdentifier, for: indexPath) as! SecondCollectionViewCell
            cell.dateLabel.text = "Date \(indexPath.item)"
            cell.dateTempLabel.text = "Temp \(indexPath.item)"
            return cell
        }
    }
}

// 셀 크기 조절
extension BottomWeatherForecastView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
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
        label.customLabel(text: "", textColor: .black, fontSize: 15)
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
