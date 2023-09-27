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

    lazy var hourlyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(white: 1, alpha: 0.3)
        collectionView.showsHorizontalScrollIndicator = false
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        collectionView.dataSource = self
        collectionView.delegate = self

        return collectionView
    }()

    private func setupConstraints() {
        weatherForecastView.addSubview(hourlyCollectionView
        )
        addSubview(weatherForecastView)

        let safeArea = safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            weatherForecastView.centerXAnchor.constraint(equalTo: centerXAnchor),
            weatherForecastView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            weatherForecastView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            weatherForecastView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            weatherForecastView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),

            hourlyCollectionView.topAnchor.constraint(equalTo: weatherForecastView.topAnchor, constant: 10),
            hourlyCollectionView.leadingAnchor.constraint(equalTo: weatherForecastView.leadingAnchor, constant: 10),
            hourlyCollectionView.trailingAnchor.constraint(equalTo: weatherForecastView.trailingAnchor, constant: -10),
            hourlyCollectionView.heightAnchor.constraint(equalToConstant: 120),

        ])
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        hourlyCollectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: WeatherCollectionViewCell.reuseIdentifier)

        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("ERROR")
    }
}

extension BottomWeatherForecastView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.reuseIdentifier, for: indexPath) as! WeatherCollectionViewCell
        cell.label.text = "셀 \(indexPath.item)"

        return cell
    }
}

// 셀 크기 조절
extension BottomWeatherForecastView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
}

// MARK: - 컬렉션뷰 셀

class WeatherCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "WeatherCell"

    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .center
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
        addSubview(label)
        backgroundColor = .white

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
