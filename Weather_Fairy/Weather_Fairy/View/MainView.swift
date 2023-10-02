import UIKit

// 레이아웃 코드 작성
final class MainView: UIView {
    let topView = TopView()
    let middleView = MiddleView()
    let bottomCurrentWeatherView = BottomCurrentWeatherView()
    let bottomWeatherForecastView = BottomWeatherForecastView()
    let bottomMyLocationView = BottomMyLocationView()

    var backgroundImageView: UIImageView?

//    private func setupBackgroundImage() {
//        if let backgroundImage = UIImage(named: "background") {
//            let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
//            backgroundImageView.image = backgroundImage
//            backgroundImageView.contentMode = .scaleAspectFill
//            backgroundImageView.clipsToBounds = true
//            insertSubview(backgroundImageView, at: 0)
//        }
//    }

    private func setupLayout() {
        addSubview(topView)
        addSubview(middleView)
        addSubview(bottomCurrentWeatherView)
        addSubview(bottomMyLocationView)
        addSubview(bottomWeatherForecastView)

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

    func changeBackgroundImage(to image: UIImage?) {
        backgroundImageView?.removeFromSuperview()
        let newBackgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        newBackgroundImageView.image = image
        newBackgroundImageView.contentMode = .scaleAspectFill
        newBackgroundImageView.clipsToBounds = true
        insertSubview(newBackgroundImageView, at: 0)
        backgroundImageView = newBackgroundImageView
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        //setupBackgroundImage()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("ERROR")
    }
}
