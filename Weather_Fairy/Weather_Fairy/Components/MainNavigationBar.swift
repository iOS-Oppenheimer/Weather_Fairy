import UIKit

class MainNavigationBar {
    static func setupNavigationBar(for viewController: UIViewController, resetButton: Selector, searchPageButton: Selector) {
        viewController.navigationController?.navigationBar.tintColor = UIColor.systemBackground
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()

        navBarAppearance.backgroundColor = .clear // #F8F0E5
        navBarAppearance.shadowColor = .clear
        viewController.navigationController?.navigationBar.standardAppearance = navBarAppearance
        viewController.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        // 현재 위치 초기화 버튼
        if let resetLocationImage = UIImage(named: "paperplane") {
            let resetLocationButtonSize = CGSize(width: 25, height: 25)
            UIGraphicsBeginImageContextWithOptions(resetLocationButtonSize, false, UIScreen.main.scale)
            resetLocationImage.draw(in: CGRect(origin: .zero, size: resetLocationButtonSize))

            if let resizedResetLocationImage = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()

                let resetLocationButton = UIBarButtonItem(image: resizedResetLocationImage.withRenderingMode(.alwaysOriginal), style: .plain, target: viewController, action: resetButton)
                resetLocationButton.imageInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)

                viewController.navigationItem.leftBarButtonItem = resetLocationButton
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

                let searchPageButton = UIBarButtonItem(image: resizedSearchPageImage.withRenderingMode(.alwaysOriginal), style: .plain, target: viewController, action: searchPageButton)
                searchPageButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
                viewController.navigationItem.rightBarButtonItems = [searchPageButton, viewController.navigationItem.rightBarButtonItem].compactMap { $0 }
            }
            UIGraphicsEndImageContext()
        }
    }
}
